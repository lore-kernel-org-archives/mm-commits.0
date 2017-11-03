From: akpm@linux-foundation.org
Subject: + mm-use-in_atomic-in-print_vma_addr.patch added to -mm tree
Date: Fri, 03 Nov 2017 10:57:54 -0700
Message-ID: <59fcae22.PMlIXllWxLQgAiFa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34134 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933473AbdKCR5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 13:57:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.s@alibaba-inc.com, fweisbec@gmail.com, mhocko@suse.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use in_atomic() in print_vma_addr()
has been added to the -mm tree.  Its filename is
     mm-use-in_atomic-in-print_vma_addr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-in_atomic-in-print_vma_addr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-in_atomic-in-print_vma_addr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Yang Shi" <yang.s@alibaba-inc.com>
Subject: mm: use in_atomic() in print_vma_addr()

3e51f3c4004c9b ("sched/preempt: Remove PREEMPT_ACTIVE unmasking off
in_atomic()") uses in_atomic() just check the preempt count, so it is not
necessary to use preempt_count() in print_vma_addr() any more.  Replace
preempt_count() to in_atomic() which is a generic API for checking atomic
context.

in_atomic() is the preferred API for checking atomic context instead of
preempt_count() which should be used for retrieving the preemption count
value.

If we go through the kernel code, almost everywhere "in_atomic" is used
for such use case already, except two places:

- print_vma_addr()
- debug_smp_processor_id()

Both came from Ingo long time ago before 3e51f3c4004c9b01 ("sched/preempt:
Remove PREEMPT_ACTIVE unmasking off in_atomic()").  But, after this commit
was merged, use in_atomic() to follow the convention.

Link: http://lkml.kernel.org/r/1509572313-102989-1-git-send-email-yang.s@alibaba-inc.com
Signed-off-by: Yang Shi <yang.s@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-use-in_atomic-in-print_vma_addr mm/memory.c
--- a/mm/memory.c~mm-use-in_atomic-in-print_vma_addr
+++ a/mm/memory.c
@@ -4488,7 +4488,7 @@ void print_vma_addr(char *prefix, unsign
 	 * Do not print if we are in atomic
 	 * contexts (in exception stacks, etc.):
 	 */
-	if (preempt_count())
+	if (in_atomic())
 		return;
 
 	down_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from yang.s@alibaba-inc.com are

tools-slabinfo-add-u-option-to-show-unreclaimable-slabs-only.patch
mm-slabinfo-dump-config_slabinfo.patch
mm-slabinfo-dump-config_slabinfo-v11.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory.patch
mm-oom-show-unreclaimable-slab-info-when-unreclaimable-slabs-user-memory-v11.patch
mm-use-in_atomic-in-print_vma_addr.patch

