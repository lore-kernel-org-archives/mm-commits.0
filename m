Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF1C383A5;
	Fri, 16 Aug 2024 05:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785429; cv=none; b=d5Y/dCnjG7QqKfFK8SQBn5D36FR+h6WZkDIkv5xOmVr9P5bETZwFw7Qb0NQOwL8B++fq+uXQBmcaQ9FxlG+Hq2W4hKk2IYr1odrr6kFMHBcTG+QseoLQiTiNURb8xh994bH7PFZxxHFF4nIC6owZC7BILTpqwsSlLjK1M9raOGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785429; c=relaxed/simple;
	bh=jEYJA4PiBytJUwCbMUJiRBQslD2gzQ2Lr5+nIZTb1t4=;
	h=Date:To:From:Subject:Message-Id; b=QUCnw9xdIWRErLYfIH3b/EEpFlU2015OZKdVX50e7ZyaEttGj3E+hg9V1yeHDJSBEhz7Us1fk30q6zwHbbdrxd1AMw2ok4CYgEL4SzAJoXUjvsAWk92ZFAoRV1lCOCBh5uS5y9Az73+bN2wSk+kw36SYbFU86GwXCatgWdkWNQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zp9K/mq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zp9K/mq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8A9C4AF0B;
	Fri, 16 Aug 2024 05:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785428;
	bh=jEYJA4PiBytJUwCbMUJiRBQslD2gzQ2Lr5+nIZTb1t4=;
	h=Date:To:From:Subject:From;
	b=Zp9K/mq5f7cgBBKflIDlRHNygPM07hm8lDsCe/v5sCeRF0GxiZvOSrXqRz3KtAfLq
	 YhIDn3j9o9OzI9c3z4qMyTgxdN0xtiUYcFsjQ4l1ufXrRezgLXTRo8DKiGdEARMNJC
	 4MPx1ak/CmeTGRJB48C/Q6s5b4jQX4Bf4BZBxrck=
Date: Thu, 15 Aug 2024 22:17:08 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,souravpanda@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,keescook@chromium.org,david@redhat.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged.patch removed from -mm tree
Message-Id: <20240816051708.AA8A9C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: mark pages reserved during CMA activation as not tagged
has been removed from the -mm tree.  Its filename was
     alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: mark pages reserved during CMA activation as not tagged
Date: Tue, 13 Aug 2024 08:07:57 -0700

During CMA activation, pages in CMA area are prepared and then freed
without being allocated.  This triggers warnings when memory allocation
debug config (CONFIG_MEM_ALLOC_PROFILING_DEBUG) is enabled.  Fix this by
marking these pages not tagged before freeing them.

Link: https://lkml.kernel.org/r/20240813150758.855881-2-surenb@google.com
Fixes: d224eb0287fb ("codetag: debug: mark codetags for reserved pages as empty")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.10]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mm_init.c~alloc_tag-mark-pages-reserved-during-cma-activation-as-not-tagged
+++ a/mm/mm_init.c
@@ -2244,6 +2244,8 @@ void __init init_cma_reserved_pageblock(
 
 	set_pageblock_migratetype(page, MIGRATE_CMA);
 	set_page_refcounted(page);
+	/* pages were reserved and not allocated */
+	clear_page_tag_ref(page);
 	__free_pages(page, pageblock_order);
 
 	adjust_managed_page_count(page, pageblock_nr_pages);
_

Patches currently in -mm which might be from surenb@google.com are


