Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3096B40855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917828; cv=none; b=btqiiREoQew4NO4evImuTVL/NjeaDkcT+PhWQrs5hezeLBE4MSX1qpvFElQZwpuq6idjoaDijW3Dh1AqaI66kwR8Zr660dPMWh+tKAliJ6HxhwNbQxg+1SxmWK6kTlDKOUkhen1bDPsrjFqFRgCBBWgdTltYgL0b+Pc+An6rzfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917828; c=relaxed/simple;
	bh=lqZebV49O5YXaFZr1Es+RqnlTfrnN9FzXCjEyLBaXMQ=;
	h=Date:To:From:Subject:Message-Id; b=vC7WKFnmJ1TMnjh9TZFDF1TiCfQKIbuUSyXtYpeaZr7gmp3RH9z82umLFVK4MHSOIwxRccetAVmW3LUuKzSmaZiQNg2JST2i0gvGBN46oXm3uL5Jz2nK8ktu0Jjdegcvt7MlOimQaeaGkgbKq8YWxlgCO3hOr4ch4Oa4dGISdzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z2khK7jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z2khK7jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E3BC4CEF7;
	Tue, 31 Mar 2026 00:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917828;
	bh=lqZebV49O5YXaFZr1Es+RqnlTfrnN9FzXCjEyLBaXMQ=;
	h=Date:To:From:Subject:From;
	b=Z2khK7jofEe2so/7eZHarbawzx3nfSfXB03eF5WeKGtCWUd1RPybDIdV+tCBXQo2a
	 14hr6nqvnfYlD+4iT2c9TxfCwDsMlbwGyqRAQJECO2ipJkbvPG0WMWXg6Msu/hNmO0
	 tz8yDCA/1yek+h+ix3DVCe+zEigCFvpWGCA12Wno=
Date: Mon, 30 Mar 2026 17:43:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-unnecessary-vm_bug_on_page.patch removed from -mm tree
Message-Id: <20260331004348.07E3BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-unnecessary-vm_bug_on_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
Date: Fri, 20 Mar 2026 18:07:23 +0000

This has been around since the beginnings of the THP implementation.  I
think we can safely assume that, if we have a THP folio, it will have a
head page.

Link: https://lkml.kernel.org/r/f3fa8eb4634ccb2e78209f570cc1a769a02ce93e.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-unnecessary-vm_bug_on_page
+++ a/mm/huge_memory.c
@@ -2452,7 +2452,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 		folio = page_folio(page);
 		folio_remove_rmap_pmd(folio, page, vma);
 		WARN_ON_ONCE(folio_mapcount(folio) < 0);
-		VM_BUG_ON_PAGE(!PageHead(page), page);
 	} else if (pmd_is_valid_softleaf(orig_pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

