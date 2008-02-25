From: akpm@linux-foundation.org
Subject: + fbcon-replace-mono_col-macro-with-static-inline.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:48:26 -0800
Message-ID: <200802251849.m1PInI7N014061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980AbYBYStz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:49:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, adaplas@pol.net


The patch titled
     fbcon: replace mono_col macro with static inline
has been added to the -mm tree.  Its filename is
     fbcon-replace-mono_col-macro-with-static-inline.patch

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
Subject: fbcon: replace mono_col macro with static inline
From: Harvey Harrison <harvey.harrison@gmail.com>

Use __u32 for max_len to match the declaration of length in the struct
fb_bitfield.

Suppresses sparse shadowed variable warnings from the nested max()
macros:
drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here
drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here
drivers/video/console/fbcon.h:130:8: warning: symbol '_y' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/video/console/fbcon.h~fbcon-replace-mono_col-macro-with-static-inline drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbcon-replace-mono_col-macro-with-static-inline
+++ a/drivers/video/console/fbcon.h
@@ -104,10 +104,14 @@ struct fbcon_ops {
 #define attr_blink(s) \
 	((s) & 0x8000)
 	
-#define mono_col(info)							\
-	(~(0xfff << (max((info)->var.green.length,			\
-			 max((info)->var.red.length,			\
-			     (info)->var.blue.length)))) & 0xff)
+
+static inline int mono_col(struct fb_info *info)
+{
+	__u32 max_len;
+	max_len = max(info->var.green.length, info->var.red.length);
+	max_len = max(info->var.blue.length, max_len);
+	return ~(0xfff << (max_len & 0xff));
+}
 
 static inline int attr_col_ec(int shift, struct vc_data *vc,
 			      struct fb_info *info, int is_fg)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-nfsd.patch
git-sched.patch
git-x86.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
