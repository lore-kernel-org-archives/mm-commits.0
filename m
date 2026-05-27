Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4934127A10F
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 01:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779846666; cv=none; b=Jo1uCIEeSLieHZVJDSFZXqaeCA1JSnKXMbWwo8AxgXB11GM76NlZ5LdKxfwbWI9ukNbT8mDNbazkt9fZaZ7QxUhy4TgfQPqoJFKMBGplF5h1IYdUyowac2qXc15ae+uIoLjINTaS6guXmDr/e4oNAnG2YcI+K03IbAfRDWg8s0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779846666; c=relaxed/simple;
	bh=h6UU315UUIe7BV2eSGfDBsOFloZYxpf/BGIeiB4+E4k=;
	h=Date:To:From:Subject:Message-Id; b=kMfxOEGWzbpA/Zs2zz+12+WSRGM0jXNFjRNxTKh2TsHEstR0xCUlL4jHo2bxEDytFM8OULH84xhcPr4IgqMPsoRMLHoJ4KCEip7+zqDridPhX4HwKVTfKJ/eLyFD3fpVPkz2o1QvIJAD7JiL1dM4+2VlVwQjgx2ABm9K0BnYtyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BfGpfXAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BfGpfXAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A4B1F000E9;
	Wed, 27 May 2026 01:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779846664;
	bh=T9qRoyTADPrKHmAH/tq2a8ZcQSC8KG1WzegSCFSTzEo=;
	h=Date:To:From:Subject;
	b=BfGpfXAy3ICUldguXuFjbrjXi6HAir1vO20FuuKlmxg03zJYe0cChASXa8eskD8Yd
	 t6PDBZEvQZvo98BvlOYcdZTFnbVCSjTPOeU2OI6+24DRIAlGxBvIuhLBgMAp9MdgC8
	 ufh3EyXUjDCpiQiWs5Gls/HU9cnxOtl1Iw0IE3S0=
Date: Tue, 26 May 2026 18:51:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shivankg@amd.com,rppt@kernel.org,pankaj.gupta@amd.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,bharata@amd.com,ankur.a.arora@oracle.com,hsalunke@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4.patch removed from -mm tree
Message-Id: <20260527015104.D0A4B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing-v4.patch

This patch was dropped because it was folded into mm-page_alloc-replace-kernel_init_pages-with-batch-page-clearing.patch

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
@@ -1211,6 +1211,21 @@ static inline bool should_skip_kasan_poi
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

