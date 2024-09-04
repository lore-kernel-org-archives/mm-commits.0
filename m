Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE2C8062A
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423612; cv=none; b=VI5oltkD0kDYYBF9EGBbAjRwdCpKFCEE3G6B0boYYZY1rqeOP9NMS0Xbs8ADSMqWoo7wpSyJJhAxXwqk1Upl866enjKZg0btvBdvVOd80N+h3HYFoTxrfTCLWlEsMMRWiuTy+7tXDbeAjdq86fM4Lp8JBx3xotAGNArAyLmQaqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423612; c=relaxed/simple;
	bh=OLhewcmPV0GKt7CtVnfvVv2Qr/u7QdDb/fPgooUm3u8=;
	h=Date:To:From:Subject:Message-Id; b=KO77B+VuF1UuhH6f1aPQfFRZBJdYQoDen/j3xaFJo79iMIXp6x0tId5i8DHsxwGLly3TJgzbeRfTZcGLLSkZQVcZYlaqM6hrACHmx9Osr9ofGmvJIfXRwDS7KXgVCdmwU0csHuMC3DgG8TXibn1HR8o1xPzWnAB4p74WEkQUDPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=czMFg0X7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="czMFg0X7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E08C4CEC2;
	Wed,  4 Sep 2024 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423612;
	bh=OLhewcmPV0GKt7CtVnfvVv2Qr/u7QdDb/fPgooUm3u8=;
	h=Date:To:From:Subject:From;
	b=czMFg0X7YpfU/aXK4aAX7BsSzqT5zUWmJhvoWBAzgfdg26nBf6KWbSfBnE9iu63lK
	 5cZxChr0sl3HzgyZPptT4DXD76DURpO++yWdOYADGOT2sqCgrEWM4k/DRv7ouMayg2
	 97Tu3XYCQe6bla6Qfqkq+2SF4f0fpT7X8Krr7HlY=
Date: Tue, 03 Sep 2024 21:20:12 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,Jonathan.Cameron@huawei.com,david@redhat.com,dan.carpenter@linaro.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch removed from -mm tree
Message-Id: <20240904042012.B1E08C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory_hotplug: check hwpoisoned page firstly in do_migrate_range()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory_hotplug: check hwpoisoned page firstly in do_migrate_range()
Date: Tue, 27 Aug 2024 19:47:26 +0800

Commit b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages to
be offlined") don't handle the hugetlb pages, the endless loop still occur
if offline a hwpoison hugetlb page, luckly, after the commit e591ef7d96d6
("mm, hwpoison,hugetlb,memory_hotplug: hotremove memory section with
hwpoisoned hugepage"), the HPageMigratable of hugetlb page will be
cleared, and the hwpoison hugetlb page will be skipped in
scan_movable_pages(), so the endless loop issue is fixed.

However if the HPageMigratable() check passed(without reference and lock),
the hugetlb page may be hwpoisoned, it won't cause issue since the
hwpoisoned page will be handled correctly in the next movable pages scan
loop, and it will be isolated in do_migrate_range() but fails to migrate. 
In order to avoid the unnecessary isolation and unify all hwpoisoned page
handling, let's unconditionally check hwpoison firstly, and if it is a
hwpoisoned hugetlb page, try to unmap it as the catch all safety net like
normal page does.

Link: https://lkml.kernel.org/r/20240827114728.3212578-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1793,26 +1793,26 @@ static void do_migrate_range(unsigned lo
 		 * folio_nr_pages() may read garbage.  This is fine as the outer
 		 * loop will revisit the split folio later.
 		 */
-		if (folio_test_large(folio)) {
+		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
-			if (folio_test_hugetlb(folio)) {
-				isolate_hugetlb(folio, &source);
-				continue;
-			}
-		}
 
 		/*
 		 * HWPoison pages have elevated reference counts so the migration would
 		 * fail on them. It also doesn't make any sense to migrate them in the
 		 * first place. Still try to unmap such a page in case it is still mapped
-		 * (e.g. current hwpoison implementation doesn't unmap KSM pages but keep
-		 * the unmap as the catch all safety net).
+		 * (keep the unmap as the catch all safety net).
 		 */
-		if (PageHWPoison(page)) {
+		if (folio_test_hwpoison(folio) ||
+		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio))
-				try_to_unmap(folio, TTU_IGNORE_MLOCK);
+				unmap_poisoned_folio(folio, TTU_IGNORE_MLOCK);
+			continue;
+		}
+
+		if (folio_test_hugetlb(folio)) {
+			isolate_hugetlb(folio, &source);
 			continue;
 		}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-convert-to-migrate_device_coherent_folio.patch
mm-migrate_device-use-a-folio-in-migrate_device_range.patch
mm-migrate_device-use-more-folio-in-migrate_device_unmap.patch
mm-migrate_device-use-more-folio-in-migrate_device_finalize.patch
mm-remove-isolate_lru_page.patch
mm-remove-isolate_lru_page-fix.patch
mm-remove-putback_lru_page.patch

