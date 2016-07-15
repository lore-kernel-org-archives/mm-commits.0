From: akpm@linux-foundation.org
Subject: + tools-vm-slabinfo-fix-an-unintentional-printf.patch added to
 -mm tree
Date: Fri, 15 Jul 2016 14:18:31 -0700
Message-ID: <57895327.UHGiMvrUuFh/tmso%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcGOVSc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jul 2016 17:18:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, cl@linux.com, colin.king@canonical.com, labbott@fedoraproject.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: fix an unintentional printf
has been added to the -mm tree.  Its filename is
     tools-vm-slabinfo-fix-an-unintentional-printf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-slabinfo-fix-an-unintentional-printf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-slabinfo-fix-an-unintentional-printf.patch

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
Subject: tools/vm/slabinfo: fix an unintentional printf

The curly braces are missing here so we print stuff unintentionally.

Fixes: 9da4714a2d4f ('slub: slabinfo update for cmpxchg handling')
Link: http://lkml.kernel.org/r/20160715211243.GE19522@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Laura Abbott <labbott@fedoraproject.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-fix-an-unintentional-printf tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-fix-an-unintentional-printf
+++ a/tools/vm/slabinfo.c
@@ -510,10 +510,11 @@ static void slab_stats(struct slabinfo *
 			s->alloc_node_mismatch, (s->alloc_node_mismatch * 100) / total);
 	}
 
-	if (s->cmpxchg_double_fail || s->cmpxchg_double_cpu_fail)
+	if (s->cmpxchg_double_fail || s->cmpxchg_double_cpu_fail) {
 		printf("\nCmpxchg_double Looping\n------------------------\n");
 		printf("Locked Cmpxchg Double redos   %lu\nUnlocked Cmpxchg Double redos %lu\n",
 			s->cmpxchg_double_fail, s->cmpxchg_double_cpu_fail);
+	}
 }
 
 static void report(struct slabinfo *s)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

testing-radix-tree-fix-a-macro-expansion-bug.patch
tools-vm-slabinfo-fix-an-unintentional-printf.patch

