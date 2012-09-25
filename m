From: akpm@linux-foundation.org
Subject: + gpu-drm-ttm-use-copy_highpage.patch added to -mm tree
Date: Tue, 25 Sep 2012 12:33:45 -0700
Message-ID: <20120925193346.0C35C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:49088 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2IYTds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 15:33:48 -0400
Received: by faet1 with SMTP id t1so468767fae.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 12:33:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, airlied@linux.ie


The patch titled
     Subject: gpu/drm/ttm: use copy_highpage
has been added to the -mm tree.  Its filename is
     gpu-drm-ttm-use-copy_highpage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
gpu-drm-ttm-use-copy_highpage.patch
cciss-cleanup-bitops-usage.patch
cciss-use-check_signature.patch
drbd-use-copy_highpage.patch

