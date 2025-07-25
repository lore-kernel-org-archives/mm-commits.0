Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68FB1F4606
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485515; cv=none; b=sjyvd7s5orwzaDEYJY6/WUeQF1NS9xg/2JmkuNp0pkckE357oHvdYjjx2Bd77P8GBP5rtEhpYx8Bh+J63jWTSUDjgocpjGXUXCNwRNeU0/QfNNg0KJfd471lTvlUUZePpYNgablgwLyhVXEl7Ee+n2hwuKhqEbJVnSnrGxl4SS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485515; c=relaxed/simple;
	bh=6PkWgFgHpGDNNUHM34PFFBPZE0d1AlD2JxtsWyspTN8=;
	h=Date:To:From:Subject:Message-Id; b=DzoHmD6WV7uO1jOvGusmdte+eMeOwoUHHr0xPvCh6Educ3KSD6CivIpVrztuqBIHyDP2VhTZf4/N7+XvGpPn2S6tgvIPI0fvRmSdv4eC4dKN2qHCKHNqyDw+MOSu9G8OvE17vI0JcqFafkV8NNeaovy9phMdyxAGBgwfsEzoXAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SaiDjp+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SaiDjp+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A323C4CEE7;
	Fri, 25 Jul 2025 23:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753485514;
	bh=6PkWgFgHpGDNNUHM34PFFBPZE0d1AlD2JxtsWyspTN8=;
	h=Date:To:From:Subject:From;
	b=SaiDjp+509g5muq1w6Y4P2Wjiv2Pz+SusRJ7+vSEJGIEHfT3nrrQzk8iPSZC6CaNB
	 XNxIP1ke2cjchZ/lUUaVoxDv1Ac666Ob45wyzl7tkPzgWB3RRhLga5wPMEVg0lIY04
	 29N20aOkom1Y3GU1QboeX5yfzn3uzct4VqUH5Vds=
Date: Fri, 25 Jul 2025 16:18:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-add-anon_vma-lifetime-debug-check-fix.patch removed from -mm tree
Message-Id: <20250725231834.5A323C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-rmap-add-anon_vma-lifetime-debug-check-fix
has been removed from the -mm tree.  Its filename was
     mm-rmap-add-anon_vma-lifetime-debug-check-fix.patch

This patch was dropped because it was folded into mm-rmap-add-anon_vma-lifetime-debug-check.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rmap-add-anon_vma-lifetime-debug-check-fix
Date: Thu Jul 24 02:48:22 PM PDT 2025

PAGE_MAPPING_ANON became FOLIO_MAPPING_ANON

Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/rmap.h~mm-rmap-add-anon_vma-lifetime-debug-check-fix
+++ a/include/linux/rmap.h
@@ -458,8 +458,9 @@ static inline void __folio_rmap_sanity_c
 	 */
 	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
 		unsigned long mapping = (unsigned long)folio->mapping;
-		struct anon_vma *anon_vma = (void *)(mapping - PAGE_MAPPING_ANON);
+		struct anon_vma *anon_vma;
 
+		anon_vma = (void *)(mapping - FOLIO_MAPPING_ANON);
 		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-swap-simplify-swapin-path-and-result-handling-fix.patch
mm-shmem-swap-simplify-swapin-path-and-result-handling-fix-fix.patch
mm-shmem-swap-rework-swap-entry-and-index-calculation-for-large-swapin-fix.patch
selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch
mm-rmap-add-anon_vma-lifetime-debug-check.patch
mm-remove-mm-io-mappingc-fix.patch
init-kconfig-restore-config_broken-help-text.patch

