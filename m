From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 19 May 2016 17:07:44 -0700
Message-ID: <20160519170744.279542a092ca98023fb710be@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_May_2016_17_07_44_-0700_OE.LLtZooe/6uuNu"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbcETAHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__19_May_2016_17_07_44_-0700_OE.LLtZooe/6uuNu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


- fsnotify fix

- poll() timeout fix

- a few scripts/ tweaks

- debugobjects updates

- the (small) ocfs2 queue

- Minor fixes to kernel/padata.c

- Maybe half of the MM queue

117 patches, based on 2600a46ee0ed57c0e0a382c2a37ebac64d374d20:

Subject: fsnotify: avoid spurious EMFILE errors from inotify_init()
Subject: time: add missing implementation for timespec64_add_safe()
Subject: fs: poll/select/recvmmsg: use timespec64 for timeout events
Subject: time: remove timespec_add_safe()
Subject: scripts/decode_stacktrace.sh: handle symbols in modules
Subject: scripts/spelling.txt: add "fimware" misspelling
Subject: scripts/bloat-o-meter: print percent change
Subject: debugobjects: make fixup functions return bool instead of int
Subject: debugobjects: correct the usage of fixup call results
Subject: workqueue: update debugobjects fixup callbacks return type
Subject: timer: update debugobjects fixup callbacks return type
Subject: rcu: update debugobjects fixup callbacks return type
Subject: percpu_counter: update debugobjects fixup callbacks return type
Subject: Documentation: update debugobjects doc
Subject: debugobjects: insulate non-fixup logic related to static obj from =
fixup callbacks
Subject: ocfs2: fix comment in struct ocfs2_extended_slot
Subject: ocfs2: clean up an unused variable 'wants_rotate' in ocfs2_truncat=
e_rec
Subject: ocfs2: clean up unused parameter 'count' in o2hb_read_block_input()
Subject: ocfs2: clean up an unneeded goto in ocfs2_put_slot()
Subject: kernel/padata.c: removed unused code
Subject: kernel/padata.c: hide unused functions
Subject: mm/slab: fix the theoretical race by holding proper lock
Subject: mm/slab: remove BAD_ALIEN_MAGIC again
Subject: mm/slab: drain the free slab as much as possible
Subject: mm/slab: factor out kmem_cache_node initialization code
Subject: mm/slab: clean-up kmem_cache_node setup
Subject: mm/slab: don't keep free slabs if free_objects exceeds free_limit
Subject: mm/slab: racy access/modify the slab color
Subject: mm/slab: make cache_grow() handle the page allocated on arbitrary =
node
Subject: mm/slab: separate cache_grow() to two parts
Subject: mm/slab: refill cpu cache through a new slab without holding a nod=
e lock
Subject: mm/slab: lockless decision to grow cache
Subject: mm/slub.c: replace kick_all_cpus_sync() with synchronize_sched() i=
n kmem_cache_shrink()
Subject: mm: SLAB freelist randomization
Subject: mm: slab: remove ZONE_DMA_FLAG
Subject: mm/slub.c: fix sysfs filename in comment
Subject: mm/page_ref: use page_ref helper instead of direct modification of=
 _count
Subject: mm: rename _count, field of the struct page, to _refcount
Subject: compiler.h: add support for malloc attribute
Subject: include/linux: apply __malloc attribute
Subject: include/linux/nodemask.h: create next_node_in() helper
Subject: mm/hugetlb: optimize minimum size (min_size) accounting
Subject: mm/hugetlb: introduce hugetlb_bad_size()
Subject: arm64: mm: use hugetlb_bad_size()
Subject: metag: mm: use hugetlb_bad_size()
Subject: powerpc: mm: use hugetlb_bad_size()
Subject: tile: mm: use hugetlb_bad_size()
Subject: x86: mm: use hugetlb_bad_size()
Subject: mm/hugetlb: is_vm_hugetlb_page() can return bool
Subject: mm/memory_hotplug: is_mem_section_removable() can return bool
Subject: mm/vmalloc.c: is_vmalloc_addr() can return bool
Subject: mm/mempolicy.c: vma_migratable() can return bool
Subject: mm/memcontrol.c:mem_cgroup_select_victim_node(): clarify comment
Subject: mm/page_alloc: remove useless parameter of __free_pages_boot_core
Subject: mm/hugetlb.c: use first_memory_node
Subject: mm/mempolicy.c:offset_il_node() document and clarify
Subject: mm/rmap: replace BUG_ON(anon_vma->degree) with VM_WARN_ON
Subject: mm, compaction: wrap calculating first and last pfn of pageblock
Subject: mm, compaction: reduce spurious pcplist drains
Subject: mm, compaction: skip blocks where isolation fails in async direct =
compaction
Subject: mm/highmem: simplify is_highmem()
Subject: mm: uninline page_mapped()
Subject: mm/hugetlb: add same zone check in pfn_range_valid_gigantic()
Subject: mm/memory_hotplug: add comment to some functions related to memory=
 hotplug
Subject: mm/vmstat: add zone range overlapping check
Subject: mm/page_owner: add zone range overlapping check
Subject: power: add zone range overlapping check
Subject: mm/writeback: correct dirty page calculation for highmem
Subject: mm/page_alloc: correct highmem memory statistics
Subject: mm/highmem: make nr_free_highpages() handles all highmem zones by =
itself
Subject: mm/vmstat: make node_page_state() handles all zones by itself
Subject: mm/mmap: kill hook arch_rebalance_pgtables()
Subject: mm: update_lru_size warn and reset bad lru_size
Subject: mm: update_lru_size do the __mod_zone_page_state
Subject: mm: use __SetPageSwapBacked and dont ClearPageSwapBacked
Subject: tmpfs: preliminary minor tidyups
Subject: tmpfs: mem_cgroup charge fault to vm_mm not current mm
Subject: mm: /proc/sys/vm/stat_refresh to force vmstat update
Subject: huge mm: move_huge_pmd does not need new_vma
Subject: huge pagecache: extend mremap pmd rmap lockout to files
Subject: arch: fix has_transparent_hugepage()
Subject: memory_hotplug: introduce CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE
Subject: memory_hotplug: introduce memhp_default_state=3D command line para=
meter
Subject: mm, oom: move GFP_NOFS check to out_of_memory
Subject: oom, oom_reaper: try to reap tasks which skip regular OOM killer p=
ath
Subject: mm, oom_reaper: clear TIF_MEMDIE for all tasks queued for oom_reap=
er
Subject: mm, page_alloc: only check PageCompound for high-order pages
Subject: mm, page_alloc: use new PageAnonHead helper in the free page fast =
path
Subject: mm, page_alloc: reduce branches in zone_statistics
Subject: mm, page_alloc: inline zone_statistics
Subject: mm, page_alloc: inline the fast path of the zonelist iterator
Subject: mm, page_alloc: use __dec_zone_state for order-0 page allocation
Subject: mm, page_alloc: avoid unnecessary zone lookups during pageblock op=
erations
Subject: mm, page_alloc: convert alloc_flags to unsigned
Subject: mm, page_alloc: convert nr_fair_skipped to bool
Subject: mm, page_alloc: remove unnecessary local variable in get_page_from=
_freelist
Subject: mm, page_alloc: remove unnecessary initialisation in get_page_from=
_freelist
Subject: mm, page_alloc: remove unnecessary initialisation from __alloc_pag=
es_nodemask()
Subject: mm, page_alloc: simplify last cpupid reset
Subject: mm, page_alloc: move __GFP_HARDWALL modifications out of the fastp=
ath
Subject: mm, page_alloc: check once if a zone has isolated pageblocks
Subject: mm, page_alloc: shorten the page allocator fast path
Subject: mm, page_alloc: reduce cost of fair zone allocation policy retry
Subject: mm, page_alloc: shortcut watermark checks for order-0 pages
Subject: mm, page_alloc: avoid looking up the first zone in a zonelist twice
Subject: mm, page_alloc: remove field from alloc_context
Subject: mm, page_alloc: check multiple page fields with a single branch
Subject: mm, page_alloc: un-inline the bad part of free_pages_check
Subject: mm, page_alloc: pull out side effects from free_pages_check
Subject: mm, page_alloc: remove unnecessary variable from free_pcppages_bulk
Subject: mm, page_alloc: inline pageblock lookup in page free fast paths
Subject: cpuset: use static key better and convert to new API
Subject: mm, page_alloc: defer debugging checks of freed pages until a PCP =
drain
Subject: mm, page_alloc: defer debugging checks of pages allocated from the=
 PCP
Subject: mm, page_alloc: don't duplicate code in free_pcp_prepare
Subject: mm, page_alloc: uninline the bad page part of check_new_page()
Subject: mm, page_alloc: restore the original nodemask if the fast path all=
ocation failed




--Signature=_Thu__19_May_2016_17_07_44_-0700_OE.LLtZooe/6uuNu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXPlVWAAoJEJxZ78cCqAIHf/QQAIaYfR41OEL4zIHllG5Z89Zy
8LZedNdb4bzyb3EY/olXPtMezU5l/s6OYAT1T/lmjaZuYErBAk2HGgBlloPEZ9yO
Cycr4OvJGPFWTLzkHvHH5Caq/hUr0KLVv/4xtSh4VqDVHpSaxHQchofuFJ8WY4Zn
5CVyTXJlTV8r1Yjj1BqxAvVjjvVuELYRxbV9GnmND9QSzZ0pzUoMCue3ucFQIryM
8zjGqg03QTfobBShfblDKz9wt/ITDlZ+ENEKD90iGjrPFB5K4EDp6TdAgtucO8fH
UFCte1pWScZtvOyposB7eQXTCSPti0vZaaOn1VfgFydf8+Gzmkj/ZabVXfpDvQii
Gfl1inFIq59qpu2SKRx83Iu2gJSfmZx9jpsQ0EmFZePhLJ7wI4RQpKbc+K+IGrDb
YsKNR5eM9Ej1j9uYkWRXbzYb/TYXFXAhQZGx48dy9EPW6DvbFlLMetbUrPz5h75d
FtPH0RHoWr7FgK+2J+C34E5DHCuDZg8hkAxyYw0+rCVKT3pP6TQfm5xoyIIBYLwA
tDH2Z0chGzlwh5JogUYbd4unVr8gchtP9Z/1ZHoUGbU6oZRqud39MmbGHwOFr2fO
1E1B6Zm91XMm+Qk83BYlzV33YaiaRfRpTIatRyswiaP8L10y0XzD8eA2SALp0bh0
UF8sKmfIY6XmoKRGmTJR
=AMTv
-----END PGP SIGNATURE-----

--Signature=_Thu__19_May_2016_17_07_44_-0700_OE.LLtZooe/6uuNu--
