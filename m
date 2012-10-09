From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-section-mismatch-warning-for-memblock_type_name.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:44 -0700
Message-ID: <20121009181445.3AB03200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:59967 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab2JISOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:47 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so59111eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rprabhu@wnohang.net, benh@kernel.crashing.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid section mismatch warning for memblock_type_name
has been removed from the -mm tree.  Its filename was
     mm-avoid-section-mismatch-warning-for-memblock_type_name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: mm: avoid section mismatch warning for memblock_type_name

Following section mismatch warning is thrown during build;

    WARNING: vmlinux.o(.text+0x32408f): Section mismatch in reference from the function memblock_type_name() to the variable .meminit.data:memblock
    The function memblock_type_name() references
    the variable __meminitdata memblock.
    This is often because memblock_type_name lacks a __meminitdata
    annotation or the annotation of memblock is wrong.

This is because memblock_type_name makes reference to memblock variable
with attribute __meminitdata.  Hence, the warning (even if the function is
inline).

[akpm@linux-foundation.org: remove inline]
Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-avoid-section-mismatch-warning-for-memblock_type_name mm/memblock.c
--- a/mm/memblock.c~mm-avoid-section-mismatch-warning-for-memblock_type_name
+++ a/mm/memblock.c
@@ -41,7 +41,8 @@ static int memblock_memory_in_slab __ini
 static int memblock_reserved_in_slab __initdata_memblock = 0;
 
 /* inline so we don't get a warning when pr_debug is compiled out */
-static inline const char *memblock_type_name(struct memblock_type *type)
+static __init_memblock const char *
+memblock_type_name(struct memblock_type *type)
 {
 	if (type == &memblock.memory)
 		return "memory";
_

Patches currently in -mm which might be from rprabhu@wnohang.net are

origin.patch

