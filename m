Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B9736F8EE
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067186; cv=none; b=B0yXqawXhDtyZojIoTDmAMnGgmJLu7p3dtzr35R1/9Drk7JOMg8tEns+z2vXCv64oGNOHqW81g4HrdweSZdxhFG9nYLRoZf+6lUHXUFDyRKsb7LMH1bHRooiFXbs3+1DUczSfFuhgTGiZqrlNsqdeuXAKtM6QzoIGrj6GcyCq9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067186; c=relaxed/simple;
	bh=Udc7URxMQj7jW4A6OpBPdTli52vu33YmIwKL7X62xxQ=;
	h=Date:To:From:Subject:Message-Id; b=oJjVpluwv/PQ+BynMKi2xho0WvzyCv/550dZ7RmYE4noVPENxuJFUoJF5Ideg4JIKrCLhLIyrvtkB6rb19Twj0OeqxRtHlW3si/7WZNw8WHOQlOc/KDf/8RjfkQceLr1ywslIkzBLRpGiPHfe4vU8CsXKQAUnqPUSPuEje3IVQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KiCTlskI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KiCTlskI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66B61F000E9;
	Sun, 21 Jun 2026 18:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067183;
	bh=slHG3L+cEVe+5n5YSvUfueoe8WrV7zS0WdJyYYQ3h80=;
	h=Date:To:From:Subject;
	b=KiCTlskIMk/6qs5AhF9yyI4CQjIih0uo5wylO2fcsioVJz8gAiXy2y+AFdPuDHmY4
	 NuRf1JJFjf+Lvk87Genhb56TRBIzelTOaAJ34rJUpkQcWsQvalZy7AgC5vXwoueG1L
	 gY6oCa0OO/ZeWFzdqYD9181QYfgcvlI0WTmYxCtQ=
Date: Sun, 21 Jun 2026 11:39:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183943.D66B61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:35 +0300

uffd-wp-remap skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Link: https://lore.kernel.org/20260511162840.375890-52-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-wp-mremap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -336,14 +336,14 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	hugepage_save_settings(true, true);
+
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-						    ARRAY_SIZE(hugetlbsizes));
+	nr_hugetlbsizes = hugetlb_setup(1, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
 
-	/* If THP is supported, save THP settings and initially disable THP. */
+	/* If THP is supported, initially disable THP. */
 	if (nr_thpsizes) {
-		thp_save_settings();
 		thp_read_settings(&settings);
 		for (i = 0; i < NR_ORDERS; i++) {
 			settings.hugepages[i].enabled = THP_NEVER;
_

Patches currently in -mm which might be from rppt@kernel.org are


