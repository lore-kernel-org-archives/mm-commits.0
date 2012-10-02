From: akpm@linux-foundation.org
Subject: + aoe-retain-static-block-device-numbers-for-backwards-compatibility.patch added to -mm tree
Date: Tue, 02 Oct 2012 14:18:06 -0700
Message-ID: <20121002211807.59D9F5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:63569 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2JBVSI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2012 17:18:08 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so413606wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Oct 2012 14:18:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: retain static block device numbers for backwards compatibility
has been added to the -mm tree.  Its filename is
     aoe-retain-static-block-device-numbers-for-backwards-compatibility.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: retain static block device numbers for backwards compatibility

The old mapping between AoE target shelf and slot addresses and the block
device minor number is retained as a backwards-compatible feature, with a
new "aoe_dyndevs" module parameter available for enabling dynamic block
device minor numbers.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |   54 +++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 3 deletions(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-retain-static-block-device-numbers-for-backwards-compatibility drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-retain-static-block-device-numbers-for-backwards-compatibility
+++ a/drivers/block/aoe/aoedev.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/bitmap.h>
 #include <linux/kdev_t.h>
+#include <linux/moduleparam.h>
 #include "aoe.h"
 
 static void dummy_timer(ulong);
@@ -18,6 +19,10 @@ static void aoedev_freedev(struct aoedev
 static void freetgt(struct aoedev *d, struct aoetgt *t);
 static void skbpoolfree(struct aoedev *d);
 
+static int aoe_dyndevs;
+module_param(aoe_dyndevs, int, 0644);
+MODULE_PARM_DESC(aoe_dyndevs, "Use dynamic minor numbers for devices.");
+
 static struct aoedev *devlist;
 static DEFINE_SPINLOCK(devlist_lock);
 
@@ -34,7 +39,7 @@ static DEFINE_SPINLOCK(used_minors_lock)
 static DECLARE_BITMAP(used_minors, N_DEVS);
 
 static int
-minor_get(ulong *minor)
+minor_get_dyn(ulong *sysminor)
 {
 	ulong flags;
 	ulong n;
@@ -48,10 +53,53 @@ minor_get(ulong *minor)
 		error = -1;
 	spin_unlock_irqrestore(&used_minors_lock, flags);
 
-	*minor = n * AOE_PARTITIONS;
+	*sysminor = n * AOE_PARTITIONS;
 	return error;
 }
 
+static int
+minor_get_static(ulong *sysminor, ulong aoemaj, int aoemin)
+{
+	ulong flags;
+	ulong n;
+	int error = 0;
+	enum {
+		/* for backwards compatibility when !aoe_dyndevs,
+		 * a static number of supported slots per shelf */
+		NPERSHELF = 16,
+	};
+
+	n = aoemaj * NPERSHELF + aoemin;
+	if (aoemin >= NPERSHELF || n >= N_DEVS) {
+		pr_err("aoe: %s with e%ld.%d\n",
+			"cannot use static minor device numbers",
+			aoemaj, aoemin);
+		error = -1;
+	} else {
+		spin_lock_irqsave(&used_minors_lock, flags);
+		if (test_bit(n, used_minors)) {
+			pr_err("aoe: %s %lu\n",
+				"existing device already has static minor number",
+				n);
+			error = -1;
+		} else
+			set_bit(n, used_minors);
+		spin_unlock_irqrestore(&used_minors_lock, flags);
+	}
+
+	*sysminor = n;
+	return error;
+}
+
+static int
+minor_get(ulong *sysminor, ulong aoemaj, int aoemin)
+{
+	if (aoe_dyndevs)
+		return minor_get_dyn(sysminor);
+	else
+		return minor_get_static(sysminor, aoemaj, aoemin);
+}
+
 static void
 minor_free(ulong minor)
 {
@@ -293,7 +341,7 @@ aoedev_by_aoeaddr(ulong maj, int min, in
 			d->ref++;
 			break;
 		}
-	if (d || !do_alloc || minor_get(&sysminor) < 0)
+	if (d || !do_alloc || minor_get(&sysminor, maj, min) < 0)
 		goto out;
 	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
 	if (!d)
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-for-performance-support-larger-packet-payloads.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch
aoe-become-i-o-request-queue-handler-for-increased-user-control.patch
aoe-use-a-kernel-thread-for-transmissions.patch
aoe-use-packets-that-work-with-the-smallest-mtu-local-interface.patch
aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch
aoe-do-revalidation-steps-in-order.patch
aoe-disallow-unsupported-aoe-minor-addresses.patch
aoe-associate-frames-with-the-aoe-storage-target.patch
aoe-increase-net_device-reference-count-while-using-it.patch
aoe-remove-unused-code-and-add-cosmetic-improvements.patch
aoe-update-internal-version-number-to-49.patch
aoe-update-copyright-year-in-touched-files.patch
aoe-update-documentation-with-new-url-and-vm-settings-reference.patch
aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers.patch
aoe-retain-static-block-device-numbers-for-backwards-compatibility.patch
aoe-update-and-specify-aoe-address-guards-and-error-messages.patch
aoe-make-dynamic-block-minor-numbers-the-default.patch
aoe-remove-unused-code.patch
aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage.patch
aoe-update-aoe-internal-version-number-to-50.patch

