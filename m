Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724C5225799
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828658; cv=none; b=rPsHybm4ptlXfougkrJK/Y2uHYm+6E0LZl998rp1EU0S8sOuiArOwWxdekERHV5NSK1qOWA6sCnF+G3BPmoHFoyMvr8qKrCS2QPRUIguWiRog3IbV083F6zuuss59T9sjkgY6gRldmD0AyDIQPqS0Fw5KHeNI6OYwataVHVtUJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828658; c=relaxed/simple;
	bh=P6FQLomqeL4wDg1ixEfqhxN9qZN8JdXAut2hff1Et3Q=;
	h=Date:To:From:Subject:Message-Id; b=h+uUP2bf+rXECqbSUFkgFz+6xsyvcM3RwzVlOhw2O0ISCjnseZOFYHX/cu0LD0KRWgXEv4rDYAUOMrPq/MaQgI3DXxEqTvANrI6fPCYr9w8EUFNS9Q8CuxdpUtBZvDzXo//xN1lzLRsXbf9orXXhLWWjSzsgttfPA8FtaxYmKH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tTvT98xB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tTvT98xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44912C4CEDD;
	Thu,  6 Feb 2025 07:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828658;
	bh=P6FQLomqeL4wDg1ixEfqhxN9qZN8JdXAut2hff1Et3Q=;
	h=Date:To:From:Subject:From;
	b=tTvT98xBJmaiGRFxza85WBM40YGaAJ8wjzFlSTKgFQvUwct+QRFkv/0AqwDksEiqy
	 uBGzo+89or4vsPz0mkZRGnqW5EptWJb+JrLHfuU/7TIwtvdbXIUj5Qtrx0jxRMRcvd
	 ZzZnxlivyz0i9mtfe0TrdnBGW61pduMOa1g9IjY0=
Date: Wed, 05 Feb 2025 23:57:37 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfilec-optimize-code-in-setup_clusters.patch added to mm-unstable branch
Message-Id: <20250206075738.44912C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile.c: optimize code in setup_clusters()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfilec-optimize-code-in-setup_clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfilec-optimize-code-in-setup_clusters.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: optimize code in setup_clusters()
Date: Wed, 5 Feb 2025 17:27:16 +0800

In the last 'for' loop inside setup_clusters(), using two local variable
'k' and 'j' are obvisouly redundant.  Using 'j' is enough and simpler.

And also move macro SWAP_CLUSTER_COLS close to its only user
setup_clusters().

Link: https://lkml.kernel.org/r/20250205092721.9395-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-optimize-code-in-setup_clusters
+++ a/mm/swapfile.c
@@ -3123,13 +3123,6 @@ static unsigned long read_swap_header(st
 	return maxpages;
 }
 
-#define SWAP_CLUSTER_INFO_COLS						\
-	DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
-#define SWAP_CLUSTER_SPACE_COLS						\
-	DIV_ROUND_UP(SWAP_ADDRESS_SPACE_PAGES, SWAPFILE_CLUSTER)
-#define SWAP_CLUSTER_COLS						\
-	max_t(unsigned int, SWAP_CLUSTER_INFO_COLS, SWAP_CLUSTER_SPACE_COLS)
-
 static int setup_swap_map_and_extents(struct swap_info_struct *si,
 					union swap_header *swap_header,
 					unsigned char *swap_map,
@@ -3169,13 +3162,20 @@ static int setup_swap_map_and_extents(st
 	return nr_extents;
 }
 
+#define SWAP_CLUSTER_INFO_COLS						\
+	DIV_ROUND_UP(L1_CACHE_BYTES, sizeof(struct swap_cluster_info))
+#define SWAP_CLUSTER_SPACE_COLS						\
+	DIV_ROUND_UP(SWAP_ADDRESS_SPACE_PAGES, SWAPFILE_CLUSTER)
+#define SWAP_CLUSTER_COLS						\
+	max_t(unsigned int, SWAP_CLUSTER_INFO_COLS, SWAP_CLUSTER_SPACE_COLS)
+
 static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 						union swap_header *swap_header,
 						unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
-	unsigned long i, j, k, idx;
+	unsigned long i, j, idx;
 	int cpu, err = -ENOMEM;
 
 	cluster_info = kvcalloc(nr_clusters, sizeof(*cluster_info), GFP_KERNEL);
@@ -3236,8 +3236,7 @@ static struct swap_cluster_info *setup_c
 	 * Reduce false cache line sharing between cluster_info and
 	 * sharing same address space.
 	 */
-	for (k = 0; k < SWAP_CLUSTER_COLS; k++) {
-		j = k % SWAP_CLUSTER_COLS;
+	for (j = 0; j < SWAP_CLUSTER_COLS; j++) {
 		for (i = 0; i < DIV_ROUND_UP(nr_clusters, SWAP_CLUSTER_COLS); i++) {
 			struct swap_cluster_info *ci;
 			idx = i * SWAP_CLUSTER_COLS + j;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch

