From: akpm@linux-foundation.org
Subject: [merged] aoe-retain-static-block-device-numbers-for-backwards-compatibility.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:55 -0700
Message-ID: <20121005202155.B221D100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56456 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:56 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so237754qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: retain static block device numbers for backwards compatibility
has been removed from the -mm tree.  Its filename was
     aoe-retain-static-block-device-numbers-for-backwards-compatibility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

