From: akpm@linux-foundation.org
Subject: [merged] aoe-make-error-messages-more-specific-in-static-minor-allocation.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:11:01 -0800
Message-ID: <20121218201102.3038B200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:59868 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRULE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:11:04 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so63453wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:11:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: make error messages more specific in static minor allocation
has been removed from the -mm tree.  Its filename was
     aoe-make-error-messages-more-specific-in-static-minor-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: make error messages more specific in static minor allocation

For some special-purpose systems where udev isn't present, static
allocation of minor numbers is desirable.  This update distinguishes
different failure scenarios, to help the user understand what went wrong.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoedev.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff -puN drivers/block/aoe/aoedev.c~aoe-make-error-messages-more-specific-in-static-minor-allocation drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-make-error-messages-more-specific-in-static-minor-allocation
+++ a/drivers/block/aoe/aoedev.c
@@ -69,25 +69,34 @@ minor_get_static(ulong *sysminor, ulong 
 		NPERSHELF = 16,
 	};
 
+	if (aoemin >= NPERSHELF) {
+		pr_err("aoe: %s %d slots per shelf\n",
+			"static minor device numbers support only",
+			NPERSHELF);
+		error = -1;
+		goto out;
+	}
+
 	n = aoemaj * NPERSHELF + aoemin;
-	if (aoemin >= NPERSHELF || n >= N_DEVS) {
+	if (n >= N_DEVS) {
 		pr_err("aoe: %s with e%ld.%d\n",
 			"cannot use static minor device numbers",
 			aoemaj, aoemin);
 		error = -1;
-	} else {
-		spin_lock_irqsave(&used_minors_lock, flags);
-		if (test_bit(n, used_minors)) {
-			pr_err("aoe: %s %lu\n",
-				"existing device already has static minor number",
-				n);
-			error = -1;
-		} else
-			set_bit(n, used_minors);
-		spin_unlock_irqrestore(&used_minors_lock, flags);
+		goto out;
 	}
 
+	spin_lock_irqsave(&used_minors_lock, flags);
+	if (test_bit(n, used_minors)) {
+		pr_err("aoe: %s %lu\n",
+			"existing device already has static minor number",
+			n);
+		error = -1;
+	} else
+		set_bit(n, used_minors);
+	spin_unlock_irqrestore(&used_minors_lock, flags);
 	*sysminor = n;
+out:
 	return error;
 }
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

