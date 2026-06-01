Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BEE224B15
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 23:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355025; cv=none; b=E9xfqESheQ9zQnjJYi9lPgZjK9w+CPPeDqireVPlpFeIu2CPqQscutBRXu6NJvp4+Vnie7WpuWZ6hwajmvVJ66KUs70f3LQnqxEOUJgLgJwHh+wPROX6tje5FP7glYKmCmZr2h334wMuYvmzPWJ/UUTjXfGjaKQR7iSbnAbIi5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355025; c=relaxed/simple;
	bh=VFMolF42pJdl6bvjDpTal+aL1vzZOSZeZ54HSDMMa8o=;
	h=Date:To:From:Subject:Message-Id; b=ez9U+ejj7ljaeI8FScewtgsiCsYg2KxLB5NDP5RKFLiF8TBSc7YJwhQMhT7NbWcfqTTbK0zuJNUkd8mX5ttvqmykw7U3ugJXS8tUyOh0Kvgmb8x5kdnRPcCM4NMoph2eAqTLa0+wrdJfy7IUJ8kAFG44tfKNRyJknZMgGfEtRF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V9Ni/mK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V9Ni/mK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6C51F00893;
	Mon,  1 Jun 2026 23:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780355024;
	bh=nnmpZq+n7Jepi5Hi2Zq+lejdwUVc3+0FlQXMY29cbUE=;
	h=Date:To:From:Subject;
	b=V9Ni/mK/A2DP5kknoXBti/IdiAzsATjqSMAApin5zCQ9D/IOggHOm4R2vMDcQs3td
	 l0KSluSMDP6FQ5QvrpEV7QnKwR4PffaInurZ3DPFEb1cjZ70jtoOIe7gZIs+GGgh7I
	 xXq88iXLlhPTsCSkM12FG+wFKJaSkhOeQS20h2X0=
Date: Mon, 01 Jun 2026 16:03:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,rmclure@linux.ibm.com,r@hev.cc,pfalcato@suse.de,pasha.tatashin@soleen.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kevin.brodsky@arm.com,kees@kernel.org,kas@kernel.org,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-use-mapping_max_folio_order-for-force_thp_readahead-order-fix.patch removed from -mm tree
Message-Id: <20260601230343.EA6C51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: add comment explaining design decision
has been removed from the -mm tree.  Its filename was
     mm-use-mapping_max_folio_order-for-force_thp_readahead-order-fix.patch

This patch was dropped because it was folded into mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: add comment explaining design decision
Date: Fri, 29 May 2026 05:31:05 -0700

Link: https://lore.kernel.org/fb47629e-6533-4c87-ac0b-e3a48a890ef4@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Heiher <r@hev.cc>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rohan McLure <rmclure@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/filemap.c~mm-use-mapping_max_folio_order-for-force_thp_readahead-order-fix
+++ a/mm/filemap.c
@@ -3319,6 +3319,14 @@ static struct file *do_sync_mmap_readahe
 
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+		/*
+		 * Preserve PMD-sized readahead where it already fits in
+		 * the page cache. Otherwise cap the new fallback path at
+		 * 2MB: this is the common PMD-sized hugepage size, and it
+		 * avoids memory pressure from very large forced readahead
+		 * when mapping_max_folio_order() is high (for example,
+		 * 128MB with 64K base pages on arm64).
+		 */
 		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
 			force_thp_readahead = true;
 			thp_order = HPAGE_PMD_ORDER;
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-make-mmap_miss-accounting-symmetric-for-vm_seq_read.patch
mm-bypass-mmap_miss-heuristic-for-vm_exec-readahead.patch
mm-use-mapping_max_folio_order-for-force_thp_readahead-order.patch

