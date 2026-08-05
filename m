Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E2D3BED18
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896682; cv=none; b=lQSnxYdSuVxSxghzIy2duHdd+0RdRXhiZqrSHLMsG8JZXXtRUxnfFBamx7ZKpb+nDcPXo4PPPLPB6fVArGyOZy5CNfmWQ1m7jzvL44OzlCZ9tSWiMuXXFTiin75nMZAwUl3Xon8Vf2k6ojbm4fqtNZYhek62qk8MUBkJxMs0Le8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896682; c=relaxed/simple;
	bh=A3q6bH8SzKVvWPfHJGr+Nra0wHCamSaldr9jWls/d94=;
	h=Date:To:From:Subject:Message-Id; b=UNyqOuDBy9FGegqVIdRNExuVFHkPDftVy4NQzYBBXz5cK5JcMnJbp2C+4xkbhj30lfwMExb+yXwBBTM+VT3q8WUJiZW1N7USTc2GgBZ9KwhuKhVxB5ejlo7X0xre11UuTGKI0FyL9OqCF/XOneWf/sH5O8dbew6ZOUJm1KLXrwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=10wH2mfB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="10wH2mfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57D41F00A3A;
	Wed,  5 Aug 2026 02:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896678;
	bh=qt7DtKsYBty1Im9BFwCEwvFHddKF+9P3qVk3RPmVqBk=;
	h=Date:To:From:Subject;
	b=10wH2mfBoT5nexoiKmTbm20VYDVYJSZvJyurMPSj1fhXqawVD4E50xY+wyTbaCxeJ
	 XoWfxhKIqKE8Xu418upn2rLnpMVg4ckE96VHD0uhFo2zYvQmcnvrwJfK+tu0lsk5Qg
	 A60mdSi8NsyzKfpQndGSfNTtCpoVhkvNfLsU+2cQ=
Date: Tue, 04 Aug 2026 19:24:38 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-add-mremap-selftests-for-ksm_rmap_walk.patch removed from -mm tree
Message-Id: <20260805022438.A57D41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: add mremap selftests for ksm_rmap_walk
has been removed from the -mm tree.  Its filename was
     ksm-add-mremap-selftests-for-ksm_rmap_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: ksm: add mremap selftests for ksm_rmap_walk
Date: Fri, 3 Jul 2026 16:26:37 +0800 (CST)

The existing tools/testing/selftests/mm/rmap.c has already one testcase
for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration of
page from one NUMA node to another NUMA node.  However, it just lacks the
scenario of mremapped VMAs.

We add the calling of mremap() and then trigger KSM to merge pages before
migrating, which is specifically to test an optimization which is
introduced by this patch ("ksm: Optimize rmap_walk_ksm by passing a
suitable address pgoff").

This test can reproduce the issue that Hugh points out at
https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/

Link: https://lore.kernel.org/20260703162637070FU4ekl58Hw_Z7OSuJryZB@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/rmap.c |   81 ++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

--- a/tools/testing/selftests/mm/rmap.c~ksm-add-mremap-selftests-for-ksm_rmap_walk
+++ a/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,85 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }
 
+static bool range_maps_the_same_pfn(int pagemap_fd, void *region, int nr_pages)
+{
+	int i;
+	int retries = 0;
+	unsigned long first_pfn;
+
+retry:
+	if (retries > 10)
+		return false;
+
+	first_pfn = pagemap_get_pfn(pagemap_fd, region);
+	for (i = 0; i < nr_pages; i++) {
+		if (pagemap_get_pfn(pagemap_fd, region + i * getpagesize()) != first_pfn) {
+			/*
+			 * Retry up to 10 times at most in case of the low chance of page
+			 * compaction migrating the page while we check for pfn.
+			 */
+			retries++;
+			goto retry;
+		}
+	}
+
+	return true;
+}
+
+TEST_F(migrate, ksm_and_mremap)
+{
+	unsigned long old_pfn, new_pfn;
+	void *region, *mremap_region;
+	const int nr_pages = 16;
+	size_t mmap_size;
+	int pagemap_fd;
+
+	/* Skip if KSM is not available */
+	if (ksm_stop() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\" failed");
+	if (ksm_get_full_scans() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\" failed");
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		SKIP(return, "opening pagemap failed");
+
+	/* Allocate and populate twice the anon pages initially. */
+	mmap_size = 2 * nr_pages * getpagesize();
+	region = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(region, MAP_FAILED);
+	memset(region, 0x77, mmap_size);
+
+	/* mremap the second half over the first half, to stress rmap handling */
+	mmap_size /= 2;
+	mremap_region = mremap(region + mmap_size, mmap_size, mmap_size,
+			       MREMAP_MAYMOVE | MREMAP_FIXED, region);
+	ASSERT_EQ(mremap_region, region);
+
+	/* Merge all pages into a single KSM page. */
+	madvise(region, mmap_size, MADV_MERGEABLE);
+	ASSERT_EQ(ksm_start(), 0);
+
+	/* The whole range should map the same KSM page. */
+	old_pfn = pagemap_get_pfn(pagemap_fd, region);
+	if (old_pfn == -1ul)
+		SKIP(return, "Obtaining PFN failed");
+	ksm_start();
+	ASSERT_TRUE(range_maps_the_same_pfn(pagemap_fd, region, nr_pages));
+
+	/*
+	 * Migrate the KSM page; the whole range should map the new (migrated)
+	 * KSM page.
+	 */
+	ASSERT_EQ(try_to_move_page(region), 0);
+
+	new_pfn = pagemap_get_pfn(pagemap_fd, region);
+	if (new_pfn == -1ul)
+		SKIP(return, "Obtaining PFN failed");
+	ASSERT_NE(new_pfn, old_pfn);
+	ASSERT_TRUE(range_maps_the_same_pfn(pagemap_fd, region, nr_pages));
+}
+
+
 TEST_HARNESS_MAIN
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

mm-mm_sloth-add-a-helper-function-mm_slot_remove.patch
mm-mm_sloth-add-comments-for-mm_slot_lookup-insert.patch

