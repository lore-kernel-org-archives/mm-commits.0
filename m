Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43E22236E0
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783381687; cv=none; b=IXpYUgC59Y+VAAgQzybupCM6N6RRhJGerrwcg6oyLGML/DqZvgb/b4SZNOybeLvdTQVpK8c5uZD33luxUbY8X6GK5aUbQ3rKJZSlO3crLp/aQ5LR0pqHzREgELyiY81tHIXdxKPxFrtzBEC2KX9p3dO2q1h/HAvanA/kqmIr5A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783381687; c=relaxed/simple;
	bh=Kh1QkZ0d2Y3RLpeJMu5SX/RJKtLPCdpsXTz7CpB3VoU=;
	h=Date:To:From:Subject:Message-Id; b=X2hdZXUY+7pFmr0TXSffWl5JmCJ8SWjQ5Z1OjgN938UmobxlrWBbMNi9WQwLG27zrDg5h/pngOxIx5G84pdjNfLwCqLLmMyxEVl74LKp4JdvfLN/0FG7lEbQrO6wDb7UJmo7OQ5A+ebRA3xfCz0yiEJg2AuVPqlTpB0w91keyvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AtBFOHUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AtBFOHUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766821F000E9;
	Mon,  6 Jul 2026 23:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783381685;
	bh=9mgPmQ7p9kP7l1cl/kde/bmCn2kHXPRPuaS4MbW/fFM=;
	h=Date:To:From:Subject;
	b=AtBFOHUouPuHPY7GlSdx5lJ5v++VikfXQ2cxp/Ql/d3KKxPzJoKo4ojSfsl9dwG37
	 7/RkgKCyc/5Sd4OsBS6Cahy2FFwwPCATPiRf7vAIZxRq30lZCsa0zupClTdja1te9n
	 mCyr0Cwu+RlqUXH3DIqaHjN63t8doaY6pUjTvuB4=
Date: Mon, 06 Jul 2026 16:48:05 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-add-mremap-selftests-for-ksm_rmap_walk.patch added to mm-new branch
Message-Id: <20260706234805.766821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: add mremap selftests for ksm_rmap_walk
has been added to the -mm mm-new branch.  Its filename is
     ksm-add-mremap-selftests-for-ksm_rmap_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-add-mremap-selftests-for-ksm_rmap_walk.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

ksm-add-linear_page_index-into-ksm_rmap_item.patch
ksm-optimize-rmap_walk_ksm-by-passing-a-suitablepage-index.patch
ksm-add-mremap-selftests-for-ksm_rmap_walk.patch

