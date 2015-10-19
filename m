From: akpm@linux-foundation.org
Subject: +
 fault-inject-fix-inverted-interval-probability-values-in-printk.patch added to -mm tree
Date: Mon, 19 Oct 2015 14:11:40 -0700
Message-ID: <56255c8c.YfD2UlcDcNiT+xXc%akpm__23793.0337236778$1445289115$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbJSVLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 17:11:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fw@strlen.de, akinobu.mita@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject: fix inverted interval/probability values in printk
has been added to the -mm tree.  Its filename is
     fault-inject-fix-inverted-interval-probability-values-in-printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fault-inject-fix-inverted-interval-probability-values-in-printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fault-inject-fix-inverted-interval-probability-values-in-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fault-inject-fix-inverted-interval-probability-values-in-printk.patch

