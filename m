Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BCB26AC3;
	Wed, 19 Mar 2025 02:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742351761; cv=none; b=ioL4KdZ7cZKnQHRhXTkuyYd41ujlYUEsgf9N9nwE+KQV+YLzsG8QzMzhqU412moNxK9Vs+uyBX9vGMGKDNmdjJQISBda1Jaqa0cWE8ddNMMCrQnqZpgWtboYpENwt83eq2quBBDG0YpCOFdDeDhA+2XDDIQvkusgWKjqgRnfCxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742351761; c=relaxed/simple;
	bh=xb5SFRMygfgsERA62SRyrX7p8qZzwJiov/07IUUWFEA=;
	h=Date:To:From:Subject:Message-Id; b=X05iEdnQwCIwfkdyAYVISmOrOFA60VH3xjmlagfSNhm5756yJTCqYsrMCFJmmfbrtI4AGXI3ZfPd4fRVUcCFqV12DGVUyRVu3oLY+OT6Mtud3F1ytiOgRmd/s6GUoZ2mKUbkSYOH+krJk+aial/nMDSkDP3sjpeyjF9y0o6SZmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AtdXXQM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AtdXXQM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD54C4CEE3;
	Wed, 19 Mar 2025 02:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742351761;
	bh=xb5SFRMygfgsERA62SRyrX7p8qZzwJiov/07IUUWFEA=;
	h=Date:To:From:Subject:From;
	b=AtdXXQM8J2zmSpViAsHInyfGXXYZeN35vXiyr/ddcPEJ2wdGyiqRiMc6LUxjax+yd
	 hFUdKXohUIKSTPRceDPXQ4V/G6IUNEIdGyX41CD0sb+Cn4qNqjfEBmRNgif0xSBMiu
	 xGrRQpj8WwsKlDQO9c8WuH3/X8wLDhoqcTcyV670=
Date: Tue, 18 Mar 2025 19:36:00 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,kernel.org,stable@vger,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper.patch added to mm-unstable branch
Message-Id: <20250319023601.0DD54C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper
Date: Tue, 18 Mar 2025 16:39:38 +0800

Patch series "mm/vmscan: don't try to reclaim hwpoison folio".

Fix a bug during memory reclaim if folio is hwpoisoned.


This patch (of 2):

Introduce helper folio_contain_hwpoisoned_page() to check if the entire
folio is hwpoisoned or it contains hwpoisoned pages.

Link: https://lkml.kernel.org/r/20250318083939.987651-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20250318083939.987651-2-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger,kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ++++++
 mm/memory_hotplug.c        |    3 +--
 mm/shmem.c                 |    3 +--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper
+++ a/include/linux/page-flags.h
@@ -1135,6 +1135,12 @@ static inline bool is_page_hwpoison(cons
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
+static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
+{
+	return folio_test_hwpoison(folio) ||
+	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
+}
+
 bool is_free_buddy_page(const struct page *page);
 
 PAGEFLAG(Isolated, isolated, PF_ANY);
--- a/mm/memory_hotplug.c~mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper
+++ a/mm/memory_hotplug.c
@@ -1828,8 +1828,7 @@ static void do_migrate_range(unsigned lo
 		if (unlikely(page_folio(page) != folio))
 			goto put_folio;
 
-		if (folio_test_hwpoison(folio) ||
-		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
+		if (folio_contain_hwpoisoned_page(folio)) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio)) {
--- a/mm/shmem.c~mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper
+++ a/mm/shmem.c
@@ -3290,8 +3290,7 @@ shmem_write_begin(struct file *file, str
 	if (ret)
 		return ret;
 
-	if (folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
+	if (folio_contain_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch
mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper.patch
mm-vmscan-dont-try-to-reclaim-hwpoison-folio.patch

