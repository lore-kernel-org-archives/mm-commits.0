From: akpm@linux-foundation.org
Subject: + remove-dead-code-in-via-pmu68k.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:13 -0700
Message-ID: <200708152118.l7FLIHFu015472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933323AbXHOVTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, geert@linux-m68k.org


The patch titled
     remove dead code in via-pmu68k
has been added to the -mm tree.  Its filename is
     remove-dead-code-in-via-pmu68k.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove dead code in via-pmu68k
From: Johannes Berg <johannes@sipsolutions.net>

When suspend is ever implemented for pmu68k it really should follow the
generic pm_ops concept and not mirror the platform-specific /dev/pmu
device with ioctls on it. Hence, this patch removes the unused code there;
should the implementers need it they can look at via-pmu.c and/or the
history of the file.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/via-pmu68k.c |  240 -------------------------------
 1 files changed, 240 deletions(-)

diff -puN drivers/macintosh/via-pmu68k.c~remove-dead-code-in-via-pmu68k drivers/macintosh/via-pmu68k.c
--- a/drivers/macintosh/via-pmu68k.c~remove-dead-code-in-via-pmu68k
+++ a/drivers/macintosh/via-pmu68k.c
@@ -818,243 +818,3 @@ pmu_present(void)
 {
 	return (pmu_kind != PMU_UNKNOWN);
 }
-
-#if 0 /* needs some work for 68K */
-
-/*
- * This struct is used to store config register values for
- * PCI devices which may get powered off when we sleep.
- */
-static struct pci_save {
-	u16	command;
-	u16	cache_lat;
-	u16	intr;
-} *pbook_pci_saves;
-static int n_pbook_pci_saves;
-
-static inline void
-pbook_pci_save(void)
-{
-	int npci;
-	struct pci_dev *pd = NULL;
-	struct pci_save *ps;
-
-	npci = 0;
-	while ((pd = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pd)) != NULL)
-		++npci;
-	n_pbook_pci_saves = npci;
-	if (npci == 0)
-		return;
-	ps = kmalloc(npci * sizeof(*ps), GFP_KERNEL);
-	pbook_pci_saves = ps;
-	if (ps == NULL)
-		return;
-
-	pd = NULL;
-	while ((pd = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pd)) != NULL) {
-		pci_read_config_word(pd, PCI_COMMAND, &ps->command);
-		pci_read_config_word(pd, PCI_CACHE_LINE_SIZE, &ps->cache_lat);
-		pci_read_config_word(pd, PCI_INTERRUPT_LINE, &ps->intr);
-		++ps;
-		--npci;
-	}
-}
-
-static inline void
-pbook_pci_restore(void)
-{
-	u16 cmd;
-	struct pci_save *ps = pbook_pci_saves;
-	struct pci_dev *pd = NULL;
-	int j;
-
-	while ((pd = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pd)) != NULL) {
-		if (ps->command == 0)
-			continue;
-		pci_read_config_word(pd, PCI_COMMAND, &cmd);
-		if ((ps->command & ~cmd) == 0)
-			continue;
-		switch (pd->hdr_type) {
-		case PCI_HEADER_TYPE_NORMAL:
-			for (j = 0; j < 6; ++j)
-				pci_write_config_dword(pd,
-					PCI_BASE_ADDRESS_0 + j*4,
-					pd->resource[j].start);
-			pci_write_config_dword(pd, PCI_ROM_ADDRESS,
-			       pd->resource[PCI_ROM_RESOURCE].start);
-			pci_write_config_word(pd, PCI_CACHE_LINE_SIZE,
-				ps->cache_lat);
-			pci_write_config_word(pd, PCI_INTERRUPT_LINE,
-				ps->intr);
-			pci_write_config_word(pd, PCI_COMMAND, ps->command);
-			break;
-			/* other header types not restored at present */
-		}
-	}
-}
-
-/*
- * Put the powerbook to sleep.
- */
-#define IRQ_ENABLE	((unsigned int *)0xf3000024)
-#define MEM_CTRL	((unsigned int *)0xf8000070)
-
-int powerbook_sleep(void)
-{
-	int ret, i, x;
-	static int save_backlight;
-	static unsigned int save_irqen;
-	unsigned long msr;
-	unsigned int hid0;
-	unsigned long p, wait;
-	struct adb_request sleep_req;
-
-	/* Notify device drivers */
-	ret = blocking_notifier_call_chain(&sleep_notifier_list,
-			PBOOK_SLEEP, NULL);
-	if (ret & NOTIFY_STOP_MASK)
-		return -EBUSY;
-
-	/* Sync the disks. */
-	/* XXX It would be nice to have some way to ensure that
-	 * nobody is dirtying any new buffers while we wait. */
-	sys_sync();
-
-	/* Turn off the display backlight */
-	save_backlight = backlight_enabled;
-	if (save_backlight)
-		pmu_enable_backlight(0);
-
-	/* Give the disks a little time to actually finish writing */
-	for (wait = jiffies + (HZ/4); time_before(jiffies, wait); )
-		mb();
-
-	/* Disable all interrupts except pmu */
-	save_irqen = in_le32(IRQ_ENABLE);
-	for (i = 0; i < 32; ++i)
-		if (i != vias->intrs[0].line && (save_irqen & (1 << i)))
-			disable_irq(i);
-	asm volatile("mtdec %0" : : "r" (0x7fffffff));
-
-	/* Save the state of PCI config space for some slots */
-	pbook_pci_save();
-
-	/* Set the memory controller to keep the memory refreshed
-	   while we're asleep */
-	for (i = 0x403f; i >= 0x4000; --i) {
-		out_be32(MEM_CTRL, i);
-		do {
-			x = (in_be32(MEM_CTRL) >> 16) & 0x3ff;
-		} while (x == 0);
-		if (x >= 0x100)
-			break;
-	}
-
-	/* Ask the PMU to put us to sleep */
-	pmu_request(&sleep_req, NULL, 5, PMU_SLEEP, 'M', 'A', 'T', 'T');
-	while (!sleep_req.complete)
-		mb();
-	/* displacement-flush the L2 cache - necessary? */
-	for (p = KERNELBASE; p < KERNELBASE + 0x100000; p += 0x1000)
-		i = *(volatile int *)p;
-	asleep = 1;
-
-	/* Put the CPU into sleep mode */
-	asm volatile("mfspr %0,1008" : "=r" (hid0) :);
-	hid0 = (hid0 & ~(HID0_NAP | HID0_DOZE)) | HID0_SLEEP;
-	asm volatile("mtspr 1008,%0" : : "r" (hid0));
-	local_save_flags(msr);
-	msr |= MSR_POW | MSR_EE;
-	local_irq_restore(msr);
-	udelay(10);
-
-	/* OK, we're awake again, start restoring things */
-	out_be32(MEM_CTRL, 0x3f);
-	pbook_pci_restore();
-
-	/* wait for the PMU interrupt sequence to complete */
-	while (asleep)
-		mb();
-
-	/* reenable interrupts */
-	for (i = 0; i < 32; ++i)
-		if (i != vias->intrs[0].line && (save_irqen & (1 << i)))
-			enable_irq(i);
-
-	/* Notify drivers */
-	blocking_notifier_call_chain(&sleep_notifier_list, PBOOK_WAKE, NULL);
-
-	/* reenable ADB autopoll */
-	pmu_adb_autopoll(adb_dev_map);
-
-	/* Turn on the screen backlight, if it was on before */
-	if (save_backlight)
-		pmu_enable_backlight(1);
-
-	/* Wait for the hard disk to spin up */
-
-	return 0;
-}
-
-/*
- * Support for /dev/pmu device
- */
-static int pmu_open(struct inode *inode, struct file *file)
-{
-	return 0;
-}
-
-static ssize_t pmu_read(struct file *file, char *buf,
-			size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static ssize_t pmu_write(struct file *file, const char *buf,
-			 size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static int pmu_ioctl(struct inode * inode, struct file *filp,
-		     u_int cmd, u_long arg)
-{
-	int error;
-	__u32 value;
-
-	switch (cmd) {
-	    case PMU_IOC_SLEEP:
-	    	return -ENOSYS;
-	    case PMU_IOC_GET_BACKLIGHT:
-		return put_user(backlight_level, (__u32 *)arg);
-	    case PMU_IOC_SET_BACKLIGHT:
-		error = get_user(value, (__u32 *)arg);
-		if (!error)
-			pmu_set_brightness(value);
-		return error;
-	    case PMU_IOC_GET_MODEL:
-	    	return put_user(pmu_kind, (__u32 *)arg);
-	}
-	return -EINVAL;
-}
-
-static const struct file_operations pmu_device_fops = {
-	.read		= pmu_read,
-	.write		= pmu_write,
-	.ioctl		= pmu_ioctl,
-	.open		= pmu_open,
-};
-
-static struct miscdevice pmu_device = {
-	PMU_MINOR, "pmu", &pmu_device_fops
-};
-
-void pmu_device_init(void)
-{
-	if (!via)
-		return;
-	if (misc_register(&pmu_device) < 0)
-		printk(KERN_ERR "via-pmu68k: cannot register misc device.\n");
-}
-#endif /* CONFIG_PMAC_PBOOK */
-
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

remove-dead-code-in-via-pmu68k.patch
git-alsa.patch
git-net.patch
git-wireless.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
