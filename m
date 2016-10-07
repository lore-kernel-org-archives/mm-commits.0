From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 7 Oct 2016 16:53:43 -0700
Message-ID: <20161007165343.b858bc589ef0c4d7640cc80d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38745 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754756AbcJGXxo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- fsnotify updates

- ocfs2 updates

- all of MM


127 patches, based on 87840a2b7e048018d18d60bdac5c09224de85370:

Subject: fsnotify: drop notification_mutex before destroying event
Subject: fsnotify: convert notification_mutex to a spinlock
Subject: fanotify: use notification_lock instead of access_lock
Subject: fanotify: fix possible false warning when freeing events
Subject: fsnotify: clean up spinlock assertions
Subject: jiffies: add time comparison functions for 64 bit jiffies
Subject: fs/ocfs2/dlmfs: remove deprecated create_singlethread_workqueue()
Subject: fs/ocfs2/cluster: remove deprecated create_singlethread_workqueue()
Subject: fs/ocfs2/super: remove deprecated create_singlethread_workqueue()
Subject: fs/ocfs2/dlm: remove deprecated create_singlethread_workqueue()
Subject: ocfs2: fix undefined struct variable in inode.h
Subject: mm: oom: deduplicate victim selection code for memcg and global oom
Subject: mm/vmalloc.c: fix align value calculation error
Subject: mm: memcontrol: add sanity checks for memcg->id.ref on get/put
Subject: mm/oom_kill.c: fix task_will_free_mem() comment
Subject: mm, compaction: make whole_zone flag ignore cached scanner positions
Subject: mm, compaction: cleanup unused functions
Subject: mm, compaction: rename COMPACT_PARTIAL to COMPACT_SUCCESS
Subject: mm, compaction: don't recheck watermarks after COMPACT_SUCCESS
Subject: mm, compaction: add the ultimate direct compaction priority
Subject: mm, compaction: use correct watermark when checking compaction success
Subject: mm, compaction: create compact_gap wrapper
Subject: mm, compaction: use proper alloc_flags in __compaction_suitable()
Subject: mm, compaction: require only min watermarks for non-costly orders
Subject: mm, vmscan: make compaction_ready() more accurate and readable
Subject: mem-hotplug: fix node spanned pages when we have a movable node
Subject: mm: fix set pageblock migratetype in deferred struct page init
Subject: mm, vmscan: get rid of throttle_vm_writeout
Subject: mm/debug_pagealloc.c: clean-up guard page handling code
Subject: mm/debug_pagealloc.c: don't allocate page_ext if we don't use guard page
Subject: mm/page_owner: move page_owner specific function to page_owner.c
Subject: mm/page_ext: rename offset to index
Subject: mm/page_ext: support extra space allocation by page_ext user
Subject: mm/page_owner: don't define fields on struct page_ext by hard-coding
Subject: do_generic_file_read(): fail immediately if killed
Subject: mm: pagewalk: fix the comment for test_walk
Subject: mm: unrig VMA cache hit ratio
Subject: mm, swap: add swap_cluster_list
Subject: mm,oom_reaper: reduce find_lock_task_mm() usage
Subject: mm,oom_reaper: do not attempt to reap a task twice
Subject: oom: keep mm of the killed task available
Subject: kernel, oom: fix potential pgd_lock deadlock from __mmdrop
Subject: mm, oom: get rid of signal_struct::oom_victims
Subject: oom, suspend: fix oom_killer_disable vs. pm suspend properly
Subject: mm, oom: enforce exit_oom_victim on current task
Subject: mm: make sure that kthreads will not refault oom reaped memory
Subject: oom, oom_reaper: allow to reap mm shared by the kthreads
Subject: mm: use zonelist name instead of using hardcoded index
Subject: mm: introduce arch_reserved_kernel_pages()
Subject: mm/memblock.c: expose total reserved memory
Subject: powerpc: implement arch_reserved_kernel_pages
Subject: mm/nobootmem.c: remove duplicate macro ARCH_LOW_ADDRESS_LIMIT statements
Subject: mm/bootmem.c: replace kzalloc() by kzalloc_node()
Subject: mm: don't use radix tree writeback tags for pages in swap cache
Subject: oom: warn if we go OOM for higher order and compaction is disabled
Subject: mm: mlock: check against vma for actual mlock() size
Subject: mm: mlock: avoid increase mm->locked_vm on mlock() when already mlock2(,MLOCK_ONFAULT)
Subject: selftest: split mlock2_ funcs into separate mlock2.h
Subject: selftests/vm: add test for mlock() when areas are intersected
Subject: selftest: move seek_to_smaps_entry() out of mlock2-tests.c
Subject: selftests: expanding more mlock selftest
Subject: thp, dax: add thp_get_unmapped_area for pmd mappings
Subject: ext2/4, xfs: call thp_get_unmapped_area() for pmd mappings
Subject: cpu: fix node state for whether it contains CPU
Subject: fs/proc/task_mmu.c: make the task_mmu walk_page_range() limit in clear_refs_write() obvious
Subject: thp: reduce usage of huge zero page's atomic counter
Subject: mm/memcontrol.c: make the walk_page_range() limit obvious
Subject: memory-hotplug: fix store_mem_state() return value
Subject: mm: fix cache mode tracking in vm_insert_mixed()
Subject: mm, swap: use offset of swap entry as key of swap cache
Subject: mm: remove page_file_index
Subject: Revert "mm, oom: prevent premature OOM killer invocation for high order request"
Subject: mm, compaction: more reliably increase direct compaction priority
Subject: mm, compaction: restrict full priority to non-costly orders
Subject: mm, compaction: make full priority ignore pageblock suitability
Subject: mm, page_alloc: pull no_progress_loops update to should_reclaim_retry()
Subject: mm, compaction: ignore fragindex from compaction_zonelist_suitable()
Subject: mm, compaction: restrict fragindex to costly orders
Subject: mm: don't emit warning from pagefault_out_of_memory()
Subject: mm/page_io.c: replace some BUG_ON()s with VM_BUG_ON_PAGE()
Subject: mm: move phys_mem_access_prot_allowed() declaration to pgtable.h
Subject: mm: memcontrol: consolidate cgroup socket tracking
Subject: mm/shmem.c: constify anon_ops
Subject: mm: nobootmem: move the comment of free_all_bootmem
Subject: mm/hugetlb: fix memory offline with hugepage size > memory block size
Subject: mm/hugetlb: check for reserved hugepages during memory offline
Subject: mm/hugetlb: improve locking in dissolve_free_huge_pages()
Subject: mm/page_isolation: fix typo: "paes" -> "pages"
Subject: mm,ksm: add __GFP_HIGH to the allocation in alloc_stable_node()
Subject: mm: vm_page_prot: update with WRITE_ONCE/READ_ONCE
Subject: mm: vma_adjust: remove superfluous confusing update in remove_next == 1 case
Subject: mm: vma_merge: fix vm_page_prot SMP race condition against rmap_walk
Subject: mm: vma_adjust: remove superfluous check for next not NULL
Subject: mm: vma_adjust: minor comment correction
Subject: mm: vma_merge: correct false positive from __vma_unlink->validate_mm_rb
Subject: mm: clarify why we avoid page_mapcount() for slab pages in dump_page()
Subject: oom: print nodemask in the oom report
Subject: mm/hugetlb: introduce ARCH_HAS_GIGANTIC_PAGE
Subject: arm64 Kconfig: select gigantic page
Subject: vfs,mm: fix a dead loop in truncate_inode_pages_range()
Subject: mm: consolidate warn_alloc_failed users
Subject: mm: warn about allocations which stall for too long
Subject: mm: remove unnecessary condition in remove_inode_hugepages
Subject: linux/mm.h: canonicalize macro PAGE_ALIGNED() definition
Subject: ia64: implement atomic64_dec_if_positive
Subject: atomic64: no need for CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
Subject: proc: much faster /proc/vmstat
Subject: proc: faster /proc/*/status
Subject: seq/proc: modify seq_put_decimal_[u]ll to take a const char *, not char
Subject: meminfo: break apart a very long seq_printf with #ifdefs
Subject: proc: relax /proc/<tid>/timerslack_ns capability requirements
Subject: proc: add LSM hook checks to /proc/<tid>/timerslack_ns
Subject: proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self
Subject: mm, proc: fix region lost in /proc/self/smaps
Subject: Documentation/filesystems/proc.txt: add more description for maps/smaps
Subject: min/max: remove sparse warnings when they're nested
Subject: nmi_backtrace: add more trigger_*_cpu_backtrace() methods
Subject: nmi_backtrace: do a local dump_stack() instead of a self-NMI
Subject: arch/tile: adopt the new nmi_backtrace framework
Subject: nmi_backtrace: generate one-line reports for idle cpus
Subject: spelling.txt: "modeled" is spelt correctly
Subject: uprobes: remove function declarations from arch/{mips,s390}
Subject: .gitattributes: set git diff driver for C source code files
Subject: mailmap: add Johan Hovold
Subject: CREDITS: update Pavel's information, add GPG key, remove snail mail address
Subject: cred: simpler, 1D supplementary groups
Subject: console: don't prefer first registered if DT specifies stdout-path

