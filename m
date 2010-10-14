From: akpm@linux-foundation.org
Subject: + scripts-namespacepl-fix-wrong-source-path.patch added to -mm tree
Date: Thu, 14 Oct 2010 15:56:30 -0700
Message-ID: <201010142256.o9EMuUWf024296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061Ab0JNW5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 18:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, mmarek@suse.cz, shemminger@vyatta.com


The patch titled
     scripts/namespace.pl: fix wrong source path
has been added to the -mm tree.  Its filename is
     scripts-namespacepl-fix-wrong-source-path.patch

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
Subject: scripts/namespace.pl: fix wrong source path
From: Amerigo Wang <amwang@redhat.com>

File::Find will do chdir automatically, so we need to get the absolute
patch with $File::Find::dir.

Reported-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Amerigo Wang <amwang@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/namespace.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/namespace.pl~scripts-namespacepl-fix-wrong-source-path scripts/namespace.pl
--- a/scripts/namespace.pl~scripts-namespacepl-fix-wrong-source-path
+++ a/scripts/namespace.pl
@@ -167,11 +167,11 @@ sub do_nm
 		printf STDERR "$fullname is not an object file\n";
 		return;
 	}
-	($source = $fullname) =~ s/\.o$//;
-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
-		$source = "$objtree$source";
+	($source = $basename) =~ s/\.o$//;
+	if (-e "$source.c" || -e "$source.S") {
+		$source = "$objtree$File::Find::dir/$source";
 	} else {
-		$source = "$srctree$source";
+		$source = "$srctree$File::Find::dir/$source";
 	}
 	if (! -e "$source.c" && ! -e "$source.S") {
 		# No obvious source, exclude the object if it is conglomerate
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
scripts-namespacepl-fix-wrong-source-path.patch
scripts-namespacepl-update-file-exclusion-list.patch
scripts-namespacepl-some-bug-fixes.patch
scripts-namespacepl-improve-to-get-more-correct-results.patch
scripts-namespacepl-add-source-file-location-exceptions.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch

