From: akpm@linux-foundation.org
Subject: + maintainers-document-new-k-entry-type.patch added to -mm tree
Date: Mon, 12 Oct 2009 16:17:31 -0700
Message-ID: <200910122317.n9CNHVj1013013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757490AbZJLXSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 19:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: document new "K:" entry type
has been added to the -mm tree.  Its filename is
     maintainers-document-new-k-entry-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: MAINTAINERS: document new "K:" entry type
=46rom: Joe Perches <joe@perches.com>

K: is for keyword.  Syntax is perl extended regex.

Reorganized header documentation and indent the section entry descripti=
ons
so that the first K: would not be considered a regex to match by
get_maintainer.pl

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-document-new-k-entry-type MAINTAINERS
--- a/MAINTAINERS~maintainers-document-new-k-entry-type
+++ a/MAINTAINERS
@@ -65,43 +65,51 @@ trivial patch so apply some common sense
=20
 8.	Happy hacking.
=20
-		-----------------------------------
+Descriptions of section entries:
=20
-Maintainers List (try to look for most precise areas first)
+	P: Person (obsolete)
+	M: Mail patches to: FullName <address@domain>
+	L: Mailing list that is relevant to this area
+	W: Web-page with status/info
+	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit=
=2E
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
=20
 Note: For the hard of thinking, this list is meant to remain in alphab=
etical
 order. If you could add yourselves to it in alphabetical order that wo=
uld be
 so much easier [Ed]
=20
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
=20
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
=20
 3C505 NETWORK DRIVER
 M:	Philip Blundell <philb@gnu.org>
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-generic-uio-for-pci-devices.patch
maintainers-update-tracing-section.patch
maintainers-update-omap-tony-lindgren-email-name.patch
maintainers-change-atm-mailing-list-to-moderated.patch
maintainers-use-tab-not-spaces-after-field-types.patch
maintainers-update-kernel-janitors-after-mismerge.patch
maintainers-update-score-architecture-name-style-and-add-file-pattern.p=
atch
maintainers-simple-firmware-interface-update-email-style.patch
maintainers-winbond-cir-integrate-p-m-lines-fixup-david-h=E4rdemans-nam=
e.patch
maintainers-fix-up-peripheral-spelling.patch
maintainers-update-wolfson-microelectronics.patch
scripts-get_maintainerpl-add-patch-file-search-for-keywords.patch
maintainers-document-new-k-entry-type.patch
maintainers-add-open-firmware-flattened-device-tree-entry.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patc=
h
isicomc-use-pr_fmt-and-pr_level.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
