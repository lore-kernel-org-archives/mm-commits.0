From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-some-redundant-casting.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:42:42 -0700
Message-ID: <5390c832.nyxb0SucPWk7oCFM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaFETmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, linux@horizon.com

Subject: [merged] ocfs2-remove-some-redundant-casting.patch removed from -mm tree
To: linux@horizon.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:42 -0700


The patch titled
     Subject: ocfs2: remove some redundant casting
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-some-redundant-casting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "George Spelvin" <linux@horizon.com>
Subject: ocfs2: remove some redundant casting

There are two standard techniques for dereferencing structures pointed
to by void *: cast to the right type each time they're used, or assign
to local variables of the right type.

But there's no need to do *both*.

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
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

origin.patch
linux-next.patch

