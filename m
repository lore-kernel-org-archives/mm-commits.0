From: akpm@linux-foundation.org
Subject: + kernel-doc-restrict-syntax-for-private-and-public.patch added to -mm tree
Date: Tue, 28 Apr 2009 15:23:36 -0700
Message-ID: <200904282223.n3SMNblV016955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbZD1WZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 18:25:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: restrict syntax for private: and public:
has been added to the -mm tree.  Its filename is
     kernel-doc-restrict-syntax-for-private-and-public.patch

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
ecryptfs-fix-printk-format-warning.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
kernel-doc-restrict-syntax-for-private-and-public.patch
lockd-fix-file_locking=n-build-error.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

