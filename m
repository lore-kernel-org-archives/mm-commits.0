From: akpm@linux-foundation.org
Subject: +
 generic-ipi-fix-misleading-smp_call_function_any-description.patch added to -mm tree
Date: Wed, 07 Aug 2013 14:35:59 -0700
Message-ID: <5202bdbf.PyS+rau5/Ecn1F7R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479Ab3HGVgA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Aug 2013 17:36:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sheng@linux.intel.com, rusty@rustcorp.com.au, jens.axboe@oracle.com, a.p.zijlstra@chello.nl, xiexiuqi@huawei.com

Subject: + generic-ipi-fix-misleading-smp_call_function_any-description.patch added to -mm tree
To: xiexiuqi@huawei.com,a.p.zijlstra@chello.nl,jens.axboe@oracle.com,rusty@rustcorp.com.au,sheng@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 07 Aug 2013 14:35:59 -0700


The patch titled
     Subject: generic-ipi: fix misleading smp_call_function_any() description
has been added to the -mm tree.  Its filename is
     generic-ipi-fix-misleading-smp_call_function_any-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/generic-ipi-fix-misleading-smp_call_function_any-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/generic-ipi-fix-misleading-smp_call_function_any-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: generic-ipi: fix misleading smp_call_function_any() description

After 8969a5ede0f9e1 ("generic-ipi: remove kmalloc()"), wait = 0 can be
guaranteed.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/smp.c~generic-ipi-fix-misleading-smp_call_function_any-description kernel/smp.c
--- a/kernel/smp.c~generic-ipi-fix-misleading-smp_call_function_any-description
+++ a/kernel/smp.c
@@ -281,8 +281,6 @@ EXPORT_SYMBOL(smp_call_function_single);
  * @wait: If true, wait until function has completed.
  *
  * Returns 0 on success, else a negative status code (if no cpus were online).
- * Note that @wait will be implicitly turned on in case of allocation failures,
- * since we fall back to on-stack allocation.
  *
  * Selection preference:
  *	1) current cpu if in @mask
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

generic-ipi-fix-misleading-smp_call_function_any-description.patch
linux-next.patch

