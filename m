Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F5D1EB31
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bKJscmBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8173EC433C7;
	Wed, 13 Dec 2023 20:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702499665;
	bh=+0qxICMOiThTDhbb1sIcGxAOKdB4YhlRr6UYp+vsPo4=;
	h=Date:To:From:Subject:From;
	b=bKJscmBUxBCZWix6H99Z/PeUDVDBIGThOx2RAQgh/9G4f1unxAheveVuJLnNM6PKu
	 l7z5+gFF/SFK9h+eMkUF6LGCGt4n2rRyFm8OsN/88aQyZTHwxYq8BYNBKEJGIVegrX
	 eBOE93Y4l75iBn5/RX6R0XGzBOOf37mFcljN8Pe8=
Date: Wed, 13 Dec 2023 12:34:25 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-cleanup-zswap_reclaim_entry.patch added to mm-unstable branch
Message-Id: <20231213203425.8173EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: cleanup zswap_reclaim_entry()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-cleanup-zswap_reclaim_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-cleanup-zswap_reclaim_entry.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: cleanup zswap_reclaim_entry()
Date: Wed, 13 Dec 2023 04:18:02 +0000

Also after the common decompress part goes to __zswap_load(), we can
cleanup the zswap_reclaim_entry() a little.

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v1-5-896763369d04@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Li <chriscli@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

--- a/mm/zswap.c~mm-zswap-cleanup-zswap_reclaim_entry
+++ a/mm/zswap.c
@@ -1449,7 +1449,6 @@ static int zswap_writeback_entry(struct
 	struct page *page;
 	struct mempolicy *mpol;
 	bool page_was_allocated;
-	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 	};
@@ -1458,16 +1457,13 @@ static int zswap_writeback_entry(struct
 	mpol = get_task_policy(current);
 	page = __read_swap_cache_async(swpentry, GFP_KERNEL, mpol,
 				NO_INTERLEAVE_INDEX, &page_was_allocated, true);
-	if (!page) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	if (!page)
+		return -ENOMEM;
 
 	/* Found an existing page, we raced with load/swapin */
 	if (!page_was_allocated) {
 		put_page(page);
-		ret = -EEXIST;
-		goto fail;
+		return -EEXIST;
 	}
 
 	/*
@@ -1481,8 +1477,7 @@ static int zswap_writeback_entry(struct
 	if (zswap_rb_search(&tree->rbroot, swp_offset(entry->swpentry)) != entry) {
 		spin_unlock(&tree->lock);
 		delete_from_swap_cache(page_folio(page));
-		ret = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 	spin_unlock(&tree->lock);
 
@@ -1498,15 +1493,7 @@ static int zswap_writeback_entry(struct
 	__swap_writepage(page, &wbc);
 	put_page(page);
 
-	return ret;
-
-fail:
-	/*
-	 * If we get here because the page is already in swapcache, a
-	 * load may be happening concurrently. It is safe and okay to
-	 * not free the entry. It is also okay to return !0.
-	 */
-	return ret;
+	return 0;
 }
 
 static int zswap_is_page_same_filled(void *ptr, unsigned long *value)
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-reuse-dstmem-when-decompress.patch
mm-zswap-change-dstmem-size-to-one-page.patch
mm-zswap-refactor-out-__zswap_load.patch
mm-zswap-cleanup-zswap_load.patch
mm-zswap-cleanup-zswap_reclaim_entry.patch

