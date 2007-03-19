From: akpm@linux-foundation.org
Subject: + revoke-special-mmap-handling-vs-fault-vs-invalidate.patch added to -mm tree
Date: Mon, 19 Mar 2007 12:42:23 -0700
Message-ID: <200703191942.l2JJgNkE015356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbXCSTmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 15:42:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michal.k.k.piotrowski@gmail.com, penberg@cs.helsinki.fi


The patch titled
     revoke-special-mmap-handling-vs-fault-vs-invalidate
has been added to the -mm tree.  Its filename is
     revoke-special-mmap-handling-vs-fault-vs-invalidate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revoke-special-mmap-handling-vs-fault-vs-invalidate
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Acked-by: Pekka J Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~revoke-special-mmap-handling-vs-fault-vs-invalidate include/linux/mm.h
--- a/include/linux/mm.h~revoke-special-mmap-handling-vs-fault-vs-invalidate
+++ a/include/linux/mm.h
@@ -171,7 +171,6 @@ extern unsigned int kobjsize(const void 
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
-#define VM_REVOKED	0x08000000	/* Mapping has been revoked */
 
 #define VM_CAN_INVALIDATE 0x08000000	/* The mapping may be invalidated,
 					 * eg. truncate or invalidate_inode_*.
@@ -179,6 +178,7 @@ extern unsigned int kobjsize(const void 
 					 * return with the page locked.
 					 */
 #define VM_CAN_NONLINEAR 0x10000000	/* Has ->fault & does nonlinear pages */
+#define VM_REVOKED	0x20000000	/* Mapping has been revoked */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch
