From: akpm@linux-foundation.org
Subject: + frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:28:17 -0700
Message-ID: <200710302028.l9UKSHqQ026618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbXJ3U3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: Permit the memory to be located elsewhere in NOMMU mode
has been added to the -mm tree.  Its filename is
     frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: Permit the memory to be located elsewhere in NOMMU mode
From: David Howells <dhowells@redhat.com>

Permit the memory to be located somewhere other than address 0xC0000000 in
NOMMU mode.  The configuration options are already present, it just
requires wiring up in the linker script.

Note that only a limited set of locations of runtime addresses are available
because of the way the CPU protection registers work.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/Kconfig              |    9 +++++++++
 arch/frv/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN arch/frv/Kconfig~frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode arch/frv/Kconfig
--- a/arch/frv/Kconfig~frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode
+++ a/arch/frv/Kconfig
@@ -138,6 +138,15 @@ config UCPAGE_OFFSET_C0000000
 
 endchoice
 
+config PAGE_OFFSET
+	hex
+	default 0x20000000 if UCPAGE_OFFSET_20000000
+	default 0x40000000 if UCPAGE_OFFSET_40000000
+	default 0x60000000 if UCPAGE_OFFSET_60000000
+	default 0x80000000 if UCPAGE_OFFSET_80000000
+	default 0xA0000000 if UCPAGE_OFFSET_A0000000
+	default 0xC0000000
+
 config PROTECT_KERNEL
 	bool "Protect core kernel against userspace"
 	depends on !MMU
diff -puN arch/frv/kernel/vmlinux.lds.S~frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode arch/frv/kernel/vmlinux.lds.S
--- a/arch/frv/kernel/vmlinux.lds.S~frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode
+++ a/arch/frv/kernel/vmlinux.lds.S
@@ -13,7 +13,7 @@ ENTRY(_start)
 
 jiffies = jiffies_64 + 4;
 
-__page_offset = 0xc0000000;		/* start of area covered by struct pages */
+__page_offset = CONFIG_PAGE_OFFSET;	/* start of area covered by struct pages */
 __kernel_image_start = __page_offset;	/* address at which kernel image resides */
 
 SECTIONS
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
suppress-aout-library-support-in-elf-binfmt-if-config_binfmt_aout.patch
mn10300-suppress-aout-library-support-in-elf-binfmt-if-fix.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
