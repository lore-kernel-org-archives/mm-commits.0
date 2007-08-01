From: akpm@linux-foundation.org
Subject: + scripts-ver_linux-correct-printing-of-binutils-version.patch added to -mm tree
Date: Wed, 01 Aug 2007 16:54:48 -0700
Message-ID: <200708012354.l71NsmFC023800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbXHAXy4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 19:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     scripts/ver_linux: correct printing of binutils version
has been added to the -mm tree.  Its filename is
     scripts-ver_linux-correct-printing-of-binutils-version.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scripts/ver_linux: correct printing of binutils version
From: Jesper Juhl <jesper.juhl@gmail.com>

Currently scripts/ver_linux prints "Binutils" or other random information
for the version number in the "binutils" output line on some distributions.
This patch corrects that.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/ver_linux |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN scripts/ver_linux~scripts-ver_linux-correct-printing-of-binutils-version scripts/ver_linux
--- a/scripts/ver_linux~scripts-ver_linux-correct-printing-of-binutils-version
+++ a/scripts/ver_linux
@@ -21,9 +21,7 @@ gcc --version 2>&1| grep gcc | awk \
 make --version 2>&1 | awk -F, '{print $1}' | awk \
       '/GNU Make/{print "Gnu make              ",$NF}'
 
-ld -v | awk -F\) '{print $1}' | awk \
-'/BFD/{print "binutils              ",$NF} \
-/^GNU/{print "binutils              ",$4}'
+echo "binutils               $(ld -v | egrep -o '[0-9]+\.[0-9\.]+')"
 
 echo -n "util-linux             "
 fdformat --version | awk '{print $NF}' | sed -e s/^util-linux-// -e s/\)$//
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hid.patch
git-ia64.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
mips-remove-some-duplicate-includes.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
