Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B1571B27;
	Sun, 19 May 2024 18:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716145057; cv=none; b=qA5yRi4Ye8373pAWGONtcJAy9/uJpC1FGJQXLS3DC6xm3UTUNUjpCFP+mSpFOHbwb1QIsvAUD1ZOZAD6xmsrl1yP3yvnHv6hIeqkyKbE4+p7Ui6/JGFczK5g0C2+QGJhN1t8LjSYpLn+LPdFH7i9hRVXtZYCDGCD6h+3uvuode4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716145057; c=relaxed/simple;
	bh=lY2vuNgTjpKMoaIZmEsZUky2k1y45LoR+gNwA6GyCNs=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Z6+7G+ZQoSytZNyqdXRC8ADQiUlw003MIyx6zJ9TOvVJeKB1mxnWqLHPPBZloMO3UGwMKiPdpAzo1Qp0pZjopMWt4b8DDuEF9nPOL0cKf5aOmzcGR4L1uvezymdvRncT+9qngJdLMXj9ihILL7/0v2+U79P10qyEJN5OPM6J8u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k8SVnqVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k8SVnqVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBA2C32781;
	Sun, 19 May 2024 18:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716145056;
	bh=lY2vuNgTjpKMoaIZmEsZUky2k1y45LoR+gNwA6GyCNs=;
	h=Date:From:To:Cc:Subject:From;
	b=k8SVnqVsdChi0NPE9PxUVYSi21F/OY6nFbcWuM/6LNcT5FqkoOoCbXTtwGUTYQZMt
	 6IhwH+aRlhqCs1/U/RHis6bZq7iphDmgQgzIOVZKhBbMu0nvU555cJJUSu0IBGb3K2
	 nOZf/CNLIWT1zbRf/JiEFbgniwwq8VjxL/tfW5Sk=
Date: Sun, 19 May 2024 11:57:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 6.10-rc1
Message-Id: <20240519115735.acabb2269a1a91ee0ebdbca5@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please pull this cycle's batch of non-MM patches, thanks.

I'm seeing a little conflict in init/main.c - addition of a code comment.


The following changes since commit 0bbac3facb5d6cc0171c45c9873a2dc96bea9680:

  Linux 6.9-rc4 (2024-04-14 13:38:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stabl=
e-2024-05-19-11-56

for you to fetch changes up to 5cbcb62dddf5346077feb82b7b0c9254222d3445:

  fs/proc: fix softlockup in __read_vmcore (2024-05-11 15:51:44 -0700)

----------------------------------------------------------------
Mainly singleton patches, documented in their respective changelogs.
Notable series include:

- Some maintenance and performance work for ocfs2 in Heming Zhao's
  series "improve write IO performance when fragmentation is high".

- Some ocfs2 bugfixes from Su Yue in the series "ocfs2 bugs fixes
  exposed by fstests".

- kfifo header rework from Andy Shevchenko in the series "kfifo: Clean
  up kfifo.h".

- GDB script fixes from Florian Rommel in the series "scripts/gdb: Fixes
  for $lx_current and $lx_per_cpu".

- After much discussion, a coding-style update from Barry Song
  explaining one reason why inline functions are preferred over macros.
  The series is "codingstyle: avoid unused parameters for a function-like
  macro".

----------------------------------------------------------------
Alexander Potapenko (3):
      mm: kmsan: implement kmsan_memmove()
      instrumented.h: add instrument_memcpy_before, instrument_memcpy_after
      x86: call instrumentation hooks from copy_mc.c

Alexey Dobriyan (1):
      cpumask: delete unused reset_cpu_possible_mask()

Andrew Morton (1):
      kernel/watchdog_perf.c: tidy up kerneldoc

Andy Shevchenko (5):
      devres: switch to use dev_err_probe() for unification
      devres: don't use "proxy" headers
      media: rc: add missing io.h
      media: stih-cec: add missing io.h
      kfifo: don't use "proxy" headers

Arnaldo Carvalho de Melo (1):
      tools lib rbtree: pick some improvements from the kernel rbtree code

Arnd Bergmann (4):
      kcov: avoid clang out-of-range warning
      test_hexdump: avoid string truncation warning
      block/partitions/ldm: convert strncpy() to strscpy()
      blktrace: convert strncpy() to strscpy_pad()

Baoquan He (3):
      Documentation: kdump: clean up the outdated description
      crash: add prefix for crash dumping messages
      kexec: fix the unexpected kexec_dprintk() macro

Barry Song (1):
      Documentation: coding-style: ask function-like macros to evaluate par=
ameters

Bart Van Assche (1):
      nilfs2: use __field_struct() for a bitwise field

Christophe JAILLET (3):
      intel_th: remove usage of the deprecated ida_simple_xx() API
      pps: remove usage of the deprecated ida_simple_xx() API
      mux: remove usage of the deprecated ida_simple_xx() API

Colin Ian King (1):
      ocfs2: remove redundant assignment to variable status

Douglas Anderson (1):
      regset: use kvzalloc() for regset_get_alloc()

Edward Liaw (1):
      selftests/kcmp: remove unused open mode

Eric Sandeen (1):
      nilfs2: convert to use the new mount API

Florian Rommel (4):
      scripts/gdb: fix failing KGDB detection during probe
      scripts/gdb: fix parameter handling in $lx_per_cpu
      scripts/gdb: make get_thread_info accept pointers
      scripts/gdb: fix detection of current CPU in KGDB

Heming Zhao (4):
      ocfs2: improve write IO performance when fragmentation is high
      ocfs2: adjust enabling place for la window
      ocfs2: speed up chain-list searching
      ocfs2: fix sparse warnings

Huang Shijie (1):
      NUMA: early use of cpu_to_node() returns 0 instead of the correct nod=
e id

Joel Granados (2):
      initrd: remove the now superfluous sentinel element from ctl_table ar=
ray
      ipc: remove the now superfluous sentinel element from ctl_table array

Joseph Qi (1):
      ocfs2: correctly use ocfs2_find_next_zero_bit()

Justin Stitt (1):
      vmcore: replace strncpy with strscpy_pad

Matthew Wilcox (Oracle) (3):
      squashfs: convert squashfs_symlink_read_folio to use folio APIs
      squashfs: remove calls to set the folio error flag
      nilfs2: remove calls to folio_set_error() and folio_clear_error()

Niklas Schnelle (1):
      kgdb: add HAS_IOPORT dependency

Phillip Lougher (1):
      Squashfs: remove deprecated strncpy by not copying the string

Rasmus Villemoes (1):
      bootconfig: do not put quotes on cmdline items unless necessary

Rik van Riel (1):
      fs/proc: fix softlockup in __read_vmcore

Ryusuke Konishi (2):
      nilfs2: make superblock data array index computation sparse friendly
      nilfs2: convert BUG_ON() in nilfs_finish_roll_forward() to WARN_ON()

Song Liu (2):
      watchdog: handle comma separated nmi_watchdog command line
      watchdog: allow nmi watchdog to use raw perf event

Su Yue (5):
      ocfs2: update inode ctime in ocfs2_fileattr_set
      ocfs2: return real error code in ocfs2_dio_wr_get_block
      ocfs2: fix races between hole punching and AIO+DIO
      ocfs2: update inode fsync transaction id in ocfs2_unlink and ocfs2_li=
nk
      ocfs2: use coarse time for new created files

Uwe Kleine-K=F6nig (1):
      lib/build_OID_registry: don't mention the full path of the script in =
output

Xining Xu (1):
      scripts: checkpatch: check unused parameters for function-like macro

Yang Li (4):
      fs: add kernel-doc comments to fat_parse_long()
      nilfs2: add kernel-doc comments to nilfs_do_roll_forward()
      nilfs2: add kernel-doc comments to nilfs_btree_convert_and_insert()
      nilfs2: add kernel-doc comments to nilfs_remove_all_gcinodes()

 Documentation/admin-guide/kdump/kdump.rst       |   8 +-
 Documentation/admin-guide/kernel-parameters.txt |   5 +-
 Documentation/dev-tools/checkpatch.rst          |  14 +
 Documentation/process/coding-style.rst          |  23 ++
 arch/x86/lib/copy_mc.c                          |  21 +-
 block/partitions/ldm.c                          |   6 +-
 drivers/hwtracing/intel_th/core.c               |   6 +-
 drivers/media/cec/platform/sti/stih-cec.c       |   1 +
 drivers/media/rc/mtk-cir.c                      |   1 +
 drivers/media/rc/serial_ir.c                    |   1 +
 drivers/media/rc/st_rc.c                        |   1 +
 drivers/media/rc/sunxi-cir.c                    |   1 +
 drivers/mux/core.c                              |   4 +-
 drivers/pps/clients/pps_parport.c               |   6 +-
 fs/binfmt_elf.c                                 |   2 +-
 fs/fat/dir.c                                    |  12 +
 fs/nilfs2/btree.c                               |  23 +-
 fs/nilfs2/dir.c                                 |   1 -
 fs/nilfs2/gcinode.c                             |   1 +
 fs/nilfs2/nilfs.h                               |   4 +-
 fs/nilfs2/recovery.c                            |   5 +-
 fs/nilfs2/segment.c                             |   8 +-
 fs/nilfs2/super.c                               | 388 +++++++++++---------=
----
 fs/nilfs2/the_nilfs.c                           |  25 +-
 fs/nilfs2/the_nilfs.h                           |   6 +-
 fs/ocfs2/aops.c                                 |   2 -
 fs/ocfs2/dlm/dlmdomain.c                        |  12 +-
 fs/ocfs2/export.c                               |  12 +-
 fs/ocfs2/file.c                                 |   2 +
 fs/ocfs2/inode.c                                |   2 +
 fs/ocfs2/ioctl.c                                |   1 +
 fs/ocfs2/localalloc.c                           |  34 +--
 fs/ocfs2/move_extents.c                         |   2 +-
 fs/ocfs2/namei.c                                |   4 +-
 fs/ocfs2/ocfs2_fs.h                             |   3 +-
 fs/ocfs2/refcounttree.c                         |   2 +-
 fs/ocfs2/reservations.c                         |   2 +-
 fs/ocfs2/resize.c                               |   8 +
 fs/ocfs2/suballoc.c                             | 117 +++++--
 fs/ocfs2/suballoc.h                             |   6 +-
 fs/proc/vmcore.c                                |   7 +-
 fs/squashfs/file.c                              |   6 +-
 fs/squashfs/file_direct.c                       |   3 +-
 fs/squashfs/namei.c                             |  14 +-
 fs/squashfs/symlink.c                           |  35 +--
 include/linux/cpumask.h                         |   5 -
 include/linux/instrumented.h                    |  35 +++
 include/linux/kexec.h                           |   6 +-
 include/linux/kfifo.h                           |   9 +-
 include/linux/kmsan-checks.h                    |  15 +
 include/linux/nmi.h                             |   2 +
 include/trace/events/nilfs2.h                   |   6 +-
 init/do_mounts_initrd.c                         |   1 -
 init/main.c                                     |  26 +-
 ipc/ipc_sysctl.c                                |   1 -
 ipc/mq_sysctl.c                                 |   1 -
 kernel/crash_core.c                             |   2 +
 kernel/crash_reserve.c                          |   4 +-
 kernel/kcov.c                                   |   3 +-
 kernel/regset.c                                 |   6 +-
 kernel/trace/blktrace.c                         |   3 +-
 kernel/watchdog.c                               |   9 +
 kernel/watchdog_perf.c                          |  47 ++-
 lib/Kconfig.kgdb                                |   1 +
 lib/build_OID_registry                          |   5 +-
 lib/devres.c                                    |  26 +-
 lib/kfifo.c                                     |   8 +-
 lib/test_hexdump.c                              |   2 +-
 mm/kmsan/hooks.c                                |  11 +
 samples/kfifo/dma-example.c                     |   3 +-
 scripts/checkpatch.pl                           |   6 +
 scripts/gdb/linux/cpus.py                       |  11 +-
 scripts/gdb/linux/tasks.py                      |   2 +-
 scripts/gdb/linux/utils.py                      |   2 +-
 tools/include/linux/rbtree_augmented.h          |   4 +-
 tools/lib/rbtree.c                              |   2 +-
 tools/testing/selftests/kcmp/kcmp_test.c        |   2 +-
 77 files changed, 683 insertions(+), 430 deletions(-)

