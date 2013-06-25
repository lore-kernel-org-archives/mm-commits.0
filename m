From: akpm@linux-foundation.org
Subject: [merged]
 scripts-setlocalversion-on-write-protected-source-tree.patch removed from
 -mm tree
Date: Tue, 25 Jun 2013 12:22:54 -0700
Message-ID: <51c9ee0e.lAn0S49s6W2rs3Cg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3FYTWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 15:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nico-linuxsetlocalversion@schottelius.org, mmarek@suse.cz, lists@nerdbynature.de

Subject: [merged] scripts-setlocalversion-on-write-protected-source-tree.patch removed from -mm tree
To: lists@nerdbynature.de,mmarek@suse.cz,nico-linuxsetlocalversion@schottelius.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 12:22:54 -0700


The patch titled
     Subject: scripts/setlocalversion on write-protected source tree
has been removed from the -mm tree.  Its filename was
     scripts-setlocalversion-on-write-protected-source-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Kujau <lists@nerdbynature.de>
Subject: scripts/setlocalversion on write-protected source tree

I just stumbled across another[0] issue when scripts/setlocalversion
operates on a write-protected source tree.  Back then[0] the source tree
was on an read-only NFS share, so "test -w" was introduced before "git
update-index" was run.

This time, the source tree is on read/write NFS share, but the permissions
are world-readable and only a specific user (or root) can write.  Thus,
"test -w ." returns "0" and then runs "git update-index", producing the
following message (on a dirty tree):

  fatal: Unable to create '/usr/local/src/linux-git/.git/index.lock': Permission denied

While it says "fatal", compilation continues just fine.

However, I don't think a kernel compilation should alter the source tree
(or the .git directory) in any way and I don't see how removing "git
update-index" could do any harm.  The Mercurial and SVN routines in
scripts/setlocalversion don't have any tree-modifying commands, AFAICS. 
So, maybe the patch below would be acceptable.

[0] https://patchwork.kernel.org/patch/29718/

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/setlocalversion |    3 ---
 1 file changed, 3 deletions(-)

diff -puN scripts/setlocalversion~scripts-setlocalversion-on-write-protected-source-tree scripts/setlocalversion
--- a/scripts/setlocalversion~scripts-setlocalversion-on-write-protected-source-tree
+++ a/scripts/setlocalversion
@@ -71,9 +71,6 @@ scm_version()
 			printf -- '-svn%s' "`git svn find-rev $head`"
 		fi
 
-		# Update index only on r/w media
-		[ -w . ] && git update-index --refresh --unmerged > /dev/null
