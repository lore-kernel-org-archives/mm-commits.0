From: akpm@linux-foundation.org
Subject: + kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch added to -mm tree
Date: Tue, 05 Aug 2008 02:59:16 -0700
Message-ID: <200808050959.m759xGtx028904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbYHEKAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 06:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, vgoyal@redhat.com


The patch titled
     always reserve elfcore header memory in crash kernel
has been added to the -mm tree.  Its filename is
     kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

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
@@ -1334,7 +1334,7 @@ kdump_find_rsvd_region (unsigned long si
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
linux-next.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
kdump-update-elfcorehdr-documentation-to-reflect-supported-architectures.patch
kdump-use-is_kdump_kernel-in-sba_init.patch
kdump-add-is_vmcore_usable-and-vmcore_unusable.patch
kdump-use-is_vmcore_usable-and-vmcore_unusable-in-reserve_elfcorehdr.patch
kdump-ia64-always-reserve-elfcore-header-memory-in-crash-kernel.patch

