From: akpm@linux-foundation.org
Subject: - kill-warnings-in-mptbaseh-on-parisc64.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:37 -0800
Message-ID: <200802232022.m1NKMbkD013440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762074AbYBWU2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyle@mcmartin.ca, Eric.Moore@lsil.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     kill warnings in mptbase.h on parisc64
has been removed from the -mm tree.  Its filename was
     kill-warnings-in-mptbaseh-on-parisc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill warnings in mptbase.h on parisc64
From: Kyle McMartin <kyle@mcmartin.ca>

Verified all the arches necessary select the CONFIG_64BIT symbol.  This
also kills the warning (since it was using the 32-bit case) on parisc64 and
mips64.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptbase.h~kill-warnings-in-mptbaseh-on-parisc64 drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~kill-warnings-in-mptbaseh-on-parisc64
+++ a/drivers/message/fusion/mptbase.h
@@ -923,7 +923,7 @@ extern struct proc_dir_entry	*mpt_proc_r
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif		/* } __KERNEL__ */
 
-#if defined(__alpha__) || defined(__sparc_v9__) || defined(__ia64__) || defined(__x86_64__) || defined(__powerpc__)
+#ifdef CONFIG_64BIT
 #define CAST_U32_TO_PTR(x)	((void *)(u64)x)
 #define CAST_PTR_TO_U32(x)	((u32)(u64)x)
 #else
_

Patches currently in -mm which might be from kyle@mcmartin.ca are

git-drm.patch
fix-uli526x-partially-recognizing-interface.patch
update-tulip-maintainers.patch
parisc-new-termios-definitions.patch
git-scsi-rc-fixes.patch
taint-kernel-after-warn_oncondition.patch
asm-futexh-should-include-linux-uaccessh.patch
