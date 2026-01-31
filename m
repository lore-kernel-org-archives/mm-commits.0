Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A236920CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898269; cv=none; b=tva/KmfvoMyk91mJFltIIjduOGiW0dt/BQ2L+dqzOgf1OmLN6zmQ3w5A+rY6GsFurAHxzmA+VBYvNnbcIp/A6symz6efOhMTats1cjBPvC5DomSAUnQQ65u8Iyw8DymVaZqTQPArmWvkhw45I9GiqVf5bix8E4HdeIsRMPFwhuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898269; c=relaxed/simple;
	bh=FgB1mPIJqq0SJVsGzSC+y/kCfzYwapqAuVoi+hjGRRw=;
	h=Date:To:From:Subject:Message-Id; b=aOnXtlbMYOT/DtybFLJtoWGSmZGyvl0+hriaRtX0Rnc2ugj1Q5AWd59z7meGZHiuMlbV/06P1YZJcyGVNkwNtayUO9xnHusGJcyXehCy/2OUvvv861j7OQhvRQvon6up07TPGsGkPn1lvVTv3WFVeyuFj1R8fxGrFEwDpj7GExU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L5KK2rSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L5KK2rSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DAAC4CEF1;
	Sat, 31 Jan 2026 22:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898269;
	bh=FgB1mPIJqq0SJVsGzSC+y/kCfzYwapqAuVoi+hjGRRw=;
	h=Date:To:From:Subject:From;
	b=L5KK2rSmoAcQtUP/cIrddkdYkl88SFGbzGE84Y4LPWSjTt/FT1GsLwPhscYDWiMXQ
	 l5/2f8jqLj6a/JZ3qSvrCJQIOkkpzVWofVZWQZMOB9e0Jl1sPs1u6soMZoq73zpS8W
	 l/YdBJ63wcCFHvZ4cogCVoutRPwdO+jOdrnX/rcc=
Date: Sat, 31 Jan 2026 14:24:28 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-balloon_compaction-mark-remaining-functions-for-having-proper-kerneldoc.patch removed from -mm tree
Message-Id: <20260131222429.43DAAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/balloon_compaction: mark remaining functions for having proper kerneldoc
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-mark-remaining-functions-for-having-proper-kerneldoc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/balloon_compaction: mark remaining functions for having proper kerneldoc
Date: Tue, 20 Jan 2026 00:01:25 +0100

Looks like all we are missing for proper kerneldoc is another "*".

Link: https://lkml.kernel.org/r/20260119230133.3551867-18-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/balloon_compaction.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/balloon_compaction.c~mm-balloon_compaction-mark-remaining-functions-for-having-proper-kerneldoc
+++ a/mm/balloon_compaction.c
@@ -17,7 +17,7 @@
  */
 static DEFINE_SPINLOCK(balloon_pages_lock);
 
-/*
+/**
  * balloon_page_insert - insert a page into the balloon's page list and make
  *			 the page->private assignment accordingly.
  * @balloon : pointer to balloon device
@@ -37,7 +37,7 @@ static void balloon_page_insert(struct b
 	list_add(&page->lru, &balloon->pages);
 }
 
-/*
+/**
  * balloon_page_finalize - prepare a balloon page that was removed from the
  *			   balloon list for release to the page allocator
  * @page: page to be released to the page allocator
@@ -135,7 +135,7 @@ size_t balloon_page_list_dequeue(struct
 }
 EXPORT_SYMBOL_GPL(balloon_page_list_dequeue);
 
-/*
+/**
  * balloon_page_alloc - allocates a new page for insertion into the balloon
  *			page list.
  *
@@ -158,7 +158,7 @@ struct page *balloon_page_alloc(void)
 }
 EXPORT_SYMBOL_GPL(balloon_page_alloc);
 
-/*
+/**
  * balloon_page_enqueue - inserts a new page into the balloon page list.
  *
  * @b_dev_info: balloon device descriptor where we will insert a new page
@@ -181,7 +181,7 @@ void balloon_page_enqueue(struct balloon
 }
 EXPORT_SYMBOL_GPL(balloon_page_enqueue);
 
-/*
+/**
  * balloon_page_dequeue - removes a page from balloon's page list and returns
  *			  its address to allow the driver to release the page.
  * @b_dev_info: balloon device descriptor where we will grab a page from.
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

