From: akpm@linux-foundation.org
Subject: - modules-include-sectionsh-to-avoid-defining-linker-variables.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:29 -0800
Message-ID: <200802082012.m18KCAv8010177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbYBHUtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:49:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     modules: include sections.h to avoid defining linker variables explicitly
has been removed from the -mm tree.  Its filename was
     modules-include-sectionsh-to-avoid-defining-linker-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: include sections.h to avoid defining linker variables explicitly
From: Christoph Lameter <clameter@sgi.com>

module.c should not define linker variables on its own. We have an include
file for that.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/module.c~modules-include-sectionsh-to-avoid-defining-linker-variables kernel/module.c
--- a/kernel/module.c~modules-include-sectionsh-to-avoid-defining-linker-variables
+++ a/kernel/module.c
@@ -46,6 +46,7 @@
 #include <asm/semaphore.h>
 #include <asm/cacheflush.h>
 #include <linux/license.h>
+#include <asm/sections.h>
 
 #if 0
 #define DEBUGP printk
@@ -343,9 +344,6 @@ static inline unsigned int block_size(in
 	return val;
 }
 
-/* Created by linker magic */
-extern char __per_cpu_start[], __per_cpu_end[];
-
 static void *percpu_modalloc(unsigned long size, unsigned long align,
 			     const char *name)
 {
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
