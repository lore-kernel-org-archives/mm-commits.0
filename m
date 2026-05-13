Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8124A256C61
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 03:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644375; cv=none; b=uEnj6fljxdz4L88/5yx+aCFt2PX2c4lEIILY0iJiCJmVxG/JB/1nX/h012E/AZCkdPM21HBAMSFNT/wUY6XwPrMmXWewj3zgowr8sXASc+bSDWQP8L219sfs8Vpc9awWRY2Rwp4mdkrx7jAsEAcnEBa0nYkrr573uWIQRuOzxvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644375; c=relaxed/simple;
	bh=hWr50w6vVaSLb0mHYxnbGEVejod0H4ObwkwT6ngXMX0=;
	h=Date:To:From:Subject:Message-Id; b=rJpc0b+CbtSbj1rAHYLk5kM/7QoRJOGDGn3XvzUzhXUAcHgMnIQlPCPWXJcjO06NKGY/BK6H0RrwCI3pukBD0mBZ8pstZR7fPS57QmSW3Za+1GJTD6i/3gwph775CUj7zFCMdOTqJZIpFOz46oGym3UCmjHspBQsp+Z4qn7ntgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LeURMqca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LeURMqca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12811C2BCC7;
	Wed, 13 May 2026 03:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778644375;
	bh=hWr50w6vVaSLb0mHYxnbGEVejod0H4ObwkwT6ngXMX0=;
	h=Date:To:From:Subject:From;
	b=LeURMqcahJx+V2Ez/BTvHeXTJdBGOGaQ7ELKQCPGuWu41NdFgmStT09td1W+Meqmy
	 rOX+4WVUnkPDm8bE+gKktqObzf4PSU6Wvgo52tzyLH+ezjhXxovCj7GbWtoSMneYVO
	 kNNj+dhu0rwH/ymsQkYBepd1mcbriFwxdqN19Buw=
Date: Tue, 12 May 2026 20:52:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shivankg@amd.com,rppt@kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,bharata@amd.com,ankur.a.arora@oracle.com,hsalunke@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4.patch added to mm-unstable branch
Message-Id: <20260513035255.12811C2BCC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hrushikesh Salunke <hsalunke@amd.com>
Subject: mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4
Date: Mon, 4 May 2026 06:39:19 +0000

Move clear_highpages_kasan_tagged() from include/linux/highmem.h to
mm/page_alloc.c as a static function to avoid code size increase.  As the
function is only used within page_alloc.c.

Link: https://lore.kernel.org/20260504063942.553438-1-hsalunke@amd.com
Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   15 ---------------
 mm/page_alloc.c         |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/highmem.h~mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4
+++ a/include/linux/highmem.h
@@ -345,21 +345,6 @@ static inline void clear_highpage_kasan_
 	kunmap_local(kaddr);
 }
 
-static inline void clear_highpages_kasan_tagged(struct page *page, int numpages)
-{
-	/* s390's use of memset() could override KASAN redzones. */
-	kasan_disable_current();
-	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
-		clear_pages(kasan_reset_tag(page_address(page)), numpages);
-	} else {
-		int i;
-
-		for (i = 0; i < numpages; i++)
-			clear_highpage_kasan_tagged(page + i);
-	}
-	kasan_enable_current();
-}
-
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
 /* Returns true if the caller has to initialize the pages */
--- a/mm/page_alloc.c~mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4
+++ a/mm/page_alloc.c
@@ -1208,6 +1208,21 @@ static inline bool should_skip_kasan_poi
 	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
 }
 
+static void clear_highpages_kasan_tagged(struct page *page, int numpages)
+{
+	/* s390's use of memset() could override KASAN redzones. */
+	kasan_disable_current();
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		clear_pages(kasan_reset_tag(page_address(page)), numpages);
+	} else {
+		int i;
+
+		for (i = 0; i < numpages; i++)
+			clear_highpage_kasan_tagged(page + i);
+	}
+	kasan_enable_current();
+}
+
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
 /* Should be called only if mem_alloc_profiling_enabled() */
_

Patches currently in -mm which might be from hsalunke@amd.com are

mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing.patch
mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4.patch

