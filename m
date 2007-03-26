From: akpm@linux-foundation.org
Subject: - fdpic-fix-the-proc-pid-stat-representation-of-executable.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:40 -0800
Message-ID: <200703260105.l2Q15epJ008725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38554 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbXCZBFx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FDPIC: fix the /proc/pid/stat representation of executable boundaries
has been removed from the -mm tree.  Its filename was
     fdpic-fix-the-proc-pid-stat-representation-of-executable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FDPIC: fix the /proc/pid/stat representation of executable boundaries
From: David Howells <dhowells@redhat.com>

Fix the /proc/pid/stat representation of executable boundaries.  It should
show the bounds of the executable, but instead shows the bounds of the
loader.

Before the patch is applied, the bug can be seen by examining, say, inetd:

	# ps | grep inetd
	  610         root          0   S   /usr/sbin/inetd -i
	# cat /proc/610/maps
	c0bb0000-c0bba788 r-xs 00000000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3180000-c31dede4 r-xs 00000000 00:0b 14582179  /lib/libuClibc-0.9.28.so
	c328c000-c328ea00 rw-p 00008000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so
	c3290000-c329b6c0 rw-p 00000000 00:00 0
	c32a0000-c32c0000 rwxp 00000000 00:00 0
	c32d4000-c32d8000 rw-p 00000000 00:00 0
	c3394000-c3398000 rw-p 00000000 00:00 0
	c3458000-c345f464 r-xs 00000000 00:0b 16384612  /usr/sbin/inetd
	c3470000-c34748f8 rw-p 00004000 00:0b 16384612  /usr/sbin/inetd
	c34cc000-c34d0000 rw-p 00000000 00:00 0
	c34d4000-c34d8000 rw-p 00000000 00:00 0
	c34d8000-c34dc000 rw-p 00000000 00:00 0
	# cat /proc/610/stat
	610 (inetd) S 1 610 610 0 -1 256 0 0 0 0 0 8 0 0 19 0 1 0 94392000718
	950272 0 4294967295 3233480704 3233523592 3274440352 3274439976
 	3273467584 0 0 4096 90115 3221712796 0 0 17 0 0 0 0

The code boundaries are 3233480704 to 3233523592, which are:

	(gdb) p/x 3233480704
	$1 = 0xc0bb0000
	(gdb) p/x 3233523592
	$2 = 0xc0bba788

Which corresponds to this line in the maps file:

	c0bb0000-c0bba788 r-xs 00000000 00:0b 14582157  /lib/ld-uClibc-0.9.28.so

Which is wrong.  After the patch is applied, the maps file is pretty much
identical (there's some minor shuffling of the location of some of the
anonymous VMAs), but the stat file is now:

	# cat /proc/610/stat
	610 (inetd) S 1 610 610 0 -1 256 0 0 0 0 0 7 0 0 18 0 1 0 94392000722
	950272 0 4294967295 3276111872 3276141668 3274440352 3274439976
	3273467584 0 0 4096 90115 3221712796 0 0 17 0 0 0 0

The code boundaries are then 3276111872 to 3276141668, which are:

	(gdb) p/x 3276111872
	$1 = 0xc3458000
	(gdb) p/x 3276141668
	$2 = 0xc345f464

And these correspond to this line in the maps file instead:

	c3458000-c345f464 r-xs 00000000 00:0b 16384612  /usr/sbin/inetd

Which is now correct.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf_fdpic.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf_fdpic.c~fdpic-fix-the-proc-pid-stat-representation-of-executable fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~fdpic-fix-the-proc-pid-stat-representation-of-executable
+++ a/fs/binfmt_elf_fdpic.c
@@ -179,6 +179,8 @@ static int load_elf_fdpic_binary(struct 
 	int executable_stack;
 	int retval, i;
 
+	kdebug("____ LOAD %d ____", current->pid);
+
 	memset(&exec_params, 0, sizeof(exec_params));
 	memset(&interp_params, 0, sizeof(interp_params));
 
@@ -941,8 +943,11 @@ static int elf_fdpic_map_file_constdisp_
 
 		if (mm) {
 			if (phdr->p_flags & PF_X) {
-				mm->start_code = seg->addr;
-				mm->end_code = seg->addr + phdr->p_memsz;
+				if (!mm->start_code) {
+					mm->start_code = seg->addr;
+					mm->end_code = seg->addr +
+						phdr->p_memsz;
+				}
 			} else if (!mm->start_data) {
 				mm->start_data = seg->addr;
 #ifndef CONFIG_MMU
@@ -1123,8 +1128,10 @@ static int elf_fdpic_map_file_by_direct_
 
 		if (mm) {
 			if (phdr->p_flags & PF_X) {
-				mm->start_code = maddr;
-				mm->end_code = maddr + phdr->p_memsz;
+				if (!mm->start_code) {
+					mm->start_code = maddr;
+					mm->end_code = maddr + phdr->p_memsz;
+				}
 			} else if (!mm->start_data) {
 				mm->start_data = maddr;
 				mm->end_data = maddr + phdr->p_memsz;
_

Patches currently in -mm which might be from dhowells@redhat.com are

nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
nommu-hide-vm_mm-in-nommu-mode.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
mutex-subsystem-synchro-test-module.patch
