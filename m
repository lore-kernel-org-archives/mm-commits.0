From: akpm@linux-foundation.org
Subject: + blk-cgroup-fix-return-code-for-mkdir-calls.patch added to -mm tree
Date: Mon, 23 Aug 2010 13:56:55 -0700
Message-ID: <201008232056.o7NKutN5014259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697Ab0HWU5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 16:57:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ciju@linux.vnet.ibm.com, axboe@kernel.dk, dpshah@google.com, kamezawa.hiroyu@jp.fujitsu.com, stable@kernel.org, vgoyal@redhat.com


The patch titled
     blk-cgroup: fix return code for mkdir calls
has been added to the -mm tree.  Its filename is
     blk-cgroup-fix-return-code-for-mkdir-calls.patch

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
Subject: blk-cgroup: fix return code for mkdir calls
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>

If the cgroup hierarchy for blkio control groups is deeper than two
levels, kernel should not allow the creation of further levels.  mkdir
system call does not except EINVAL as a return value.  This patch replaces
EINVAL with more appropriate EPERM

Signed-off-by: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Divyesh Shah <dpshah@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-cgroup.c~blk-cgroup-fix-return-code-for-mkdir-calls block/blk-cgroup.c
--- a/block/blk-cgroup.c~blk-cgroup-fix-return-code-for-mkdir-calls
+++ a/block/blk-cgroup.c
@@ -966,7 +966,7 @@ blkiocg_create(struct cgroup_subsys *sub
 
 	/* Currently we do not support hierarchy deeper than two level (0,1) */
 	if (parent != cgroup->top_cgroup)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-EPERM);
 
 	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
 	if (!blkcg)
_

Patches currently in -mm which might be from ciju@linux.vnet.ibm.com are

blk-cgroup-fix-return-code-for-mkdir-calls.patch

