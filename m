Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827483B27C3
	for <mm-commits@vger.kernel.org>; Sat,  3 Oct 2026 22:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791067158; cv=none; b=htrHUXSoc4tkt0md9vbmcczs/vBqrYTXhz1L7tWUWtYPy4Exw7o2cCV28CcRZpBFILuWuz3i2b/R+Nd0xGCdETal9Xqt4cESYq/uLvwHyRDX+mDiufWbB+QX3CRPXhTSZRqWDLlsnvMIxA03HTxK4ZnxW9uBELC7J2uS1r7dXN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791067158; c=relaxed/simple;
	bh=sZo7zUmd4cdzJdFnJ9OOqJ9+tnmeLdLteup9Sz538xU=;
	h=Date:To:From:Subject:Message-Id; b=Q0xj9T20bwENsqlftY8UD8MgYNCjZ+c8bj8ZoIJBnT1VNQO2LNSHMkCjXEKN0tK9FL3rMmV0G6i9ZGSoJhcyp0W88BE+FMELYEmn/fFaz5K5/ffUHPAIo8h9IR62h3tphPJ8PgTNo6rg6Npz9ItcS9vb/HI5wQK2H88OF4Uju5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EuQ8iCnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EuQ8iCnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3ED1F0089C;
	Sat,  3 Oct 2026 22:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791067156;
	bh=wEHuQ9ZS3aOAttFLTMaoKU1sv5B4i0BPIn2mwcWjdm4=;
	h=Date:To:From:Subject;
	b=EuQ8iCnvPYT+ziE3XLkLs20MYy4xJh9rGAujUZSoyawr5P/kWzVk/d9TFDj08IJT6
	 SqEU+SLduIfxNc7BkangqXOku+FuLkzcJw9U5JYoKtMAtPzuhiwV+Tpxo11bFARYyO
	 qAyfaEvRNfb8iFzljSUwbtqR6xs+/zZW3r0BYeG0=
Date: Sat, 03 Oct 2026 15:39:15 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-eliminate-vm_special-vma_special_flags.patch removed from -mm tree
Message-Id: <20261003223916.4D3ED1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
has been removed from the -mm tree.  Its filename was
     mm-eliminate-vm_special-vma_special_flags.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Date: Thu, 17 Sep 2026 17:22:46 +0100

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted
to predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Link: https://lore.kernel.org/20260917-b4-mmap-prepare-vma-flag-sanify-v3-37-4583d8a23bca@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anup Patel <anup@brainfault.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Emil Tsalapatis <emil@etsalapatis.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jaya Kumar <jayalk@intworks.biz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 include/linux/mm.h              |    8 --------
 tools/testing/vma/include/dup.h |    8 --------
 2 files changed, 16 deletions(-)

--- a/include/linux/mm.h~mm-eliminate-vm_special-vma_special_flags
+++ a/include/linux/mm.h
@@ -578,14 +578,6 @@ enum {
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
 /*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
-/*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
  *   IO tells people not to look at these pages
--- a/tools/testing/vma/include/dup.h~mm-eliminate-vm_special-vma_special_flags
+++ a/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-userland-pgtable-freeing-is-rcu-safe-now-remove-leftover-bits.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

