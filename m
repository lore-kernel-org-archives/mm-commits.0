From: akpm@linux-foundation.org
Subject: + w1-w1_family-remove-unused-variable-need_exit.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:20 -0700
Message-ID: <200807310316.m6V3GKDL001167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782AbYGaDXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:23:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: w1_family, remove unused variable need_exit
has been added to the -mm tree.  Its filename is
     w1-w1_family-remove-unused-variable-need_exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch

