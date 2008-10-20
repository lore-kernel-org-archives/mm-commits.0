From: akpm@linux-foundation.org
Subject: - kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:12 -0700
Message-ID: <200810202037.m9KKbCTl011561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282AbYJTUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: horms@verge.net.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     always reserve elfcore header memory in crash kernel
has been removed from the -mm tree.  Its filename was
     kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: always reserve elfcore header memory in crash kernel
From: Simon Horman <horms@verge.net.au>

elfcore header memory needs to be reserved in a crash kernel.  This means
that the relevant code should be protected by CONFIG_CRASH_DUMP rather
than CONFIG_PROC_VMCORE.

Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c   |    2 +-
 arch/ia64/kernel/setup.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/efi.c~kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel
+++ a/arch/ia64/kernel/efi.c
@@ -1335,7 +1335,7 @@ kdump_find_rsvd_region (unsigned long si
 }
 #endif
 
-#ifdef CONFIG_PROC_VMCORE
+#ifdef CONFIG_CRASH_DUMP
 /* locate the size find a the descriptor at a certain address */
 unsigned long __init
 vmcore_find_descriptor_size (unsigned long address)
diff -puN arch/ia64/kernel/setup.c~kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel
+++ a/arch/ia64/kernel/setup.c
@@ -352,7 +352,7 @@ reserve_memory (void)
 	}
 #endif
 
-#ifdef CONFIG_PROC_VMCORE
+#ifdef CONFIG_CRASH_KERNEL
 	if (reserve_elfcorehdr(&rsvd_region[n].start,
 			       &rsvd_region[n].end) == 0)
 		n++;
@@ -496,9 +496,7 @@ static int __init parse_elfcorehdr(char 
 	return 0;
 }
 early_param("elfcorehdr", parse_elfcorehdr);
-#endif
 
-#ifdef CONFIG_PROC_VMCORE
 int __init reserve_elfcorehdr(unsigned long *start, unsigned long *end)
 {
 	unsigned long length;
_

Patches currently in -mm which might be from horms@verge.net.au are

origin.patch

