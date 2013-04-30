From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-parameter-of-pages_correctly_reserved.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:49 -0700
Message-ID: <20130430184949.7C7A95A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:53992 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760747Ab3D3Stu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:50 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so85334ggc.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, gregkh@linuxfoundation.org, wangsl-fnst@cn.fujitsu.com, wency@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Remove unused parameter of pages_correctly_reserved()
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-parameter-of-pages_correctly_reserved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm: Remove unused parameter of pages_correctly_reserved()

nr_pages is not used in pages_correctly_reserved().
So remove it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/base/memory.c~mm-remove-unused-parameter-of-pages_correctly_reserved drivers/base/memory.c
--- a/drivers/base/memory.c~mm-remove-unused-parameter-of-pages_correctly_reserved
+++ a/drivers/base/memory.c
@@ -207,8 +207,7 @@ int memory_isolate_notify(unsigned long
  * The probe routines leave the pages reserved, just as the bootmem code does.
  * Make sure they're still that way.
  */
-static bool pages_correctly_reserved(unsigned long start_pfn,
-					unsigned long nr_pages)
+static bool pages_correctly_reserved(unsigned long start_pfn)
 {
 	int i, j;
 	struct page *page;
@@ -256,7 +255,7 @@ memory_block_action(unsigned long phys_i
 
 	switch (action) {
 		case MEM_ONLINE:
-			if (!pages_correctly_reserved(start_pfn, nr_pages))
+			if (!pages_correctly_reserved(start_pfn))
 				return -EBUSY;
 
 			ret = online_pages(start_pfn, nr_pages, online_type);
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch
linux-next.patch

