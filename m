From: akpm@linux-foundation.org
Subject: - w1-w1_family-remove-unused-variable-need_exit.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:00 -0700
Message-ID: <200810182320.m9INK0tc029611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbYJRXUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: w1_family, remove unused variable need_exit
has been removed from the -mm tree.  Its filename was
     w1-w1_family-remove-unused-variable-need_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: w1_family, remove unused variable need_exit
From: David Fries <david@fries.net>

Removed the w1_family structure member variable need_exit.  It was only
being set and never used.  Even if it were to be used it is a polling type
operation.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_family.c |    7 +------
 drivers/w1/w1_family.h |    1 -
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/w1/w1_family.c~w1-w1_family-remove-unused-variable-need_exit drivers/w1/w1_family.c
--- a/drivers/w1/w1_family.c~w1-w1_family-remove-unused-variable-need_exit
+++ a/drivers/w1/w1_family.c
@@ -48,7 +48,6 @@ int w1_register_family(struct w1_family 
 
 	if (!ret) {
 		atomic_set(&newf->refcnt, 0);
-		newf->need_exit = 0;
 		list_add_tail(&newf->family_entry, &w1_families);
 	}
 	spin_unlock(&w1_flock);
@@ -73,9 +72,6 @@ void w1_unregister_family(struct w1_fami
 			break;
 		}
 	}
-
-	fent->need_exit = 1;
-
 	spin_unlock(&w1_flock);
 
 	/* deatch devices using this family code */
@@ -113,8 +109,7 @@ struct w1_family * w1_family_registered(
 
 static void __w1_family_put(struct w1_family *f)
 {
-	if (atomic_dec_and_test(&f->refcnt))
-		f->need_exit = 1;
+	atomic_dec(&f->refcnt);
 }
 
 void w1_family_put(struct w1_family *f)
diff -puN drivers/w1/w1_family.h~w1-w1_family-remove-unused-variable-need_exit drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~w1-w1_family-remove-unused-variable-need_exit
+++ a/drivers/w1/w1_family.h
@@ -53,7 +53,6 @@ struct w1_family
 	struct w1_family_ops	*fops;
 
 	atomic_t		refcnt;
-	u8			need_exit;
 };
 
 extern spinlock_t w1_flock;
_

Patches currently in -mm which might be from david@fries.net are

origin.patch

