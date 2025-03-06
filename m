Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B39029CF0;
	Thu,  6 Mar 2025 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239441; cv=none; b=Zq5m4wjufuEnoewUmgu82rA2LxgB7dxXXTyVJ7UWAbYXel0jrj/zrHHnoS9K94PeDSjr+zus+FoVvGsBcZ/u3uQEicwhrPu5ir0WgoXref1PFCmqM5oChDG1RZ+ZoWE0xNodq1ilAfJ3zGpyB3DQ2cnmCueXjOBvdr0j20jc4Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239441; c=relaxed/simple;
	bh=nYne5yH1VDGAzLhrfF7RFXPn2k79XFCWhgBE7G9vUTc=;
	h=Date:To:From:Subject:Message-Id; b=UiRn3vLmGylpjo1Y53aVBGqOXw+9Ju0n8basX85hSaLLH7ON0FG6xV8PO1wDWHdo2tlqZ9I5ZYvQBW4C69C4rAxmFc1lkA0wZ30Arae3GSTz60uAC3CDLTJD+FdjgnglNNcVY4aisEn4aLcLuvy49u3Gb4anwTW/zEvoS2TLSVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSB+Re0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSB+Re0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CFCC4CEE4;
	Thu,  6 Mar 2025 05:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239441;
	bh=nYne5yH1VDGAzLhrfF7RFXPn2k79XFCWhgBE7G9vUTc=;
	h=Date:To:From:Subject:From;
	b=FSB+Re0sUpioRQ8JKXBYvnwBi9H98R5ks/7l754sy17lCvKj7XQ3RImHS3pR86woF
	 v66Oa//HDXoTsXIoFUn52RzbjGrrT8bMty9BN3od81JbXEK9ISWYMrQqHdMz6jQsa3
	 MQWmWiXliJRpjVefOx6gygYJHbdD7HT9s6fYcgts=
Date: Wed, 05 Mar 2025 21:37:20 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.com,linmiaohe@huawei.com,david@redhat.com,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch removed from -mm tree
Message-Id: <20250306053721.13CFCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory-hotplug: check folio ref count first in do_migrate_range
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ma Wupeng <mawupeng1@huawei.com>
Subject: mm: memory-hotplug: check folio ref count first in do_migrate_range
Date: Mon, 17 Feb 2025 09:43:28 +0800

If a folio has an increased reference count, folio_try_get() will acquire
it, perform necessary operations, and then release it.  In the case of a
poisoned folio without an elevated reference count (which is unlikely for
memory-failure), folio_try_get() will simply bypass it.

Therefore, relocate the folio_try_get() function, responsible for checking
and acquiring this reference count at first.

Link: https://lkml.kernel.org/r/20250217014329.3610326-3-mawupeng1@huawei.com
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory-hotplug-check-folio-ref-count-first-in-do_migrate_range
+++ a/mm/memory_hotplug.c
@@ -1822,12 +1822,12 @@ static void do_migrate_range(unsigned lo
 		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
-		/*
-		 * HWPoison pages have elevated reference counts so the migration would
-		 * fail on them. It also doesn't make any sense to migrate them in the
-		 * first place. Still try to unmap such a page in case it is still mapped
-		 * (keep the unmap as the catch all safety net).
-		 */
+		if (!folio_try_get(folio))
+			continue;
+
+		if (unlikely(page_folio(page) != folio))
+			goto put_folio;
+
 		if (folio_test_hwpoison(folio) ||
 		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
 			if (WARN_ON(folio_test_lru(folio)))
@@ -1835,14 +1835,8 @@ static void do_migrate_range(unsigned lo
 			if (folio_mapped(folio))
 				unmap_poisoned_folio(folio, pfn, false);
 
-			continue;
-		}
-
-		if (!folio_try_get(folio))
-			continue;
-
-		if (unlikely(page_folio(page) != folio))
 			goto put_folio;
+		}
 
 		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
_

Patches currently in -mm which might be from mawupeng1@huawei.com are


