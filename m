From: akpm@linux-foundation.org
Subject: + mm-bootmemc-remove-unused-wrapper-function-reserve_bootmem_generic.patch added to -mm tree
Date: Tue, 11 Dec 2012 13:58:00 -0800
Message-ID: <20121211215801.13BDF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47479 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2LKV6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 16:58:06 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so220944wib.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 13:58:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linfeng@cn.fujitsu.com, hannes@cmpxchg.org, yinghai@kernel.org


The patch titled
     Subject: mm/bootmem.c: remove unused wrapper function reserve_bootmem_generic()
has been added to the -mm tree.  Its filename is
     mm-bootmemc-remove-unused-wrapper-function-reserve_bootmem_generic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
