From: akpm@linux-foundation.org
Subject: + dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:04:13 -0800
Message-ID: <200802142104.m1EL4DqQ002762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57092 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608AbYBNVEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, pcaulfie@redhat.com, swhiteho@redhat.com, teigland@redhat.com


The patch titled
     dlm: match signedness between dlm_config_info and cluster_set
has been added to the -mm tree.  Its filename is
     dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch

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
Subject: dlm: match signedness between dlm_config_info and cluster_set
From: Harvey Harrison <harvey.harrison@gmail.com>

cluster_set is only called from the macro CLUSTER_ATTR which defines read/write
access functions.  Make the signedness match to avoid sparse warnings every time
CLUSTER_ATTR is used (lines 149-159) all of the form:

fs/dlm/config.c:149:1: warning: incorrect type in argument 3 (different signedness)
fs/dlm/config.c:149:1:    expected unsigned int *info_field
fs/dlm/config.c:149:1:    got int extern [toplevel] *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Patrick Caulfield <pcaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dlm/config.c~dlm-match-signedness-between-dlm_config_info-and-cluster_set fs/dlm/config.c
--- a/fs/dlm/config.c~dlm-match-signedness-between-dlm_config_info-and-cluster_set
+++ a/fs/dlm/config.c
@@ -114,7 +114,7 @@ struct cluster_attribute {
 };
 
 static ssize_t cluster_set(struct cluster *cl, unsigned int *cl_field,
-			   unsigned int *info_field, int check_zero,
+			   int *info_field, int check_zero,
 			   const char *buf, size_t len)
 {
 	unsigned int x;
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
git-x86.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
