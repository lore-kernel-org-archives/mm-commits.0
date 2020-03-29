From: akpm@linux-foundation.org
Subject: +
 maintainers-list-the-section-entries-in-the-preferred-order.patch added to
 -mm tree
Date: Sat, 28 Mar 2020 17:56:38 -0700
Message-ID: <20200329005638.e8iUJH8c4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgC2A4k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 20:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy.shevchenko@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: list the section entries in the preferred order
has been added to the -mm tree.  Its filename is
     maintainers-list-the-section-entries-in-the-preferred-order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-list-the-section-entries-in-the-preferred-order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-list-the-section-entries-in-the-preferred-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: list the section entries in the preferred order

The MAINTAINERS file header has never shown a preferred order for the
section entries but scripts/parse-maintainers.pl added a preferred order
with commit 61f741645a35 ("parse-maintainers: Add section pattern
sorting")

Commit 5cdbec108fd2 ("parse-maintainers: Do not sort section content by
default") changed the preferred order to be a bit more sensible.

Update the MAINTAINERS section description block to use this preferred
section entry ordering.

Add a slightly better description for the N: entry too.

Link: http://lkml.kernel.org/r/5aa5aad6fb1678230c260337dc066cd449a2bf32.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- a/MAINTAINERS~maintainers-list-the-section-entries-in-the-preferred-order
+++ a/MAINTAINERS
@@ -77,21 +77,13 @@ Tips for patch submitters
 
 8.	Happy hacking.
 
-Descriptions of section entries
--------------------------------
+Descriptions of section entries and preferred order
+---------------------------------------------------
 
 	M: *Mail* patches to: FullName <address@domain>
 	R: Designated *Reviewer*: FullName <address@domain>
 	   These reviewers should be CCed on patches.
 	L: *Mailing list* that is relevant to this area
-	W: *Web-page* with status/info
-	B: URI for where to file *bugs*. A web-page with detailed bug
-	   filing info, a direct bug tracker link, or a mailto: URI.
-	C: URI for *chat* protocol, server and channel where developers
-	   usually hang out, for example irc://server/channel.
-	Q: *Patchwork* web based patch tracking system site
-	T: *SCM* tree type and location.
-	   Type is one of: git, hg, quilt, stgit, topgit
 	S: *Status*, one of the following:
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
@@ -102,30 +94,39 @@ Descriptions of section entries
 	   Obsolete:	Old code. Something tagged obsolete generally means
 			it has been replaced by a better system and you
 			should be using that.
+	W: *Web-page* with status/info
+	Q: *Patchwork* web based patch tracking system site
+	B: URI for where to file *bugs*. A web-page with detailed bug
+	   filing info, a direct bug tracker link, or a mailto: URI.
+	C: URI for *chat* protocol, server and channel where developers
+	   usually hang out, for example irc://server/channel.
 	P: Subsystem Profile document for more details submitting
 	   patches to the given subsystem. This is either an in-tree file,
 	   or a URI. See Documentation/maintainer/maintainer-entry-profile.rst
 	   for details.
+	T: *SCM* tree type and location.
+	   Type is one of: git, hg, quilt, stgit, topgit
 	F: *Files* and directories wildcard patterns.
 	   A trailing slash includes all files and subdirectory files.
 	   F:	drivers/net/	all files in and below drivers/net
 	   F:	drivers/net/*	all files in drivers/net, but not below
 	   F:	*/net/*		all files in "any top level directory"/net
 	   One pattern per line.  Multiple F: lines acceptable.
+	X: *Excluded* files and directories that are NOT maintained, same
+	   rules as F:. Files exclusions are tested before file matches.
+	   Can be useful for excluding a specific subdirectory, for instance:
+	   F:	net/
+	   X:	net/ipv6/
+	   matches all files in and below net excluding net/ipv6/
 	N: Files and directories *Regex* patterns.
-	   N:	[^a-z]tegra	all files whose path contains the word tegra
+	   N:	[^a-z]tegra	all files whose path contains tegra
+	                        (not including files like integrator)
 	   One pattern per line.  Multiple N: lines acceptable.
 	   scripts/get_maintainer.pl has different behavior for files that
 	   match F: pattern and matches of N: patterns.  By default,
 	   get_maintainer will not look at git log history when an F: pattern
 	   match occurs.  When an N: match occurs, git log history is used
 	   to also notify the people that have git commit signatures.
-	X: *Excluded* files and directories that are NOT maintained, same
-	   rules as F:. Files exclusions are tested before file matches.
-	   Can be useful for excluding a specific subdirectory, for instance:
-	   F:	net/
-	   X:	net/ipv6/
-	   matches all files in and below net excluding net/ipv6/
 	K: *Content regex* (perl extended) pattern match in a patch or file.
 	   For instance:
 	   K: of_get_profile
_

Patches currently in -mm which might be from joe@perches.com are

mm-use-fallthrough.patch
maintainers-list-the-section-entries-in-the-preferred-order.patch
checkpatch-remove-email-address-comment-from-email-address-comparisons.patch
checkpatch-prefer-fallthrough-over-fallthrough-comments.patch
checkpatch-improve-gerrit-change-id-test.patch
checkpatch-avoid-warning-about-uninitialized_var.patch
