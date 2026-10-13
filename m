Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431A8515970;
	Tue, 13 Oct 2026 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791908688; cv=none; b=JTPuXhIht9jmQH2Rhch6DAAd98zDbMjaJComqyrZiJQFHtKrg3K6tLSLDZ1NUOWUNLHkp1qzUGn1Qed4gi3lwDsVuXpjsW/CH26TrhFC/neRaHemWWFGmR+kNLL2iU724/dxaxmrBMEi95XvFp/bgpCUnv6cBTCuIGGvnHY+gS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791908688; c=relaxed/simple;
	bh=Wq0KK60KB9cvB3i/Qy1xvz1MQHW4MAXTigPshF7yeIo=;
	h=Date:To:From:Subject:Message-Id; b=Wo9RHyq+EdMQ6WneWHKRi6pEY3f2sIrFOxNP66NhsTxDzxUIsqmDZNdZlmnvkK1ja8meuoC8CCTdx8E2qqCUTlPaCVQcDxtCI9Z7b74JuMdtMkEp8gHfkukwtDzCWcEqh6GNYrLb22kc+Ca4T8Uz7zJulzs50uHqPHCc6nfV/KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BTF6WD4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BTF6WD4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F5B1F000FF;
	Tue, 13 Oct 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791908686;
	bh=y6zQvWK5/jrYI/WBrzHiqGh1VRGjntPigrgFt2cFchM=;
	h=Date:To:From:Subject;
	b=BTF6WD4MMxLgx93Zi8G8kJBBTUfSe6JKYyeyUeSUzeM4vpbmehbXQHRkTZXlLztiE
	 qLEVuxV+IphzGu/C99i71TsTwWuxPqo7/IErFhE8aXXltRuSZHxbJTpMAZMZzNvLXO
	 v/CEW5x7SeeFC225Ge0CbWdDAJ1f+SH20O3JyW8Y=
Date: Tue, 13 Oct 2026 09:24:46 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,riel@redhat.com,ngocthang2710.1999@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,benh@kernel.crashing.org,a.p.zijlstra@chello.nl,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch added to mm-hotfixes-unstable branch
Message-Id: <20261013162446.C1F5B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: disallow ioremap'ing ordinary RAM in generic_access_phys()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: disallow ioremap'ing ordinary RAM in generic_access_phys()
Date: Tue, 13 Oct 2026 13:41:24 +0200

generic_access_phys() can end up getting called on CoW PFNMAP mappings,
resulting in it trying to ioremap anonymous folios, which especially
the x86 code doesn't enjoy, and which is in general just odd/wrong.

E.g., with a CoW mapping of a PCI BAR:

ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
  WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
  Call Trace:
   generic_access_phys+0x130/0x4d0 mm/memory.c:7178
   kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
   __access_remote_vm+0x58f/0x890 mm/memory.c:7256
   mem_rw+0x2a1/0x670 fs/proc/base.c:912

But more generically, we should disallow access to anything that looks
like ordinary RAM in the system: including allocating memory (e.g.,
alloc_pages) and mapping them in a VM_PFNMAP.

For pages with an online memmap, allow only pages marked as reserved
(PageReserved). This also includes memblock allocations, however,
distinguishing them from other MMIO is tricky, and nobody should really
be mapping them in a PFNMAP (except someone abusing /dev/mem, which we
do not care about).

So only allow access if there is no online memmap, or if the pages are
marked reserved. Reject other pages with -EINVAL.

Note that, just like other pfn_to_online_page() users, we won't care about
concurrent memory offlining; mapping memory that can concurrently get
offlined is highly dubious.

Link: https://lore.kernel.org/20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org
Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
Reported-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Closes: https://lore.kernel.org/r/20261001152524.171115-1-ngocthang2710.1999@gmail.com/
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/memory.c~mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys
+++ a/mm/memory.c
@@ -7170,6 +7170,7 @@ int generic_access_phys(struct vm_area_s
 	resource_size_t phys_addr;
 	pgprot_t prot = __pgprot(0);
 	void __iomem *maddr;
+	struct page *page;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
 	bool writable;
@@ -7178,6 +7179,19 @@ int generic_access_phys(struct vm_area_s
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
+
+	/*
+	 * Reject anything that looks like ordinary RAM, including anonymous
+	 * folios in CoW mappings or allocated kernel memory. Note that we
+	 * cannot distinguish memblock allocations from non-RAM reliably, so
+	 * we cannot easily reject them here.
+	 */
+	page = pfn_to_online_page(args.pfn);
+	if (page && !PageReserved(page)) {
+		follow_pfnmap_end(&args);
+		return -EINVAL;
+	}
+
 	prot = args.pgprot;
 	phys_addr = (resource_size_t)args.pfn << PAGE_SHIFT;
 	writable = args.writable;
_

Patches currently in -mm which might be from david@kernel.org are

mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch
arm64-mm-move-__check_safe_pte_update-fix.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch
vmcoreinfo-export-section_has_mem_map.patch

