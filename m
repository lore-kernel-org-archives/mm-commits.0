Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1009A1547F3;
	Sat, 25 Jan 2025 07:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737789985; cv=none; b=Cq3fCPmzhMER9MeQvwgTSRHsYQaLzTbd5QM68vWyVWMJhtIEL4+RggbZ3NjMeXrD7NNSm0W/EB3b1jzI0Xdhy1dbU7lCgER8bEDall9OtpMdooxXVstVfrSxFAea2tL3RdxnksBHCY2Gl++3VbYg6+7jhizzwJ5Mm9MDc4Tt54c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737789985; c=relaxed/simple;
	bh=3boqcdfZcO5Xp3qIG7NXzwRLWpcLqBhwQdGsoxfzP/U=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=auSzsEvRAH+FDXr2Yc45Stq5poBzygjKHPm/yQJxzTQ1MHy9k0m0G/3vt62sK4rCukxSmf5GMkZqqGhFd3hJlo67ey1LW+RScTCXdtmoiy99BHW4yD1j1LU/oLRcCqPZgbgqHeIqsiOUrmV09idvKs/h6eCBX2afDpIXhRtSDLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yXl1P6BJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yXl1P6BJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549F5C4CED6;
	Sat, 25 Jan 2025 07:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737789984;
	bh=3boqcdfZcO5Xp3qIG7NXzwRLWpcLqBhwQdGsoxfzP/U=;
	h=Date:From:To:Cc:Subject:From;
	b=yXl1P6BJTetvwunkwlfA2X4e7ZCyz1GkdqnfA8PCtnr30QERlS4RaREINvCjeFjli
	 PznrKfhxZuKwOjD0vwg6A03/WytlFqeWeS9X4KxNKUpInBUMlMQLJwBYfK87R2DEO4
	 4TNLXHTXHkKyOpnrzXuSLUmTgCjO8kfILO3GzpCw=
Date: Fri, 24 Jan 2025 23:26:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 6.14-rc1
Message-Id: <20250124232623.62694054f4c1e92f0900bcba@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Linus, please pull mm.git's non-MM updates for the 6.14 cycle, thanks.


Conflicts which I am seeing, along with their linux-next resolutions
are:

drivers/gpu/drm/i915/display/intel_display_driver.c, vs drm-intel tree:
https://lkml.kernel.org/r/20250106130348.73a5fae6@canb.auug.org.au

scripts/checkpatch.pl, vs jc_docs tree:
https://lkml.kernel.org/r/20250106095826.140c01cb@canb.auug.org.au


Forthcoming conflicts include:

kernel/auditsc.c vs security tree:
https://lkml.kernel.org/r/20241014144648.1923104a@canb.auug.org.au

security/lsm_audit.c vs security tree:
https://lkml.kernel.org/r/20241023123139.127ad800@canb.auug.org.au



The following changes since commit cd6313beaeaea0b2e6d428afef7a86a986b50abe:

  Revert "vmstat: disable vmstat_work on vmstat_cpu_down_prep()" (2025-01-06 06:10:24 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-01-24-23-16

for you to fetch changes up to beeba1eeec9c75d0a62335861ac175b9bdccfbd5:

  ocfs2: use str_yes_no() and str_no_yes() helper functions (2025-01-24 22:47:28 -0800)

----------------------------------------------------------------
Mainly individually changelogged singleton patches.  The patch series in
this pull are:

- "lib min_heap: Improve min_heap safety, testing, and documentation"
  from Kuan-Wei Chiu provides various tightenings to the min_heap library
  code.

- "xarray: extract __xa_cmpxchg_raw" from Tamir Duberstein preforms some
  cleanup and Rust preparation in the xarray library code.

- "Update reference to include/asm-<arch>" from Geert Uytterhoeven fixes
  pathnames in some code comments.

- "Converge on using secs_to_jiffies()" from Easwar Hariharan uses the
  new secs_to_jiffies() in various places where that is appropriate.

- "ocfs2, dlmfs: convert to the new mount API" from Eric Sandeen
  switches two filesystems to the new mount API.

- "Convert ocfs2 to use folios" from Matthew Wilcox does that.

- "Remove get_task_comm() and print task comm directly" from Yafang Shao
  removes now-unneeded calls to get_task_comm() in various places.

- "squashfs: reduce memory usage and update docs" from Phillip Lougher
  implements some memory savings in squashfs and performs some
  maintainability work.

- "lib: clarify comparison function requirements" from Kuan-Wei Chiu
  tightens the sort code's behaviour and adds some maintenance work.

- "nilfs2: protect busy buffer heads from being force-cleared" from
  Ryusuke Konishi fixes an issues in nlifs when the fs is presented with a
  corrupted image.

- "nilfs2: fix kernel-doc comments for function return values" from
  Ryusuke Konishi fixes some nilfs kerneldoc.

- "nilfs2: fix issues with rename operations" from Ryusuke Konishi
  addresses some nilfs BUG_ONs which syzbot was able to trigger.

- "minmax.h: Cleanups and minor optimisations" from David Laight
  does some maintenance work on the min/max library code.

- "Fixes and cleanups to xarray" from Kemeng Shi does maintenance work
  on the xarray library code.

----------------------------------------------------------------
Akinobu Mita (1):
      fault-inject: use prandom where cryptographically secure randomness is not needed

Ariel Otilibili (1):
      lib/inflate.c: remove dead code

Colin Ian King (1):
      scripts/spelling.txt: add more spellings to spelling.txt

Dan Carpenter (1):
      checkpatch: don't warn about extra parentheses in staging/

Daniel Yang (2):
      ocfs2: heartbeat: replace simple_strtoul with kstrtoul
      ocfs2: replace deprecated simple_strtol with kstrtol

David Laight (7):
      minmax.h: add whitespace around operators and after commas
      minmax.h: update some comments
      minmax.h: reduce the #define expansion of min(), max() and clamp()
      minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
      minmax.h: move all the clamp() definitions after the min/max() ones
      minmax.h: simplify the variants of clamp()
      minmax.h: remove some #defines that are only expanded once

David Reaver (1):
      checkpatch: remove migrated RCU APIs from deprecated_apis

Dmitry Antipov (1):
      ocfs2: miscellaneous spelling fixes

Dominik Karol Piątkowski (1):
      kasan: fix typo in kasan_poison_new_object documentation

Easwar Hariharan (18):
      netfilter: conntrack: cleanup timeout definitions
      coccinelle: misc: add secs_to_jiffies script
      arm: pxa: convert timeouts to use secs_to_jiffies()
      s390: kernel: convert timeouts to use secs_to_jiffies()
      powerpc/papr_scm: convert timeouts to secs_to_jiffies()
      mm: kmemleak: convert timeouts to secs_to_jiffies()
      accel/habanalabs: convert timeouts to secs_to_jiffies()
      drm/xe: convert timeout to secs_to_jiffies()
      scsi: lpfc: convert timeouts to secs_to_jiffies()
      scsi: arcmsr: convert timeouts to secs_to_jiffies()
      scsi: pm8001: convert timeouts to secs_to_jiffies()
      xen/blkback: convert timeouts to secs_to_jiffies()
      wifi: ath11k: convert timeouts to secs_to_jiffies()
      bluetooth: mgmt: convert timeouts to secs_to_jiffies()
      staging: vc04_services: convert timeouts to secs_to_jiffies()
      ceph: convert timeouts to secs_to_jiffies()
      livepatch: convert timeouts to secs_to_jiffies()
      ALSA: line6: convert timeouts to secs_to_jiffies()

Eric Sandeen (2):
      dlmfs: convert to the new mount API
      ocfs2: convert to the new mount API

Gao Xiang (1):
      include/linux/lz4.h: add some missing macros

Geert Uytterhoeven (2):
      checkpatch: update reference to include/asm-<arch>
      include: update references to include/asm-<arch>

Julian Sun (2):
      ocfs2: check el->l_next_free_rec in ocfs2_get_clusters_nocache
      ocfs2: correct l_next_free_rec in online check

Kemeng Shi (5):
      Xarray: do not return sibling entries from xas_find_marked()
      Xarray: move forward index correctly in xas_pause()
      Xarray: distinguish large entries correctly in xas_split_alloc()
      Xarray: remove repeat check in xas_squash_marks()
      Xarray: use xa_mark_t in xas_squash_marks() to keep code consistent

Kuan-Wei Chiu (6):
      lib min_heap: improve type safety in min_heap macros by using container_of
      lib/test_min_heap: use inline min heap variants to reduce attack vector
      lib min_heap: add brief introduction to Min Heap API
      Documentation/core-api: min_heap: add author information
      lib/sort: clarify comparison function requirements in sort_r()
      lib/list_sort: clarify comparison function requirements in list_sort()

Linus Lüssing (1):
      mailmap: update entry for Linus Lüssing

Luis Felipe Hernandez (1):
      lib/math: add int_sqrt test suite

Mark Tinguely (17):
      ocfs2: convert w_target_page to w_target_folio
      ocfs2: use a folio in ocfs2_zero_new_buffers()
      ocfs2: use a folio in ocfs2_write_begin_inline()
      ocfs2: convert ocfs2_readpage_inline() to take a folio
      ocfs2: convert ocfs2_inode_lock_with_page() to ocfs2_inode_lock_with_folio()
      ocfs2: convert w_pages to w_folios
      ocfs2: convert ocfs2_write_failure() to use a folio
      ocfs2: use a folio in ocfs2_write_end_nolock()
      ocfs2: use a folio in ocfs2_prepare_page_for_write()
      ocfs2: use a folio in ocfs2_map_and_dirty_page()
      ocfs2: convert ocfs2_map_page_blocks() to ocfs2_map_folio_blocks()
      ocfs2: convert ocfs2_clear_page_regions() to ocfs2_clear_folio_regions()
      ocfs2: use an array of folios instead of an array of pages
      ocfs2: convert ocfs2_duplicate_clusters_by_page() to use a folio
      ocfs2: convert ocfs2_map_and_dirty_page() to ocfs2_map_and_dirty_folio()
      ocfs2: support large folios in ocfs2_zero_cluster_folios()
      ocfs2: support large folios in ocfs2_write_zero_page()

Martin Kepplinger (1):
      init: fix removal warning for deprecated initrd loading

Mateusz Guzik (1):
      get_task_exe_file: check PF_KTHREAD locklessly

Matthew Wilcox (Oracle) (12):
      ocfs2: handle a symlink read error correctly
      ocfs2: convert ocfs2_page_mkwrite() to use a folio
      ocfs2: pass mmap_folio around instead of mmap_page
      ocfs2: convert ocfs2_read_inline_data() to take a folio
      ocfs2: use a folio in ocfs2_fast_symlink_read_folio()
      ocfs2: remove ocfs2_start_walk_page_trans() prototype
      iov_iter: remove setting of page->index
      squashfs: use a folio throughout squashfs_read_folio()
      squashfs: pass a folio to squashfs_readpage_fragment()
      squashfs: convert squashfs_readpage_block() to take a folio
      squashfs; convert squashfs_copy_cache() to take a folio
      squashfs: convert squashfs_fill_page() to take a folio

MengEn Sun (1):
      ucounts: move kfree() out of critical zone protected by ucounts_lock

Oxana Kharitonova (1):
      hung_task: add task->flags, blocked by coredump to log

Phillip Lougher (4):
      squashfs: make squashfs_cache_init() return ERR_PTR(-ENOMEM)
      squashfs: don't allocate read_page cache if SQUASHFS_FILE_DIRECT configured
      Documentation: update the Squashfs filesystem documentation
      squashfs: update Kconfig information

Pratyush Mittal (1):
      lib/rhashtable: fix the typo for preemptible

Randy Dunlap (3):
      latencytop: use correct kernel-doc format for func params
      gcov: clang: use correct function param names
      ipc/util.c: complete the kernel-doc function descriptions

Rob Herring (Arm) (1):
      MAINTAINERS: fix list entries with display names

Ryusuke Konishi (11):
      nilfs2: do not force clear folio if buffer is referenced
      nilfs2: protect access to buffers with no active references
      nilfs2: correct return value kernel-doc descriptions for ioctl functions
      nilfs2: correct return value kernel-doc descriptions for bmap functions
      nilfs2: correct return value kernel-doc descriptions for sufile
      nilfs2: correct return value kernel-doc descriptions for metadata files
      nilfs2: correct return value kernel-doc descriptions for the rest
      nilfs2: add missing return value kernel-doc descriptions
      nilfs2: revise the return value description style for consistency.
      nilfs2: handle errors that nilfs_prepare_chunk() may return
      nilfs2: do not update mtime of renamed directory that is not moved

Shivam Chaudhary (1):
      kernel-wide: add explicity||explicitly to spelling.txt

Su Yue (3):
      ocfs2: check tl->count of truncate log inode in ocfs2_get_truncate_log_info
      ocfs2: mark dquot as inactive if failed to start trans while releasing dquot
      ocfs2: remove parameter parent_fe_bh from __ocfs2_mknod_locked

Tamir Duberstein (5):
      xarray: extract xa_zero_to_null
      xarray: extract helper from __xa_{insert,cmpxchg}
      xarray: port tests to kunit
      checkpatch: check return of `git_commit_info`
      XArray: minor documentation improvements

Tanya Agarwal (1):
      CREDITS: fix spelling mistake

Thorsten Blum (2):
      alpha: remove duplicate included header file
      ocfs2: use str_yes_no() and str_no_yes() helper functions

Tio Zhang (1):
      kthread: correct comments before kthread_queue_work()

Wang Yaxin (2):
      delayacct: add delay max to record delay peak
      delayacct: add delay min to record delay peak

Yafang Shao (5):
      kernel: remove get_task_comm() and print task comm directly
      arch: remove get_task_comm() and print task comm directly
      net: remove get_task_comm() and print task comm directly
      security: remove get_task_comm() and print task comm directly
      drivers: remove get_task_comm() and print task comm directly

Yunhui Cui (1):
      watchdog: output this_cpu when printing hard LOCKUP

Zijun Hu (1):
      kernel/resource: simplify API __devm_release_region() implementation

pangliyuan (1):
      Squashfs: don't allocate fragment caches more than fragments

zhang jiao (1):
      tools/accounting/procacct: fix minor errors

 .mailmap                                           |   1 +
 CREDITS                                            |   2 +-
 Documentation/accounting/delay-accounting.rst      |  42 +-
 Documentation/core-api/min_heap.rst                |   2 +
 Documentation/core-api/xarray.rst                  |  24 +-
 Documentation/filesystems/squashfs.rst             |  14 +-
 MAINTAINERS                                        |  10 +-
 arch/alpha/lib/fpreg.c                             |   1 -
 arch/arc/kernel/unaligned.c                        |   5 +-
 arch/arm/mach-pxa/sharpsl_pm.c                     |   8 +-
 arch/m68k/configs/amiga_defconfig                  |   1 -
 arch/m68k/configs/apollo_defconfig                 |   1 -
 arch/m68k/configs/atari_defconfig                  |   1 -
 arch/m68k/configs/bvme6000_defconfig               |   1 -
 arch/m68k/configs/hp300_defconfig                  |   1 -
 arch/m68k/configs/mac_defconfig                    |   1 -
 arch/m68k/configs/multi_defconfig                  |   1 -
 arch/m68k/configs/mvme147_defconfig                |   1 -
 arch/m68k/configs/mvme16x_defconfig                |   1 -
 arch/m68k/configs/q40_defconfig                    |   1 -
 arch/m68k/configs/sun3_defconfig                   |   1 -
 arch/m68k/configs/sun3x_defconfig                  |   1 -
 arch/powerpc/configs/ppc64_defconfig               |   1 -
 arch/powerpc/kvm/book3s_hv.c                       |   2 +-
 arch/powerpc/platforms/pseries/papr_scm.c          |   2 +-
 arch/s390/kernel/lgr.c                             |   2 +-
 arch/s390/kernel/time.c                            |   4 +-
 arch/s390/kernel/topology.c                        |   2 +-
 arch/s390/mm/cmm.c                                 |   2 +-
 arch/x86/kernel/vm86_32.c                          |   5 +-
 drivers/accel/habanalabs/common/context.c          |   3 +-
 drivers/accel/habanalabs/common/device.c           |   2 +-
 drivers/accel/habanalabs/common/habanalabs_drv.c   |   3 +-
 drivers/accel/habanalabs/common/habanalabs_ioctl.c |  11 +-
 drivers/block/xen-blkback/blkback.c                |   2 +-
 .../gpu/drm/i915/display/intel_display_driver.c    |   6 +-
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   4 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   5 +-
 drivers/gpu/drm/xe/xe_device.c                     |   2 +-
 drivers/infiniband/hw/hfi1/iowait.h                |   2 +-
 drivers/infiniband/hw/usnic/usnic_abi.h            |   2 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |   2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   2 +-
 drivers/scsi/cxlflash/superpipe.c                  |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  18 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   8 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   4 +-
 drivers/scsi/lpfc/lpfc_vmid.c                      |   2 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   2 +-
 .../vc04_services/bcm2835-audio/bcm2835-vchiq.c    |   2 +-
 drivers/tty/tty_io.c                               |   3 +-
 fs/ceph/quota.c                                    |   2 +-
 fs/erofs/decompressor.c                            |   7 -
 fs/nilfs2/alloc.c                                  |  67 +-
 fs/nilfs2/alloc.h                                  |   2 +
 fs/nilfs2/bmap.c                                   | 124 ++--
 fs/nilfs2/btnode.c                                 |   3 +-
 fs/nilfs2/btree.c                                  |   7 +-
 fs/nilfs2/cpfile.c                                 |  69 +-
 fs/nilfs2/dat.c                                    |  45 +-
 fs/nilfs2/dir.c                                    |  13 +-
 fs/nilfs2/gcinode.c                                |  24 +-
 fs/nilfs2/ifile.c                                  |  37 +-
 fs/nilfs2/inode.c                                  |  16 +-
 fs/nilfs2/ioctl.c                                  | 236 +++----
 fs/nilfs2/mdt.c                                    |  63 +-
 fs/nilfs2/namei.c                                  |  39 +-
 fs/nilfs2/nilfs.h                                  |   4 +-
 fs/nilfs2/page.c                                   |  39 +-
 fs/nilfs2/recovery.c                               |  62 +-
 fs/nilfs2/segbuf.c                                 |  12 +-
 fs/nilfs2/segment.c                                |  66 +-
 fs/nilfs2/sufile.c                                 | 112 ++--
 fs/nilfs2/sufile.h                                 |  22 +-
 fs/nilfs2/super.c                                  |  10 +-
 fs/nilfs2/the_nilfs.c                              |  26 +-
 fs/ocfs2/alloc.c                                   | 157 ++---
 fs/ocfs2/alloc.h                                   |   8 +-
 fs/ocfs2/aops.c                                    | 337 +++++-----
 fs/ocfs2/aops.h                                    |  17 +-
 fs/ocfs2/cluster/heartbeat.c                       |  28 +-
 fs/ocfs2/cluster/masklog.h                         |   2 +-
 fs/ocfs2/cluster/quorum.c                          |   6 +-
 fs/ocfs2/cluster/tcp.c                             |   8 +-
 fs/ocfs2/dlm/dlmapi.h                              |   2 +-
 fs/ocfs2/dlm/dlmdebug.c                            |   9 +-
 fs/ocfs2/dlm/dlmmaster.c                           |  12 +-
 fs/ocfs2/dlm/dlmrecovery.c                         |  13 +-
 fs/ocfs2/dlmfs/dlmfs.c                             |  23 +-
 fs/ocfs2/dlmglue.c                                 |  31 +-
 fs/ocfs2/dlmglue.h                                 |   6 +-
 fs/ocfs2/extent_map.c                              |  10 +
 fs/ocfs2/file.c                                    |   8 +-
 fs/ocfs2/inode.c                                   |  28 +-
 fs/ocfs2/ioctl.c                                   |   2 +-
 fs/ocfs2/journal.c                                 |   2 +-
 fs/ocfs2/mmap.c                                    |  18 +-
 fs/ocfs2/move_extents.c                            |   8 +-
 fs/ocfs2/namei.c                                   |   7 +-
 fs/ocfs2/ocfs2_fs.h                                |   8 +-
 fs/ocfs2/ocfs2_ioctl.h                             |   2 +-
 fs/ocfs2/ocfs2_lockid.h                            |   2 +-
 fs/ocfs2/ocfs2_trace.h                             |  20 +-
 fs/ocfs2/quota_global.c                            |   5 +
 fs/ocfs2/refcounttree.c                            |  41 +-
 fs/ocfs2/reservations.h                            |   4 +-
 fs/ocfs2/stack_o2cb.c                              |   2 +-
 fs/ocfs2/stackglue.h                               |   2 +-
 fs/ocfs2/super.c                                   | 591 ++++++++---------
 fs/ocfs2/symlink.c                                 |  16 +-
 fs/ocfs2/xattr.c                                   |  10 +-
 fs/squashfs/Kconfig                                |   6 +-
 fs/squashfs/cache.c                                |  10 +-
 fs/squashfs/file.c                                 |  90 +--
 fs/squashfs/file_cache.c                           |   6 +-
 fs/squashfs/file_direct.c                          |  11 +-
 fs/squashfs/squashfs.h                             |  13 +-
 fs/squashfs/super.c                                |  21 +-
 include/asm-generic/syscall.h                      |   2 +-
 include/linux/bitmap.h                             |   2 +-
 include/linux/delayacct.h                          |  14 +
 include/linux/kasan.h                              |   2 +-
 include/linux/lz4.h                                |   6 +
 include/linux/min_heap.h                           |  72 ++-
 include/linux/minmax.h                             | 205 +++---
 include/linux/sched.h                              |   6 +
 include/linux/types.h                              |   2 +-
 include/uapi/linux/taskstats.h                     |  17 +
 init/do_mounts_initrd.c                            |   2 +-
 ipc/util.c                                         |  11 +-
 kernel/capability.c                                |   8 +-
 kernel/delayacct.c                                 |  55 +-
 kernel/fork.c                                      |   9 +-
 kernel/futex/waitwake.c                            |   3 +-
 kernel/gcov/clang.c                                |   6 +-
 kernel/hung_task.c                                 |   2 +
 kernel/kthread.c                                   |   2 +-
 kernel/latencytop.c                                |   6 +-
 kernel/resource.c                                  |   3 +-
 kernel/sched/core.c                                |   4 +-
 kernel/sched/stats.h                               |   9 +-
 kernel/ucount.c                                    |   8 +-
 kernel/watchdog.c                                  |   2 +-
 lib/Kconfig.debug                                  |  34 +-
 lib/Makefile                                       |   2 +-
 lib/fault-inject.c                                 |  28 +-
 lib/inflate.c                                      |   2 -
 lib/kunit_iov_iter.c                               |   3 -
 lib/list_sort.c                                    |   7 +
 lib/lz4/lz4_compress.c                             |   1 -
 lib/lz4/lz4_decompress.c                           |   1 -
 lib/lz4/lz4defs.h                                  |   4 +-
 lib/lz4/lz4hc_compress.c                           |   1 -
 lib/math/Makefile                                  |   1 +
 lib/math/tests/Makefile                            |   1 +
 lib/math/tests/int_sqrt_kunit.c                    |  66 ++
 lib/rhashtable.c                                   |   2 +-
 lib/sort.c                                         |   7 +
 lib/test_min_heap.c                                |  30 +-
 lib/test_xarray.c                                  | 706 +++++++++++++--------
 lib/xarray.c                                       |  78 +--
 mm/kmemleak.c                                      |   4 +-
 net/bluetooth/mgmt.c                               |   2 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |  21 +-
 net/wireless/wext-core.c                           |   4 +-
 samples/livepatch/livepatch-callbacks-busymod.c    |   3 +-
 samples/livepatch/livepatch-shadow-fix1.c          |   3 +-
 samples/livepatch/livepatch-shadow-mod.c           |  15 +-
 scripts/checkpatch.pl                              |  26 +-
 scripts/coccinelle/misc/secs_to_jiffies.cocci      |  22 +
 scripts/spelling.txt                               |  37 ++
 security/yama/yama_lsm.c                           |   4 +-
 sound/usb/line6/toneport.c                         |   2 +-
 tools/accounting/getdelays.c                       |  67 +-
 tools/accounting/procacct.c                        |   5 +-
 tools/testing/radix-tree/multiorder.c              |   4 +
 tools/testing/selftests/pidfd/pidfd_test.c         |   2 +-
 179 files changed, 2501 insertions(+), 2093 deletions(-)
 create mode 100644 lib/math/tests/int_sqrt_kunit.c
 create mode 100644 scripts/coccinelle/misc/secs_to_jiffies.cocci

