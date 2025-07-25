Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91522218592;
	Fri, 25 Jul 2025 02:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409691; cv=none; b=PdInWEcODM0o421dhS0fZA7q3EIyIhGpQpNgGohRF/0w4/MBkZAh8NWzeXKk/Wch5QSbvjuKL/JBhklLdgXKoHe45dLjumZckq0lLP2uVJdNBYkLk4/Iu+fxN3IHU3SO0q6zpCpU1GIDCyCFWYKZLdH8Qn+4sf7ZgfaTNKgF4Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409691; c=relaxed/simple;
	bh=XGctmUu+f0VuJwMX9CdWQCNIIUm0NkUPxb8a5KUCr4o=;
	h=Date:To:From:Subject:Message-Id; b=bIz9mugRCx99WHDhOuAsShpyYRiIsH/J8tQKncoSjLJ/GqWac0XjC55wIQCMOSTxyFSm1lxWWVcWC/A/qFesR6S4DXdmHSQuU26qq1mCOcxWW6wIT9bFyVL8igFOErOwdaMwdxYsHJGORjn/xeWk8wHYVqUfEADYF3mixVEgcBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1pRrXNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1pRrXNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657EFC4CEF5;
	Fri, 25 Jul 2025 02:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409691;
	bh=XGctmUu+f0VuJwMX9CdWQCNIIUm0NkUPxb8a5KUCr4o=;
	h=Date:To:From:Subject:From;
	b=W1pRrXNyFELMpzSLFy+dCDwj9oHnPm/ejAdvv5HjZESR8TrsCNZPoza/I2itI736f
	 5/mtEcVniEiE6lgkzYdfhHZ8Ah7epKjhebWO6xns4ZZKPagIB1f2DVEVVwXtyCrBY3
	 EZYcyLrJBOP3EXUbd3Se9lKhsuujyWIpuLDdnTQ8=
Date: Thu, 24 Jul 2025 19:14:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch removed from -mm tree
Message-Id: <20250725021451.657EFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()
has been removed from the -mm tree.  Its filename was
     mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()
Date: Thu, 22 May 2025 20:25:51 +0800

Patch series "Some randome fixes and cleanups to swapfile".

Patch 0-3 are some random fixes.  Patch 4 is a cleanup.  More details can
be found in respective patches.


This patch (of 4):

When folio_alloc_swap() encounters a failure in either
mem_cgroup_try_charge_swap() or add_to_swap_cache(), nr_swap_pages counter
is not decremented for allocated entry.  However, the following
put_swap_folio() will increase nr_swap_pages counter unpairly and lead to
an imbalance.

Move nr_swap_pages decrement from folio_alloc_swap() to swap_range_alloc()
to pair the nr_swap_pages counting.

Link: https://lkml.kernel.org/r/20250522122554.12209-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250522122554.12209-2-shikemeng@huaweicloud.com
Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-move-nr_swap_pages-counter-decrement-from-folio_alloc_swap-to-swap_range_alloc
+++ a/mm/swapfile.c
@@ -1115,6 +1115,7 @@ static void swap_range_alloc(struct swap
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
 	}
+	atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
@@ -1313,7 +1314,6 @@ int folio_alloc_swap(struct folio *folio
 	if (add_to_swap_cache(folio, entry, gfp | __GFP_NOMEMALLOC, NULL))
 		goto out_free;
 
-	atomic_long_sub(size, &nr_swap_pages);
 	return 0;
 
 out_free:
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


