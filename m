From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 23 May 2016 16:21:24 -0700
Message-ID: <20160523162124.12acd7a92f96bd6c8710e180@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_May_2016_16_21_24_-0700_SSR1CJCWiGMao54s"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbcEWXVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:21:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Mon__23_May_2016_16_21_24_-0700_SSR1CJCWiGMao54s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


- Please have a think about Oleg's "wait/ptrace: assume __WALL if the
  child is traced".  It's a kernel-based workaround for existing
  userspace issues and is a form of non-back-compatible change.

- A few hotfixes

- befs cleanups

- nilfs2 updates

- sys_wait() changes

- kexec updates

- kdump

- scripts/gdb updates

- the last of the MM queue

- a few other misc things

84 patches, based on 7639dad93a5564579987abded4ec05e3db13659d:

Subject: m32r: fix build failure
Subject: : ELF/MIPS build fix
Subject: mm: memcontrol: fix possible css ref leak on oom
Subject: fs/befs/datastream.c:befs_read_datastream(): remove unneeded initi=
alization to NULL
Subject: fs/befs/datastream.c:befs_read_lsymlink(): remove unneeded initial=
ization to NULL
Subject: fs/befs/datastream.c:befs_find_brun_dblindirect(): remove unneeded=
 initializations to NULL
Subject: fs/befs/linuxvfs.c:befs_get_block(): remove unneeded initializatio=
n to NULL
Subject: fs/befs/linuxvfs.c:befs_iget(): remove unneeded initialization to =
NULL
Subject: fs/befs/linuxvfs.c:befs_iget(): remove unneeded raw_inode initiali=
zation to NULL
Subject: fs/befs/linuxvfs.c:befs_iget(): remove unneeded befs_nio initializ=
ation to NULL
Subject: fs/befs/io.c:befs_bread_iaddr(): remove unneeded initialization to=
 NULL
Subject: fs/befs/io.c:befs_bread(): remove unneeded initialization to NULL
Subject: nilfs2: constify nilfs_sc_operations structures
Subject: nilfs2: fix white space issue in nilfs_mount()
Subject: nilfs2: remove space before comma
Subject: nilfs2: remove FSF mailing address from GPL notices
Subject: nilfs2: clean up old e-mail addresses
Subject: MAINTAINERS: add web link for nilfs project
Subject: nilfs2: clarify permission to replicate the design
Subject: nilfs2: get rid of nilfs_mdt_mark_block_dirty()
Subject: nilfs2: move cleanup code of metadata file from inode routines
Subject: nilfs2: replace __attribute__((packed)) with __packed
Subject: nilfs2: add missing line spacing
Subject: nilfs2: clean trailing semicolons in macros
Subject: nilfs2: do not emit extra newline on nilfs_warning() and nilfs_err=
or()
Subject: nilfs2: remove space before semicolon
Subject: nilfs2: fix code indent coding style issue
Subject: nilfs2: avoid bare use of 'unsigned'
Subject: nilfs2: remove unnecessary else after return or break
Subject: nilfs2: remove loops of single statement macros
Subject: nilfs2: fix block comments
Subject: wait/ptrace: assume __WALL if the child is traced
Subject: wait: allow sys_waitid() to accept __WNOTHREAD/__WCLONE/__WALL
Subject: signal: make oom_flags a bool
Subject: kernel/signal.c: convert printk(KERN_<LEVEL> ...) to pr_<level>(..=
.)
Subject: signal: move the "sig < SIGRTMIN" check into siginmask(sig)
Subject: kernek/fork.c: allocate idle task for a CPU always on its local no=
de
Subject: exec: remove the no longer needed remove_arg_zero()->free_arg_page=
()
Subject: kexec: introduce a protection mechanism for the crashkernel reserv=
ed memory
Subject: kexec: provide arch_kexec_protect(unprotect)_crashkres()
Subject: kexec: make a pair of map/unmap reserved pages in error path
Subject: kexec: do a cleanup for function kexec_load
Subject: s390/kexec: consolidate crash_map/unmap_reserved_pages() and arch_=
kexec_protect(unprotect)_crashkres()
Subject: kdump: fix gdb macros work work with newer and 64-bit kernels
Subject: rtsx_usb_ms: use schedule_timeout_idle() in polling loop
Subject: drivers/memstick/core/mspro_block: use kmemdup
Subject: arch/defconfig: remove CONFIG_RESOURCE_COUNTERS
Subject: scripts/gdb: Adjust module reference counter reported by lx-lsmod
Subject: scripts/gdb: provide linux constants
Subject: scripts/gdb: provide kernel list item generators
Subject: scripts/gdb: convert modules usage to lists functions
Subject: scripts/gdb: provide exception catching parser
Subject: scripts/gdb: support !CONFIG_MODULES gracefully
Subject: scripts/gdb: provide a dentry_name VFS path helper
Subject: scripts/gdb: add io resource readers
Subject: scripts/gdb: add mount point list command
Subject: scripts/gdb: add cpu iterators
Subject: scripts/gdb: cast CPU numbers to integer
Subject: scripts/gdb: add a Radix Tree Parser
Subject: scripts/gdb: add documentation example for radix tree
Subject: scripts/gdb: add lx_thread_info_by_pid helper
Subject: scripts/gdb: improve types abstraction for gdb python scripts
Subject: scripts/gdb: fix issue with dmesg.py and python 3.X
Subject: scripts/gdb: decode bytestream on dmesg for Python3
Subject: MAINTAINERS: add co-maintainer for scripts/gdb
Subject: mm: make mmap_sem for write waits killable for mm syscalls
Subject: mm: make vm_mmap killable
Subject: mm: make vm_munmap killable
Subject: mm, aout: handle vm_brk failures
Subject: mm, elf: handle vm_brk error
Subject: mm: make vm_brk killable
Subject: mm, proc: make clear_refs killable
Subject: mm, fork: make dup_mmap wait for mmap_sem for write killable
Subject: ipc, shm: make shmem attach/detach wait for mmap_sem killable
Subject: vdso: make arch_setup_additional_pages wait for mmap_sem for write=
 killable
Subject: coredump: make coredump_wait wait for mmap_sem for write killable
Subject: aio: make aio_setup_ring killable
Subject: exec: make exec path waiting for mmap_sem killable
Subject: prctl: make PR_SET_THP_DISABLE wait for mmap_sem killable
Subject: uprobes: wait for mmap_sem for write killable
Subject: drm/i915: make i915_gem_mmap_ioctl wait for mmap_sem killable
Subject: drm/radeon: make radeon_mn_get wait for mmap_sem killable
Subject: drm/amdgpu: make amdgpu_mn_get wait for mmap_sem killable
Subject: kgdb: depends on VT




--Signature=_Mon__23_May_2016_16_21_24_-0700_SSR1CJCWiGMao54s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXQ5B6AAoJEJxZ78cCqAIHeXMP/153/e5yfvVsEBr45/qufQ9E
5GSk/KJr97C2UYIXnocYAlrPhIMCvm8vDFUhypweF+qOM1OVMb4O9supPEd1CakL
xcDKOLfIyn5FC6Hoaj5slhfSSETnFLfGG2hZNWzLKSIDRH5JmCwbtMdMkkic+OKK
gcSPnb0U7R4Z5TCgmKSnEcLTFAvejWcNjzdJnY4U7/jOQD6rcD9WRSVZwsLzWLxA
aWgr/U3OhtkYmzY/203x4LJtV8v8spN/F0+1TkaTk7/tfBzc+k3/EoxF82ZQkAEb
gIv4DXfxCijaC68S22DWccwR9/8RtCAt4HiPgnVMqKdtLmI9fCoRxmQopGFzGHO1
5I2w9vbiZctlA0FeosNxuHb9itL+eNc+UP/N5g+ZkExiADQaWGSApPs7G5cNjMZx
y2/7Q7KVWyLQ4ZeVPxT5aPuj++kYGdqsPz8r5rPZBKIfj6UWg1ZWGU01dhWw4nqM
uYdPJ4BDnbnuO7TPcQyINUBxkPWgRjaunhAU7+FApeFT2tK9Y4YGQBs/ikzksUSM
y3oXaEo7pz4IdyhhFuyOE+RhMcu/4x+MfTJzbTu2iOOSVhGs8GnhCHMqhA/gj190
X8ThAKGNabFFT8p0An8zywjh1OYaeZJr1TRco0C2+Zy0gX6ei3+wL+VcqWC/eonu
7Tf7LO1YHwRukN99cZFs
=CW+k
-----END PGP SIGNATURE-----

--Signature=_Mon__23_May_2016_16_21_24_-0700_SSR1CJCWiGMao54s--
