Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B04163D5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957005; cv=none; b=uutBMWh3Y2fr6ieSF1rV8dpZzhq4MUgSuqh3ZRzykf5kPfYS5K6uDTaSAb4IyUxpAlh05vyUj4hAReiqjqhnctrLF6904fLk6+et0ByVVwV7szHC/qaTUHgSxhmIlKPIQrvQXn2agQsCLF3EKM5tm/mGHTrjkxmvdgVB5AxIVKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957005; c=relaxed/simple;
	bh=+ZV4hz5SHz6pIqDUqUo7uP+c4Ax/Z0pkVggZbqXyyYU=;
	h=Date:To:From:Subject:Message-Id; b=j5x4rVzOictYc+OZUPOwL8HjrEGG9JJQxVER44putXGhQQ+2SQJ/55GRw4cXPEgrtTOFiiKqp2R2n1Fq6j2fk0MOJ7wpToB66XUAg28p/bDbtTFgez4nmRGZ8espkbGzyvsZlyIsMdjxXF3O42u3SiWoqUQTLlrcEHJPRwMCWx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bdDfwPOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bdDfwPOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0F0C113CC;
	Mon,  6 May 2024 00:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957005;
	bh=+ZV4hz5SHz6pIqDUqUo7uP+c4Ax/Z0pkVggZbqXyyYU=;
	h=Date:To:From:Subject:From;
	b=bdDfwPOt8vEbea/6nc85OEyvQaT5Gxt1ByNFF5ONGZCbNVshlw5eeT+xSf8ApX8of
	 Pn+LB7WfGmLLOSUAUo4m29NnT/gsBgvutssqHP/fniaTZfd3vp90lfQLHCsaSceoV0
	 lZu6Olm9SMgbJAtkHrFk8/ORgpPXaJyn+M7wTa7I=
Date: Sun, 05 May 2024 17:56:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ysato@users.sourceforge.jp,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richardycc@google.com,peterx@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jcmvbkbc@gmail.com,hughd@google.com,glaubitz@physik.fu-berlin.de,fengwei.yin@intel.com,dalias@libc.org,corbet@lwn.net,chris@zankel.net,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch removed from -mm tree
Message-Id: <20240506005645.2E0F0C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: use folio_mapcount() in zap_huge_pmd() sanity check
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: use folio_mapcount() in zap_huge_pmd() sanity check
Date: Tue, 9 Apr 2024 21:22:51 +0200

We want to limit the use of page_mapcount() to the places where it is
absolutely necessary.  Let's similarly check for folio_mapcount()
underflows instead of page_mapcount() underflows like we do in
zap_present_folio_ptes() now.

Instead of the VM_BUG_ON(), we should actually be doing something like
print_bad_pte().  For now, let's keep it simple and use WARN_ON_ONCE(),
performing that check independently of DEBUG_VM.

Link: https://lkml.kernel.org/r/20240409192301.907377-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check
+++ a/mm/huge_memory.c
@@ -1791,7 +1791,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 			folio = page_folio(page);
 			folio_remove_rmap_pmd(folio, page, vma);
-			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
+			WARN_ON_ONCE(folio_mapcount(folio) < 0);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
 		} else if (thp_migration_supported()) {
 			swp_entry_t entry;
_

Patches currently in -mm which might be from david@redhat.com are


