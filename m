From: akpm@linux-foundation.org
Subject: + ocfs2-remove-some-redundant-casting.patch added to -mm tree
Date: Tue, 13 May 2014 13:13:02 -0700
Message-ID: <53727cce.3y2guKaWcic0kh6W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaEMUNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 16:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, linux@horizon.com

Subject: + ocfs2-remove-some-redundant-casting.patch added to -mm tree
To: linux@horizon.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 13:13:02 -0700


The patch titled
     Subject: ocfs2: remove some redundant casting
has been added to the -mm tree.  Its filename is
     ocfs2-remove-some-redundant-casting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-some-redundant-casting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-some-redundant-casting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "George Spelvin" <linux@horizon.com>
Subject: ocfs2: remove some redundant casting

There are two standard techniques for dereferencing structures pointed
to by void *: cast to the right type each time they're used, or assign
to local variables of the right type.

But there's no need to do *both*.

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-remove-some-redundant-casting fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-remove-some-redundant-casting
+++ a/fs/ocfs2/refcounttree.c
@@ -1408,10 +1408,9 @@ static void swap_refcount_rec(void *a, v
 {
 	struct ocfs2_refcount_rec *l = a, *r = b, tmp;
 
-	tmp = *(struct ocfs2_refcount_rec *)l;
-	*(struct ocfs2_refcount_rec *)l =
-			*(struct ocfs2_refcount_rec *)r;
-	*(struct ocfs2_refcount_rec *)r = tmp;
+	tmp = *l;
+	*l = *r;
+	*r = tmp;
 }
 
 /*
_

Patches currently in -mm which might be from linux@horizon.com are

ocfs2-remove-some-redundant-casting.patch

