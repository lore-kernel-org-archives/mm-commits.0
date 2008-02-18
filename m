From: akpm@linux-foundation.org
Subject: + jffs2-fix-sparse-warning-in-nodemgmtc.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:00:40 -0800
Message-ID: <200802181001.m1IA1bAD018955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759305AbYBRKCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:02:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, dwmw2@infradead.org


The patch titled
     jffs2: fix sparse warning in nodemgmt.c
has been added to the -mm tree.  Its filename is
     jffs2-fix-sparse-warning-in-nodemgmtc.patch

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
Subject: jffs2: fix sparse warning in nodemgmt.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/jffs2/nodemgmt.c:60:8: warning: symbol 'ret' shadows an earlier one
fs/jffs2/nodemgmt.c:45:6: originally declared here

Use a different var (gc) in the inner loop to test the condition.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/nodemgmt.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/jffs2/nodemgmt.c~jffs2-fix-sparse-warning-in-nodemgmtc fs/jffs2/nodemgmt.c
--- a/fs/jffs2/nodemgmt.c~jffs2-fix-sparse-warning-in-nodemgmtc
+++ a/fs/jffs2/nodemgmt.c
@@ -57,7 +57,7 @@ int jffs2_reserve_space(struct jffs2_sb_
 	/* this needs a little more thought (true <tglx> :)) */
 	while(ret == -EAGAIN) {
 		while(c->nr_free_blocks + c->nr_erasing_blocks < blocksneeded) {
-			int ret;
+			int gc;
 			uint32_t dirty, avail;
 
 			/* calculate real dirty size
@@ -116,9 +116,9 @@ int jffs2_reserve_space(struct jffs2_sb_
 				  c->free_size + c->dirty_size + c->wasted_size + c->used_size + c->erasing_size + c->bad_size, c->flash_size));
 			spin_unlock(&c->erase_completion_lock);
 
-			ret = jffs2_garbage_collect_pass(c);
-			if (ret)
-				return ret;
+			gc = jffs2_garbage_collect_pass(c);
+			if (gc)
+				return gc;
 
 			cond_resched();
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
cifs-remove-global_extern-macro.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-replace-macro-with-static-inline-in-libatah.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
