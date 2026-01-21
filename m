Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CA235F8BD
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966027; cv=none; b=o0ULVMVgqvlYihoYIhkfLZNfz2bG+zIbKBAT2TqXRk+Xu61mo+SBvZIwuYCpYf6bRzeJ1aqmftsgJQShJ2waKiFbHiscYkJgdcMGdU2lt/1anGysMyDqHlbuygpXlah1033JLydumwYU5LBy5w3x0v5jiPt5I3WXl5I2W4oI5Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966027; c=relaxed/simple;
	bh=BHZ9Ng7u5jAF/5dW4pUmX4RX541xQf1nQsoZ2KYm3fU=;
	h=Date:To:From:Subject:Message-Id; b=iS4QyuRoH/pyMLch2qs1LC4cTsgcNhyQgsCbRjlprsmYXlY/BPFGKM+8gaGpVO/vc2w7BrKo/xQYgyzaZEyg3ZB9brqzK37vdPL2sve2GkUXJ/ZBFVAjfg2KW2S/XDEOXNGLatR/fOQ4nYXxRl19URUa16XB7DkBr/JQnHhcJl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nmzfcBnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nmzfcBnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37365C16AAE;
	Wed, 21 Jan 2026 03:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966027;
	bh=BHZ9Ng7u5jAF/5dW4pUmX4RX541xQf1nQsoZ2KYm3fU=;
	h=Date:To:From:Subject:From;
	b=nmzfcBnmlWWU63JR5LFnlG7f8ON0yrp9sScxFPOb7eGRyYilxAEoD1r9eZR5Brs2+
	 CO4LW10jqeTdXHqTKtlwAghDSXZJFu4wxAF0xS4NeoUWtOjmeMea0SkadmW8WIwCvf
	 rHlXwRoio4r4GSJZa/o6xt3kEKRnnZV2bzCxvGyc=
Date: Tue, 20 Jan 2026 19:27:06 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-rename-zram_free_page.patch removed from -mm tree
Message-Id: <20260121032707.37365C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: rename zram_free_page()
has been removed from the -mm tree.  Its filename was
     zram-rename-zram_free_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: rename zram_free_page()
Date: Mon, 1 Dec 2025 18:47:52 +0900

We don't free page in zram_free_page(), not all slots even have any memory
associated with them (e.g.  ZRAM_SAME).  We free the slot (or reset it),
rename the function accordingly.

Link: https://lkml.kernel.org/r/20251201094754.4149975-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-rename-zram_free_page
+++ a/drivers/block/zram/zram_drv.c
@@ -56,7 +56,7 @@ static size_t huge_class_size;
 
 static const struct block_device_operations zram_devops;
 
-static void zram_free_page(struct zram *zram, size_t index);
+static void zram_slot_free(struct zram *zram, u32 index);
 #define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
 static void zram_slot_lock_init(struct zram *zram, u32 index)
@@ -984,7 +984,7 @@ static int zram_writeback_complete(struc
 		huge = zram_test_flag(zram, index, ZRAM_HUGE);
 	}
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_WB);
 	zram_set_handle(zram, index, req->blk_idx);
 
@@ -2025,7 +2025,7 @@ static void zram_meta_free(struct zram *
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
-		zram_free_page(zram, index);
+		zram_slot_free(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
@@ -2057,7 +2057,7 @@ static bool zram_meta_alloc(struct zram
 	return true;
 }
 
-static void zram_free_page(struct zram *zram, size_t index)
+static void zram_slot_free(struct zram *zram, u32 index)
 {
 	unsigned long handle;
 
@@ -2256,7 +2256,7 @@ static int write_same_filled_page(struct
 				  u32 index)
 {
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_SAME);
 	zram_set_handle(zram, index, fill);
 	zram_slot_unlock(zram, index);
@@ -2294,7 +2294,7 @@ static int write_incompressible_page(str
 	kunmap_local(src);
 
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_flag(zram, index, ZRAM_HUGE);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, PAGE_SIZE);
@@ -2359,7 +2359,7 @@ static int zram_write_page(struct zram *
 	zcomp_stream_put(zstrm);
 
 	zram_slot_lock(zram, index);
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_handle(zram, index, handle);
 	zram_set_obj_size(zram, index, comp_len);
 	zram_slot_unlock(zram, index);
@@ -2581,7 +2581,7 @@ static int recompress_slot(struct zram *
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
 	zcomp_stream_put(zstrm);
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_set_handle(zram, index, handle_new);
 	zram_set_obj_size(zram, index, comp_len_new);
 	zram_set_priority(zram, index, prio);
@@ -2784,7 +2784,7 @@ static void zram_bio_discard(struct zram
 
 	while (n >= PAGE_SIZE) {
 		zram_slot_lock(zram, index);
-		zram_free_page(zram, index);
+		zram_slot_free(zram, index);
 		zram_slot_unlock(zram, index);
 		atomic64_inc(&zram->stats.notify_free);
 		index++;
@@ -2892,7 +2892,7 @@ static void zram_slot_free_notify(struct
 		return;
 	}
 
-	zram_free_page(zram, index);
+	zram_slot_free(zram, index);
 	zram_slot_unlock(zram, index);
 }
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

