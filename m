Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B723027E7FC;
	Sat, 11 Oct 2025 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760206744; cv=none; b=JLNcBH9D1zHtpzi/zEMQfotznQEeg6x9nIKKG82Cm9a8AikDgq9xn7dU0ke8J4HFL6GpbvWMLc0XQho2OSxSqpEhQD/Tk5oPATjjbDM4fBWd9gDKTzsRxhSqWvYOSjMqd1oBKoeAiQnuYl0uLdgQi1Qs7lHIPZiNvsU253VbKU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760206744; c=relaxed/simple;
	bh=CmZHlWENDOXB5FihDwZPF8B5709mdCqtNOPzDOOZycw=;
	h=Date:To:From:Subject:Message-Id; b=Xqm+ZMLBT0tHBCEvZ5iHpBTYN5Na8Z6gxJTe+sZkkNqr0832NHdVdjn9TPeeWqi3S9ofGTGd8/kYBfZ6XdbjaXUOFAw7esGPXbiC3bQPTqaL61Yd7yf6nswLYjVuQLUu9UZ27ApssuwdDF72lGJdIK5tefzxs5nbq/WLXedRGu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rx6cWUSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rx6cWUSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA3EC4CEF4;
	Sat, 11 Oct 2025 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760206743;
	bh=CmZHlWENDOXB5FihDwZPF8B5709mdCqtNOPzDOOZycw=;
	h=Date:To:From:Subject:From;
	b=rx6cWUScidrIvPHOlVNAQ1wC9q3nX47nGE4jrm46vTsDROxWq4r+qHwFWJX927qIK
	 ZxzNzfZMv7IPdV6pMLKhy+Mz0IMxaaayZtbxVKYDSzxglZt8kTxCxgyjxThzzpSaKt
	 7/YKixKB+cKz6jPMLhCKrhC8pXsNlwheZhrGO9bk=
Date: Sat, 11 Oct 2025 11:19:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,tony.luck@intel.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,jiaqiyan@google.com,farrah.chen@intel.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,qiuxu.zhuo@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-poison-consumption-when-splitting-thp.patch added to mm-hotfixes-unstable branch
Message-Id: <20251011181903.1FA3EC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prevent poison consumption when splitting THP
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-prevent-poison-consumption-when-splitting-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-poison-consumption-when-splitting-thp.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
try_to_map_unused_to_zeropage(), which reads the sub-pages of the THP to
identify zero-filled pages.  However, reading the sub-pages results in a
second in-kernel #MC, occurring before the initial memory_failure()
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

[5] Re-access sub-pages of the hw-poisoned THP in the kernel.

[6] Triggered in-kernel, leading to a panic kernel.

In Step[2], memory_failure() sets the poisoned flag on the sub-page of the
THP by TestSetPageHWPoison() before calling try_to_split_thp_page().

As suggested by David Hildenbrand, fix this panic by not accessing to the
poisoned sub-page of the THP during zeropage identification, while
continuing to scan unaffected sub-pages of the THP for possible zeropage
mapping.  This prevents a second in-kernel #MC that would cause kernel
panic in Step[4].

[ Credits to Andrew Zaborowski <andrew.zaborowski@intel.com> for his
  original fix that prevents passing the RMP_USE_SHARED_ZEROPAGE flag
  to remap_page() in Step[3] if the THP has the has_hwpoisoned flag set,
  avoiding access to the entire THP for zero-page identification. ]

Link: https://lkml.kernel.org/r/20251011075520.320862-1-qiuxu.zhuo@intel.com
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reported-by: Farrah Chen <farrah.chen@intel.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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
Cc: Zi Yan <ziy@nvidia.com>
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

mm-prevent-poison-consumption-when-splitting-thp.patch

