From: akpm@linux-foundation.org
Subject: + setlocalversion-use-git-svn-instead-of-git-svn.patch added to -mm tree
Date: Tue, 07 Apr 2009 14:02:35 -0700
Message-ID: <200904072102.n37L2Ze8027231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbZDGVFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 17:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacmet@sunsite.dk, sam@ravnborg.org


The patch titled
     setlocalversion: use git svn instead of git-svn
has been added to the -mm tree.  Its filename is
     setlocalversion-use-git-svn-instead-of-git-svn.patch

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
Subject: setlocalversion: use git svn instead of git-svn
From: Peter Korsgaard <jacmet@sunsite.dk>

Use the correct git <subcmd> syntax instead of the deprecated git-<subcmd>.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/setlocalversion |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/setlocalversion~setlocalversion-use-git-svn-instead-of-git-svn scripts/setlocalversion
--- a/scripts/setlocalversion~setlocalversion-use-git-svn-instead-of-git-svn
+++ a/scripts/setlocalversion
@@ -21,7 +21,7 @@ if head=`git rev-parse --verify --short 
 
 	# Is this git on svn?
 	if git config --get svn-remote.svn.url >/dev/null; then
-	        printf -- '-svn%s' "`git-svn find-rev $head`"
+	        printf -- '-svn%s' "`git svn find-rev $head`"
 	fi
 
 	# Are there uncommitted changes?
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

origin.patch
linux-next.patch
setlocalversion-use-git-svn-instead-of-git-svn.patch

