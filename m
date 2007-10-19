From: akpm@linux-foundation.org
Subject: - misc-phantom-improved-data-passing.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:24 -0700
Message-ID: <200710192252.l9JMqOS7024267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765564AbXJSXFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Misc: phantom, improved data passing
has been removed from the -mm tree.  Its filename was
     misc-phantom-improved-data-passing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Misc: phantom, improved data passing
From: Jiri Slaby <jirislaby@gmail.com>

This new version guarantees amb_bit switch in small enough intervals, so that
the device won't stop working in the middle of a movement anymore.  However it
preserves old (openhaptics) functionality.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c  |   94 ++++++++++++++++++++++++++++++--------
 include/linux/phantom.h |    6 ++
 2 files changed, 81 insertions(+), 19 deletions(-)

diff -puN drivers/misc/phantom.c~misc-phantom-improved-data-passing drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-improved-data-passing
+++ a/drivers/misc/phantom.c
@@ -25,13 +25,14 @@
 #include <asm/atomic.h>
 #include <asm/io.h>
 
-#define PHANTOM_VERSION		"n0.9.5"
+#define PHANTOM_VERSION		"n0.9.7"
 
 #define PHANTOM_MAX_MINORS	8
 
 #define PHN_IRQCTL		0x4c    /* irq control in caddr space */
 
 #define PHB_RUNNING		1
+#define PHB_NOT_OH		2
 
 static struct class *phantom_class;
 static int phantom_major;
@@ -48,7 +49,11 @@ struct phantom_device {
 	struct cdev cdev;
 
 	struct mutex open_lock;
-	spinlock_t ioctl_lock;
+	spinlock_t regs_lock;
+
+	/* used in NOT_OH mode */
+	struct phm_regs oregs;
+	u32 ctl_reg;
 };
 
 static unsigned char phantom_devices[PHANTOM_MAX_MINORS];
@@ -83,6 +88,7 @@ static long phantom_ioctl(struct file *f
 	struct phm_regs rs;
 	struct phm_reg r;
 	void __user *argp = (void __user *)arg;
+	unsigned long flags;
 	unsigned int i;
 
 	if (_IOC_TYPE(cmd) != PH_IOC_MAGIC ||
@@ -97,32 +103,45 @@ static long phantom_ioctl(struct file *f
 		if (r.reg > 7)
 			return -EINVAL;
 
-		spin_lock(&dev->ioctl_lock);
+		spin_lock_irqsave(&dev->regs_lock, flags);
 		if (r.reg == PHN_CONTROL && (r.value & PHN_CTL_IRQ) &&
 				phantom_status(dev, dev->status | PHB_RUNNING)){
-			spin_unlock(&dev->ioctl_lock);
+			spin_unlock_irqrestore(&dev->regs_lock, flags);
 			return -ENODEV;
 		}
 
 		pr_debug("phantom: writing %x to %u\n", r.value, r.reg);
+
+		/* preserve amp bit (don't allow to change it when in NOT_OH) */
+		if (r.reg == PHN_CONTROL && (dev->status & PHB_NOT_OH)) {
+			r.value &= ~PHN_CTL_AMP;
+			r.value |= dev->ctl_reg & PHN_CTL_AMP;
+			dev->ctl_reg = r.value;
+		}
+
 		iowrite32(r.value, dev->iaddr + r.reg);
 		ioread32(dev->iaddr); /* PCI posting */
 
 		if (r.reg == PHN_CONTROL && !(r.value & PHN_CTL_IRQ))
 			phantom_status(dev, dev->status & ~PHB_RUNNING);
-		spin_unlock(&dev->ioctl_lock);
+		spin_unlock_irqrestore(&dev->regs_lock, flags);
 		break;
 	case PHN_SET_REGS:
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
 
 		pr_debug("phantom: SRS %u regs %x\n", rs.count, rs.mask);
-		spin_lock(&dev->ioctl_lock);
-		for (i = 0; i < min(rs.count, 8U); i++)
-			if ((1 << i) & rs.mask)
-				iowrite32(rs.values[i], dev->oaddr + i);
-		ioread32(dev->iaddr); /* PCI posting */
-		spin_unlock(&dev->ioctl_lock);
+		spin_lock_irqsave(&dev->regs_lock, flags);
+		if (dev->status & PHB_NOT_OH)
+			memcpy(&dev->oregs, &rs, sizeof(rs));
+		else {
+			u32 m = min(rs.count, 8U);
+			for (i = 0; i < m; i++)
+				if (rs.mask & BIT(i))
+					iowrite32(rs.values[i], dev->oaddr + i);
+			ioread32(dev->iaddr); /* PCI posting */
+		}
+		spin_unlock_irqrestore(&dev->regs_lock, flags);
 		break;
 	case PHN_GET_REG:
 		if (copy_from_user(&r, argp, sizeof(r)))
@@ -136,20 +155,35 @@ static long phantom_ioctl(struct file *f
 		if (copy_to_user(argp, &r, sizeof(r)))
 			return -EFAULT;
 		break;
-	case PHN_GET_REGS:
+	case PHN_GET_REGS: {
+		u32 m;
+
 		if (copy_from_user(&rs, argp, sizeof(rs)))
 			return -EFAULT;
 
+		m = min(rs.count, 8U);
+
 		pr_debug("phantom: GRS %u regs %x\n", rs.count, rs.mask);
-		spin_lock(&dev->ioctl_lock);
-		for (i = 0; i < min(rs.count, 8U); i++)
-			if ((1 << i) & rs.mask)
+		spin_lock_irqsave(&dev->regs_lock, flags);
+		for (i = 0; i < m; i++)
+			if (rs.mask & BIT(i))
 				rs.values[i] = ioread32(dev->iaddr + i);
-		spin_unlock(&dev->ioctl_lock);
+		spin_unlock_irqrestore(&dev->regs_lock, flags);
 
 		if (copy_to_user(argp, &rs, sizeof(rs)))
 			return -EFAULT;
 		break;
+	} case PHN_NOT_OH:
+		spin_lock_irqsave(&dev->regs_lock, flags);
+		if (dev->status & PHB_RUNNING) {
+			printk(KERN_ERR "phantom: you need to set NOT_OH "
+					"before you start the device!\n");
+			spin_unlock_irqrestore(&dev->regs_lock, flags);
+			return -EINVAL;
+		}
+		dev->status |= PHB_NOT_OH;
+		spin_unlock_irqrestore(&dev->regs_lock, flags);
+		break;
 	default:
 		return -ENOTTY;
 	}
@@ -172,8 +206,11 @@ static int phantom_open(struct inode *in
 		return -EINVAL;
 	}
 
+	WARN_ON(dev->status & PHB_NOT_OH);
+
 	file->private_data = dev;
 
+	atomic_set(&dev->counter, 0);
 	dev->opened++;
 	mutex_unlock(&dev->open_lock);
 
@@ -188,6 +225,7 @@ static int phantom_release(struct inode 
 
 	dev->opened = 0;
 	phantom_status(dev, dev->status & ~PHB_RUNNING);
+	dev->status &= ~PHB_NOT_OH;
 
 	mutex_unlock(&dev->open_lock);
 
@@ -221,12 +259,32 @@ static struct file_operations phantom_fi
 static irqreturn_t phantom_isr(int irq, void *data)
 {
 	struct phantom_device *dev = data;
+	unsigned int i;
+	u32 ctl;
 
-	if (!(ioread32(dev->iaddr + PHN_CONTROL) & PHN_CTL_IRQ))
+	spin_lock(&dev->regs_lock);
+	ctl = ioread32(dev->iaddr + PHN_CONTROL);
+	if (!(ctl & PHN_CTL_IRQ)) {
+		spin_unlock(&dev->regs_lock);
 		return IRQ_NONE;
+	}
 
 	iowrite32(0, dev->iaddr);
 	iowrite32(0xc0, dev->iaddr);
+
+	if (dev->status & PHB_NOT_OH) {
+		struct phm_regs *r = &dev->oregs;
+		u32 m = min(r->count, 8U);
+
+		for (i = 0; i < m; i++)
+			if (r->mask & BIT(i))
+				iowrite32(r->values[i], dev->oaddr + i);
+
+		dev->ctl_reg ^= PHN_CTL_AMP;
+		iowrite32(dev->ctl_reg, dev->iaddr + PHN_CONTROL);
+	}
+	spin_unlock(&dev->regs_lock);
+
 	ioread32(dev->iaddr); /* PCI posting */
 
 	atomic_inc(&dev->counter);
@@ -298,7 +356,7 @@ static int __devinit phantom_probe(struc
 	}
 
 	mutex_init(&pht->open_lock);
-	spin_lock_init(&pht->ioctl_lock);
+	spin_lock_init(&pht->regs_lock);
 	init_waitqueue_head(&pht->wait);
 	cdev_init(&pht->cdev, &phantom_file_ops);
 	pht->cdev.owner = THIS_MODULE;
diff -puN include/linux/phantom.h~misc-phantom-improved-data-passing include/linux/phantom.h
--- a/include/linux/phantom.h~misc-phantom-improved-data-passing
+++ a/include/linux/phantom.h
@@ -30,7 +30,11 @@ struct phm_regs {
 #define PHN_SET_REG		_IOW (PH_IOC_MAGIC, 1, struct phm_reg *)
 #define PHN_GET_REGS		_IOWR(PH_IOC_MAGIC, 2, struct phm_regs *)
 #define PHN_SET_REGS		_IOW (PH_IOC_MAGIC, 3, struct phm_regs *)
-#define PH_IOC_MAXNR		3
+/* this ioctl tells the driver, that the caller is not OpenHaptics and might
+ * use improved registers update (no more phantom switchoffs when using
+ * libphantom) */
+#define PHN_NOT_OH		_IO  (PH_IOC_MAGIC, 4)
+#define PH_IOC_MAXNR		4
 
 #define PHN_CONTROL		0x6     /* control byte in iaddr space */
 #define PHN_CTL_AMP		0x1     /*   switch after torques change */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
