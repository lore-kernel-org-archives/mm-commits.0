From: akpm@linux-foundation.org
Subject: + documentation-how-to-use-doc-section-blocks.patch added to -mm tree
Date: Thu, 18 Dec 2008 15:53:19 -0800
Message-ID: <200812182353.mBINrJf4002706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbYLRXyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 18:54:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, johannes@sipsolutions.net


The patch titled
     documentation: how to use DOC: section blocks
has been added to the -mm tree.  Its filename is
     documentation-how-to-use-doc-section-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: how to use DOC: section blocks
From: Randy Dunlap <randy.dunlap@oracle.com>

Add info on how to use DOC: sections in kernel-doc.  DOC: sections enable
the addition of inline source file comments that are general in nature
instead of being specific to a function, struct, union, enum, or typedef.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |   29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~documentation-how-to-use-doc-section-blocks Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~documentation-how-to-use-doc-section-blocks
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -287,6 +287,32 @@ struct my_struct {
 };
 
 
+Including documentation blocks in source files
+----------------------------------------------
+
+To facilitate having source code and comments close together, you can
+include kernel-doc documentation blocks that are free-form comments
+instead of being kernel-doc for functions, structures, unions,
+enums, or typedefs.  This could be used for something like a
+theory of operation for a driver or library code, for example.
+
+This is done by using a DOC: section keyword with a section title.  E.g.:
+
+/**
+ * DOC: Theory of Operation
+ *
+ * The whizbang foobar is a dilly of a gizmo.  It can do whatever you
+ * want it to do, at any time.  It reads your mind.  Here's how it works.
+ *
+ * foo bar splat
+ *
+ * The only drawback to this gizmo is that is can sometimes damage
+ * hardware, software, or its subject(s).
+ */
+
+DOC: sections are used in SGML templates files as indicated below.
+
+
 How to make new SGML template files
 -----------------------------------
 
@@ -307,6 +333,9 @@ exported using EXPORT_SYMBOL.
 !F<filename> <function [functions...]> is replaced by the
 documentation, in <filename>, for the functions listed.
 
+!P<filename> <section title> is replaced by the contents of the DOC:
+section titled <section title> from <filename>.
+Spaces are allowed in <section title>; do not quote the <section title>.
 
 Tim.
 */ <twaugh@redhat.com>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
mtd-fix-dataflash-printk-formats.patch
mtd-fix-m25p80-printk-formats.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
documentation-when-to-bug-and-when-to-not-bug.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
documentation-how-to-use-doc-section-blocks.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch

