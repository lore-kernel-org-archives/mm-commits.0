From: akpm@linux-foundation.org
Subject: - setlocalversion-dont-include-svn-change-count.patch removed from -mm tree
Date: Thu, 02 Oct 2008 16:57:34 -0700
Message-ID: <200810022357.m92NvYrx001049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755487AbYJBX5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 19:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     setlocalversion: dont include svn change count
has been removed from the -mm tree.  Its filename was
     setlocalversion-dont-include-svn-change-count.patch

This patch was dropped because an updated version will be merged

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

setlocalversion-dont-include-svn-change-count.patch

