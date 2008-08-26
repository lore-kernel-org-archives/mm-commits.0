From: akpm@linux-foundation.org
Subject: + setlocalversion-dont-include-svn-change-count.patch added to -mm tree
Date: Tue, 26 Aug 2008 14:11:05 -0700
Message-ID: <200808262111.m7QLB5qi027860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbYHZVLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 17:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, sam@ravnborg.org


The patch titled
     setlocalversion: dont include svn change count
has been added to the -mm tree.  Its filename is
     setlocalversion-dont-include-svn-change-count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: setlocalversion: dont include svn change count
From: Mike Frysinger <vapier@gentoo.org>

The number of pending changes is pretty useless, so encoding it into the
version is just annoying by the constant shuffle in corresponding modules.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/setlocalversion |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/setlocalversion~setlocalversion-dont-include-svn-change-count scripts/setlocalversion
--- a/scripts/setlocalversion~setlocalversion-dont-include-svn-change-count
+++ a/scripts/setlocalversion
@@ -55,7 +55,7 @@ if rev=`svn info 2>/dev/null | grep '^Re
 
 	# Are there uncommitted changes?
 	if [ $changes != 0 ]; then
-		printf -- '-svn%s%s%s' "$rev" -dirty "$changes"
+		printf -- '-svn%s%s%s' "$rev" -dirty
 	else
 		printf -- '-svn%s' "$rev"
 	fi
_

Patches currently in -mm which might be from vapier@gentoo.org are

blackfin-fix-update-gitignore-files.patch
setlocalversion-dont-include-svn-change-count.patch

