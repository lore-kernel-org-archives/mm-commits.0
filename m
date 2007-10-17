From: akpm@linux-foundation.org
Subject: + kill-warnings-in-mptbaseh-on-parisc64.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:14:25 -0700
Message-ID: <200710172114.l9HLEP4d008641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757756AbXJQVOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:14:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@mcmartin.ca, Eric.Moore@lsil.com, James.Bottomley@steeleye.com


The patch titled
     kill warnings in mptbase.h on parisc64
has been added to the -mm tree.  Its filename is
     kill-warnings-in-mptbaseh-on-parisc64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -922,7 +922,7 @@ extern struct proc_dir_entry	*mpt_proc_r
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif		/* } __KERNEL__ */
 
-#if defined(__alpha__) || defined(__sparc_v9__) || defined(__ia64__) || defined(__x86_64__) || defined(__powerpc__)
+#ifdef CONFIG_64BIT
 #define CAST_U32_TO_PTR(x)	((void *)(u64)x)
 #define CAST_PTR_TO_U32(x)	((u32)(u64)x)
 #else
_

Patches currently in -mm which might be from kyle@mcmartin.ca are

origin.patch
f_dupfd_cloexec-implementation.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
parisc-extern-inline-static-inline.patch
kill-warnings-in-mptbaseh-on-parisc64.patch
bitops-introduce-lock-ops.patch
