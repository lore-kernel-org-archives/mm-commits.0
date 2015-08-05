From: akpm@linux-foundation.org
Subject: + writeback-fix-initial-dirty-limit.patch added to -mm tree
Date: Wed, 05 Aug 2015 12:32:49 -0700
Message-ID: <55c264e1.DGhmT5mrGIVEbvXQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbbHETcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Aug 2015 15:32:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rabin.vincent@axis.com, axboe@fb.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: fix initial dirty limit
has been added to the -mm tree.  Its filename is
     writeback-fix-initial-dirty-limit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-fix-initial-dirty-limit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-fix-initial-dirty-limit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rabin Vincent <rabin.vincent@axis.com>
Subject: writeback: fix initial dirty limit

The initial value of global_wb_domain.dirty_limit set by
writeback_set_ratelimit() is zeroed out by the memset in wb_domain_init().

Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~writeback-fix-initial-dirty-limit mm/page-writeback.c
--- a/mm/page-writeback.c~writeback-fix-initial-dirty-limit
+++ a/mm/page-writeback.c
@@ -2063,10 +2063,10 @@ static struct notifier_block ratelimit_n
  */
 void __init page_writeback_init(void)
 {
+	BUG_ON(wb_domain_init(&global_wb_domain, GFP_KERNEL));
+
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
