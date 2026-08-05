Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373083BE15D
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896653; cv=none; b=gtJ8TgSIActCUrVjD2IuEKixhEs4abNHVhS+oejxm9Dub+Rb4SMIUETMn2asrRWZudM+Cu61bYDwEOAFpdHtkaacAuqJpmymwMCKCKL0vSSlGm4MJFZyF3DMOYyXuMDESDqij5KDhSRlhxwtXn/QpogEFrsBOZadWeur95PV7Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896653; c=relaxed/simple;
	bh=HE8qTjc0J0Wvfc5GeJVbiIo+xBAROmgD9aGg8Q+pmE4=;
	h=Date:To:From:Subject:Message-Id; b=fKYs6AmprkssyHurpVcT0rpEvMopvFyVjgTW+FVKnMCxP8THzvp7/Rs5znYSvVuyRmEFJBOQEsVyUKexvuNrfXMqA4JYsA7DD/YfpKDyS/Igj0yqwvSTkP7q+SoBF/YWuksoqCwSda6F3wR3ajgJrGFvyYMA52/E8I6wPsBsUGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iij+ZoMm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iij+ZoMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA63B1F000E9;
	Wed,  5 Aug 2026 02:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896652;
	bh=T3B/X3fOB4NX2CI5fcQs/y+WVvY3NfzAl6we1gdVwbY=;
	h=Date:To:From:Subject;
	b=iij+ZoMm7gKtyeXiaHWasRbBo4vQzD6FwOpyH6BLkwYP637XyRdhLElSutDg5DIyJ
	 noJU5k04tnYZ0cZoK1GWw5H//v3BtguE+3bFjULJrH+mbeWnAO9Kr+JBTtEnjgWHsT
	 M+OlJI567sqe/ZyfxvuNCLxNmpD9fU1G61tRLm7g=
Date: Tue, 04 Aug 2026 19:24:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mingo@redhat.com,mhocko@suse.com,luto@kernel.org,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hpa@zytor.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dave.hansen@linux.intel.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch removed from -mm tree
Message-Id: <20260805022411.EA63B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
Date: Thu, 16 Jul 2026 16:51:03 +0200

As preparation for further changes, let's temporarily allow freeing pages
that were not previously registered.

This will allow freeing unregistered vmemmap pages allocated during boot
through free_bootmem_page() from hugetlb code, until we fully rip all of
that out.

Link: https://lore.kernel.org/20260716-bootmem_info_part2-v2-4-4afc76c73d61@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem_info.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/bootmem_info.h~mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type
+++ a/include/linux/bootmem_info.h
@@ -44,12 +44,12 @@ static inline void free_bootmem_page(str
 {
 	enum bootmem_type type = bootmem_type(page);
 
-	VM_BUG_ON_PAGE(page_ref_count(page) != 2, page);
-
-	if (type == SECTION_INFO || type == MIX_SECTION_INFO)
+	if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
+		VM_WARN_ON_PAGE(page_ref_count(page) != 2, page);
 		put_page_bootmem(page);
-	else
-		VM_BUG_ON_PAGE(1, page);
+	} else {
+		free_reserved_page(page);
+	}
 }
 #else
 static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
_

Patches currently in -mm which might be from david@kernel.org are

mm-standardize-printing-for-pgtable-entries.patch
mm-gup-fix-always-draining-lru-caches-in-collect_longterm_unpinnable_folios.patch

