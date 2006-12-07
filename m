From: akpm@osdl.org
Subject: - initrd-remove-unused-false-condition-for.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:03 -0800
Message-ID: <200612072305.kB7N539Y030114@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52335 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163886AbWLGXFJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henry.ne@arcor.de, mm-commits@vger.kernel.org


The patch titled
     initrd: remove unused false condition for initrd_start
has been removed from the -mm tree.  Its filename was
     initrd-remove-unused-false-condition-for.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: initrd: remove unused false condition for initrd_start
From: Henry Nestler <henry.ne@arcor.de>

After LOADER_TYPE && INITRD_START are true, the short if-condition
for INITRD_START can never be false.

Remove unused code from the else condition.

Signed-off-by: Henry Nestler <henry.ne@arcor.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/frv/kernel/setup.c    |    2 +-
 arch/i386/kernel/setup.c   |    3 +--
 arch/m32r/kernel/setup.c   |    4 +---
 arch/m32r/mm/discontig.c   |    4 +---
 arch/sh/kernel/setup.c     |    3 +--
 arch/sh64/kernel/setup.c   |    4 +---
 arch/x86_64/kernel/setup.c |    3 +--
 7 files changed, 7 insertions(+), 16 deletions(-)

diff -puN arch/frv/kernel/setup.c~initrd-remove-unused-false-condition-for arch/frv/kernel/setup.c
--- a/arch/frv/kernel/setup.c~initrd-remove-unused-false-condition-for
+++ a/arch/frv/kernel/setup.c
@@ -947,7 +947,7 @@ static void __init setup_linux_memory(vo
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (low_top_pfn << PAGE_SHIFT)) {
 			reserve_bootmem(INITRD_START, INITRD_SIZE);
-			initrd_start = INITRD_START ? INITRD_START + PAGE_OFFSET : 0;
+			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start + INITRD_SIZE;
 		}
 		else {
diff -puN arch/i386/kernel/setup.c~initrd-remove-unused-false-condition-for arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c~initrd-remove-unused-false-condition-for
+++ a/arch/i386/kernel/setup.c
@@ -1162,8 +1162,7 @@ void __init setup_bootmem_allocator(void
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (max_low_pfn << PAGE_SHIFT)) {
 			reserve_bootmem(INITRD_START, INITRD_SIZE);
-			initrd_start =
-				INITRD_START ? INITRD_START + PAGE_OFFSET : 0;
+			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start+INITRD_SIZE;
 		}
 		else {
diff -puN arch/m32r/kernel/setup.c~initrd-remove-unused-false-condition-for arch/m32r/kernel/setup.c
--- a/arch/m32r/kernel/setup.c~initrd-remove-unused-false-condition-for
+++ a/arch/m32r/kernel/setup.c
@@ -196,9 +196,7 @@ static unsigned long __init setup_memory
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (max_low_pfn << PAGE_SHIFT)) {
 			reserve_bootmem(INITRD_START, INITRD_SIZE);
-			initrd_start = INITRD_START ?
-				INITRD_START + PAGE_OFFSET : 0;
-
+			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start + INITRD_SIZE;
 			printk("initrd:start[%08lx],size[%08lx]\n",
 				initrd_start, INITRD_SIZE);
diff -puN arch/m32r/mm/discontig.c~initrd-remove-unused-false-condition-for arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~initrd-remove-unused-false-condition-for
+++ a/arch/m32r/mm/discontig.c
@@ -105,9 +105,7 @@ unsigned long __init setup_memory(void)
 		if (INITRD_START + INITRD_SIZE <= PFN_PHYS(max_low_pfn)) {
 			reserve_bootmem_node(NODE_DATA(0), INITRD_START,
 				INITRD_SIZE);
-			initrd_start = INITRD_START ?
-				INITRD_START + PAGE_OFFSET : 0;
-
+			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start + INITRD_SIZE;
 			printk("initrd:start[%08lx],size[%08lx]\n",
 				initrd_start, INITRD_SIZE);
diff -puN arch/sh/kernel/setup.c~initrd-remove-unused-false-condition-for arch/sh/kernel/setup.c
--- a/arch/sh/kernel/setup.c~initrd-remove-unused-false-condition-for
+++ a/arch/sh/kernel/setup.c
@@ -332,8 +332,7 @@ void __init setup_arch(char **cmdline_p)
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (max_low_pfn << PAGE_SHIFT)) {
 			reserve_bootmem_node(NODE_DATA(0), INITRD_START+__MEMORY_START, INITRD_SIZE);
-			initrd_start =
-				INITRD_START ? INITRD_START + PAGE_OFFSET + __MEMORY_START : 0;
+			initrd_start = INITRD_START + PAGE_OFFSET + __MEMORY_START;
 			initrd_end = initrd_start + INITRD_SIZE;
 		} else {
 			printk("initrd extends beyond end of memory "
diff -puN arch/sh64/kernel/setup.c~initrd-remove-unused-false-condition-for arch/sh64/kernel/setup.c
--- a/arch/sh64/kernel/setup.c~initrd-remove-unused-false-condition-for
+++ a/arch/sh64/kernel/setup.c
@@ -243,9 +243,7 @@ void __init setup_arch(char **cmdline_p)
 		if (INITRD_START + INITRD_SIZE <= (PFN_PHYS(last_pfn))) {
 		        reserve_bootmem_node(NODE_DATA(0), INITRD_START + __MEMORY_START, INITRD_SIZE);
 
-			initrd_start =
-			  (long) INITRD_START ? INITRD_START + PAGE_OFFSET +  __MEMORY_START : 0;
-
+			initrd_start = (long) INITRD_START + PAGE_OFFSET + __MEMORY_START;
 			initrd_end = initrd_start + INITRD_SIZE;
 		} else {
 			printk("initrd extends beyond end of memory "
diff -puN arch/x86_64/kernel/setup.c~initrd-remove-unused-false-condition-for arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~initrd-remove-unused-false-condition-for
+++ a/arch/x86_64/kernel/setup.c
@@ -471,8 +471,7 @@ void __init setup_arch(char **cmdline_p)
 	if (LOADER_TYPE && INITRD_START) {
 		if (INITRD_START + INITRD_SIZE <= (end_pfn << PAGE_SHIFT)) {
 			reserve_bootmem_generic(INITRD_START, INITRD_SIZE);
-			initrd_start =
-				INITRD_START ? INITRD_START + PAGE_OFFSET : 0;
+			initrd_start = INITRD_START + PAGE_OFFSET;
 			initrd_end = initrd_start+INITRD_SIZE;
 		}
 		else {
_

Patches currently in -mm which might be from henry.ne@arcor.de are

origin.patch

