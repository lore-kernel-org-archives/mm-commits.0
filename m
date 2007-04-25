From: akpm@linux-foundation.org
Subject: - mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch removed from -mm tree
Date: Wed, 25 Apr 2007 04:48:23 -0700
Message-ID: <200704251148.l3PBmNsH001738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948AbXDYLs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 07:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, ak@suse.de, jeremy@goop.org, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     i386: for debugging, make the initial page table setup less forgiving
has been removed from the -mm tree.  Its filename was
     mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: i386: for debugging, make the initial page table setup less forgiving
From: "H. Peter Anvin" <hpa@zytor.com>

We just discovered that the accounting for initial memory usage (head.S:
INIT_MAP_BEYOND_END) has been way, way off for a very long time.  This
patch makes the initial page table not round up to the nearest 4M boundary,
but instead stop dead (and zero the rest of the final page table) as soon
as it hits the configured limit.

This patch is intended as a debugging aid.  If it goes into the kernel, it
should go in at the very beginning of a review cycle, as it may very well
expose real failures (without Jeremy's patch to fix the accounting, it
*will* crash.)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/head.S~mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving
+++ a/arch/i386/kernel/head.S
@@ -146,15 +146,27 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
 	movl %ecx,page_pde_offset(%edx)		/* Store kernel PDE entry */
 	addl $4,%edx
 	movl $1024, %ecx
+	/*
+	 * End condition: we must map up to and including
+	 * INIT_MAP_BEYOND_END bytes beyond the end of our
+	 * own page tables; 0x1000 is the size of the page
+	 * table were about to write, and +0x007 is the
+	 * attribute bits.
+	 */
+	leal (INIT_MAP_BEYOND_END+0x1000+0x007)(%edi),%ebp
 11:
 	stosl
 	addl $0x1000,%eax
-	loop 11b
-	/* End condition: we must map up to and including INIT_MAP_BEYOND_END */
-	/* bytes beyond the end of our own page tables; the +0x007 is the attribute bits */
-	leal (INIT_MAP_BEYOND_END+0x007)(%edi),%ebp
 	cmpl %ebp,%eax
-	jb 10b
+	jae 12f
+	loop 11b
+	jmp 10b
+12:
+	/* Clear the remainder of the last page table */
+	decl %ecx
+	xorl %eax,%eax
+	rep; stosl
+
 	movl %edi,(init_pg_tables_end - __PAGE_OFFSET)
 
 	xorl %ebx,%ebx				/* This is the boot CPU (BSP) */
_

Patches currently in -mm which might be from hpa@zytor.com are

git-kbuild.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
devpts-add-fsnotify-create-event.patch
console-utf-8-fixes.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
