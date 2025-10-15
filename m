Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712F11624D5;
	Wed, 15 Oct 2025 20:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559911; cv=none; b=l+sPGx0mNb5hrRF/mBREM+nRylnVbDm+796qZYSgcuqLJPtxxDRF5ViWcTnCKp7fEQRmU21L1JbtiHXNdD4JFes/cLigsUaJJ/fvj43JusLTYGeLzW7ILKwGrjU+3/oW3nl7vhBeWbgpn0Y/GpxOw65PVb2Z4yHaYEpZ1BGQTU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559911; c=relaxed/simple;
	bh=IH/jew1XIGhcfFImpaKLyBtyjCm2P4tkn288/0zi63s=;
	h=Date:To:From:Subject:Message-Id; b=nCm8d0lBMtJvBCMtLfqmiriNMaSh9O9egeDU3RdKXzoSH20RSIzFSZ7rcp8Q74WzWew8E+uku5HVuwCMUSVoCokqjJeaAkT2nbRysshnkioI3PfJ3DqisDDhoLUBc9nynGXCUZrN4n8bPJg/1VqiWAgAvf/ZzAZolcCrQN2YTBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XInMVMdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XInMVMdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4067CC4CEF8;
	Wed, 15 Oct 2025 20:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760559911;
	bh=IH/jew1XIGhcfFImpaKLyBtyjCm2P4tkn288/0zi63s=;
	h=Date:To:From:Subject:From;
	b=XInMVMdzQi55J6AHerB2VSaHRJO3+bzoMQt9jjJWfI0kgXYU8SjHSiHz7/6dXfabR
	 odfbOojrUXCBVmHHczdElrgHty5CpiSUjnj9AF2rHtc5QY5IJGI3PxSBNmC6wt/03L
	 nEz04mlMnuY9YKWkr+MbribNxs7OXv7/ov0rQv7k=
Date: Wed, 15 Oct 2025 13:25:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,tony.luck@intel.com,stable@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jiaqiyan@google.com,farrah.chen@intel.com,dev.jain@arm.com,david@redhat.com,baohua@kernel.org,qiuxu.zhuo@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-prevent-poison-consumption-when-splitting-thp.patch removed from -mm tree
Message-Id: <20251015202511.4067CC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prevent poison consumption when splitting THP
has been removed from the -mm tree.  Its filename was
     mm-prevent-poison-consumption-when-splitting-thp.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: mm: prevent poison consumption when splitting THP
Date: Sat, 11 Oct 2025 15:55:19 +0800

When performing memory error injection on a THP (Transparent Huge Page)
mapped to userspace on an x86 server, the kernel panics with the following
trace.  The expected behavior is to terminate the affected process instead
of panicking the kernel, as the x86 Machine Check code can recover from an
in-userspace #MC.

  mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
  mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
  mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
  mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
  mce: [Hardware Error]: Run the above through 'mcelog --ascii'
  mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
  Kernel panic - not syncing: Fatal local machine check

The root cause of this panic is that handling a memory failure triggered
by an in-userspace #MC necessitates splitting the THP.  The splitting
process employs a mechanism, implemented in
try_to_map_unused_to_zeropage(), which reads the pages in the THP to
identify zero-filled pages.  However, reading the pages in the THP results
in a second in-kernel #MC, occurring before the initial memory_failure()
completes, ultimately leading to a kernel panic.  See the kernel panic
call trace on the two #MCs.

  First Machine Check occurs // [1]
    memory_failure()         // [2]
      try_to_split_thp_page()
        split_huge_page()
          split_huge_page_to_list_to_order()
            __folio_split()  // [3]
              remap_page()
                remove_migration_ptes()
                  remove_migration_pte()
                    try_to_map_unused_to_zeropage()  // [4]
                      memchr_inv()                   // [5]
                        Second Machine Check occurs  // [6]
                          Kernel panic

[1] Triggered by accessing a hardware-poisoned THP in userspace, which is
    typically recoverable by terminating the affected process.

[2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().

[3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().

[4] Try to map the unused THP to zeropage.

[5] Re-access pages in the hw-poisoned THP in the kernel.

[6] Triggered in-kernel, leading to a panic kernel.

In Step[2], memory_failure() sets the poisoned flag on the page in the THP
by TestSetPageHWPoison() before calling try_to_split_thp_page().

As suggested by David Hildenbrand, fix this panic by not accessing to the
poisoned page in the THP during zeropage identification, while continuing
to scan unaffected pages in the THP for possible zeropage mapping.  This
prevents a second in-kernel #MC that would cause kernel panic in Step[4].

Thanks to Andrew Zaborowski for his initial work on fixing this issue.

Link: https://lkml.kernel.org/r/20251015064926.1887643-1-qiuxu.zhuo@intel.com
Link: https://lkml.kernel.org/r/20251011075520.320862-1-qiuxu.zhuo@intel.com
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reported-by: Farrah Chen <farrah.chen@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 mm/migrate.c     |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-prevent-poison-consumption-when-splitting-thp
+++ a/mm/huge_memory.c
@@ -4109,6 +4109,9 @@ static bool thp_underused(struct folio *
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
+	if (folio_contain_hwpoisoned_page(folio))
+		return false;
+
 	for (i = 0; i < folio_nr_pages(folio); i++) {
 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
 			if (++num_zero_pages > khugepaged_max_ptes_none)
--- a/mm/migrate.c~mm-prevent-poison-consumption-when-splitting-thp
+++ a/mm/migrate.c
@@ -301,8 +301,9 @@ static bool try_to_map_unused_to_zeropag
 	struct page *page = folio_page(folio, idx);
 	pte_t newpte;
 
-	if (PageCompound(page))
+	if (PageCompound(page) || PageHWPoison(page))
 		return false;
+
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(old_pte), page);
_

Patches currently in -mm which might be from qiuxu.zhuo@intel.com are


