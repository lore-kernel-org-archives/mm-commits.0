Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1C44FF6C
	for <mm-commits@vger.kernel.org>; Mon, 18 Dec 2023 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pXEBKMI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF51C433C7;
	Mon, 18 Dec 2023 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702919397;
	bh=CMq+sBIf0hsbFqt7DJvLUdyUhKVM88FNjJ0l3cMAGpY=;
	h=Date:To:From:Subject:From;
	b=pXEBKMI/m96c/jCzYgoCmWC0yaiFBnjawowQx7ZHnzXc+dIkqkIxCvXKQcDnz1uQY
	 qEjgt6HmEx5bk1Hw4X3hOdbVD/bzMQHOLwVzxB9N5B9SEPqAR/TM/LDj+Rqn4wWVyw
	 dn0KWQ0+WoLeZVdpgGdqJj+9XBHXH3NXYZnX/rI0=
Date: Mon, 18 Dec 2023 09:09:56 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-cleanup-zswap_load.patch added to mm-unstable branch
Message-Id: <20231218170957.4AF51C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: cleanup zswap_load()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-cleanup-zswap_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-cleanup-zswap_load.patch

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
Subject: mm/zswap: cleanup zswap_load()
Date: Mon, 18 Dec 2023 11:50:34 +0000

After the common decompress part goes to __zswap_load(), we can cleanup
the zswap_load() a little.

Link: https://lkml.kernel.org/r/20231213-zswap-dstmem-v3-4-4eac09b94ece@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/zswap.c~mm-zswap-cleanup-zswap_load
+++ a/mm/zswap.c
@@ -1754,7 +1754,6 @@ bool zswap_load(struct folio *folio)
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
 	u8 *dst;
-	bool ret;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
@@ -1771,19 +1770,16 @@ bool zswap_load(struct folio *folio)
 		dst = kmap_local_page(page);
 		zswap_fill_page(dst, entry->value);
 		kunmap_local(dst);
-		ret = true;
-		goto stats;
+	} else {
+		__zswap_load(entry, page);
 	}
 
-	__zswap_load(entry, page);
-	ret = true;
-stats:
 	count_vm_event(ZSWPIN);
 	if (entry->objcg)
 		count_objcg_event(entry->objcg, ZSWPIN);
 
 	spin_lock(&tree->lock);
-	if (ret && zswap_exclusive_loads_enabled) {
+	if (zswap_exclusive_loads_enabled) {
 		zswap_invalidate_entry(tree, entry);
 		folio_mark_dirty(folio);
 	} else if (entry->length) {
@@ -1793,7 +1789,7 @@ stats:
 	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
-	return ret;
+	return true;
 }
 
 void zswap_invalidate(int type, pgoff_t offset)
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-change-dstmem-size-to-one-page.patch
mm-zswap-reuse-dstmem-when-decompress.patch
mm-zswap-refactor-out-__zswap_load.patch
mm-zswap-cleanup-zswap_load.patch
mm-zswap-cleanup-zswap_writeback_entry.patch
mm-zswap-directly-use-percpu-mutex-and-buffer-in-load-store.patch

