Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA652771B
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 00:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784246583; cv=none; b=c/q6JWtQsrttfxYK5Tlh3SasBNUSKtxRaQQ3KWhrLX/DWVWeCdigJ3amjagMgPzNqRsAYekMw7ExJURyNDWXJHK+7yTo2lqjdUcMRGsyQSE4hwO9+btTJHo/hum67omkMaCssT0CycpDXRwu0VAnvn/9uNfh+aWOtkXXGjDrph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784246583; c=relaxed/simple;
	bh=oQNTqVbfLxAj231F2fDmBJ9A9WcuuhlHckv7awrGP9g=;
	h=Date:To:From:Subject:Message-Id; b=bHlkhOu4FB6UWds6u5QdITp5XqCsR6/KNWWZA6Y+VVPc6pq4IFNZUU4KeowjXHVhU2DLzK2HEKyU30s/j5qRep3t+nCfhu7dkQlDU7IhfadMgGv/U7AbxGcWFmTjIO3D5h5y46zhIAjLs3HGKjd7aLOAiikR3R22qf+/L5QZrfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R6MbWvVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R6MbWvVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108141F000E9;
	Fri, 17 Jul 2026 00:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784246582;
	bh=OL+rgeqLqIIwuk1843CecQH5ZVjejStPyFUgva+2h4w=;
	h=Date:To:From:Subject;
	b=R6MbWvVwHxCFLdodHkP0GyhsuOGTCEiztNfWwzvl5lCVJkJIYChhSesi/wHM4iWxI
	 oaLIg34olkeZXgh+4geQqvbwLxkBoQsYUPtY2A/Q6sO7fFtdX51YOn7NLuBqykQeFQ
	 ApZG95LNJoydbdIYTLs5fM+vUnsJUvzcxyxjLKQI=
Date: Thu, 16 Jul 2026 17:03:01 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch added to mm-unstable branch
Message-Id: <20260717000302.108141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch

This patch will later appear in the mm-unstable branch at
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

sparc-mm-drop-custom-pte_clear_not_present_full.patch
mm-drop-pte_clear_not_present_full.patch
mm-cleanup-clear_not_present_full_ptes-and-rename-to-clear_non_present_ptes.patch
x86-mm-drop-order-parameter-from-free_pagetable.patch
mm-provide-free_reserved_pages-removing-x86-variant.patch
s390-mm-use-free_reserved_pages-in-vmem_free_pages.patch
mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

