Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985AC2153E1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188243; cv=none; b=degnEInz915EzIv6pwJHDBPy2PJEbp/vJpzd5v+0e30gKQJxSAqYoDzGuDZwxUX1DtlO+rNf0PMlbXNIC11fVb8qCVlgW+1pvoLZfqDQ/zF6z2jjLMIbFYUlXZngWCtQ6GGeNSCVoIBuJo3XtfsXgGbALYAb2wwh78HYv99p29g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188243; c=relaxed/simple;
	bh=5CZ278D2AWqn61i4DwrIweDqrswoo+aNiiT6s9+xJDM=;
	h=Date:To:From:Subject:Message-Id; b=dv9hE6WSvkXOL5vV3mxfYqYEQ1jHobDmYmIHbXk48iu10oqnHxt9T9zc4QjWQBDYfafPMwE79J2aMgfONS/G9gDtCPeIZc+bRSNPd1A+7YdeOKnXyuDZGxOSr4WDUsBtzTL2Sf2NPhLMf8oxLQzpc5f1J3CMpzCMLg7dmYjYEn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DEkpdlRh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DEkpdlRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF18C4CEEC;
	Mon, 17 Mar 2025 05:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188243;
	bh=5CZ278D2AWqn61i4DwrIweDqrswoo+aNiiT6s9+xJDM=;
	h=Date:To:From:Subject:From;
	b=DEkpdlRhXCnabJUiY0H3fR6ErFaLXmJHqyqxs1t4Yf4ODSUDcwkJwA4y0x2e2wIVV
	 BP0OyA8kwOGnHa0+FpqGkEcbnmUG7bFsC8cmu9G1kEf2Yp//JPRX5ZBlrrC83GWM59
	 M94m2wUzEJjzEQr7cxmPZ9xGTyT9MPC176edfeZQ=
Date: Sun, 16 Mar 2025 22:10:42 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfilec-optimize-code-in-setup_clusters.patch removed from -mm tree
Message-Id: <20250317051043.6DF18C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile.c: optimize code in setup_clusters()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-optimize-code-in-setup_clusters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-optimize-code-in-setup_clusters
+++ a/mm/swapfile.c
@@ -3127,13 +3127,6 @@ static unsigned long read_swap_header(st
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
@@ -3173,13 +3166,20 @@ static int setup_swap_map_and_extents(st
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
@@ -3240,8 +3240,7 @@ static struct swap_cluster_info *setup_c
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


