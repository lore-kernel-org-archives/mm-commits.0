From: akpm@linux-foundation.org
Subject: + kbuild-move-non-__kernel__-checking-headers-to-header-y.patch added to -mm tree
Date: Tue, 20 May 2008 00:10:08 -0700
Message-ID: <200805200710.m4K7A83w010360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756243AbYETHKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 03:10:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     kbuild: move non-__KERNEL__-checking headers to header-y
has been added to the -mm tree.  Its filename is
     kbuild-move-non-__kernel__-checking-headers-to-header-y.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: move non-__KERNEL__-checking headers to header-y
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Move exported header files under include/linux that don't check the
__KERNEL__ preprocessor from unifdef-y to header-y.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN include/linux/Kbuild~kbuild-move-non-__kernel__-checking-headers-to-header-y include/linux/Kbuild
--- a/include/linux/Kbuild~kbuild-move-non-__kernel__-checking-headers-to-header-y
+++ a/include/linux/Kbuild
@@ -104,6 +104,7 @@ header-y += iso_fs.h
 header-y += ixjuser.h
 header-y += jffs2.h
 header-y += keyctl.h
+header-y += kvm.h
 header-y += limits.h
 header-y += dlm_plock.h
 header-y += magic.h
@@ -157,11 +158,18 @@ header-y += toshiba.h
 header-y += udf_fs_i.h
 header-y += ultrasound.h
 header-y += un.h
+header-y += unistd.h
 header-y += utime.h
 header-y += veth.h
 header-y += video_decoder.h
 header-y += video_encoder.h
 header-y += videotext.h
+header-y += virtio_blk.h
+header-y += virtio_net.h
+header-y += virtio_9p.h
+header-y += virtio_balloon.h
+header-y += virtio_pci.h
+header-y += wireless.h
 header-y += x25.h
 
 unifdef-y += acct.h
@@ -254,7 +262,6 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-unifdef-y += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
@@ -339,24 +346,17 @@ unifdef-y += types.h
 unifdef-y += udp.h
 unifdef-y += uinput.h
 unifdef-y += uio.h
-unifdef-y += unistd.h
 unifdef-y += usbdevice_fs.h
 unifdef-y += utsname.h
 unifdef-y += videodev2.h
 unifdef-y += videodev.h
 unifdef-y += virtio_config.h
-unifdef-y += virtio_blk.h
-unifdef-y += virtio_net.h
-unifdef-y += virtio_9p.h
-unifdef-y += virtio_balloon.h
 unifdef-y += virtio_console.h
-unifdef-y += virtio_pci.h
 unifdef-y += virtio_ring.h
 unifdef-y += vt.h
 unifdef-y += wait.h
 unifdef-y += wanrouter.h
 unifdef-y += watchdog.h
-unifdef-y += wireless.h
 unifdef-y += xattr.h
 unifdef-y += xfrm.h
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
kbuild-remove-final-references-to-deprecated-unreferenced-topdir.patch
kbuild-move-non-__kernel__-checking-headers-to-header-y.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch
spi-kconfig-simplifications.patch

