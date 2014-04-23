From: akpm@linux-foundation.org
Subject: + autofs-fix-lockref-lookup.patch added to -mm tree
Date: Wed, 23 Apr 2014 14:46:46 -0700
Message-ID: <535834c6.WIFVamdQFXe7b8qZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaDWVqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Apr 2014 17:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, raven@themaw.net

Subject: + autofs-fix-lockref-lookup.patch added to -mm tree
To: raven@themaw.net,torvalds@linux-foundation.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 23 Apr 2014 14:46:46 -0700


The patch titled
     Subject: autofs: fix lockref lookup
has been added to the -mm tree.  Its filename is
     autofs-fix-lockref-lookup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-lockref-lookup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-lockref-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: fix lockref lookup

autofs needs to be able to see private data dentry flags for its dentrys
that are being created but not yet hashed and for its dentrys that have
been rmdir()ed but not yet freed.  It needs to do this so it can block
processes in these states until a status has been returned to indicate the
given operation is complete.

It does this by keeping two lists, active and expring, of dentrys in this
state and uses ->d_release() to keep them stable while it checks the
reference count to determine if they should be used.

But with the recent lockref changes dentrys being freed sometimes don't
transition to a reference count of 0 before being freed so autofs can
occassionally use a dentry that is invalid which can lead to a panic.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/autofs4/root.c~autofs-fix-lockref-lookup fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs-fix-lockref-lookup
+++ a/fs/autofs4/root.c
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_act
 		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (!d_count(active))
+		if ((int) d_count(active) <= 0)
 			goto next;
 
 		qstr = &active->d_name;
@@ -230,7 +230,7 @@ static struct dentry *autofs4_lookup_exp
 
 		spin_lock(&expiring->d_lock);
 
-		/* Bad luck, we've already been dentry_iput */
+		/* We've already been dentry_iput or unlinked */
 		if (!expiring->d_inode)
 			goto next;
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-fix-lockref-lookup.patch

