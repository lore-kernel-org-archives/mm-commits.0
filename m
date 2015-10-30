From: akpm@linux-foundation.org
Subject: [merged]
 fault-inject-fix-inverted-interval-probability-values-in-printk.patch
 removed from -mm tree
Date: Fri, 30 Oct 2015 12:44:48 -0700
Message-ID: <5633c8b0.Z3NTb6ShHve3iz9T%akpm__12809.3782616363$1446234302$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbbJ3Tos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Oct 2015 15:44:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fw@strlen.de, akinobu.mita@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: fix inverted interval/probability values in printk
has been removed from the -mm tree.  Its filename was
     fault-inject-fix-inverted-interval-probability-values-in-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Florian Westphal <fw@strlen.de>
Subject: fault-inject: fix inverted interval/probability values in printk

interval displays the probability and vice versa.

Fixes: 6adc4a22f20bb ("fault-inject: add ratelimit option")
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/fault-inject.c~fault-inject-fix-inverted-interval-probability-values-in-printk lib/fault-inject.c
--- a/lib/fault-inject.c~fault-inject-fix-inverted-interval-probability-values-in-printk
+++ a/lib/fault-inject.c
@@ -44,7 +44,7 @@ static void fail_dump(struct fault_attr
 		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
 		       "name %pd, interval %lu, probability %lu, "
 		       "space %d, times %d\n", attr->dname,
-		       attr->probability, attr->interval,
+		       attr->interval, attr->probability,
 		       atomic_read(&attr->space),
 		       atomic_read(&attr->times));
 		if (attr->verbose > 1)
_

Patches currently in -mm which might be from fw@strlen.de are


