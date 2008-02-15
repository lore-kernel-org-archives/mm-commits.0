From: akpm@linux-foundation.org
Subject: + ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:25:46 -0800
Message-ID: <200802152125.m1FLPkKh024763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756840AbYBOV0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:26:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, VANDROVE@vc.cvut.cz


The patch titled
     ncpfs: fix sparse warning in ncpsign_kernel.c
has been added to the -mm tree.  Its filename is
     ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch

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
Subject: ncpfs: fix sparse warning in ncpsign_kernel.c
From: Harvey Harrison <harvey.harrison@gmail.com>

We're casting anyway, might as well cast to the correct sign.
Specific to i386 (ifdef __i386__)

fs/ncpfs/ncpsign_kernel.c:58:23: warning: incorrect type in initializer (different signedness)
fs/ncpfs/ncpsign_kernel.c:58:23:    expected unsigned int *data2
fs/ncpfs/ncpsign_kernel.c:58:23:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ncpsign_kernel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ncpfs/ncpsign_kernel.c~ncpfs-fix-sparse-warning-in-ncpsign_kernelc fs/ncpfs/ncpsign_kernel.c
--- a/fs/ncpfs/ncpsign_kernel.c~ncpfs-fix-sparse-warning-in-ncpsign_kernelc
+++ a/fs/ncpfs/ncpsign_kernel.c
@@ -55,7 +55,7 @@ static void nwsign(char *r_data1, char *
  unsigned int w0,w1,w2,w3;
  static int rbit[4]={0, 2, 1, 3};
 #ifdef __i386__
- unsigned int *data2=(int *)r_data2;
+ unsigned int *data2=(unsigned int *)r_data2;
 #else
  unsigned int data2[16];
  for (i=0;i<16;i++)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
