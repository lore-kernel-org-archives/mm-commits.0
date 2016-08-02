From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Tue, 2 Aug 2016 14:01:36 -0700
Message-ID: <20160802140136.153c5be9ea346935e896d438@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Aug_2016_14_01_36_-0700_Nsyknwr1nE=Q52HB"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbcHBVBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Tue__2_Aug_2016_14_01_36_-0700_Nsyknwr1nE=Q52HB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


- the rest of ocfs2

- various hotfixes, mainly MM

- quite a bit of misc stuff - drivers, fork, exec, signals, etc.

- printk updates

- firmware

- checkpatch

- nilfs2

- more kexec stuff than usual

- rapidio updates

- w1 things


111 patches, based on f7b32e4c021fd788f13f6785e17efbc3eb05b351:

Subject: ocfs2: ensure that dlm lockspace is created by kernel module
Subject: ocfs2: retry on ENOSPC if sufficient space in truncate log
Subject: ocfs2/dlm: disable BUG_ON when DLM_LOCK_RES_DROPPING_REF is cleare=
d before dlm_deref_lockres_done_handler
Subject: ocfs2/dlm: solve a BUG when deref failed in dlm_drop_lockres_ref
Subject: ocfs2/dlm: continue to purge recovery lockres when recovery master=
 goes down
Subject: mm: fail prefaulting if page table allocation fails
Subject: mm: move swap-in anonymous page into active list
Subject: tools/testing/radix-tree/linux/gfp.h: fix bitrotted value
Subject: mm/hugetlb: avoid soft lockup in set_max_huge_pages()
Subject: mm, hugetlb: fix huge_pte_alloc BUG_ON
Subject: memcg: put soft limit reclaim out of way if the excess tree is emp=
ty
Subject: mm/kasan: fix corruptions and false positive reports
Subject: mm/kasan: don't reduce quarantine in atomic contexts
Subject: mm/kasan, slub: don't disable interrupts when object leaves quaran=
tine
Subject: mm/kasan: get rid of ->alloc_size in struct kasan_alloc_meta
Subject: mm/kasan: get rid of ->state in struct kasan_alloc_meta
Subject: kasan: improve double-free reports
Subject: kasan: avoid overflowing quarantine size on low memory systems
Subject: radix-tree: account nodes to memcg only if explicitly requested
Subject: mm: vmscan: fix memcg-aware shrinkers not called on global reclaim
Subject: sysv, ipc: fix security-layer leaking
Subject: UBSAN: fix typo in format string
Subject: cgroup: update cgroup's document path
Subject: MAINTAINERS: befs: add new maintainers
Subject: proc_oom_score: remove tasklist_lock and pid_alive()
Subject: procfs: avoid 32-bit time_t in /proc/*/stat
Subject: fs/proc/task_mmu.c: suppress compilation warnings with W=3D1
Subject: init/Kconfig: make COMPILE_TEST depend on !UML
Subject: memstick: don't allocate unused major for ms_block
Subject: treewide: replace obsolete _refok by __ref
Subject: uapi: move forward declarations of internal structures
Subject: mailmap: add Linus L_ssing
Subject: include: mman: use bool instead of int for the return value of arc=
h_validate_prot
Subject: task_work: use READ_ONCE/lockless_dereference, avoid pi_lock if !t=
ask_works
Subject: dynamic_debug: only add header when used
Subject: printk: do not include interrupt.h
Subject: printk: create pr_<level> functions
Subject: printk: introduce suppress_message_printing()
Subject: printk: include <asm/sections.h> instead of <asm-generic/sections.=
h>
Subject: fbdev/bfin_adv7393fb: move DRIVER_NAME before its first use
Subject: ratelimit: extend to print suppressed messages on release
Subject: printk: add kernel parameter to control writes to /dev/kmsg
Subject: get_maintainer.pl: reduce need for command-line option -f
Subject: lib/iommu-helper: skip to next segment
Subject: crc32: use ktime_get_ns() for measurement
Subject: radix-tree: fix comment about "exceptional" bits
Subject: firmware: consolidate kmap/read/write logic
Subject: firmware: provide infrastructure to make fw caching optional
Subject: firmware: support loading into a pre-allocated buffer
Subject: checkpatch: skip long lines that use an EFI_GUID macro
Subject: checkpatch: allow c99 style // comments
Subject: checkpatch: yet another commit id improvement
Subject: checkpatch: don't complain about BIT macro in uapi
Subject: checkpatch: improve 'bare use of' signed/unsigned types warning
Subject: checkpatch: check signoff when reading stdin
Subject: checkpatch: if no filenames then read stdin
Subject: binfmt_elf: fix calculations for bss padding
Subject: mm: refuse wrapped vm_brk requests
Subject: fs/binfmt_em86.c: fix incompatible pointer type
Subject: nilfs2: hide function name argument from nilfs_error()
Subject: nilfs2: add nilfs_msg() message interface
Subject: nilfs2: embed a back pointer to super block instance in nilfs obje=
ct
Subject: nilfs2: reduce bare use of printk() with nilfs_msg()
Subject: nilfs2: replace nilfs_warning() with nilfs_msg()
Subject: nilfs2: emit error message when I/O error is detected
Subject: nilfs2: do not use yield()
Subject: nilfs2: refactor parser of snapshot mount option
Subject: nilfs2: fix misuse of a semaphore in sysfs code
Subject: nilfs2: use BIT() macro
Subject: nilfs2: move ioctl interface and disk layout to uapi separately
Subject: reiserfs: fix "new_insert_key may be used uninitialized ..."
Subject: signal: consolidate {TS,TLF}_RESTORE_SIGMASK code
Subject: kernel/exit.c: quieten greatest stack depth printk
Subject: cpumask: fix code comment
Subject: kexec: return error number directly
Subject: ARM: kdump: advertise boot aliased crash kernel resource
Subject: ARM: kexec: advertise location of bootable RAM
Subject: kexec: don't invoke OOM-killer for control page allocation
Subject: kexec: ensure user memory sizes do not wrap
Subject: kdump: arrange for paddr_vmcoreinfo_note() to return phys_addr_t
Subject: kexec: allow architectures to override boot mapping
Subject: ARM: keystone: dts: add psci command definition
Subject: ARM: kexec: fix kexec for Keystone 2
Subject: kexec: use core_param for crash_kexec_post_notifiers boot option
Subject: kexec: add a kexec_crash_loaded() function
Subject: kexec: allow kdump with crash_kexec_post_notifiers
Subject: kexec: add restriction on kexec_load() segment sizes
Subject: rapidio: add RapidIO channelized messaging driver
Subject: rapidio: remove unnecessary 0x prefixes before %pa extension uses
Subject: rapidio/documentation: fix mangled paragraph in mport_cdev
Subject: rapidio: fix return value description for dma_prep functions
Subject: rapidio/tsi721_dma: add channel mask and queue size parameters
Subject: rapidio/tsi721: add PCIe MRRS override parameter
Subject: rapidio/tsi721: add messaging mbox selector parameter
Subject: rapidio/tsi721_dma: advance queue processing from transfer submit =
call
Subject: rapidio: fix error handling in mbox request/release functions
Subject: rapidio/idt_gen2: fix locking warning
Subject: rapidio: change inbound window size type to u64
Subject: rapidio: modify for rev.3 specification changes
Subject: powerpc/fsl_rio: apply changes for RIO spec rev 3
Subject: rapidio/switches: add driver for IDT gen3 switches
Subject: w1: remove need for ida and use PLATFORM_DEVID_AUTO
Subject: w1: add helper macro module_w1_family
Subject: w1:omap_hdq: fix regression
Subject: init: allow blacklisting of module_init functions
Subject: relay: add global mode support for buffer-only channels
Subject: init/Kconfig: ban CONFIG_LOCALVERSION_AUTO with allmodconfig
Subject: config: add android config fragments
Subject: init/Kconfig: add clarification for out-of-tree modules
Subject: kcov: allow more fine-grained coverage instrumentation
Subject: ipc: delete "nr_ipc_ns"


--Signature=_Tue__2_Aug_2016_14_01_36_-0700_Nsyknwr1nE=Q52HB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXoQo1AAoJEJxZ78cCqAIHr/8P/0ILYqsMHltrcqXIJDUtOJpT
5BG/X7C89/EyH96sINESmBgeVpQbBJHUITL5fSYx6FS590iy5EwD2A6ur3Mbnhbz
J6SoMPDJF7tHmRxXPD/PUkGEfldqNYFb0s84HUfx6tb2gT2EnzlK5L4UnpQ2ko5h
UPNQF0VDgTwuu5ObPo/01Ef77kmduScqqEguo2d1MWzLwnPoYNBgFYp1ArWRSH0p
18bQISFEIoGqnx2z++w14ZDZO2Tu1NDZ5NJm4wjSqGE5c+FNAq+DerAVRIjscyBB
ghXSWie+cVos2PcH8swcJhxCH9jC7s+xOLsNhlUbW+lzjukngcKJ3OYKaXfRkFHv
xpO7bhHtAUaOY3b3siUqTG3K06Rv5AqMjnQLFX2L9nMv9R6tDJknbgezp5SDQCaB
aonV8O/VLdaLukcjTQBTe1oueJwGecNP/Dc4TFyG7dpK/HIy66RKgQH2DhohKc24
3Je7dKxdy3k3nD1Ym4YA1uaGcAGJbOr+TwQzgom9l+NJlaZQvrtdxu8hT0g3x/zy
cNjke/J1pYLfHJnLNWaokInc8gp23Fp2x20NPbX4MO7Ug/8XQUsR6Cqu1ckU2boP
wxn/0SXcYSKwne+fbiZYZ0EFitG9TCUPPmNBQDnvu0q61Sj7eJ3Pr4piS5xpURlP
V3cNNkgHq7mlO+QM5ogU
=ADlX
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Aug_2016_14_01_36_-0700_Nsyknwr1nE=Q52HB--
