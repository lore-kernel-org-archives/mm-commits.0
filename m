From: akpm@linux-foundation.org
Subject: mmotm 2017-05-12-15-53 uploaded
Date: Fri, 12 May 2017 15:54:45 -0700
Message-ID: <59163d35.CNbYdTCU7mayKvM0%akpm__29875.8919387639$1494629698$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751811AbdELWyq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:54:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz, broonie@kernel.org

The mm-of-the-moment snapshot 2017-05-12-15-53 has been uploaded to

   http://www.ozlabs.org/~akpm/mmotm/

mmotm-readme.txt says

README for mm-of-the-moment:

http://www.ozlabs.org/~akpm/mmotm/

This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
more than once a week.

You will need quilt to apply these patches to the latest Linus release (4.x
or 4.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
http://ozlabs.org/~akpm/mmotm/series

The file broken-out.tar.gz contains two datestamp files: .DATE and
.DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
followed by the base kernel version against which this patch series is to
be applied.

This tree is partially included in linux-next.  To see which patches are
included in linux-next, consult the `series' file.  Only the patches
within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
linux-next.

A git tree which contains the memory management portion of this tree is
maintained at git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
by Michal Hocko.  It contains the patches which are between the
"#NEXT_PATCHES_START mm" and "#NEXT_PATCHES_END" markers, from the series
file, http://www.ozlabs.org/~akpm/mmotm/series.


A full copy of the full kernel tree with the linux-next and mmotm patches
already applied is available through git within an hour of the mmotm
release.  Individual mmotm releases are tagged.  The master branch always
points to the latest release, so it's constantly rebasing.

http://git.cmpxchg.org/cgit.cgi/linux-mmotm.git/

To develop on top of mmotm git:

  $ git remote add mmotm git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git
  $ git remote update mmotm
  $ git checkout -b topic mmotm/master
  <make changes, commit>
  $ git send-email mmotm/master.. [...]

To rebase a branch with older patches to a new mmotm release:

  $ git remote update mmotm
  $ git rebase --onto mmotm/master <topic base> topic




The directory http://www.ozlabs.org/~akpm/mmots/ (mm-of-the-second)
contains daily snapshots of the -mm tree.  It is updated more frequently
than mmotm, and is untested.

A git copy of this tree is available at

	http://git.cmpxchg.org/cgit.cgi/linux-mmots.git/

and use of this tree is similar to
http://git.cmpxchg.org/cgit.cgi/linux-mmotm.git/, described above.


This mmotm tree contains the following patches against 4.11:
(patches marked "*" will be included in linux-next)

  origin.patch
  i-need-old-gcc.patch
* hwpoison-memcg-forcibly-uncharge-lru-pages.patch
* time-delete-current_fs_time-function.patch
* mm-vmstat-remove-spurious-warn-during-zoneinfo-print.patch
* gcov-support-gcc-71.patch
* mm-khugepaged-add-missed-tracepoint-for-collapse_huge_page_swapin.patch
* mm-vmalloc-fix-vmalloc-users-tracking-properly.patch
* tigran-has-moved.patch
* dax-prevent-invalidation-of-mapped-dax-entries.patch
* mm-fix-data-corruption-due-to-stale-mmap-reads.patch
* ext4-return-back-to-starting-transaction-in-ext4_dax_huge_fault.patch
* dax-fix-data-corruption-when-fault-races-with-write.patch
* dax-fix-pmd-data-corruption-when-fault-races-with-write.patch
* mm-thp-copying-user-pages-must-schedule-on-collapse.patch
* mm-vmscan-scan-until-it-founds-eligible-pages.patch
* mm-docs-update-memorystat-description-with-workingset-entries.patch
* mm-skip-hwpoisoned-pages-when-onlining-pages.patch
* arm-arch-arm-include-asm-pageh-needs-personalityh.patch
* teach-initramfs_root_uid-and-initramfs_root_gid-that-1-means-current-user.patch
* clarify-help-text-that-compression-applies-to-ramfs-as-well-as-legacy-ramdisk.patch
* ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch
* ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
* ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch
* ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
* block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
  mm.patch
* mm-slub-remove-a-redundant-assignment-in-___slab_alloc.patch
* mm-slub-reset-cpu_slabs-pointer-in-deactivate_slab.patch
* mm-slub-pack-red_left_pad-with-another-int-to-save-a-word.patch
* mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial.patch
* mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
* mm-slub-wrap-kmem_cache-cpu_partial-in-config-config_slub_cpu_partial.patch
* mm-sparsemem-break-out-of-loops-early.patch
* mark-protection_map-as-__ro_after_init.patch
* mm-vmscan-fix-unsequenced-modification-and-access-warning.patch
* mm-nobootmem-return-0-when-start_pfn-equals-end_pfn.patch
* ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit.patch
* ksm-fix-use-after-free-with-merge_across_nodes-=-0.patch
* zram-introduce-zram_entry-to-prepare-dedup-functionality.patch
* zram-implement-deduplication-in-zram.patch
* zram-make-deduplication-feature-optional.patch
* zram-compare-all-the-entries-with-same-checksum-for-deduplication.patch
* mm-vmstat-standardize-file-operations-variable-names.patch
* mm-page_alloc-return-0-in-case-this-node-has-no-page-within-the-zone.patch
* mm-vmscan-do-not-pass-reclaimed-slab-to-vmpressure.patch
* mm-page_owner-align-with-pageblock_nr-pages.patch
* mm-walk-the-zone-in-pageblock_nr_pages-steps.patch
* fs-epoll-short-circuit-fetching-events-if-thread-has-been-killed.patch
* kexec-move-vmcoreinfo-out-of-the-kernels-bss-section.patch
* powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr.patch
* kdump-protect-vmcoreinfo-data-under-the-crash-memory.patch
* kdump-vmcoreinfo-report-actual-value-of-phys_base.patch
* uapi-fix-linux-sysctlh-userspace-compilation-errors.patch
* bfs-fix-sanity-checks-for-empty-files.patch
* scripts-gdb-add-lx-fdtdump-command.patch
* procfs-fdinfo-extend-information-about-epoll-target-files.patch
* kcmp-add-kcmp_epoll_tfd-mode-to-compare-epoll-target-files.patch
* kernel-reboot-add-devm_register_reboot_notifier.patch
* kernel-reboot-add-devm_register_reboot_notifier-fix.patch
* fault-inject-support-systematic-fault-injection.patch
* fault-inject-support-systematic-fault-injection-fix.patch
* fault-inject-automatically-detect-the-number-base-for-fail-nth-write-interface.patch
* fault-inject-parse-as-natural-1-based-value-for-fail-nth-write-interface.patch
* fault-inject-make-fail-nth-read-write-interface-symmetric.patch
* fault-inject-simplify-access-check-for-fail-nth.patch
* fault-inject-simplify-access-check-for-fail-nth-fix.patch
* fault-inject-add-proc-pid-fail-nth.patch
* ipc-sem-avoid-indexing-past-end-of-sem_array.patch
  linux-next.patch
  linux-next-git-rejects.patch
* imx7-fix-kconfig-warning-and-build-errors.patch
* sparc64-ng4-memset-32-bits-overflow.patch
* mm-zeroing-hash-tables-in-allocator.patch
* mm-updated-callers-to-use-hash_zero-flag.patch
* mm-adaptive-hash-table-scaling.patch
* lib-crc-ccitt-add-ccitt-false-crc16-variant.patch
  mm-add-strictlimit-knob-v2.patch
  make-sure-nobodys-leaking-resources.patch
  releasing-resources-with-children.patch
  kernel-forkc-export-kernel_thread-to-modules.patch
  mutex-subsystem-synchro-test-module.patch
  slab-leaks3-default-y.patch
  workaround-for-a-pci-restoring-bug.patch
