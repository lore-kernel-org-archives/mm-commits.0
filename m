From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-utilc-remove-the-vm_warn_once-for-vm_committed_as-underflow-check.patch
 added to -mm tree
Date: Thu, 04 Jun 2020 14:30:00 -0700
Message-ID: <20200604213000.zX206f1-o%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgFDVaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 17:30:04 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi.kleen@intel.com, cai@lca.pw, feng.tang@intel.com, hannes@cmpxchg.org, keescook@chromium.org, koct9i@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/util.c: remove the VM_WARN_ONCE for vm_committed_as underflow check
has been added to the -mm tree.  Its filename is
     mm-utilc-remove-the-vm_warn_once-for-vm_committed_as-underflow-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-utilc-remove-the-vm_warn_once-for-vm_committed_as-underflow-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-utilc-remove-the-vm_warn_once-for-vm_committed_as-underflow-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/util.c: remove the VM_WARN_ONCE for vm_committed_as underflow check

This check was added by 82f71ae4a2b8 ("mm: catch memory commitment
underflow") in 2014 to have a safety check for issues which have been
fixed.  And there has been few report caught by it, as described in its
commit log:

: This shouldn't happen any more - the previous two patches fixed
: the committed_as underflow issues.

But it was really found by Qian Cai when he used the LTP memory stress
suite to test a RFC patchset, which tries to improve scalability of
per-cpu counter 'vm_committed_as', by chosing a bigger 'batch' number for
loose overcommit policies (OVERCOMMIT_ALWAYS and OVERCOMMIT_GUESS), while
keeping current number for OVERCOMMIT_NEVER.

With that patchset, when system firstly uses a loose policy, the
'vm_committed_as' count could be a big negative value, as its big 'batch'
number allows a big deviation, then when the policy is changed to
OVERCOMMIT_NEVER, the 'batch' will be decreased to a much smaller value,
thus hits this WARN check.

To mitigate this, one proposed solution is to queue work on all online
CPUs to do a local sync for 'vm_committed_as' when changing policy to
OVERCOMMIT_NEVER, plus some global syncing to garante the case won't be
hit.

But this solution is costy and slow, given this check hasn't shown real
trouble or benefit, simply drop it from one hot path of MM.  And perf
stats does show some tiny saving for removing it.

Link: http://lkml.kernel.org/r/20200603094804.GB89848@shbuild999.sh.intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reported-by: Qian Cai <cai@lca.pw>
Reviewed-by: Qian Cai <cai@lca.pw>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/util.c~mm-utilc-remove-the-vm_warn_once-for-vm_committed_as-underflow-check
+++ a/mm/util.c
@@ -796,10 +796,6 @@ int __vm_enough_memory(struct mm_struct
 {
 	long allowed;
 
-	VM_WARN_ONCE(percpu_counter_read(&vm_committed_as) <
-			-(s64)vm_committed_as_batch * num_online_cpus(),
-			"memory commitment underflow");
