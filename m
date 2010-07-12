From: akpm@linux-foundation.org
Subject: + gpiolib-get-rid-of-struct-poll_desc-and-worklet.patch added to -mm tree
Date: Mon, 12 Jul 2010 13:02:14 -0700
Message-ID: <201007122002.o6CK2ENT026319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751642Ab0GLUCv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 16:02:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dg@emlix.com, david-b@pacbell.net


The patch titled
     gpiolib: get rid of struct poll_desc and worklet
has been added to the -mm tree.  Its filename is
     gpiolib-get-rid-of-struct-poll_desc-and-worklet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpiolib: get rid of struct poll_desc and worklet
=46rom: Daniel Gl=F6ckner <dg@emlix.com>

As sysfs_notify_dirent has been made irq safe, there is no reason to no=
t
call it directly from irq.  With the work_struct removed, the remaining
element in poll_desc is a sysfs_dirent pointer which may not be NULL.  =
We
can therefore store it directly in the idr and pass it as context to th=
e
irq handler.

Most part of the patch deals with renaming defines and variables to
reflect their new use without functional change.

I also took the opportunity to initialize the idr statically.

Signed-off-by: Daniel Gl=F6ckner <dg@emlix.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   80 +++++++++++++--------------------------
 1 file changed, 27 insertions(+), 53 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-get-rid-of-struct-poll_desc-an=
d-worklet drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-get-rid-of-struct-poll_desc-and-wo=
rklet
+++ a/drivers/gpio/gpiolib.c
@@ -57,9 +57,9 @@ struct gpio_desc {
 #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
 #define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
=20
-#define PDESC_ID_SHIFT	16	/* add new flags before this one */
+#define ID_SHIFT	16	/* add new flags before this one */
=20
-#define GPIO_FLAGS_MASK		((1 << PDESC_ID_SHIFT) - 1)
+#define GPIO_FLAGS_MASK		((1 << ID_SHIFT) - 1)
 #define GPIO_TRIGGER_MASK	(BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE))
=20
 #ifdef CONFIG_DEBUG_FS
@@ -69,12 +69,7 @@ struct gpio_desc {
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
=20
 #ifdef CONFIG_GPIO_SYSFS
-struct poll_desc {
-	struct work_struct	work;
-	struct sysfs_dirent	*value_sd;
-};
-
-static struct idr pdesc_idr;
+static DEFINE_IDR(dirent_idr);
 #endif
=20
 static inline void desc_set_label(struct gpio_desc *d, const char *lab=
el)
@@ -325,24 +320,16 @@ static const DEVICE_ATTR(value, 0644,
=20
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
 {
-	struct work_struct	*work =3D priv;
+	struct sysfs_dirent	*value_sd =3D priv;
=20
-	schedule_work(work);
+	sysfs_notify_dirent(value_sd);
 	return IRQ_HANDLED;
 }
=20
-static void gpio_notify_sysfs(struct work_struct *work)
-{
-	struct poll_desc	*pdesc;
-
-	pdesc =3D container_of(work, struct poll_desc, work);
-	sysfs_notify_dirent(pdesc->value_sd);
-}
-
 static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 		unsigned long gpio_flags)
 {
-	struct poll_desc	*pdesc;
+	struct sysfs_dirent	*value_sd;
 	unsigned long		irq_flags;
 	int			ret, irq, id;
=20
@@ -353,18 +340,16 @@ static int gpio_setup_irq(struct gpio_de
 	if (irq < 0)
 		return -EIO;
=20
-	id =3D desc->flags >> PDESC_ID_SHIFT;
-	pdesc =3D idr_find(&pdesc_idr, id);
-	if (pdesc) {
-		free_irq(irq, &pdesc->work);
-		cancel_work_sync(&pdesc->work);
-	}
+	id =3D desc->flags >> ID_SHIFT;
+	value_sd =3D idr_find(&dirent_idr, id);
+	if (value_sd)
+		free_irq(irq, value_sd);
=20
 	desc->flags &=3D ~GPIO_TRIGGER_MASK;
=20
 	if (!gpio_flags) {
 		ret =3D 0;
-		goto free_sd;
+		goto free_id;
 	}
=20
 	irq_flags =3D IRQF_SHARED;
@@ -375,55 +360,46 @@ static int gpio_setup_irq(struct gpio_de
 		irq_flags |=3D test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
 			IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
=20
-	if (!pdesc) {
-		pdesc =3D kmalloc(sizeof(*pdesc), GFP_KERNEL);
-		if (!pdesc) {
-			ret =3D -ENOMEM;
+	if (!value_sd) {
+		value_sd =3D sysfs_get_dirent(dev->kobj.sd, NULL, "value");
+		if (!value_sd) {
+			ret =3D -ENODEV;
 			goto err_out;
 		}
=20
 		do {
 			ret =3D -ENOMEM;
-			if (idr_pre_get(&pdesc_idr, GFP_KERNEL))
-				ret =3D idr_get_new_above(&pdesc_idr,
-						pdesc, 1, &id);
+			if (idr_pre_get(&dirent_idr, GFP_KERNEL))
+				ret =3D idr_get_new_above(&dirent_idr, value_sd,
+							1, &id);
 		} while (ret =3D=3D -EAGAIN);
=20
 		if (ret)
-			goto free_mem;
+			goto free_sd;
=20
 		desc->flags &=3D GPIO_FLAGS_MASK;
-		desc->flags |=3D (unsigned long)id << PDESC_ID_SHIFT;
+		desc->flags |=3D (unsigned long)id << ID_SHIFT;
=20
-		if (desc->flags >> PDESC_ID_SHIFT !=3D id) {
+		if (desc->flags >> ID_SHIFT !=3D id) {
 			ret =3D -ERANGE;
 			goto free_id;
 		}
-
-		pdesc->value_sd =3D sysfs_get_dirent(dev->kobj.sd, NULL, "value");
-		if (!pdesc->value_sd) {
-			ret =3D -ENODEV;
-			goto free_id;
-		}
-		INIT_WORK(&pdesc->work, gpio_notify_sysfs);
 	}
=20
 	ret =3D request_irq(irq, gpio_sysfs_irq, irq_flags,
-			"gpiolib", &pdesc->work);
+				"gpiolib", value_sd);
 	if (ret)
-		goto free_sd;
+		goto free_id;
=20
 	desc->flags |=3D gpio_flags;
 	return 0;
=20
-free_sd:
-	if (pdesc)
-		sysfs_put(pdesc->value_sd);
 free_id:
-	idr_remove(&pdesc_idr, id);
+	idr_remove(&dirent_idr, id);
 	desc->flags &=3D GPIO_FLAGS_MASK;
-free_mem:
-	kfree(pdesc);
+free_sd:
+	if (value_sd)
+		sysfs_put(value_sd);
 err_out:
 	return ret;
 }
@@ -993,8 +969,6 @@ static int __init gpiolib_sysfs_init(voi
 	unsigned long	flags;
 	unsigned	gpio;
=20
-	idr_init(&pdesc_idr);
