Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5A038330E
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 20:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779481581; cv=none; b=pYNcrCeSUHGiNG2FPuas7peaKnKLJ0s5k/l2zmtXmKKPffZCdnFdgQiBT+vkOx5lFaRB95nwP0ItB07NRPblwAYm+cerMUJCW6HChvZmxjDUvGGRP/+XprSBLeWSEylyTf6yNpogZcct1/uzanCKbZILhv+Snmv+lpUtEp1HHDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779481581; c=relaxed/simple;
	bh=XJVRbERryvcZ1Ttcym5e5OzQIx2i2A0WmWnyMzRpXMg=;
	h=Date:To:From:Subject:Message-Id; b=t+ShrRtExu1fNXdxPMN+aH+3mKc0iB0KY2Akmf9+mBy4yImCgm7MqV+qfAGJdFXa+nw1mL1bHRTO/04q4z2cbquiqnSyal/79C5chHtwzK1rqp8EIIEsZOsdvnriwYgvEhDqZxQ1kRPMPBN3ihl3oVmS5wyWymIo9thrGwOAhbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nrgZDcWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nrgZDcWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE6F1F000E9;
	Fri, 22 May 2026 20:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779481579;
	bh=ZJc7qiNba93kfRU+ESp3/no80GXQtYTutm+rlAQlRpA=;
	h=Date:To:From:Subject;
	b=nrgZDcWQ3rn/+q9OLTiSQd0raLudXEcOTJZGKPBNXlgYCQiQtXCCUICeaGpYB+bHo
	 GuRls5gAEF76kEBk3PHXD32b9S6L0MUAbK2X0BBIzFbf2wnwBq12McmhTIiD4HkdvU
	 gtDM2DodaAcEaXYEck70qzhyKA5auLP6JBbMGuxk=
Date: Fri, 22 May 2026 13:26:19 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch removed from -mm tree
Message-Id: <20260522202619.9DE6F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: skip collapsing mTHP to smaller orders
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Mon, 11 May 2026 12:58:07 -0600

khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in some
pages being unmapped.  Skip these cases until we have a way to check if
its ok to collapse to a smaller mTHP size (like in the case of a partially
mapped folio).  This check is also not done during the scan phase as the
current collapse order is unknown at that time.

This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].

Link: https://lore.kernel.org/20260511185817.686831-8-npache@redhat.com
Link: https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/ [1]
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-skip-collapsing-mthp-to-smaller-orders
+++ a/mm/khugepaged.c
@@ -685,6 +685,14 @@ static enum scan_result __collapse_huge_
 				goto out;
 			}
 		}
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (!is_pmd_order(order) && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
_

Patches currently in -mm which might be from npache@redhat.com are

a.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

