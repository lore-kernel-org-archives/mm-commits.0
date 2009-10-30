From: akpm@linux-foundation.org
Subject: [merged] maintainers-document-new-k-entry-type.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:49:52 -0700
Message-ID: <200910302049.n9UKnqVB009237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757503AbZJ3UuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: document new "K:" entry type
has been removed from the -mm tree.  Its filename was
     maintainers-document-new-k-entry-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: document new "K:" entry type
From: Joe Perches <joe@perches.com>

K: is for keyword.  Syntax is perl extended regex.

Reorganized header documentation and indent the section entry descriptions
so that the first K: would not be considered a regex to match by
get_maintainer.pl

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-document-new-k-entry-type MAINTAINERS
--- a/MAINTAINERS~maintainers-document-new-k-entry-type
+++ a/MAINTAINERS
@@ -65,43 +65,51 @@ trivial patch so apply some common sense
 
 8.	Happy hacking.
 
-		-----------------------------------
+Descriptions of section entries:
 
-Maintainers List (try to look for most precise areas first)
+	P: Person (obsolete)
+	M: Mail patches to: FullName <address@domain>
+	L: Mailing list that is relevant to this area
+	W: Web-page with status/info
+	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
+	S: Status, one of the following:
+	   Supported:	Someone is actually paid to look after this.
+	   Maintained:	Someone actually looks after it.
+	   Odd Fixes:	It has a maintainer but they don't have time to do
+			much other than throw the odd patch in. See below..
+	   Orphan:	No current maintainer [but maybe you could take the
+			role as you write your new code].
+	   Obsolete:	Old code. Something tagged obsolete generally means
+			it has been replaced by a better system and you
+			should be using that.
+	F: Files and directories with wildcard patterns.
+	   A trailing slash includes all files and subdirectory files.
+	   F:	drivers/net/	all files in and below drivers/net
+	   F:	drivers/net/*	all files in drivers/net, but not below
+	   F:	*/net/*		all files in "any top level directory"/net
+	   One pattern per line.  Multiple F: lines acceptable.
+	X: Files and directories that are NOT maintained, same rules as F:
+	   Files exclusions are tested before file matches.
+	   Can be useful for excluding a specific subdirectory, for instance:
+	   F:	net/
+	   X:	net/ipv6/
+	   matches all files in and below net excluding net/ipv6/
+	K: Keyword perl extended regex pattern to match content in a
+	   patch or file.  For instance:
+	   K: of_get_profile
+	      matches patches or files that contain "of_get_profile"
+	   K: \b(printk|pr_(info|err))\b
+	      matches patches or files that contain one or more of the words
+	      printk, pr_info or pr_err
+	   One regex pattern per line.  Multiple K: lines acceptable.
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
 order. If you could add yourselves to it in alphabetical order that would be
 so much easier [Ed]
 
-P: Person (obsolete)
-M: Mail patches to: FullName <address@domain>
-L: Mailing list that is relevant to this area
-W: Web-page with status/info
-T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
-S: Status, one of the following:
-
-	Supported:	Someone is actually paid to look after this.
-	Maintained:	Someone actually looks after it.
-	Odd Fixes:	It has a maintainer but they don't have time to do
-			much other than throw the odd patch in. See below..
-	Orphan:		No current maintainer [but maybe you could take the
-			role as you write your new code].
-	Obsolete:	Old code. Something tagged obsolete generally means
-			it has been replaced by a better system and you
-			should be using that.
+Maintainers List (try to look for most precise areas first)
 
-F: Files and directories with wildcard patterns.
-   A trailing slash includes all files and subdirectory files.
-	F:	drivers/net/	all files in and below drivers/net
-	F:	drivers/net/*	all files in drivers/net, but not below
-	F:	*/net/*		all files in "any top level directory"/net
-   One pattern per line.  Multiple F: lines acceptable.
-X: Files and directories that are NOT maintained, same rules as F:
-   Files exclusions are tested before file matches.
-   Can be useful for excluding a specific subdirectory, for instance:
-	F:	net/
-	X:	net/ipv6/
-   matches all files in and below net excluding net/ipv6/
+		-----------------------------------
 
 3C505 NETWORK DRIVER
 M:	Philip Blundell <philb@gnu.org>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-asus-acpi-extras-remove-f-arch-x86-kernel-acpi-bootc.patch
maintainers-brocade-bfa-use-single-line-m-and-tabs.patch
maintainers-server-engines-10gbps-iscsi-use-single-line-m.patch
maintainers-vmware-vmxnet3-quote-name-with-comma-and-period-use-tabs.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch

