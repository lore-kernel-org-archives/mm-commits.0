From: akpm@linux-foundation.org
Subject: + scripts-setlocalversion-on-write-protected-source-tree.patch
 added to -mm tree
Date: Tue, 18 Jun 2013 14:10:30 -0700
Message-ID: <51c0ccc6.J0sK68fTvBV7g7Di%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab3FRVKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jun 2013 17:10:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nico-linuxsetlocalversion@schottelius.org, mmarek@suse.cz, lists@nerdbynature.de

Subject: + scripts-setlocalversion-on-write-protected-source-tree.patch added to -mm tree
To: lists@nerdbynature.de,mmarek@suse.cz,nico-linuxsetlocalversion@schottelius.org
From: akpm@linux-foundation.org
Date: Tue, 18 Jun 2013 14:10:30 -0700


The patch titled
     Subject: scripts/setlocalversion on write-protected source tree
has been added to the -mm tree.  Its filename is
     scripts-setlocalversion-on-write-protected-source-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
