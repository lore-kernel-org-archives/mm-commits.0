From: akpm@linux-foundation.org
Subject: + ubi-fix-sparse-errors-in-ubih.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:00:58 -0800
Message-ID: <200802142200.m1EM0wDD005136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933243AbYBNWBN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:01:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dedekind@infradead.org


The patch titled
     ubi: fix sparse errors in ubi.h
has been added to the -mm tree.  Its filename is
     ubi-fix-sparse-errors-in-ubih.patch

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
Subject: ubi: fix sparse errors in ubi.h
From: Harvey Harrison <harvey.harrison@gmail.com>

In C, signed 1-bit bitfields can only take the values 0 and -1, only 0 and 1
are ever assigned in current code.  Make them unsigned bitfields.

Fixes the (repeated) sparse errors:
drivers/mtd/ubi/ubi.h:220:15: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:221:17: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:222:18: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:223:16: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:224:20: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/ubi/ubi.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/ubi/ubi.h~ubi-fix-sparse-errors-in-ubih drivers/mtd/ubi/ubi.h
--- a/drivers/mtd/ubi/ubi.h~ubi-fix-sparse-errors-in-ubih
+++ a/drivers/mtd/ubi/ubi.h
@@ -217,11 +217,11 @@ struct ubi_volume {
 	void *upd_buf;
 
 	int *eba_tbl;
-	int checked:1;
-	int corrupted:1;
-	int upd_marker:1;
-	int updating:1;
-	int changing_leb:1;
+	unsigned int checked:1;
+	unsigned int corrupted:1;
+	unsigned int upd_marker:1;
+	unsigned int updating:1;
+	unsigned int changing_leb:1;
 
 #ifdef CONFIG_MTD_UBI_GLUEBI
 	/*
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
include-linux-remove-all-users-of-fastcall-macro.patch
rcupdate-fix-comment.patch
remove-final-fastcall-users.patch
final-removal-of-fastcall-fastcall.patch
inotify-make-variables-static-in-inotify_userc.patch
kernel-doc-remove-fastcall.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
