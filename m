From: akpm@linux-foundation.org
Subject: [merged] mm-bootmemc-remove-unused-wrapper-function-reserve_bootmem_generic.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:30:26 -0800
Message-ID: <20121214233027.266BB200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40983 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab2LNXaa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:30:30 -0500
Received: by mail-ee0-f74.google.com with SMTP id t10so208802eei.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:30:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linfeng@cn.fujitsu.com, hannes@cmpxchg.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/bootmem.c: remove unused wrapper function reserve_bootmem_generic()
has been removed from the -mm tree.  Its filename was
     mm-bootmemc-remove-unused-wrapper-function-reserve_bootmem_generic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lin Feng <linfeng@cn.fujitsu.com>
Subject: mm/bootmem.c: remove unused wrapper function reserve_bootmem_generic()

reserve_bootmem_generic() has no caller,

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    3 ---
 mm/bootmem.c            |    6 ------
 2 files changed, 9 deletions(-)

diff -puN include/linux/bootmem.h~mm-bootmemc-remove-unused-wrapper-function-reserve_bootmem_generic include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-bootmemc-remove-unused-wrapper-function-reserve_bootmem_generic
+++ a/include/linux/bootmem.h
@@ -137,9 +137,6 @@ extern void *__alloc_bootmem_low_node(pg
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
 
-extern int reserve_bootmem_generic(unsigned long addr, unsigned long size,
-				   int flags);
-
 #ifdef CONFIG_HAVE_ARCH_ALLOC_REMAP
 extern void *alloc_remap(int nid, unsigned long size);
 #else
diff -puN mm/bootmem.c~mm-bootmemc-remove-unused-wrapper-function-reserve_bootmem_generic mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmemc-remove-unused-wrapper-function-reserve_bootmem_generic
+++ a/mm/bootmem.c
@@ -460,12 +460,6 @@ int __init reserve_bootmem(unsigned long
 	return mark_bootmem(start, end, 1, flags);
 }
 
-int __weak __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
-				   int flags)
-{
-	return reserve_bootmem(phys, len, flags);
-}
