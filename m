From: akpm@linux-foundation.org
Subject: [merged] gpu-drm-ttm-use-copy_highpage.patch removed from -mm tree
Date: Tue, 02 Oct 2012 12:33:19 -0700
Message-ID: <20121002193320.9DB855C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:55836 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2JBTdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2012 15:33:22 -0400
Received: by wibhr7 with SMTP id hr7so79118wib.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Oct 2012 12:33:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, airlied@linux.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: gpu/drm/ttm: use copy_highpage
has been removed from the -mm tree.  Its filename was
     gpu-drm-ttm-use-copy_highpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: gpu/drm/ttm: use copy_highpage

Use copy_highpage() to copy from one page to another.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ttm/ttm_tt.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff -puN drivers/gpu/drm/ttm/ttm_tt.c~gpu-drm-ttm-use-copy_highpage drivers/gpu/drm/ttm/ttm_tt.c
--- a/drivers/gpu/drm/ttm/ttm_tt.c~gpu-drm-ttm-use-copy_highpage
+++ a/drivers/gpu/drm/ttm/ttm_tt.c
@@ -290,8 +290,6 @@ int ttm_tt_swapin(struct ttm_tt *ttm)
 	struct file *swap_storage;
 	struct page *from_page;
 	struct page *to_page;
-	void *from_virtual;
-	void *to_virtual;
 	int i;
 	int ret = -ENOMEM;
 
@@ -311,11 +309,7 @@ int ttm_tt_swapin(struct ttm_tt *ttm)
 			goto out_err;
 
 		preempt_disable();
-		from_virtual = kmap_atomic(from_page);
-		to_virtual = kmap_atomic(to_page);
-		memcpy(to_virtual, from_virtual, PAGE_SIZE);
-		kunmap_atomic(to_virtual);
-		kunmap_atomic(from_virtual);
+		copy_highpage(to_page, from_page);
 		preempt_enable();
 		page_cache_release(from_page);
 	}
@@ -336,8 +330,6 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 	struct file *swap_storage;
 	struct page *from_page;
 	struct page *to_page;
-	void *from_virtual;
-	void *to_virtual;
 	int i;
 	int ret = -ENOMEM;
 
@@ -367,11 +359,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 			goto out_err;
 		}
 		preempt_disable();
-		from_virtual = kmap_atomic(from_page);
-		to_virtual = kmap_atomic(to_page);
-		memcpy(to_virtual, from_virtual, PAGE_SIZE);
-		kunmap_atomic(to_virtual);
-		kunmap_atomic(from_virtual);
+		copy_highpage(to_page, from_page);
 		preempt_enable();
 		set_page_dirty(to_page);
 		mark_page_accessed(to_page);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
cciss-cleanup-bitops-usage.patch
cciss-use-check_signature.patch
drbd-use-copy_highpage.patch

