Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929E63D5648
	for <mm-commits@vger.kernel.org>; Thu, 16 Jul 2026 23:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784245589; cv=none; b=D9lmt9Bx8xfl8vwpeRNhr6FjgFL+tynhc4UGSEtoXViX9uKeYnhK/Cc9d0+5QXsQwuGbdfAWMyB+mihCRqAKyVPeNa8GY+puYAFTqo4p6zNiqqUaR+ZihW63KSzrTcjb54ti9zqMDmxe6uhyCcAarY9j+4Knr4R2YGZPALGEbh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784245589; c=relaxed/simple;
	bh=vIpJC0akTRSN3GjqML25i0VO7z73TrzUg8BeY4+kvtQ=;
	h=Date:To:From:Subject:Message-Id; b=JxW4IFX9vb+cQo5s2zqCaOMSwMHwgkAGUvyCJi2yH33AdK3nPEQSOcxXOpJFIaFaE+JnsO8s5hpmPZzw6Fe1G3eUxU/LCr+Pm6SffJZF9/bBvQdoH7qPnF09UiSZXudsVcqlt1yfDP6BpFTvYUQb58QQ+47DDQ2ipWNv19Is9S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z1MfSdZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z1MfSdZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680801F00A3A;
	Thu, 16 Jul 2026 23:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784245588;
	bh=vyZDz5eUbGQdkNPN+8M4PGn2YgjhRWJr30twfcDGeL8=;
	h=Date:To:From:Subject;
	b=z1MfSdZuWBMiLe7CX1j0/DXykHgG9lF+9WctWry4iLQi1CGVPUCLyWNCHmMfbADl9
	 YZlnCHd9mPUqsTJ0AitCuo9I1d4t6zyW33MNZeTfWmqVGy1oz5puoG5O8w+mW9ZQsR
	 aEzVp6QgId1kIbh3OvqhZJK2Ofb1VNCPJt3faPRk=
Date: Thu, 16 Jul 2026 16:46:28 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch removed from -mm tree
Message-Id: <20260716234628.680801F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
has been removed from the -mm tree.  Its filename was
     mm-bootmem_info-allow-calling-free_bootmem_page-on-pages-without-a-bootmem_type.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/bootmem_info: allow calling free_bootmem_page() on pages without a bootmem_type
Date: Wed, 08 Jul 2026 16:10:59 +0200

As preparation for further changes, let's temporarily allow freeing pages
that were not previously registered.

This will allow freeing unregistered vmemmap pages allocated during boot
through free_bootmem_page() from hugetlb code, until we fully rip all of
that out.

Link: https://lore.kernel.org/20260708-bootmem_info_part2-v1-4-156ce4986598@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
Cc: Zi Yan <ziy@nvidia.com>
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
x86-mm-stop-marking-vmemmap-as-section_info.patch
x86-mm-stop-marking-page-tables-as-mix_section_info.patch
x86-mm-remove-config_have_bootmem_info_node.patch
mm-hugetlb_vmemmap-remove-bootmem_info-leftovers.patch
mm-sparse-remove-bootmem_infoh-include.patch
mm-bootmem_info-remove-config_have_bootmem_info_node.patch
mm-standardize-printing-for-pgtable-entries.patch

