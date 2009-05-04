From: akpm@linux-foundation.org
Subject: [merged] kernel-doc-restrict-syntax-for-private-and-public.patch removed from -mm tree
Date: Mon, 04 May 2009 13:13:32 -0700
Message-ID: <200905042013.n44KDW2G022612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbZEDUPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:15:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: restrict syntax for private: and public:
has been removed from the -mm tree.  Its filename was
     kernel-doc-restrict-syntax-for-private-and-public.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-doc: restrict syntax for private: and public:
From: Randy Dunlap <randy.dunlap@oracle.com>

scripts/kernel-doc can (incorrectly) delete struct members that are
surrounded by /* ...  */ <struct members> /* ...  */ if there is a /*
private: */ comment in there somewhere also.

Fix that by making the "/* private:" only allow whitespace between /* and
"private:", not anything/everything in the world.

This fixes some erroneous kernel-doc warnings that popped up while
processing include/linux/usb/composite.h.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |    7 +++++--
 scripts/kernel-doc                      |    7 ++++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~kernel-doc-restrict-syntax-for-private-and-public Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~kernel-doc-restrict-syntax-for-private-and-public
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -269,7 +269,10 @@ Use the argument mechanism to document m
 
 Inside a struct description, you can use the "private:" and "public:"
 comment tags.  Structure fields that are inside a "private:" area
-are not listed in the generated output documentation.
+are not listed in the generated output documentation.  The "private:"
+and "public:" tags must begin immediately following a "/*" comment
+marker.  They may optionally include comments between the ":" and the
+ending "*/" marker.
 
 Example:
 
@@ -283,7 +286,7 @@ Example:
 struct my_struct {
     int a;
     int b;
-/* private: */
+/* private: internal use only */
     int c;
 };
 
diff -puN scripts/kernel-doc~kernel-doc-restrict-syntax-for-private-and-public scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-restrict-syntax-for-private-and-public
+++ a/scripts/kernel-doc
@@ -1411,7 +1411,8 @@ sub dump_struct($$) {
     my $file = shift;
     my $nested;
 
-    if ($x =~/(struct|union)\s+(\w+)\s*{(.*)}/) {
+    if ($x =~ /(struct|union)\s+(\w+)\s*{(.*)}/) {
+	#my $decl_type = $1;
 	$declaration_name = $2;
 	my $members = $3;
 
@@ -1420,8 +1421,8 @@ sub dump_struct($$) {
 	$nested = $1;
 
 	# ignore members marked private:
-	$members =~ s/\/\*.*?private:.*?public:.*?\*\///gos;
-	$members =~ s/\/\*.*?private:.*//gos;
+	$members =~ s/\/\*\s*private:.*?\/\*\s*public:.*?\*\///gos;
+	$members =~ s/\/\*\s*private:.*//gos;
 	# strip comments:
 	$members =~ s/\/\*.*?\*\///gos;
 	$nested =~ s/\/\*.*?\*\///gos;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
nfsd-use-c99-struct-initializers.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
lockd-fix-file_locking=n-build-error.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

