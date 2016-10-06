From: akpm@linux-foundation.org
Subject: + mm-slab-fix-kmemcg-cache-creation-delayed-issue.patch added to
 -mm tree
Date: Thu, 06 Oct 2016 15:34:16 -0700
Message-ID: <57f6d168.V0C85KTHXxyvCdK4%akpm__34567.6507837654$1475793271$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbcJFWeR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2016 18:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, dsmythies@telus.net, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix kmemcg cache creation delayed issue
has been added to the -mm tree.  Its filename is
     mm-slab-fix-kmemcg-cache-creation-delayed-issue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-fix-kmemcg-cache-creation-delayed-issue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-fix-kmemcg-cache-creation-delayed-issue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: fix kmemcg cache creation delayed issue

There is a bug report that SLAB makes extreme load average due to over
2000 kworker thread.

https://bugzilla.kernel.org/show_bug.cgi?id=172981

This issue is caused by kmemcg feature that try to create new set of
kmem_caches for each memcg.  Recently, kmem_cache creation is slowed by
synchronize_sched() and futher kmem_cache creation is also delayed since
kmem_cache creation is synchronized by a global slab_mutex lock.  So, the
number of kworker that try to create kmem_cache increases quitely. 
synchronize_sched() is for lockless access to node's shared array but it's
not needed when a new kmem_cache is created.  So, this patch rules out
that case.

Fixes: 801faf0db894 ("mm/slab: lockless decision to grow cache")
Link: http://lkml.kernel.org/r/1475734855-4837-1-git-send-email-iamjoonsoo.kim@lge.com
Reported-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-fix-kmemcg-cache-creation-delayed-issue mm/slab.c
--- a/mm/slab.c~mm-slab-fix-kmemcg-cache-creation-delayed-issue
+++ a/mm/slab.c
@@ -966,7 +966,7 @@ static int setup_kmem_cache_node(struct
 	 * guaranteed to be valid until irq is re-enabled, because it will be
 	 * freed after synchronize_sched().
 	 */
-	if (force_change)
+	if (old_shared && force_change)
 		synchronize_sched();
 
 fail:
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-kmemcg-cache-creation-delayed-issue.patch
mm-debug_pagealloc-clean-up-guard-page-handling-code.patch
mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch
mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch
mm-page_ext-rename-offset-to-index.patch
mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch
mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch

