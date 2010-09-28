From: akpm@linux-foundation.org
Subject: + namespacepl-fix-source-tree-name-mangling.patch added to -mm tree
Date: Tue, 28 Sep 2010 14:38:20 -0700
Message-ID: <201009282138.o8SLcKgE019334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab0I1ViX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Sep 2010 17:38:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, mmarek@suse.cz


The patch titled
     namespace.pl: fix source tree name mangling
has been added to the -mm tree.  Its filename is
     namespacepl-fix-source-tree-name-mangling.patch

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
Subject: namespace.pl: fix source tree name mangling
From: Stephen Hemminger <shemminger@vyatta.com>

The current namespace.pl script does not find source files correctly.
The problem is that the current directory is not the base of the kernel
tree at the point where it calls objdump.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/namespace.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/namespace.pl~namespacepl-fix-source-tree-name-mangling scripts/namespace.pl
--- a/scripts/namespace.pl~namespacepl-fix-source-tree-name-mangling
+++ a/scripts/namespace.pl
@@ -167,8 +167,10 @@ sub do_nm
 		printf STDERR "$fullname is not an object file\n";
 		return;
 	}
-	($source = $fullname) =~ s/\.o$//;
-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
+	$fullname =~ s/\.o$//;
+	$source = $basename;
+	$source =~ s/\.o$//;
+	if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
 		$source = "$objtree$source";
 	} else {
 		$source = "$srctree$source";
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
namespacepl-fix-source-tree-name-mangling.patch
namespacepl-update-file-exclusion-list.patch

