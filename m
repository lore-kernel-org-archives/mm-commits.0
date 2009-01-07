From: akpm@linux-foundation.org
Subject: - documentation-how-to-use-doc-section-blocks.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:15 -0800
Message-ID: <200901072220.n07MKFVw019514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762072AbZAGWVv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:21:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, johannes@sipsolutions.net, mm-commits@vger.kernel.org


The patch titled
     documentation: how to use DOC: section blocks
has been removed from the -mm tree.  Its filename was
     documentation-how-to-use-doc-section-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

