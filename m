From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 1 Jun 2020 21:44:57 -0700
Message-ID: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBEpB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


A few little subsystems and a start of a lot of MM patches.

128 patches, based on 9bf9511e3d9f328c03f6f79bfb741c3d18f2f2c0:

Subsystems affected by this patch series:

  squashfs
  ocfs2
  parisc
  vfs
  mm/slab-generic
  mm/slub
  mm/debug
  mm/pagecache
  mm/gup
  mm/swap
  mm/memcg
  mm/pagemap
  mm/memory-failure
  mm/vmalloc
  mm/kasan

Subsystem: squashfs

    Philippe Liard <pliard@google.com>:
      squashfs: migrate from ll_rw_block usage to BIO

Subsystem: ocfs2

    Jules Irenge <jbi.octave@gmail.com>:
      ocfs2: add missing annotation for dlm_empty_lockres()

    Gang He <ghe@suse.com>:
      ocfs2: mount shared volume without ha stack

Subsystem: parisc

    Andrew Morton <akpm@linux-foundation.org>:
      arch/parisc/include/asm/pgtable.h: remove unused `old_pte'

Subsystem: vfs

    Jeff Layton <jlayton@redhat.com>:
    Patch series "vfs: have syncfs() return error when there are writeback:
      vfs: track per-sb writeback errors and report them to syncfs
      fs/buffer.c: record blockdev write errors in super_block that it backs

Subsystem: mm/slab-generic

    Vlastimil Babka <vbabka@suse.cz>:
      usercopy: mark dma-kmalloc caches as usercopy caches

Subsystem: mm/slub

    Dongli Zhang <dongli.zhang@oracle.com>:
      mm/slub.c: fix corrupted freechain in deactivate_slab()

    Christoph Lameter <cl@linux.com>:
      slub: Remove userspace notifier for cache add/remove

    Christopher Lameter <cl@linux.com>:
      slub: remove kmalloc under list_lock from list_slab_objects() V2

    Qian Cai <cai@lca.pw>:
      mm/slub: fix stack overruns with SLUB_STATS

    Andrew Morton <akpm@linux-foundation.org>:
      Documentation/vm/slub.rst: s/Toggle/Enable/

Subsystem: mm/debug

    Vlastimil Babka <vbabka@suse.cz>:
      mm, dump_page(): do not crash with invalid mapping pointer

Subsystem: mm/pagecache

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
    Patch series "Change readahead API", v11:
      mm: move readahead prototypes from mm.h
      mm: return void from various readahead functions
      mm: ignore return value of ->readpages
      mm: move readahead nr_pages check into read_pages
      mm: add new readahead_control API
      mm: use readahead_control to pass arguments
      mm: rename various 'offset' parameters to 'index'
      mm: rename readahead loop variable to 'i'
      mm: remove 'page_offset' from readahead loop
      mm: put readahead pages in cache earlier
      mm: add readahead address space operation
      mm: move end_index check out of readahead loop
      mm: add page_cache_readahead_unbounded
      mm: document why we don't set PageReadahead
      mm: use memalloc_nofs_save in readahead path
      fs: convert mpage_readpages to mpage_readahead
      btrfs: convert from readpages to readahead
      erofs: convert uncompressed files from readpages to readahead
      erofs: convert compressed files from readpages to readahead
      ext4: convert from readpages to readahead
      ext4: pass the inode to ext4_mpage_readpages
      f2fs: convert from readpages to readahead
      f2fs: pass the inode to f2fs_mpage_readpages
      fuse: convert from readpages to readahead
      iomap: convert from readpages to readahead

    Guoqing Jiang <guoqing.jiang@cloud.ionos.com>:
    Patch series "Introduce attach/detach_page_private to cleanup code":
      include/linux/pagemap.h: introduce attach/detach_page_private
      md: remove __clear_page_buffers and use attach/detach_page_private
      btrfs: use attach/detach_page_private
      fs/buffer.c: use attach/detach_page_private
      f2fs: use attach/detach_page_private
      iomap: use attach/detach_page_private
      ntfs: replace attach_page_buffers with attach_page_private
      orangefs: use attach/detach_page_private
      buffer_head.h: remove attach_page_buffers
      mm/migrate.c: call detach_page_private to cleanup code
      mm_types.h: change set_page_private to inline function

    "Matthew Wilcox (Oracle)" <willy@infradead.org>:
      mm/filemap.c: remove misleading comment

    Chao Yu <yuchao0@huawei.com>:
      mm/page-writeback.c: remove unused variable

    NeilBrown <neilb@suse.de>:
      mm/writeback: replace PF_LESS_THROTTLE with PF_LOCAL_THROTTLE
      mm/writeback: discard NR_UNSTABLE_NFS, use NR_WRITEBACK instead

Subsystem: mm/gup

    Souptick Joarder <jrdr.linux@gmail.com>:
      mm/gup.c: update the documentation

    John Hubbard <jhubbard@nvidia.com>:
      mm/gup: introduce pin_user_pages_unlocked
      ivtv: convert get_user_pages() --> pin_user_pages()

    Miles Chen <miles.chen@mediatek.com>:
      mm/gup.c: further document vma_permits_fault()

Subsystem: mm/swap

    chenqiwu <chenqiwu@xiaomi.com>:
      mm/swapfile: use list_{prev,next}_entry() instead of open-coding

    Qian Cai <cai@lca.pw>:
      mm/swap_state: fix a data race in swapin_nr_pages

    Andrea Righi <andrea.righi@canonical.com>:
      mm: swap: properly update readahead statistics in unuse_pte_range()

    Wei Yang <richard.weiyang@gmail.com>:
      mm/swapfile.c: offset is only used when there is more slots
      mm/swapfile.c: explicitly show ssd/non-ssd is handled mutually exclusive
      mm/swapfile.c: remove the unnecessary goto for SSD case
      mm/swapfile.c: simplify the calculation of n_goal
      mm/swapfile.c: remove the extra check in scan_swap_map_slots()
      mm/swapfile.c: found_free could be represented by (tmp < max)
      mm/swapfile.c: tmp is always smaller than max
      mm/swapfile.c: omit a duplicate code by compare tmp and max first

    Huang Ying <ying.huang@intel.com>:
      swap: try to scan more free slots even when fragmented

    Wei Yang <richard.weiyang@gmail.com>:
      mm/swapfile.c: classify SWAP_MAP_XXX to make it more readable
      mm/swapfile.c: __swap_entry_free() always free 1 entry

    Huang Ying <ying.huang@intel.com>:
      mm/swapfile.c: use prandom_u32_max()
      swap: reduce lock contention on swap cache from swap slots allocation

    Randy Dunlap <rdunlap@infradead.org>:
      mm: swapfile: fix /proc/swaps heading and Size/Used/Priority alignment

    Miaohe Lin <linmiaohe@huawei.com>:
      include/linux/swap.h: delete meaningless __add_to_swap_cache() declaration

Subsystem: mm/memcg

    Yafang Shao <laoar.shao@gmail.com>:
      mm, memcg: add workingset_restore in memory.stat

    Kaixu Xia <kaixuxia@tencent.com>:
      mm: memcontrol: simplify value comparison between count and limit

    Shakeel Butt <shakeelb@google.com>:
      memcg: expose root cgroup's memory.stat

    Jakub Kicinski <kuba@kernel.org>:
    Patch series "memcg: Slow down swap allocation as the available space gets:
      mm/memcg: prepare for swap over-high accounting and penalty calculation
      mm/memcg: move penalty delay clamping out of calculate_high_delay()
      mm/memcg: move cgroup high memory limit setting into struct page_counter
      mm/memcg: automatically penalize tasks with high swap use

    Zefan Li <lizefan@huawei.com>:
      memcg: fix memcg_kmem_bypass() for remote memcg charging

Subsystem: mm/pagemap

    Steven Price <steven.price@arm.com>:
    Patch series "Fix W+X debug feature on x86":
      x86: mm: ptdump: calculate effective permissions correctly
      mm: ptdump: expand type of 'val' in note_page()

    Huang Ying <ying.huang@intel.com>:
      /proc/PID/smaps: Add PMD migration entry parsing

    chenqiwu <chenqiwu@xiaomi.com>:
      mm/memory: remove unnecessary pte_devmap case in copy_one_pte()

Subsystem: mm/memory-failure

    Wetp Zhang <wetp.zy@linux.alibaba.com>:
      mm, memory_failure: don't send BUS_MCEERR_AO for action required error

Subsystem: mm/vmalloc

    Christoph Hellwig <hch@lst.de>:
    Patch series "decruft the vmalloc API", v2:
      x86/hyperv: use vmalloc_exec for the hypercall page
      x86: fix vmap arguments in map_irq_stack
      staging: android: ion: use vmap instead of vm_map_ram
      staging: media: ipu3: use vmap instead of reimplementing it
      dma-mapping: use vmap insted of reimplementing it
      powerpc: add an ioremap_phb helper
      powerpc: remove __ioremap_at and __iounmap_at
      mm: remove __get_vm_area
      mm: unexport unmap_kernel_range_noflush
      mm: rename CONFIG_PGTABLE_MAPPING to CONFIG_ZSMALLOC_PGTABLE_MAPPING
      mm: only allow page table mappings for built-in zsmalloc
      mm: pass addr as unsigned long to vb_free
      mm: remove vmap_page_range_noflush and vunmap_page_range
      mm: rename vmap_page_range to map_kernel_range
      mm: don't return the number of pages from map_kernel_range{,_noflush}
      mm: remove map_vm_range
      mm: remove unmap_vmap_area
      mm: remove the prot argument from vm_map_ram
      mm: enforce that vmap can't map pages executable
      gpu/drm: remove the powerpc hack in drm_legacy_sg_alloc
      mm: remove the pgprot argument to __vmalloc
      mm: remove the prot argument to __vmalloc_node
      mm: remove both instances of __vmalloc_node_flags
      mm: remove __vmalloc_node_flags_caller
      mm: switch the test_vmalloc module to use __vmalloc_node
      mm: remove vmalloc_user_node_flags
      arm64: use __vmalloc_node in arch_alloc_vmap_stack
      powerpc: use __vmalloc_node in alloc_vm_stack
      s390: use __vmalloc_node in stack_alloc

    Joerg Roedel <jroedel@suse.de>:
    Patch series "mm: Get rid of vmalloc_sync_(un)mappings()", v3:
      mm: add functions to track page directory modifications
      mm/vmalloc: track which page-table levels were modified
      mm/ioremap: track which page-table levels were modified
      x86/mm/64: implement arch_sync_kernel_mappings()
      x86/mm/32: implement arch_sync_kernel_mappings()
      mm: remove vmalloc_sync_(un)mappings()
      x86/mm: remove vmalloc faulting

Subsystem: mm/kasan

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: fix clang compilation warning due to stack protector

    Kees Cook <keescook@chromium.org>:
      ubsan: entirely disable alignment checks under UBSAN_TRAP

    Jing Xia <jing.xia@unisoc.com>:
      mm/mm_init.c: report kasan-tag information stored in page->flags

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: move kasan_report() into report.c

 Documentation/admin-guide/cgroup-v2.rst            |   24 +
 Documentation/core-api/cachetlb.rst                |    2 
 Documentation/filesystems/locking.rst              |    6 
 Documentation/filesystems/proc.rst                 |    4 
 Documentation/filesystems/vfs.rst                  |   15 
 Documentation/vm/slub.rst                          |    2 
 arch/arm/configs/omap2plus_defconfig               |    2 
 arch/arm64/include/asm/pgtable.h                   |    3 
 arch/arm64/include/asm/vmap_stack.h                |    6 
 arch/arm64/mm/dump.c                               |    2 
 arch/parisc/include/asm/pgtable.h                  |    2 
 arch/powerpc/include/asm/io.h                      |   10 
 arch/powerpc/include/asm/pci-bridge.h              |    2 
 arch/powerpc/kernel/irq.c                          |    5 
 arch/powerpc/kernel/isa-bridge.c                   |   28 +
 arch/powerpc/kernel/pci_64.c                       |   56 +-
 arch/powerpc/mm/ioremap_64.c                       |   50 --
 arch/riscv/include/asm/pgtable.h                   |    4 
 arch/riscv/mm/ptdump.c                             |    2 
 arch/s390/kernel/setup.c                           |    9 
 arch/sh/kernel/cpu/sh4/sq.c                        |    3 
 arch/x86/hyperv/hv_init.c                          |    5 
 arch/x86/include/asm/kvm_host.h                    |    3 
 arch/x86/include/asm/pgtable-2level_types.h        |    2 
 arch/x86/include/asm/pgtable-3level_types.h        |    2 
 arch/x86/include/asm/pgtable_64_types.h            |    2 
 arch/x86/include/asm/pgtable_types.h               |    8 
 arch/x86/include/asm/switch_to.h                   |   23 -
 arch/x86/kernel/irq_64.c                           |    2 
 arch/x86/kernel/setup_percpu.c                     |    6 
 arch/x86/kvm/svm/sev.c                             |    3 
 arch/x86/mm/dump_pagetables.c                      |   35 +
 arch/x86/mm/fault.c                                |  196 ----------
 arch/x86/mm/init_64.c                              |    5 
 arch/x86/mm/pti.c                                  |    8 
 arch/x86/mm/tlb.c                                  |   37 -
 block/blk-core.c                                   |    1 
 drivers/acpi/apei/ghes.c                           |    6 
 drivers/base/node.c                                |    2 
 drivers/block/drbd/drbd_bitmap.c                   |    4 
 drivers/block/loop.c                               |    2 
 drivers/dax/device.c                               |    1 
 drivers/gpu/drm/drm_scatter.c                      |   11 
 drivers/gpu/drm/etnaviv/etnaviv_dump.c             |    4 
 drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c   |    2 
 drivers/lightnvm/pblk-init.c                       |    5 
 drivers/md/dm-bufio.c                              |    4 
 drivers/md/md-bitmap.c                             |   12 
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |    3 
 drivers/media/common/videobuf2/videobuf2-vmalloc.c |    3 
 drivers/media/pci/ivtv/ivtv-udma.c                 |   19 -
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   17 
 drivers/media/pci/ivtv/ivtvfb.c                    |    4 
 drivers/mtd/ubi/io.c                               |    4 
 drivers/pcmcia/electra_cf.c                        |   45 --
 drivers/scsi/sd_zbc.c                              |    3 
 drivers/staging/android/ion/ion_heap.c             |    4 
 drivers/staging/media/ipu3/ipu3-css-pool.h         |    4 
 drivers/staging/media/ipu3/ipu3-dmamap.c           |   30 -
 fs/block_dev.c                                     |    7 
 fs/btrfs/disk-io.c                                 |    4 
 fs/btrfs/extent_io.c                               |   64 ---
 fs/btrfs/extent_io.h                               |    3 
 fs/btrfs/inode.c                                   |   39 --
 fs/buffer.c                                        |   23 -
 fs/erofs/data.c                                    |   41 --
 fs/erofs/decompressor.c                            |    2 
 fs/erofs/zdata.c                                   |   31 -
 fs/exfat/inode.c                                   |    7 
 fs/ext2/inode.c                                    |   10 
 fs/ext4/ext4.h                                     |    5 
 fs/ext4/inode.c                                    |   25 -
 fs/ext4/readpage.c                                 |   25 -
 fs/ext4/verity.c                                   |   35 -
 fs/f2fs/data.c                                     |   56 +-
 fs/f2fs/f2fs.h                                     |   14 
 fs/f2fs/verity.c                                   |   35 -
 fs/fat/inode.c                                     |    7 
 fs/file_table.c                                    |    1 
 fs/fs-writeback.c                                  |    1 
 fs/fuse/file.c                                     |  100 +----
 fs/gfs2/aops.c                                     |   23 -
 fs/gfs2/dir.c                                      |    9 
 fs/gfs2/quota.c                                    |    2 
 fs/hpfs/file.c                                     |    7 
 fs/iomap/buffered-io.c                             |  113 +----
 fs/iomap/trace.h                                   |    2 
 fs/isofs/inode.c                                   |    7 
 fs/jfs/inode.c                                     |    7 
 fs/mpage.c                                         |   38 --
 fs/nfs/blocklayout/extent_tree.c                   |    2 
 fs/nfs/internal.h                                  |   10 
 fs/nfs/write.c                                     |    4 
 fs/nfsd/vfs.c                                      |    9 
 fs/nilfs2/inode.c                                  |   15 
 fs/ntfs/aops.c                                     |    2 
 fs/ntfs/malloc.h                                   |    2 
 fs/ntfs/mft.c                                      |    2 
 fs/ocfs2/aops.c                                    |   34 -
 fs/ocfs2/dlm/dlmmaster.c                           |    1 
 fs/ocfs2/ocfs2.h                                   |    4 
 fs/ocfs2/slot_map.c                                |   46 +-
 fs/ocfs2/super.c                                   |   21 +
 fs/omfs/file.c                                     |    7 
 fs/open.c                                          |    3 
 fs/orangefs/inode.c                                |   32 -
 fs/proc/meminfo.c                                  |    3 
 fs/proc/task_mmu.c                                 |   16 
 fs/qnx6/inode.c                                    |    7 
 fs/reiserfs/inode.c                                |    8 
 fs/squashfs/block.c                                |  273 +++++++-------
 fs/squashfs/decompressor.h                         |    5 
 fs/squashfs/decompressor_multi.c                   |    9 
 fs/squashfs/decompressor_multi_percpu.c            |   17 
 fs/squashfs/decompressor_single.c                  |    9 
 fs/squashfs/lz4_wrapper.c                          |   17 
 fs/squashfs/lzo_wrapper.c                          |   17 
 fs/squashfs/squashfs.h                             |    4 
 fs/squashfs/xz_wrapper.c                           |   51 +-
 fs/squashfs/zlib_wrapper.c                         |   63 +--
 fs/squashfs/zstd_wrapper.c                         |   62 +--
 fs/sync.c                                          |    6 
 fs/ubifs/debug.c                                   |    2 
 fs/ubifs/lprops.c                                  |    2 
 fs/ubifs/lpt_commit.c                              |    4 
 fs/ubifs/orphan.c                                  |    2 
 fs/udf/inode.c                                     |    7 
 fs/xfs/kmem.c                                      |    2 
 fs/xfs/xfs_aops.c                                  |   13 
 fs/xfs/xfs_buf.c                                   |    2 
 fs/zonefs/super.c                                  |    7 
 include/asm-generic/5level-fixup.h                 |    5 
 include/asm-generic/pgtable.h                      |   27 +
 include/linux/buffer_head.h                        |    8 
 include/linux/fs.h                                 |   18 
 include/linux/iomap.h                              |    3 
 include/linux/memcontrol.h                         |    4 
 include/linux/mm.h                                 |   67 ++-
 include/linux/mm_types.h                           |    6 
 include/linux/mmzone.h                             |    1 
 include/linux/mpage.h                              |    4 
 include/linux/page_counter.h                       |    8 
 include/linux/pagemap.h                            |  193 ++++++++++
 include/linux/ptdump.h                             |    3 
 include/linux/sched.h                              |    3 
 include/linux/swap.h                               |   17 
 include/linux/vmalloc.h                            |   49 +-
 include/linux/zsmalloc.h                           |    2 
 include/trace/events/erofs.h                       |    6 
 include/trace/events/f2fs.h                        |    6 
 include/trace/events/writeback.h                   |    5 
 kernel/bpf/core.c                                  |    6 
 kernel/bpf/syscall.c                               |   29 -
 kernel/dma/remap.c                                 |   48 --
 kernel/groups.c                                    |    2 
 kernel/module.c                                    |    3 
 kernel/notifier.c                                  |    1 
 kernel/sys.c                                       |    2 
 kernel/trace/trace.c                               |   12 
 lib/Kconfig.ubsan                                  |    2 
 lib/ioremap.c                                      |   46 +-
 lib/test_vmalloc.c                                 |   26 -
 mm/Kconfig                                         |    4 
 mm/debug.c                                         |   56 ++
 mm/fadvise.c                                       |    6 
 mm/filemap.c                                       |    1 
 mm/gup.c                                           |   77 +++-
 mm/internal.h                                      |   14 
 mm/kasan/Makefile                                  |   21 -
 mm/kasan/common.c                                  |   19 -
 mm/kasan/report.c                                  |   22 +
 mm/memcontrol.c                                    |  198 +++++++---
 mm/memory-failure.c                                |   15 
 mm/memory.c                                        |    2 
 mm/migrate.c                                       |    9 
 mm/mm_init.c                                       |   16 
 mm/nommu.c                                         |   52 +-
 mm/page-writeback.c                                |   62 ++-
 mm/page_alloc.c                                    |    7 
 mm/percpu.c                                        |    2 
 mm/ptdump.c                                        |   17 
 mm/readahead.c                                     |  349 ++++++++++--------
 mm/slab_common.c                                   |    3 
 mm/slub.c                                          |   67 ++-
 mm/swap_state.c                                    |    5 
 mm/swapfile.c                                      |  194 ++++++----
 mm/util.c                                          |    2 
 mm/vmalloc.c                                       |  399 ++++++++-------------
 mm/vmscan.c                                        |    4 
 mm/vmstat.c                                        |   11 
 mm/zsmalloc.c                                      |   12 
 net/bridge/netfilter/ebtables.c                    |    6 
 net/ceph/ceph_common.c                             |    3 
 sound/core/memalloc.c                              |    2 
 sound/core/pcm_memory.c                            |    2 
 195 files changed, 2292 insertions(+), 2288 deletions(-)
