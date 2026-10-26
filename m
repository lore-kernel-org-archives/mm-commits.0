Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792985247;
	b=LTUBN5OmGlBJxLms/vnu86gjioWktdig+uXIvtX4JORBCcAALKoPJnyHr4XYl283V9o6
	 pgcpeQ6JzXFMAB6rurHNxQYnluyZjQ4xtkSzu07olI6E0O5a54Bn9lP+IIue7BJjg3flB
	 mVnufQLeuth0W90iQ99TvXIogEb5UAWTqwae8sEdzuAdrJycMpG+uQ5NHESxldFI4sTlI
	 N3FJl4JJb7LsB/0lX4ap5VIFEnzP4oChYh5NoYlxF79yk/P0r8Qxql+22Kbfy1KytR3Jg
	 0MDeY/a2IrN8dVkcIE2uaJ5CJpAKUXrsJm8EVWJH+vldYL98GLMzyLhNzyrv1dJF1Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792985247;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:X-Mailer:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=bV85UXCiRvQ6l70rB3jL6zdHTDrBWR6UmB7GcO73pNU=;
	b=g+61rE+FO7Vt1BrYIJqfCSBfJSEt99yrdsaAL6Fv5oTBZLOemrzew8yxN9o9EIrnS7tO
	 Cr0oJQGLUsRnRucg0t8WqHs4GNhh8Zn9sOVvKLK1hMoYwFDd+KgpQw7woKhbvujSApjqx
	 DN6v9w48LDIdkrMK3Q0ZpRl3O9kzBTlT/q4dyVf0jJ35Zr31Sub5k593lo/oG7MbY3UD7
	 jfjhl36/DhjvMkZRVObloowLFwLQzut+zQ5tnfZrACYMdzhxCNyRiZ1Os7Kc8nxx9dq7y
	 tsmgNIsnz+JhVIzW4tNUqI0eRtTdRKwU0hxYQm1WSNdhspvA7letoCPzrRxdYCXMraw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gwev9kVW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEBF606A31A;
	Mon, 26 Oct 2026 03:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gwev9kVW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67251F01825;
	Mon, 26 Oct 2026 03:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792985245;
	bh=bV85UXCiRvQ6l70rB3jL6zdHTDrBWR6UmB7GcO73pNU=;
	h=Date:From:To:Cc:Subject;
	b=gwev9kVWkU3ConPWM3WLsSAhFY5vUTev7Yo57hj/Xi53fgAExvir2J2nczPGlWtnd
	 tIMh2pn9jdXVZGrff2TalnobvUfKBsXkxjNRvw/Fbmw/ex5beBSmS9PiuXZFf+coag
	 37lcGWb24ksGrwvAPDL+C4S5zdPDfaXQuxLAvkOE=
Date: Sun, 25 Oct 2026 20:27:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 7.4-rc1
Message-Id: <20261025202725.34c617497b6d9a2be352cf4f@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Linus, please merge mm.git's other-than-MM material for this
development cycle.

I'm seeing a single conflict with current mainline, in
arch/s390/kernel/traps.c.  The linux-next resolution is at
https://lore.kernel.org/as93Q-hDP5cW6gaj@sirena.org.uk

Thanks.


The following changes since commit ff47652a4b66c067c765a7ad464d930b5a9367cc:

  Merge tag 'cifs-fixes-7.3-rc6' of https://git.manguebit.org/linux (2026-10-02 14:04:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-10-25-14-57

for you to fetch changes up to b6232ca8d194c60ee603586e42b5ea584d4b7be9:

  scripts/gdb: fix stack depot out-of-bounds diagnostic (2026-10-24 00:46:53 -0700)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-stable

Total patches:       134
Fixes: tags:         86
cc:stable patches:   52
Reviews/patch:       0.73
Reviewed rate:       59%

Summary of patch series in this merge:

- "ocfs2: exit recovery thread on mount error path" (Joseph Qi):

  Stop OCFS2 recovery before freeing failed-mount state and replay slots,
  closing use-after-free and double-free races.  Defer suballocator reclaim
  to break a transaction-lock deadlock with dismount.

- "ocfs2: validate suballoc slot and bit of metadata blocks" (Joseph Qi):

  Validate OCFS2 metadata suballocator slots, bits and directory index
  block locations.  Reject corrupt metadata with filesystem errors instead
  of BUGs or out-of-bounds accesses.

- "ocfs2: deal with legacy signed name hash values" (Joseph Qi):

  Restore OCFS2 lookups for non-ASCII names stored with legacy signed
  hashes.  Use stored xattr hashes during bucket splits to avoid duplicate
  entries and spurious ENOSPC failures.

- "ocfs2: stabilize dentry names in file and setattr traces" (Cen Zhang):

  Snapshot OCFS2 names during file and setattr tracing to prevent rename
  races using freed storage or mismatched names and lengths.  Preserve
  trace formats and the locked release open-count sample.

- "panic: fix panic_force_cpu= redirect races and NMI bypass"
  (Bradley Morgan):

  Fix panic_force_cpu races and NMI redirection so crash-kernel CPU
  selection is honored.  Preserve variable arguments on failed redirects
  and use a static message buffer.

- "fat: allocate multiple clusters in fallocate"
  (Matheus Alves de Almeida):

  Allocate FAT clusters in batches for FALLOC_FL_KEEP_SIZE and batch FAT
  updates.  This removes repeated single-cluster allocation overhead,
  particularly on synchronous mounts.

- "scripts/gdb: fix radix tree lookup and stack depot diagnostic"
  (Ting-Han Hou):

  Fix GDB radix-tree lookup and its handling of XArray sibling, retry and
  zero entries.  Also repair the stack-depot diagnostic for an out-of-range
  pool index.

- "hung_task: Improve warning budget handling and task reporting"
  (Aaron Tomlin):

  Reset the hung-task warning budget after recovery so later hangs remain
  visible.  Keep the configured limit intact and emit one summary per scan
  when detailed reports exhaust the budget.

- "bootconfig: Reject unexpected data after null character and cleanups"
  (Masami Hiramatsu (Google)):

  Reject bootconfig data after an embedded null while accepting trailing
  padding.  Validate the full input in the userspace tool, and retain
  internal tree sanity checks there rather than in the kernel.

- "kbuild: GCOV cleanups following the prefer-atomic fix"
  (Konstantin Khorenko):

  Use the actual GCOV build flags in the prefer-atomic compiler probe.
  Move flag setup into scripts/Makefile.gcov and skip the probe when GCOV
  is disabled.

- "ocfs2: xattr bucket validation fixes" (Joseph Qi):

  Accept valid OCFS2 xattr buckets spanning 512-byte blocks, avoiding false
  read-only remounts.  Reject misaligned buckets and return errors instead
  of panicking on corrupt defrag metadata.

- "ocfs2: fix metadata reservation for xattr value trees" (Joseph Qi):

  Reserve enough OCFS2 metadata for new and relocated xattr value trees.
  Fix shortfalls which could cause ENOSPC, dropped entries and leaked
  clusters on fragmented filesystems; remove duplicate reservations.

- "Introduce arch_do_panic" (Mete Durlu):

  Add arch_do_panic() and move s390 and sparc handling out of generic panic
  code.  The architecture-specific actions now follow the end-of-panic
  marker.

- "checkpatch: userspace improvements" (Petr Vorel):

  Improve checkpatch's userspace detection and suppress kernel-only checks.
  Recognize standard inttypes macros and add explicit --userspace and
  --no-userspace overrides.

- "ocfs2: validate dr_fs_generation of dir index root blocks" (Joseph Qi):

  Check OCFS2 directory index generations and leaf block numbers.  Reject
  stale or misplaced blocks instead of using metadata left by a previously
  formatted filesystem.

- "selftests/membarrier: Skip an unregistered memory barrier test on Musl"
  (Chris Gellermann):

  Skip the unregistered membarrier test when libc has already registered
  the command.  Musl does this during thread creation, causing false
  failures in the multithreaded test.

- "init: fix array boundary bugs in boot parameter parsing"
  (Wilson Felipe Pereira):

  Fix boot argument boundary cases which leave stale arguments in init's
  command line or panic when replacing the final environment variable.
  Clear the last slot and check duplicates before the limit.

Summary of the 87 singletons in this merge:

The OCFS2 singletons fix deadlocks between xattr updates and inline
truncation, and during inode reclaim. Corrupt quota and extent metadata
could also crash the kernel or corrupt memory; these paths now check the
layout before using it. Other fixes close use-after-free and publication
races around cluster reconfiguration, node failure, quota remount errors
and shared refcount trees. New files now retain security labels from all
stacked LSMs instead of silently dropping all but one. Valid xattr
insertions also stop tripping FORTIFY on builds with counted arrays.

Elsewhere, a lost wakeup could leave hardware-monitoring reads stuck in
unkillable sleep and block further I2C traffic. That is fixed, as are
kernel memory leaks in POSIX message-queue notifications and tmpfs
casefold setup which could grow until memory is exhausted. A driver
removal race which could crash the kernel is fixed too. The hibernation
command through reboot() also stops taking the same mutex twice,
avoiding a deadlock before suspension.

On the boot side, bzip2 decoding now accepts valid full blocks emitted
by lbzip2, fixing failures to boot those compressed kernels. Malformed
bzip2 streams can no longer overflow the decode buffer, and LZ4 initrds
are checked before the decoder can read past their end. FAT rejects
geometry which overflows the data-area calculation on 32-bit systems,
and rolls back entries when inode setup fails, preventing failed
creations from reappearing after remount. The x86 XOR and RAID6 AVX
paths also avoid imposing a slowdown on subsequent SSE code.

----------------------------------------------------------------
Aamir Ahmed (1):
      lib: decompress_bunzip2: fix integer overflow in run-length decoding

Aaron Tomlin (2):
      hung_task: reset warning budget when problem gets resolved
      hung_task: log summary line when warning budget is exhausted

Adam Harshbarger (1):
      lib/plist: fix plist_requeue() corrupting order in the last bucket

Ali Ahmet Memiş (1):
      mailmap: update email address for Ali Ahmet Memiş

Andrei Vagin (1):
      proc: report SIGEV_NONE in /proc/pid/timers if target task has died

Andrew Jones (1):
      mailmap: add entries for Andrew Jones

Andrey Golovko (1):
      mailmap: update email address for Andrey Golovko

Andy Shevchenko (2):
      resource: replace open coded resource_overlaps()
      CREDITS: fix the ordering and other issues

Armaan Sandhu (1):
      lib/cmdline: fix get_options() count and overflow with large ranges

Avi Weiss (1):
      profiling: fix sampling step on 64-bit big-endian systems

Bradley Morgan (10):
      mailmap: update email address for Bradley Morgan
      taskstats: fold the two pid/tgid handlers into one
      taskstats: drop the unused CPU_DONT_CARE enum member
      panic: fix redirect CPU race in panic_try_force_cpu()
      panic: flatten nmi_panic control flow
      panic: fix va_list reuse in panic_try_force_cpu()
      panic: restore variable arguments to nmi_panic()
      panic: allow force_cpu redirect from an NMI
      panic: kill the "buffer unavailable" redirect fallback
      watchdog/perf: one digit too short in the raw event config copy

Caleb Kan (1):
      stackdepot: stop preallocating after the final pool

Cen Zhang (13):
      ocfs2/heartbeat: unlink live slots when their node is missing
      ocfs2: initialize status waiters before publishing them
      ocfs2: publish the filecheck owner before adding sysfs attributes
      ocfs2/dlm: hold a lock reference across grant AST enqueue
      ocfs2: cancel quota sync work before freeing quota info
      ocfs2: pin refcount trees before dropping the lookup lock
      ocfs2/cluster: initialize heartbeat regions before publishing them
      ocfs2: pin owning modules for open debugfs files
      ocfs2: drain quorum work before removing the cluster
      ocfs2/dlm: drain join handlers before releasing module text
      ocfs2: snapshot dentry names in file and setattr traces
      ocfs2: snapshot the dentry name while tracing file release
      ocfs2/cluster: remove zero-address nodes from IP tree on teardown

Chris Gellermann (2):
      selftests/membarrier: introduce helper to get membarrier command registrations
      selftests/membarrier: skip unpermitted membarrier command test if preregistered by libc

DAI RENJIE (1):
      resource: fix lost wakeup when waiting for a muxed region

Daehyeon Ko (1):
      ipc/mqueue: release notification resources during inode eviction

Danish Khateeb (1):
      kselftest/filelock: plan for the five ofdlocks tests

Edward Adam Davis (1):
      kernel/reboot: avoid potential deadlocks during suspension

Eric Biggers (3):
      xor: add missing vzeroupper to AVX code
      raid6: add missing vzeroupper to AVX2 code
      raid6: add missing vzeroupper to AVX-512 code

Fang Xieyan (1):
      kcov: ignore an out-of-range comparison count in write_comp_data()

Feng Tang (1):
      panic: remove the unneeded panic_print_get()

Florian Schmaus (1):
      selftests/epoll: fix race condition in multi-waiter wakeup tests

Frank Li (1):
      rapidio: use dmaengine_get_dma_device() instead of chan->device->dev

Geert Uytterhoeven (1):
      raid/kunit: enable RAID6 PQ and XOR benchmarks if KUNIT_ALL_TESTS=m

Giorgi Kobakhia (1):
      ocfs2: fix array out of bound access in __ocfs2_find_path()

Guixin Liu (1):
      checkpatch: don't flag ACQUIRE_ERR() assignments in if conditions

Hemanth Selam (1):
      scripts/spelling.txt: keep British spelling for "initalise"

Hengyu Liang (1):
      fat: calculate data area start without overflow

Hrushiraj Gandhi (1):
      gcov: use strscpy() instead of strcpy() in init_node()

Hungyu Lin (1):
      compat: avoid double rounding in times()

Ivy Lopez (1):
      lib: decompress_unxz: make it obvious that there is no memory leak

James Kim (1):
      rapidio: mport_cdev: fix use-after-free in mport_mm_close()

Jiaming Zhang (1):
      ocfs2: fix chunk number of the first chunk in a local quota file

Jose A. Perez de Azpillaga (1):
      percpu_counter: annotate lockless read in _limited_add()

Joseph Qi (24):
      ocfs2: fix deadlock in inline-data truncate transactions
      ocfs2: exit recovery thread on mount error path
      ocfs2: free replay slots in ocfs2_recovery_exit()
      ocfs2: defer suballocator block group reclaim to workqueue
      ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes
      ocfs2: validate suballoc bit during inode read
      ocfs2: validate suballoc slot and bit of xattr and dir index blocks
      ocfs2: validate suballoc slot and bit of extent and refcount blocks
      ocfs2: allow xattr bucket entries to span multiple blocks
      ocfs2: reject inconsistent xattr bucket during defrag
      ocfs2: skip uninitialized lockres in ocfs2_mark_lockres_freeing()
      ocfs2: validate dr_fs_generation of dir index root blocks
      ocfs2: validate dl_blkno and dl_fs_generation of dir index leaf blocks
      ocfs2: retain all security xattrs during inode creation
      ocfs2: restore -ERANGE check in ocfs2_xattr_tree_list_index_block()
      ocfs2: fix possible deadlock between nfs_sync_rwlock and fs_reclaim
      ocfs2: reserve metadata for a new xattr block and its value tree
      ocfs2: reserve value tree metadata when moving an xattr into the inode
      ocfs2: reserve xattr value tree metadata only once
      ocfs2: deal with legacy signed dir index name hash values
      ocfs2: use the stored hash when checking xattr bucket collision
      ocfs2: deal with legacy signed xattr name hash values
      ocfs2/dlm: hold the lookup reference across convert AST enqueue
      ocfs2: validate the xattr tree root of an indexed xattr block

Julian Braha (2):
      lib: cleanup "fake" tristates in Kconfig
      arch/Kconfig: fix dead conditions by removing dead options

Karl Mehltretter (5):
      klist: avoid accesses after waking klist_remove()
      fork: honor task_struct's declared alignment
      ocfs2/cluster: hold a reference on the heartbeat thread
      resource, kunit: stop selecting GET_FREE_REGION
      kcov: report spurious PCs in the interrupt selftest

Kazuki Hanai (1):
      tmpfs: fix unicode_map leaks in casefold option handling

Konstantin Khorenko (3):
      selftests/core: fix unshare_test with large fs.nr_open
      kbuild: use $(CFLAGS_GCOV) in the prefer-atomic try-run test
      kbuild: move GCOV flags to scripts/Makefile.gcov

Markus Mayer (1):
      MAINTAINERS: update Markus's e-mail address

Masami Hiramatsu (Google) (2):
      bootconfig: reject unexpected data after null character
      bootconfig: skip internal tree sanity checks in kernel

Matheus Alves de Almeida (3):
      fat: remove cluster allocation size limit
      fat: support adding multiple clusters
      fat: allocate multiple clusters in fallocate

Matt Turner (1):
      lib/decompress_bunzip2: fix off-by-one in run-length bounds check

Matthias Goergens (1):
      kdev_t: shift in dev_t in MKDEV()

Mete Durlu (3):
      panic: introduce arch_do_panic
      s390: implement arch_do_panic
      sparc: implement arch_do_panic

Michael Liang (1):
      fault-inject: fix dentry leak

Nguyen Ngoc Thang (1):
      ocfs2: validate chunk and block counts of the local quota file

Nick Desaulniers (1):
      scripts/checkstack.pl: support llvm-objdump disassembly for x86

OGAWA Hirofumi (1):
      fat: fix fat_ent_write() for reverting the value

Petr Vorel (5):
      checkpatch: skip CamelCase cache for --no-tree without root
      checkpatch: add more userspace directories to is_userspace()
      checkpatch: ignore <inttypes.h> format macros for userspace tools
      checkpatch: add --userspace to force userspace rules
      checkpatch: skip kernel specific checks for userspace

Sang-Heon Jeon (2):
      bootconfig: remove redundant assignment in xbc_parse_array()
      init/main.c: remove unreachable check in obsolete_checksetup()

Sasha Levin (1):
      selftests/proc: proc-pid-vm: fix unused variable warning on non-x86

Su Yue (1):
      ocfs2: update xattr count before moving bucket entries

Thomas Maarseveen (1):
      lib/tests: add KUnit tests for errseq

Thorsten Blum (3):
      init: fix early boot crash with bare hostname parameter
      init: simplify early_hostname()
      lib: kstrtox: use isdigit() in _parse_integer_limit()

Ting-Han Hou (2):
      scripts/gdb: fix radix tree lookup pointer handling
      scripts/gdb: fix stack depot out-of-bounds diagnostic

Tzung-Bi Shih (1):
      watchdog: force console verbose when reporting lockups

Wilson Felipe Pereira (2):
      init/main: fix off-by-one in argv_init cleanup
      init/main: fix false-positive kernel panic on environment variable overwrite

Yuntao Wang (1):
      init: simplify initramfs.o build rule

Zhan Xusheng (1):
      minmax.h: update the stale 'x' versus 'ux' comment

ZhengYuan Huang (1):
      ocfs2: reject inconsistent local xattr entries

Zhiling Zou (1):
      lib: validate in-memory LZ4 chunk length

Zi Yan (1):
      USB: gadgetfs: do not WARN about excessively large memory allocations

zhoumin (1):
      fat: roll back the new entry when create/mkdir fails to build the inode

 .mailmap                                           |   9 +
 CREDITS                                            | 181 ++++----
 Documentation/admin-guide/sysctl/kernel.rst        |   5 +-
 MAINTAINERS                                        |  10 +-
 Makefile                                           |  22 +-
 arch/Kconfig                                       |   8 -
 arch/s390/kernel/traps.c                           |   7 +
 arch/sparc/kernel/setup.c                          |   9 +
 drivers/infiniband/hw/hfi1/fault.c                 |   1 -
 drivers/rapidio/devices/rio_mport_cdev.c           |   9 +-
 drivers/usb/gadget/legacy/inode.c                  |   4 +-
 drivers/watchdog/hpwdt.c                           |   2 +-
 fs/fat/fat.h                                       |   5 +-
 fs/fat/fatent.c                                    |  83 +++-
 fs/fat/file.c                                      |  13 +-
 fs/fat/inode.c                                     |  31 +-
 fs/fat/misc.c                                      |   7 +-
 fs/fat/namei_msdos.c                               |  22 +-
 fs/fat/namei_vfat.c                                |  22 +-
 fs/ocfs2/alloc.c                                   |  36 +-
 fs/ocfs2/cluster/heartbeat.c                       |  51 +-
 fs/ocfs2/cluster/netdebug.c                        |   4 +
 fs/ocfs2/cluster/nodemanager.c                     |  10 +-
 fs/ocfs2/cluster/quorum.c                          |   7 +-
 fs/ocfs2/cluster/quorum.h                          |   1 +
 fs/ocfs2/cluster/tcp.c                             |   8 +-
 fs/ocfs2/dir.c                                     | 131 +++++-
 fs/ocfs2/dlm/dlmconvert.c                          |  10 +-
 fs/ocfs2/dlm/dlmdebug.c                            |   5 +
 fs/ocfs2/dlm/dlmdomain.c                           |   3 +-
 fs/ocfs2/dlm/dlmlock.c                             |   8 +-
 fs/ocfs2/dlmglue.c                                 |  35 +-
 fs/ocfs2/dlmglue.h                                 |   5 +-
 fs/ocfs2/export.c                                  |  10 +-
 fs/ocfs2/file.c                                    | 118 +++--
 fs/ocfs2/filecheck.c                               |   5 +-
 fs/ocfs2/inode.c                                   |  58 ++-
 fs/ocfs2/journal.c                                 |   3 +-
 fs/ocfs2/journal.h                                 |   1 -
 fs/ocfs2/namei.c                                   |   6 +-
 fs/ocfs2/ocfs2.h                                   |  17 +
 fs/ocfs2/quota_local.c                             |  36 +-
 fs/ocfs2/refcounttree.c                            |  42 +-
 fs/ocfs2/suballoc.c                                | 235 ++++++++--
 fs/ocfs2/suballoc.h                                |   2 +-
 fs/ocfs2/super.c                                   |  33 +-
 fs/ocfs2/xattr.c                                   | 515 +++++++++++++++++----
 fs/ocfs2/xattr.h                                   |  12 +-
 fs/proc/base.c                                     |   8 +-
 include/linux/fault-inject.h                       |  10 +-
 include/linux/kdev_t.h                             |   2 +-
 include/linux/minmax.h                             |   6 +-
 include/linux/panic.h                              |   5 +-
 init/Makefile                                      |   6 +-
 init/main.c                                        |  12 +-
 init/version.c                                     |  11 +-
 ipc/mqueue.c                                       |   7 +
 kernel/fork.c                                      |   3 +-
 kernel/gcov/fs.c                                   |   2 +-
 kernel/hung_task.c                                 |  55 ++-
 kernel/kcov.c                                      |  43 +-
 kernel/panic.c                                     | 102 ++--
 kernel/profile.c                                   |   2 +-
 kernel/reboot.c                                    |   4 +-
 kernel/resource.c                                  |  16 +-
 kernel/resource_kunit.c                            |   3 +
 kernel/sys.c                                       |   3 +
 kernel/taskstats.c                                 |  50 +-
 kernel/watchdog.c                                  |   8 +-
 kernel/watchdog_perf.c                             |   4 +-
 lib/Kconfig                                        |  14 +-
 lib/Kconfig.debug                                  |  16 +-
 lib/bootconfig.c                                   |  46 +-
 lib/cmdline.c                                      |  13 +-
 lib/decompress_bunzip2.c                           |   6 +-
 lib/decompress_unlz4.c                             |   4 +
 lib/decompress_unxz.c                              |  10 +-
 lib/fault-inject.c                                 |   7 +-
 lib/klist.c                                        |  16 +-
 lib/kstrtox.c                                      |   2 +-
 lib/percpu_counter.c                               |  10 +-
 lib/plist.c                                        |   7 +
 lib/raid/Kconfig                                   |   2 +
 lib/raid/raid6/x86/avx2.c                          |   6 +
 lib/raid/raid6/x86/avx512.c                        |   6 +
 lib/raid/raid6/x86/recov_avx2.c                    |   2 +
 lib/raid/raid6/x86/recov_avx512.c                  |   2 +
 lib/raid/xor/x86/xor-avx.c                         |   1 +
 lib/stackdepot.c                                   |   2 +-
 lib/tests/Makefile                                 |   1 +
 lib/tests/cmdline_kunit.c                          |  39 ++
 lib/tests/errseq_kunit.c                           | 237 ++++++++++
 mm/shmem.c                                         |   7 +
 scripts/Makefile.gcov                              |  21 +
 scripts/checkpatch.pl                              |  38 +-
 scripts/checkstack.pl                              |   6 +-
 scripts/gdb/linux/radixtree.py                     |  66 +--
 scripts/gdb/linux/stackdepot.py                    |   2 +-
 scripts/spelling.txt                               |   4 +-
 tools/bootconfig/main.c                            |   4 +-
 tools/bootconfig/test-bootconfig.sh                |  12 +
 tools/testing/selftests/core/unshare_test.c        |  19 +-
 tools/testing/selftests/filelock/ofdlocks.c        |   2 +-
 .../filesystems/epoll/epoll_wakeup_test.c          |  32 +-
 .../selftests/membarrier/membarrier_test_impl.h    |  17 +-
 tools/testing/selftests/proc/proc-pid-vm.c         |  14 +-
 106 files changed, 2229 insertions(+), 683 deletions(-)
 create mode 100644 lib/tests/errseq_kunit.c
 create mode 100644 scripts/Makefile.gcov

