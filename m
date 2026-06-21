Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63242F7EF3;
	Sun, 21 Jun 2026 17:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782062871; cv=none; b=KN7wlZt0eeGR008OHQet/Aj887jkeNthdRM0l7NSd3IuMWYk0CkvWlW3t9QYvNHczQov4L/nXNWODAPAWxNZ9ouxOocXj12F6IeM3GpoUa0wxbzX1ASP/opKZEA9fgfCCOnvfpCcxl1XNABsw6ItvEphZoebOyMLxtQyMdJ2/Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782062871; c=relaxed/simple;
	bh=uuHY4pCjC3OlmxQeKE+VZcirDK/Ok0q+6iQL7Iel/VA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=onlLGyXoDB/DKr27s6SceTnrSEY8SiMxsBflCJAd5PqISvoYf5TwtsSo+1Pvi50c3r8XcFOmuB39T4EqoIaVbG/u7PwJXQzD/+ccR58/3zHW9K7vU4cvp/Zq0zgfb9KKk90iGg2Zqi1Ij7WUYM1bVjEwckcDP2MWf4xs/CRcaaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CmiTqgEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CmiTqgEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903031F00A3A;
	Sun, 21 Jun 2026 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782062869;
	bh=vegQAqhBv1wruCbDcvXbL0ND8hsh2KcN0r7lwl9EJ8k=;
	h=Date:From:To:Cc:Subject;
	b=CmiTqgEwRcCA9O5VtApovpvxGWUqrVj6rVzR60yI9gm15WZIyr+wBMtpRAeRiTMwN
	 +qdvdTDTPCZdK4yezLLNImmdHH2w6Cjfw2l4XCYo0jeUQJDVQA6oO5gRGl4zN8nmsG
	 zsko4KNrRFuqH7vGtTcPeoORsfApQrcn0LS+JkbY=
Date: Sun, 21 Jun 2026 10:27:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 7.2-rc1
Message-Id: <20260621102749.186ffe45cf2fd65838bc3ccc@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge these other-then-MM updates for the upcoming -rc
cycle, thanks.

I'm seeing one possible upcoming conflict in fs/ocfs2/dir.c, versus the
fs tree.  Mark resolved it thusly:
	https://lore.kernel.org/adOxjbi2byrIet3y@sirena.org.uk


The following changes since commit d60ec36cab338dfe2ae40d73e9c8d6c4af70d2b8:

  Merge tag 'mm-hotfixes-stable-2026-05-25-16-22' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/akpm/mm (2026-05-26 08:23:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stabl=
e-2026-06-21-10-22

for you to fetch changes up to ff6f26c58421614b02694ac9d219ac61d924bc68:

  ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write (2026-06=
-17 15:37:48 -0700)

----------------------------------------------------------------
mm.git review status for mm-hotfixes-stable..mm-nonmm-stable

Everything:

Total patches:       108
Reviews/patch:       0.84
Reviewed rate:       75%

Patch series in this merge:

- The 2 patch series "taskstats: fix TGID dead-thread stat retention"
  from Yiyang Chen fixes a taskstats TGID aggregation bug where fields
  added in the TGID query path were not preserved after thread exit, and
  adds a kselftest covering the regression.

- The 2 patch series "lib/tests: string_helpers: Slight improvements"
  from Andy Shevchenko improves lib/tests/string_helpers_kunit.c a little.

- The 2 patch series "lib/base64: decode fixes" from Josh Law addreesses
  minor issues in lib/base64.c.

- The 3 patch series "selftests/filelock: Make output more kselftestish"
  from Mark Brown makes the output from the ofdlocks test a bit easier for
  tooling to work with, and also ignores the generated file.

- The 3 patch series "uaccess: unify inline vs outline
  copy_{from,to}_user() selection" from Yury Norov simplifies the usercopy
  code by removing the selectability of inlining copy_{from,to}_user().

- The 5 patch series "ocfs2: validate inline xattr header consumers"
  from ZhengYuan Huang fixes a number of possible issues in the ocfs2
  xattr code.

- The 8 patch series "lib and lib/cmdline enhancements" from Dmitry
  Antipov provides additional robustness checking in the cmdline handling
  code and its in-kernel testing and selftests.

- The 18 patch series "cleanup the RAID6 P/Q library" from Christoph
  Hellwig cleans up the RAID6 P/Q library to match the recent updates to
  the RAID 5 XOR library and other CRC/crypto libraries.

- The 3 patch series "ocfs2: harden inode validators against forged
  metadata" from Michael Bommarito adds three structural checks to OCFS2
  dinode validation so malformed on-disk fields are rejected before
  ocfs2_populate_inode() copies them into the in-core inode.

- The 2 patch series "lib/raid: replace __get_free_pages() call with
  kmalloc()" from Mike Rapoport cleans up the lib/raid code by using
  kmalloc() in more places.

----------------------------------------------------------------
Adi Nata (1):
      kunit: fat: test cluster and directory i_pos layout helpers

Aleksandr Nogikh (1):
      ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write

Alexander Potapenko (2):
      kfence: fix KASAN HW tags bypass via runtime sample_interval change
      MAINTAINERS: add Alexander as a kcov reviewer

Alexander Sverdlin (1):
      mailmap: update Alexander Sverdlin's Email addresses

Alexey Dobriyan (2):
      proc: add tgid_iter.pid_ns member
      proc: rewrite next_tgid()

Anand Moon (1):
      treewide: fix indentation and whitespace in Kconfig files

Andy Shevchenko (2):
      lib/tests: string_helpers: decouple unescape and escape cases
      lib/tests: string_helpers: don't use "proxy" headers

Arnd Bergmann (2):
      init.h: discard exitcall symbols early
      err.h: use __always_inline on all error pointer helpers

Bart Van Assche (1):
      clang-format: fix formatting of guard() and scoped_guard() statements

Christoph Hellwig (18):
      raid6: turn the userspace test harness into a kunit test
      raid6: remove __KERNEL__ ifdefs
      raid6: move to lib/raid/
      raid6: remove unused defines in pq.h
      raid6: remove raid6_get_zero_page
      raid6: use named initializers for struct raid6_calls
      raid6: improve the public interface
      raid6: warn when using less than four devices
      raid6: hide internals
      raid6: rework registration of optimized algorithms
      raid6: use static_call for gen_syndrom and xor_syndrom
      raid6: use static_call for raid6_recov_2data and raid6_recov_datap
      raid6: update top of file comments
      raid6_kunit: use KUNIT_CASE_PARAM
      raid6_kunit: dynamically allocate data buffers using vmalloc
      raid6_kunit: cleanup dataptr handling
      raid6_kunit: randomize parameters and increase limits
      raid6_kunit: randomize buffer alignment

Costa Shulyupin (1):
      include: remove unused cnt32_to_63.h

Cryolitia PukNgae (1):
      checkpatch: cuppress warnings when Reported-by: is followed by Link:

Dan Carpenter (1):
      rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()

Dmitry Antipov (9):
      lib: fix _parse_integer_limit() to handle overflow
      lib: fix memparse() to handle overflow
      lib: add more string to 64-bit integer conversion overflow tests
      lib/cmdline_kunit: add test case for memparse()
      lib/cmdline: adjust a few comments to fix kernel-doc -Wreturn warnings
      riscv: add platform-specific double word shifts for riscv32
      lib: kunit: add tests for __ashldi3(), __ashrdi3(), and __lshrdi3()
      riscv: fix building compressed EFI image
      ocfs2: fix buffer head management in ocfs2_read_blocks()

Feng Tang (1):
      lib/nmi_backtrace: print out the CPUs which fail to respond to NMI

Guixin Liu (1):
      selftests/uevent: increase __UEVENT_BUFFER_SIZE to avoid ENOBUFS on b=
usy systems

Hongfu Li (1):
      selftests/perf_events: fix mmap() error check in sigtrap_threads

Ian Bridges (3):
      ocfs2: fix out-of-bounds write in ocfs2_remove_refcount_extent
      ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec
      ocfs2: fix NULL h_transaction deref in ocfs2_assure_trans_credits

Ingyu Jang (1):
      error-inject: use IS_ERR() check for debugfs_create_file()

Jann Horn (2):
      kcov: refactor common handle ID into kcov_common_handle_id
      kcov: allow simultaneous KCOV_ENABLE/KCOV_REMOTE_ENABLE

Joe Perches (2):
      checkpatch: add check for function pointer arrays in declarations
      MAINTAINERS/CREDITS: remove inactive checkpatch reviewers

Jorge Ramirez-Ortiz (1):
      mailmap: update Jorge Ramirez-Ortiz email address

Joseph Qi (2):
      ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
      ocfs2: fix race between ocfs2_control_install_private() and ocfs2_con=
trol_release()

Josh Law (2):
      lib/base64: validate before writing in decode tail path
      lib/base64: fix copy-pasted @padding doc in base64_decode()

Karl Mehltretter (1):
      kcov: use WRITE_ONCE() for selftest mode stores

Konstantin Khorenko (1):
      gcov: use atomic counter updates to fix concurrent access crashes

Kyle Zeng (1):
      ocfs2: avoid moving extents to occupied clusters

Lucas Poupeau (1):
      lib/bug: cleanup comment style, types and modernize logging

Mark Brown (3):
      kselftest/filelock: use ksft_perror()
      kselftest/filelock: report each test in oftlocks separately
      kselftest/filelock: add a .gitignore file

Maxwell Doose (2):
      fs: fat: inode: replace sprintf() with scnprintf()
      fs: efs: remove unneeded debug prints

Michael Bommarito (3):
      ocfs2: reject dinodes with non-canonical i_mode type
      ocfs2: reject dinodes whose i_rdev disagrees with the file type
      ocfs2: reject non-inline dinodes with i_size and zero i_clusters

Mike Rapoport (Microsoft) (2):
      xor: use kmalloc() in calibrate_xor_blocks()
      raid6: use kmalloc() in raid6_select_algo()

Petr Vorel (2):
      checkpatch: allow passing config directory
      checkpatch: add option to not force /* */ for SPDX

Philipp Stanner (1):
      llist: make locking comments consistent

Samuel Moelius (3):
      lib/test_firmware: allocate the configured into_buf size
      fat: reject BPB volumes whose data area starts beyond total sectors
      lib: interval_tree_test: validate benchmark parameters

Sasha Levin (1):
      get_maintainer: add --json output mode

Shardul Deshpande (1):
      treewide: fix transposed "sign" typos and update spelling.txt

Shuvam Pandey (2):
      seq_buf: export seq_buf_putmem_hex() and add KUnit tests
      lib/tests: extend cmdline KUnit with next_arg() tests

Stepan Ionichev (1):
      lib/uuid_kunit: add tests for the four random UUID/GUID generators

Tetsuo Handa (1):
      ocfs2: kill osb->system_file_mutex lock

Thomas Wei=DFschuh (1):
      lib: kunit_iov_iter: repeatedly call alloc_pages_bulk()

Thorsten Blum (2):
      proc: use strnlen() for name validation in __proc_create
      string: use min in sized_strscpy

Tristan Madani (1):
      ocfs2: use kzalloc for quota recovery bitmap allocation

Yiyang Chen (3):
      tools/accounting/getdelays: fix -Wformat-truncation warning in format=
_timespec
      taskstats: retain dead thread stats in TGID queries
      selftests/acct: add taskstats TGID retention test

Yury Norov (4):
      rust: uaccess: use INLINE_COPY_TO_USER to guard copy_to_user()
      uaccess: unify inline vs outline copy_{from,to}_user() selection
      uaccess: minimize INLINE_COPY_USER-related ifdefery
      scripts/bloat-o-meter: ignore _sdata

Zhang Cen (5):
      ocfs2: rebase copied fsdlm LVB pointers in locking_state
      ocfs2: reject oversized group bitmap descriptors
      ocfs2: validate fast symlink target during inode read
      ocfs2: reject FITRIM ranges shorter than a cluster
      ocfs2/dlm: require a ref for locking_state debugfs open

ZhengYuan Huang (7):
      ocfs2: reject inconsistent inode size before truncate
      ocfs2: don't BUG_ON an invalid journal dinode
      ocfs2: validate inline xattr header before ibody lookups
      ocfs2: validate inline xattr header before checking outside values
      ocfs2: validate inline xattr header before ibody remove
      ocfs2: validate inline xattr header before inline refcount attach
      ocfs2: validate inline xattr header before reflinking inline xattrs

 .clang-format                                      |   2 +
 .mailmap                                           |  16 +-
 CREDITS                                            |   4 +
 Documentation/crypto/async-tx-api.rst              |   4 +-
 Documentation/dev-tools/checkpatch.rst             |  14 +
 Documentation/dev-tools/kcov.rst                   |   6 +
 MAINTAINERS                                        |   7 +-
 Makefile                                           |  27 +-
 arch/arc/include/asm/uaccess.h                     |   3 +-
 arch/arm/include/asm/uaccess.h                     |   3 +-
 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi         |   2 +-
 arch/arm64/include/asm/uaccess.h                   |   3 +-
 arch/hexagon/include/asm/uaccess.h                 |   3 +-
 arch/loongarch/include/asm/uaccess.h               |   3 +-
 arch/m68k/include/asm/uaccess.h                    |   3 +-
 arch/microblaze/include/asm/uaccess.h              |   3 +-
 arch/mips/include/asm/uaccess.h                    |   3 +-
 arch/nios2/include/asm/uaccess.h                   |   3 +-
 arch/openrisc/include/asm/uaccess.h                |   3 +-
 arch/parisc/include/asm/uaccess.h                  |   3 +-
 arch/riscv/Kconfig                                 |   3 -
 arch/riscv/include/asm/asm-prototypes.h            |   4 +
 arch/riscv/kernel/image-vars.h                     |   9 +
 arch/riscv/lib/Makefile                            |   1 +
 arch/riscv/lib/ashldi3.S                           |  36 ++
 arch/riscv/lib/ashrdi3.S                           |  36 ++
 arch/riscv/lib/lshrdi3.S                           |  36 ++
 arch/s390/include/asm/uaccess.h                    |   3 +-
 arch/sh/include/asm/uaccess.h                      |   3 +-
 arch/sparc/include/asm/uaccess_32.h                |   3 +-
 arch/sparc/include/asm/uaccess_64.h                |   3 +-
 arch/um/include/asm/uaccess.h                      |   3 +-
 arch/xtensa/include/asm/uaccess.h                  |   3 +-
 certs/Kconfig                                      |  16 +-
 crypto/async_tx/async_pq.c                         |   9 +-
 crypto/async_tx/async_raid6_recov.c                |   9 +-
 drivers/dma/bcm-sba-raid.c                         |   1 +
 drivers/firmware/efi/libstub/Makefile              |   6 +-
 drivers/gpu/drm/drm_color_mgmt.c                   |   2 +-
 drivers/md/raid5.c                                 |   4 +-
 drivers/rapidio/devices/tsi721.c                   |   3 +-
 drivers/scsi/elx/efct/efct_hw.h                    |   2 +-
 drivers/scsi/isci/host.c                           |   2 +-
 drivers/scsi/isci/port.c                           |   2 +-
 drivers/scsi/isci/port_config.c                    |   2 +-
 drivers/usb/usbip/usbip_common.h                   |  29 +-
 drivers/usb/usbip/vhci_rx.c                        |   4 +-
 drivers/usb/usbip/vhci_sysfs.c                     |   2 +-
 drivers/vhost/vhost.h                              |   2 +-
 fs/Kconfig                                         |   6 +-
 fs/btrfs/raid56.c                                  |   8 +-
 fs/efs/file.c                                      |  21 +-
 fs/fat/fat_test.c                                  |  33 ++
 fs/fat/inode.c                                     |  10 +-
 fs/ocfs2/alloc.c                                   |   2 +-
 fs/ocfs2/aops.c                                    |  13 +-
 fs/ocfs2/buffer_head_io.c                          |   7 +-
 fs/ocfs2/dlm/dlmdebug.c                            |  16 +-
 fs/ocfs2/dlmglue.c                                 |  17 +
 fs/ocfs2/file.c                                    |  23 +-
 fs/ocfs2/inode.c                                   | 206 ++++++++++-
 fs/ocfs2/journal.c                                 |  13 +-
 fs/ocfs2/journal.h                                 |   3 +
 fs/ocfs2/move_extents.c                            |   4 +-
 fs/ocfs2/ocfs2.h                                   |   2 -
 fs/ocfs2/quota_local.c                             |   2 +-
 fs/ocfs2/refcounttree.c                            |   9 +-
 fs/ocfs2/stack_user.c                              |  10 +-
 fs/ocfs2/suballoc.c                                |  22 ++
 fs/ocfs2/super.c                                   |   2 -
 fs/ocfs2/sysfile.c                                 |   9 +-
 fs/ocfs2/xattr.c                                   | 123 ++++---
 fs/proc/base.c                                     |  57 ++--
 fs/proc/generic.c                                  |  10 +-
 include/asm-generic/uaccess.h                      |   3 +-
 include/linux/cnt32_to_63.h                        | 104 ------
 include/linux/err.h                                |  12 +-
 include/linux/init.h                               |   2 +-
 include/linux/kcov.h                               |  14 +-
 include/linux/llist.h                              |   4 +-
 include/linux/raid/pq.h                            | 216 +-----------
 include/linux/raid/pq_tables.h                     |  19 ++
 include/linux/sched.h                              |   3 +
 include/linux/skbuff.h                             |  14 +-
 include/linux/types.h                              |   6 +
 include/linux/uaccess.h                            |  25 +-
 init/Kconfig                                       |  24 +-
 kernel/bpf/helpers.c                               |   2 +-
 kernel/kcov.c                                      | 104 +++---
 kernel/taskstats.c                                 |  62 ++--
 lib/Kconfig                                        |  13 +-
 lib/Kconfig.debug                                  |  10 +
 lib/Makefile                                       |   1 -
 lib/base64.c                                       |   5 +-
 lib/bug.c                                          |  80 ++---
 lib/cmdline.c                                      |  30 +-
 lib/error-inject.c                                 |   4 +-
 lib/interval_tree_test.c                           |  22 ++
 lib/kstrtox.c                                      |  37 +-
 lib/nmi_backtrace.c                                |  15 +-
 lib/raid/Kconfig                                   |  33 ++
 lib/raid/Makefile                                  |   2 +-
 lib/{ =3D> raid}/raid6/.gitignore                    |   0
 lib/raid/raid6/Makefile                            | 126 +++++++
 lib/raid/raid6/algos.c                             | 377 +++++++++++++++++=
++++
 lib/raid/raid6/algos.h                             |  41 +++
 lib/{raid6 =3D> raid/raid6/arm}/neon.c               |  23 +-
 lib/{raid6 =3D> raid/raid6/arm}/neon.h               |   0
 lib/{raid6 =3D> raid/raid6/arm}/neon.uc              |   2 +-
 lib/raid/raid6/arm/pq_arch.h                       |  21 ++
 lib/{raid6 =3D> raid/raid6/arm}/recov_neon.c         |  27 +-
 lib/{raid6 =3D> raid/raid6/arm}/recov_neon_inner.c   |   2 +-
 lib/raid/raid6/arm64/pq_arch.h                     |   1 +
 lib/{ =3D> raid}/raid6/int.uc                        |  10 +-
 .../raid6/loongarch}/loongarch_simd.c              |  31 +-
 lib/raid/raid6/loongarch/pq_arch.h                 |  23 ++
 .../raid6/loongarch}/recov_loongarch_simd.c        |  39 +--
 lib/{ =3D> raid}/raid6/mktables.c                    |  28 +-
 lib/{raid6 =3D> raid/raid6/powerpc}/altivec.uc       |  32 +-
 lib/raid/raid6/powerpc/pq_arch.h                   |  32 ++
 lib/{raid6 =3D> raid/raid6/powerpc}/vpermxor.uc      |  29 +-
 lib/{ =3D> raid}/raid6/recov.c                       |  62 +---
 lib/raid/raid6/riscv/pq_arch.h                     |  21 ++
 lib/{raid6 =3D> raid/raid6/riscv}/recov_rvv.c        |  14 +-
 lib/{raid6 =3D> raid/raid6/riscv}/rvv.c              |   0
 lib/{raid6 =3D> raid/raid6/riscv}/rvv.h              |  26 +-
 lib/raid/raid6/s390/pq_arch.h                      |  15 +
 lib/{raid6 =3D> raid/raid6/s390}/recov_s390xc.c      |  14 +-
 lib/{raid6 =3D> raid/raid6/s390}/s390vx.uc           |  15 +-
 lib/raid/raid6/tests/Makefile                      |   3 +
 lib/raid/raid6/tests/raid6_kunit.c                 | 321 ++++++++++++++++++
 lib/{ =3D> raid}/raid6/unroll.awk                    |   0
 lib/{raid6 =3D> raid/raid6/x86}/avx2.c               |  47 +--
 lib/{raid6 =3D> raid/raid6/x86}/avx512.c             |  57 +---
 lib/{raid6 =3D> raid/raid6/x86}/mmx.c                |  39 +--
 lib/raid/raid6/x86/pq_arch.h                       |  96 ++++++
 lib/{raid6 =3D> raid/raid6/x86}/recov_avx2.c         |  22 +-
 lib/{raid6 =3D> raid/raid6/x86}/recov_avx512.c       |  26 +-
 lib/{raid6 =3D> raid/raid6/x86}/recov_ssse3.c        |  23 +-
 lib/{raid6 =3D> raid/raid6/x86}/sse1.c               |  49 +--
 lib/{raid6 =3D> raid/raid6/x86}/sse2.c               |  47 +--
 lib/raid/xor/xor-core.c                            |   5 +-
 lib/raid6/Makefile                                 |  83 -----
 lib/raid6/algos.c                                  | 291 ----------------
 lib/raid6/loongarch.h                              |  38 ---
 lib/raid6/test/.gitignore                          |   3 -
 lib/raid6/test/Makefile                            | 156 ---------
 lib/raid6/test/test.c                              | 152 ---------
 lib/raid6/x86.h                                    |  75 ----
 lib/seq_buf.c                                      |   1 +
 lib/string.c                                       |   8 +-
 lib/test-kstrtox.c                                 |   6 +
 lib/test_firmware.c                                |   2 +-
 lib/tests/Makefile                                 |   1 +
 lib/tests/cmdline_kunit.c                          | 118 +++++++
 lib/tests/kunit_iov_iter.c                         |  12 +-
 lib/tests/seq_buf_kunit.c                          |  34 ++
 lib/tests/shdi3_kunit.c                            | 175 ++++++++++
 lib/tests/string_helpers_kunit.c                   |  15 +-
 lib/tests/uuid_kunit.c                             |  56 +++
 lib/usercopy.c                                     |   4 +-
 mm/Kconfig                                         |   4 +-
 mm/kfence/core.c                                   |   5 +
 rust/helpers/uaccess.c                             |   2 +-
 scripts/bloat-o-meter                              |   1 +
 scripts/checkpatch.pl                              |  53 ++-
 scripts/get_maintainer.pl                          |  73 ++--
 scripts/spelling.txt                               |   1 +
 tools/accounting/getdelays.c                       |   8 +-
 tools/testing/selftests/acct/.gitignore            |   3 +-
 tools/testing/selftests/acct/Makefile              |   5 +-
 .../selftests/acct/taskstats_fill_stats_tgid.c     | 375 +++++++++++++++++=
+++
 tools/testing/selftests/filelock/.gitignore        |   1 +
 tools/testing/selftests/filelock/ofdlocks.c        |  94 +++--
 .../selftests/perf_events/watermark_signal.c       |   2 +-
 tools/testing/selftests/uevent/uevent_filtering.c  |   2 +-
 176 files changed, 3254 insertions(+), 2198 deletions(-)
 create mode 100644 arch/riscv/lib/ashldi3.S
 create mode 100644 arch/riscv/lib/ashrdi3.S
 create mode 100644 arch/riscv/lib/lshrdi3.S
 delete mode 100644 include/linux/cnt32_to_63.h
 create mode 100644 include/linux/raid/pq_tables.h
 rename lib/{ =3D> raid}/raid6/.gitignore (100%)
 create mode 100644 lib/raid/raid6/Makefile
 create mode 100644 lib/raid/raid6/algos.c
 create mode 100644 lib/raid/raid6/algos.h
 rename lib/{raid6 =3D> raid/raid6/arm}/neon.c (79%)
 rename lib/{raid6 =3D> raid/raid6/arm}/neon.h (100%)
 rename lib/{raid6 =3D> raid/raid6/arm}/neon.uc (99%)
 create mode 100644 lib/raid/raid6/arm/pq_arch.h
 rename lib/{raid6 =3D> raid/raid6/arm}/recov_neon.c (81%)
 rename lib/{raid6 =3D> raid/raid6/arm}/recov_neon_inner.c (99%)
 create mode 100644 lib/raid/raid6/arm64/pq_arch.h
 rename lib/{ =3D> raid}/raid6/int.uc (96%)
 rename lib/{raid6 =3D> raid/raid6/loongarch}/loongarch_simd.c (96%)
 create mode 100644 lib/raid/raid6/loongarch/pq_arch.h
 rename lib/{raid6 =3D> raid/raid6/loongarch}/recov_loongarch_simd.c (96%)
 rename lib/{ =3D> raid}/raid6/mktables.c (83%)
 rename lib/{raid6 =3D> raid/raid6/powerpc}/altivec.uc (84%)
 create mode 100644 lib/raid/raid6/powerpc/pq_arch.h
 rename lib/{raid6 =3D> raid/raid6/powerpc}/vpermxor.uc (82%)
 rename lib/{ =3D> raid}/raid6/recov.c (60%)
 create mode 100644 lib/raid/raid6/riscv/pq_arch.h
 rename lib/{raid6 =3D> raid/raid6/riscv}/recov_rvv.c (95%)
 rename lib/{raid6 =3D> raid/raid6/riscv}/rvv.c (100%)
 rename lib/{raid6 =3D> raid/raid6/riscv}/rvv.h (70%)
 create mode 100644 lib/raid/raid6/s390/pq_arch.h
 rename lib/{raid6 =3D> raid/raid6/s390}/recov_s390xc.c (90%)
 rename lib/{raid6 =3D> raid/raid6/s390}/s390vx.uc (93%)
 create mode 100644 lib/raid/raid6/tests/Makefile
 create mode 100644 lib/raid/raid6/tests/raid6_kunit.c
 rename lib/{ =3D> raid}/raid6/unroll.awk (100%)
 rename lib/{raid6 =3D> raid/raid6/x86}/avx2.c (94%)
 rename lib/{raid6 =3D> raid/raid6/x86}/avx512.c (93%)
 rename lib/{raid6 =3D> raid/raid6/x86}/mmx.c (81%)
 create mode 100644 lib/raid/raid6/x86/pq_arch.h
 rename lib/{raid6 =3D> raid/raid6/x86}/recov_avx2.c (95%)
 rename lib/{raid6 =3D> raid/raid6/x86}/recov_avx512.c (94%)
 rename lib/{raid6 =3D> raid/raid6/x86}/recov_ssse3.c (95%)
 rename lib/{raid6 =3D> raid/raid6/x86}/sse1.c (78%)
 rename lib/{raid6 =3D> raid/raid6/x86}/sse2.c (94%)
 delete mode 100644 lib/raid6/Makefile
 delete mode 100644 lib/raid6/algos.c
 delete mode 100644 lib/raid6/loongarch.h
 delete mode 100644 lib/raid6/test/.gitignore
 delete mode 100644 lib/raid6/test/Makefile
 delete mode 100644 lib/raid6/test/test.c
 delete mode 100644 lib/raid6/x86.h
 create mode 100644 lib/tests/shdi3_kunit.c
 create mode 100644 tools/testing/selftests/acct/taskstats_fill_stats_tgid.c
 create mode 100644 tools/testing/selftests/filelock/.gitignore

