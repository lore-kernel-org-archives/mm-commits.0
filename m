Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612A04ED1B9
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789680277; cv=none; b=Kj2vauxBorootlH3uJyADqePom1ExsDeHP9POasCAHCAeqD/5MmpGkBYmPcQGs8C/qrDLtVm7HpjAGqLBQS162ROND1kn3MLe0k93UljcL8SJF68aM5ZU0PxRJJunU7y1jQsmvsRevTUWJaRRvHAdL1HTJPFQWeGg4q9qDZctpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789680277; c=relaxed/simple;
	bh=LIU79/pJyD+dv/K0VEjG9Ojzjt0+W259KFtTTQoivss=;
	h=Date:To:From:Subject:Message-Id; b=RvRDo8ImEsHUdVFWcMcE1t4bMKN5vm2O7r4bEIb6jtQYzU9p123aRNQLhckP4h5SkTBMzI8vq1dZLqWy61bqSY2pBjNnE7YfhqVpLqt4ST1ZKPH6sZ3CIyO6ZSmA6EqlSlDNr/3lgl8MrmK+3xjAe8n1veASLjmB5h03ubUFn98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lda6bTrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lda6bTrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC61C1F000FF;
	Thu, 17 Sep 2026 21:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789680273;
	bh=AdHsiyVz3/n7HMMgs1hxAU1aR87BNLMTBXEZp0j1w10=;
	h=Date:To:From:Subject;
	b=lda6bTrBl4Ir6kABcRareYShrBlqCUz7rh3nIJMXowtQBXUbB3vXgKg0HqbCQEK/3
	 6dn/k5Lz+kckAZ/3G3x3bSlmDAuiMynDHXXlloD2gTYZX4m5upz03PZbtLRibMbAog
	 eP3JY4Tz3Po9akF9+CFYz5gDlKvu1NXiqK4+pMgw=
Date: Thu, 17 Sep 2026 14:24:33 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch added to mm-unstable branch
Message-Id: <20260917212433.CC61C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: filesystems: update mmap_prepare docs for discontig kernel pgs
has been added to the -mm mm-unstable branch.  Its filename is
     docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: docs: filesystems: update mmap_prepare docs for discontig kernel pgs
Date: Thu, 17 Sep 2026 17:22:18 +0100

Describe the newly introduced discontiguous kernel page mapping mechanism,
detailing how to use it sensibly and how the API looks.

Explicitly detail the various discontiguous actions available and how to
use them.

Link: https://lore.kernel.org/20260917-b4-mmap-prepare-vma-flag-sanify-v3-9-4583d8a23bca@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Cc: David Hildenbrand <david@kernel.org>
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
Cc: Zi Yan <ziy@nvidia.com>
---

 Documentation/filesystems/mmap_prepare.rst |   81 +++++++++++++++++++
 1 file changed, 81 insertions(+)

--- a/Documentation/filesystems/mmap_prepare.rst~docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs
+++ a/Documentation/filesystems/mmap_prepare.rst
@@ -164,5 +164,86 @@ pointer. These are:
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 
+* mmap_action_map_discontig_kernel_pages() - Maps a discontiguous range of
+  `struct page` pointers over the VMA. They must span from the start of the VMA,
+  but may terminate prior to the end (leaving the remainder unmapped).
+
 **NOTE:** The ``action`` field should never normally be manipulated directly,
 rather you ought to use one of these helpers.
+
+Discontiguous Actions
+=====================
+
+Some actions can be performed across discontiguous ranges.
+
+Map kernel pages
+----------------
+
+To map kernel pages discontiguously, you must provide hooks using ``struct
+discontig_kernel_page_ops``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_ops {
+        int (*init)(void *vm_private_data, void **private);
+        int (*get)(struct discontig_kernel_page_state *state);
+    };
+
+The ``init`` hook is optional and allows state to be established before the
+operation starts, for instance taking a reference count. Nothing is invoked
+after the operation, so ``init`` must not leave locks held, and state that must
+be released once the mapping goes away should be released in
+``vm_ops->close``.
+
+The ``init`` hook, if provided, is invoked prior to the operation starting. It
+may update what is pointed to by ``vm_private_data`` and/or ``private``. If an
+error is returned, then the operation is aborted. The ``private`` field can be
+reassigned.
+
+**NOTE:** The operation may sleep between invocations of ``get``, so locks
+needed to stabilise state must be taken and released within each hook.
+
+The ``get`` handler is the key means through which the operation is
+executed. The current state of the operation is provided through ``struct
+discontig_kernel_page_state``:
+
+.. code-block:: C
+
+    struct discontig_kernel_page_state {
+        /* Map state. */
+        unsigned long start;            /* Start address of VMA. */
+        unsigned long end;              /* End address of VMA. */
+        unsigned long addr;             /* The current address to be mapped. */
+        pgoff_t pgoff;                  /* The current pgoff to be mapped. */
+        unsigned long nr_pages_mapped;  /* The number of pages mapped. */
+        unsigned long nr_pages_remain;  /* The number of pages remaining. */
+
+        /* User-defined state. */
+        void *vm_private_data;          /* VMA private data. */
+        void *private;                  /* Mapping private data. */
+
+        /* Users should not touch these, use discontig_kernel_map_*() helpers. */
+        ... internal fields ...
+    };
+
+With ``private`` being an additional user-controllable state variable,
+initialised via ``mmap_action_map_discontig_kernel_pages()``, and
+``vm_private_data`` being equal to the ``desc->private_data`` field set in
+the ``mmap_prepare()`` hook.
+
+In the ``get`` hook, the user must choose how to map kernel pages:
+
+* ``discontig_kernel_map_abort()`` - Call this to abort the operation, whatever
+  has been mapped so far will be retained, the rest of the mapping will SIGBUS
+  if accessed.
+* ``discontig_kernel_map_page()`` - Maps a single page, correctly handling
+  compound pages (if the compound page is bigger than the remaining pages in the
+  VMA, then only those pages that fit will be mapped). For a compound page, the
+  head page must be passed.
+* ``discontig_kernel_map_page_range()`` - Map an array of pages of a specified
+  size. Note that if the number of pages specified exceeds the VMA size then an
+  error will arise.
+
+If an error arises after ``init`` succeeded, the core unmaps the VMA, invoking
+``vm_ops->close`` if set, which is therefore the place to release any state
+that ``init`` established.
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-huge_memory-zap-deposited-page-tables-after-an-rcu-grace-period.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

