Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795559255;
	b=BKrbBenPeCH9MRNf+dE9s/B7Y6FFxgnx0bqdS48ARe8+UmKxHzl4gupJTsnCbEUzhL2z
	 5JS5w2nepWX7lLiIysVHx7mkhXIYqrLTtpDce5St1EvHt//s2Op2Wa1kp9dj9NiUgNkJg
	 S9kXPsSr4HbvuSby3dQxu/5QV8WpkvaEWxTLzoEguFcwBsFL8YJxa0jPiLgvLl6qIXBns
	 +0O3/LMCemXgFum4tSFP8CpbInKXKgZFscUfmVk/M4JOXm9r1Yne9GlgX1RTP4AlaDnfl
	 JcBZ/6XYH5yMG2mWVl0vfkO3AQCxl+Lbb85Fk0N8LSjLJc2rGHnIMaTOJoH4QkpLr9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795559255;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=9Q9tX/iVFPf/zzeK2ZxDcjtBdnywZAGjNA8dKM0Xqg8=;
	b=3ykZ6+b9H6acaUAD2PC/Mm4Z8yfcBUMdELtewrW0dBV2Ibd145U1lp0LQbEGJJM2mJMn
	 1+VGNRZJgkMfnxFQR6LcL6/i3YjW3qn6TdqpZo+X6Wh+TS9clR/Q0joKHKU3844So/Vpn
	 iNRXdjy3VF2j6UfF0qxlALLw4n6ugFF/uAloUaA3/Z31qK3S0lZ0VvV768NtL727kXVhw
	 9MfSCEQeL+tNii8ORoZAW6DQScCx17F7NdO/egTuE32QNlz5ezmiPCECQMYFDSQvHLylp
	 mXbSNWxc+UAsA42JcgmEsTMOf90GQGPWl66o6+kgYghaszfyN72cwRK2GWKH+HNwzhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="k/Coo9bS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359B7606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 22:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k/Coo9bS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EE41F000CF;
	Tue, 24 Nov 2026 22:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795559254;
	bh=9Q9tX/iVFPf/zzeK2ZxDcjtBdnywZAGjNA8dKM0Xqg8=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=k/Coo9bS41b6ZIjIBQuOFwiAaX/YIh9Nb72nBTo8ot544jHwgH2409+StyFkJo26i
	 t3XsWiJwuhVn4QxcJQihJAFVrnxmX6A6O2tgUFEI50ik7MDrdn8NL1FzwZb3f1OHuR
	 Q3hYb+S2QzVsj/PuGD0gf3TYfnsMquCxpLgmwbkI=
Date: Tue, 24 Nov 2026 14:27:33 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,
	sfr@canb.auug.org.au,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,
	peterx@redhat.com,osalvador@suse.de,nico.pache@linux.dev,
	muchun.song@linux.dev,mirq-linux@rere.qmqm.pl,miko.lenczewski@arm.com,
	mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,
	leitao@debian.org,lance.yang@linux.dev,kas@kernel.org,jthoughton@google.com,
	joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,dev.jain@arm.com,
	david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,balbirs@nvidia.com,avagin@gmail.com,arnd@arndb.de,
	apopple@nvidia.com,aarcange@redhat.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261117-uffd-state-fixes-v3-5-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-5-b617009d1a4a@columbia.edu>
Subject: + fs-proc-task_mmu-write-protect-device-private-thps-in-pagemap_scan.patch added to mm-new branch
Message-Id: <20261124222734.58EE41F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-write-protect-device-private-thps-in-pagemap_scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-write-protect-device-private-thps-in-pagemap_scan.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
Date: Tue, 17 Nov 2026 23:28:45 -0500

PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
make_uffd_wp_pmd(), which handles a present THP and a migration entry
but does nothing for a device-private THP. The PMD never gets the uffd
bit.

pagemap_thp_category() reports a non-present PMD without the uffd bit as
written. A user tracking writes with async uffd-wp therefore sees every
page of a device-private THP as written on every scan, whether it was
written to or not. This requires a driver that migrates THPs to device
memory.

A device-private PMD must be write-protected like any other huge PMD. To
fix it, pass any valid PMD softleaf entry to set_uffd_wp_softleaf_pmd(),
not only a migration entry. It downgrades a writable entry and sets the
uffd bit. When the THP migrates back, set_pmd_migration_entry() carries
the uffd bit over to the migration entry, so the write protection is
kept.

Link: https://patch.msgid.link/20261117-uffd-state-fixes-v3-5-b617009d1a4a@columbia.edu
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mikołaj Lenczewski <miko.lenczewski@arm.com>
Cc: Breno Leitao <leitao@debian.org>

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-write-protect-device-private-thps-in-pagemap_scan
+++ a/fs/proc/task_mmu.c
@@ -2515,7 +2515,7 @@ static void make_uffd_wp_pmd(struct vm_a
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_valid_softleaf(pmd)) {
 		pmd = set_uffd_wp_softleaf_pmd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
userfaultfd-use-anonymous-memory-for-uffdio_zeropage-on-private-file-mappings.patch
userfaultfd-refuse-uffdio_move-into-a-non-present-huge-destination-pmd.patch
fs-proc-task_mmu-downgrade-writable-migration-entries-in-pagemap_scan-write-protect.patch
fs-proc-task_mmu-write-protect-device-private-thps-in-pagemap_scan.patch
mm-huge_memory-build-the-moved-huge-zero-pmd-from-the-destination-vma.patch
mm-mremap-resolve-uffd-state-when-the-context-is-dropped-not-during-the-move.patch
mm-userfaultfd-check-the-hugetlb-alignment-of-every-vma-in-the-pre-scan.patch

