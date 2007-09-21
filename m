From: akpm@linux-foundation.org
Subject: + aio-dont-confuse-debug-define-location.patch added to -mm tree
Date: Fri, 21 Sep 2007 12:27:59 -0700
Message-ID: <200709211927.l8LJRxrD018845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbXIUT2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 15:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, zach.brown@oracle.com


The patch titled
     aio: don't confuse DEBUG define location
has been added to the -mm tree.  Its filename is
     aio-dont-confuse-debug-define-location.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aio: don't confuse DEBUG define location
From: Randy Dunlap <randy.dunlap@oracle.com>

I was debugging (via pr_debug()) why one test app was getting EINVAL
returns from aio.  However, using DEBUG to enable pr_debug() needs to be
done before #include linux/kernel.h, so remove it from below there so that
someone doesn't have to debug pr_debug().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/aio.c~aio-dont-confuse-debug-define-location fs/aio.c
--- a/fs/aio.c~aio-dont-confuse-debug-define-location
+++ a/fs/aio.c
@@ -8,6 +8,7 @@
  *
  *	See ../COPYING for licensing terms.
  */
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -17,8 +18,6 @@
 #include <linux/syscalls.h>
 #include <linux/uio.h>
 
-#define DEBUG 0
-
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/file.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
sound-hda-fix-help-text.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
fix-signedness-of-parameters-in-scsi-module.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
kgdb-fix-help-text.patch
kgdb-fix-docbook-and-kernel-doc-typos.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
aio-dont-confuse-debug-define-location.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
profile-likely-unlikely-macros.patch
