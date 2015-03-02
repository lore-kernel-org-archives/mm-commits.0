From: akpm@linux-foundation.org
Subject: + cpumask-dont-perform-while-loop-in-cpumask_next_and.patch added to -mm tree
Date: Mon, 02 Mar 2015 15:58:58 -0800
Message-ID: <54f4f942.PQm4OugPrxrrW9I8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbbCBX67 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 18:58:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, amirv@mellanox.com, davem@davemloft.net, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: don't perform while loop in cpumask_next_and()
has been added to the -mm tree.  Its filename is
     cpumask-dont-perform-while-loop-in-cpumask_next_and.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cpumask-dont-perform-while-loop-in-cpumask_next_and.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: cpumask: don't perform while loop in cpumask_next_and()

cpumask_next_and() is looking for cpumask_next() in src1 in a loop and
tests if found cpu is also present in src2. remove that loop, perform
cpumask_and() of src1 and src2 first and use that new mask to find
cpumask_next().

Apart from removing while loop, ./bloat-o-meter on x86_64 shows
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-8 (-8)
function                                     old     new   delta
cpumask_next_and                              62      54      -8

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Amir Vadai <amirv@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cpumask.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN lib/cpumask.c~cpumask-dont-perform-while-loop-in-cpumask_next_and lib/cpumask.c
--- a/lib/cpumask.c~cpumask-dont-perform-while-loop-in-cpumask_next_and
+++ a/lib/cpumask.c
@@ -37,10 +37,11 @@ EXPORT_SYMBOL(__next_cpu_nr);
 int cpumask_next_and(int n, const struct cpumask *src1p,
 		     const struct cpumask *src2p)
 {
-	while ((n = cpumask_next(n, src1p)) < nr_cpu_ids)
-		if (cpumask_test_cpu(n, src2p))
-			break;
-	return n;
+	struct cpumask tmp;
+
+	if (cpumask_and(&tmp, src1p, src2p))
+		return cpumask_next(n, &tmp);
+	return nr_cpu_ids;
 }
 EXPORT_SYMBOL(cpumask_next_and);
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

