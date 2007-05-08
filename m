From: akpm@linux-foundation.org
Subject: + wrap-access-to-thread_info-fix.patch added to -mm tree
Date: Tue, 08 May 2007 13:48:08 -0700
Message-ID: <200705082048.l48Km8mT001227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934278AbXEHUsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 16:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org


The patch titled
     rename-thread_info-to-stack-fix 2
has been added to the -mm tree.  Its filename is
     wrap-access-to-thread_info-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rename-thread_info-to-stack-fix 2
From: Roman Zippel <zippel@linux-m68k.org>

The two changes to asm-offsets.c belong to second rename patch and the
rest is for the first wrapper patch.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/asm-offsets.c  |    2 +-
 arch/m68knommu/kernel/asm-offsets.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/blackfin/kernel/asm-offsets.c~wrap-access-to-thread_info-fix arch/blackfin/kernel/asm-offsets.c
--- a/arch/blackfin/kernel/asm-offsets.c~wrap-access-to-thread_info-fix
+++ a/arch/blackfin/kernel/asm-offsets.c
@@ -46,7 +46,7 @@ int main(void)
 	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
 	DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
 	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
-	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
 	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
 	DEFINE(TASK_SIGPENDING, offsetof(struct task_struct, pending));
diff -puN arch/m68knommu/kernel/asm-offsets.c~wrap-access-to-thread_info-fix arch/m68knommu/kernel/asm-offsets.c
--- a/arch/m68knommu/kernel/asm-offsets.c~wrap-access-to-thread_info-fix
+++ a/arch/m68knommu/kernel/asm-offsets.c
@@ -31,7 +31,7 @@ int main(void)
 	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
 	DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
 	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
-	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
 	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
is_power_of_2-in-fs-hfs.patch
optimize-timespec_trunc.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
wrap-access-to-thread_info.patch
wrap-access-to-thread_info-fix.patch
rename-thread_info-to-stack.patch
rename-thread_info-to-stack-fix.patch
rename-thread_info-to-stack-fix-2.patch
