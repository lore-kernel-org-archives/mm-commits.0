From: akpm@linux-foundation.org
Subject: + lib-scatterlist-error-handling-in-__sg_alloc_table.patch added
 to -mm tree
Date: Wed, 26 Jun 2013 14:33:01 -0700
Message-ID: <51cb5e0d.mtlu3ynndjix/Nd8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3FZVdC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 17:33:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, maximlevitsky@gmail.com, imre.deak@intel.com, daniel.vetter@ffwll.ch, akinobu.mita@gmail.com, dan.carpenter@oracle.com

Subject: + lib-scatterlist-error-handling-in-__sg_alloc_table.patch added to -mm tree
To: dan.carpenter@oracle.com,akinobu.mita@gmail.com,daniel.vetter@ffwll.ch,imre.deak@intel.com,maximlevitsky@gmail.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 14:33:01 -0700


The patch titled
     Subject: lib/scatterlist: error handling in __sg_alloc_table()
has been added to the -mm tree.  Its filename is
     lib-scatterlist-error-handling-in-__sg_alloc_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: lib/scatterlist: error handling in __sg_alloc_table()

I was reviewing code which I suspected might allocate a zero size SG
table.  That will cause memory corruption.  Also we can't return before
doing the memset or we could end up using uninitialized memory in the
cleanup path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/scatterlist.c~lib-scatterlist-error-handling-in-__sg_alloc_table lib/scatterlist.c
--- a/lib/scatterlist.c~lib-scatterlist-error-handling-in-__sg_alloc_table
+++ a/lib/scatterlist.c
@@ -247,13 +247,15 @@ int __sg_alloc_table(struct sg_table *ta
 	struct scatterlist *sg, *prv;
 	unsigned int left;
 
+	memset(table, 0, sizeof(*table));
+
+	if (nents == 0)
+		return -EINVAL;
 #ifndef ARCH_HAS_SG_CHAIN
 	if (WARN_ON_ONCE(nents > max_ents))
 		return -EINVAL;
 #endif
 
-	memset(table, 0, sizeof(*table));
