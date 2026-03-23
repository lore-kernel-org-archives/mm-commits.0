Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E33D9DD7;
	Mon, 23 Mar 2026 19:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774294408; cv=none; b=l+7Ruq5vf48RZlEIKNYLXL5JWliX2zANTdnaI0vHX7HSjE9OULyp9ItGnBsWQZWih9TdTm4DICq9EJFmOMqkGkh3htpybIhIfKnNX9TmHrhklPzK1uJyFjdzfbVLQAVVsW9dUCbj4eJs0XiYOpPsZ/5tPYpe5vfPOSSzKMgUWyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774294408; c=relaxed/simple;
	bh=zow9YRq0acOQfoT/XfESlELBk3oR8YQBr/E7jvEyFwI=;
	h=Date:To:From:Subject:Message-Id; b=frlIxJCv4jMQa3IK7ty9iwZVzj9USFxTTww3hxDJeNalsBVtY9kG20Dey0FZz0gO7aMX/iM97tX4KHgztyza3JKfVVYgjfU47HomiTeRjyR/zOhITtYBLOZCOEqodN6M4YW0fKLiR0ghw/4vskhZ88z+tlnv9rLLSBh42JI2/Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XdOPfo/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XdOPfo/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C301C4CEF7;
	Mon, 23 Mar 2026 19:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774294407;
	bh=zow9YRq0acOQfoT/XfESlELBk3oR8YQBr/E7jvEyFwI=;
	h=Date:To:From:Subject:From;
	b=XdOPfo/u7nmLWXkJSW2LF8dqOpVx5Cc2jPU5DjWKv0eKu86mIZqPF4x/uV9iL4ylw
	 60Cw3w98zS3ii2D1WmOZHVlrYOlTX8Q2YnCYaB9Lw/4Uzmwd/4NsU43tT9J3Rjehi1
	 Zq0tsxrNixnuww8jYsv345FRYurykgfphPseQQkc=
Date: Mon, 23 Mar 2026 12:33:26 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,stable@vger.kernel.org,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,baohua@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4.patch added to mm-hotfixes-unstable branch
Message-Id: <20260323193327.3C301C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4
Date: Sat, 21 Mar 2026 15:52:14 +0800

update function name and comments

Link: https://lkml.kernel.org/r/20260321075214.3305564-1-tujinjiang@huawei.com
Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leafops.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/leafops.h~mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4
+++ a/include/linux/leafops.h
@@ -363,10 +363,14 @@ static inline unsigned long softleaf_to_
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
-static inline void softleaf_migration_entry_check(softleaf_t entry,
-			struct folio *folio)
+static inline void softleaf_migration_sync(softleaf_t entry,
+		struct folio *folio)
 {
-	/* See __split_folio_to_order() comment */
+	/*
+	 * Ensure we do not race with split, which might alter tail pages into new
+	 * folios and thus result in observing an unlocked folio.
+	 * This matches the write barrier in __split_folio_to_order().
+	 */
 	smp_rmb();
 
 	/*
@@ -388,7 +392,7 @@ static inline struct page *softleaf_to_p
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
 	if (softleaf_is_migration(entry))
-		softleaf_migration_entry_check(entry, page_folio(page));
+		softleaf_migration_sync(entry, page_folio(page));
 
 	return page;
 }
@@ -405,7 +409,7 @@ static inline struct folio *softleaf_to_
 
 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
 	if (softleaf_is_migration(entry))
-		softleaf_migration_entry_check(entry, folio);
+		softleaf_migration_sync(entry, folio);
 
 	return folio;
 }
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio.patch
mm-huge_memory-fix-folio-isnt-locked-in-softleaf_to_folio-v4.patch
mm-hugetlb-fix-memory-offline-failure-due-to-hwpoisoned-file-hugetlb.patch

