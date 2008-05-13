From: akpm@linux-foundation.org
Subject: - mn10300-replace-deprecated-topdir-with-newer-srctree.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:36 -0700
Message-ID: <200805132133.m4DLXaKi000839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759617AbYEMVe2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dhowells@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     mn10300: replace deprecated "TOPDIR" with newer "srctree"
has been removed from the -mm tree.  Its filename was
     mn10300-replace-deprecated-topdir-with-newer-srctree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: replace deprecated "TOPDIR" with newer "srctree"
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

This would appear to be the last reference to TOPDIR in the entire tree, after
which i'm guessing that variable can be dropped.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/boot/install.sh |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN arch/mn10300/boot/install.sh~mn10300-replace-deprecated-topdir-with-newer-srctree arch/mn10300/boot/install.sh
--- a/arch/mn10300/boot/install.sh~mn10300-replace-deprecated-topdir-with-newer-srctree
+++ a/arch/mn10300/boot/install.sh
@@ -26,42 +26,42 @@ rm -fr $4/../usr/include/linux $4/../usr
 install -c -m 0755 $2 $4/vmlinuz
 install -c -m 0755 $5 $4/boot.rom
 install -c -m 0755 -d $4/../usr/include/linux
-cd $TOPDIR/include/linux
+cd ${srctree}/include/linux
 for i in `find . -maxdepth 1 -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/linux
 done
 install -c -m 0755 -d $4/../usr/include/linux/byteorder
-cd $TOPDIR/include/linux/byteorder
+cd ${srctree}/include/linux/byteorder
 for i in `find . -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/linux/byteorder
 done
 install -c -m 0755 -d $4/../usr/include/linux/lockd
-cd $TOPDIR/include/linux/lockd
+cd ${srctree}/include/linux/lockd
 for i in `find . -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/linux/lockd
 done
 install -c -m 0755 -d $4/../usr/include/linux/netfilter_ipv4
-cd $TOPDIR/include/linux/netfilter_ipv4
+cd ${srctree}/include/linux/netfilter_ipv4
 for i in `find . -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/linux/netfilter_ipv4
 done
 install -c -m 0755 -d $4/../usr/include/linux/nfsd
-cd $TOPDIR/include/linux/nfsd
+cd ${srctree}/include/linux/nfsd
 for i in `find . -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/linux/nfsd/$i
 done
 install -c -m 0755 -d $4/../usr/include/linux/raid
-cd $TOPDIR/include/linux/raid
+cd ${srctree}/include/linux/raid
 for i in `find . -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/linux/raid
 done
 install -c -m 0755 -d $4/../usr/include/linux/sunrpc
-cd $TOPDIR/include/linux/sunrpc
+cd ${srctree}/include/linux/sunrpc
 for i in `find . -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/linux/sunrpc
 done
 install -c -m 0755 -d $4/../usr/include/asm
-cd $TOPDIR/include/asm
+cd ${srctree}/include/asm
 for i in `find . -name '*.h' -print`; do
   install -c -m 0644 $i $4/../usr/include/asm
 done
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch
macintosh-replace-deprecated-__initcall-with-device_initcall.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-apparently-unused-fd1772h-header-file.patch
init-delete-hard-coded-setting-and-testing-of-build_cramdisk.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
lists-remove-a-redundant-conditional-definition-of-list_add.patch
zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch
spi-kconfig-simplifications.patch

