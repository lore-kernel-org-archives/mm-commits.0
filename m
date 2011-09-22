From: akpm@google.com
Subject: + thp-fix-khugepaged-defrag-tunable-documentation.patch added to -mm tree
Date: Thu, 22 Sep 2011 14:52:00 -0700
Message-ID: <201109222152.p8MLq0jP028455@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:40377 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1IVVwK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Sep 2011 17:52:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com


The patch titled
     Subject: thp: fix khugepaged defrag tunable documentation
has been added to the -mm tree.  Its filename is
     thp-fix-khugepaged-defrag-tunable-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: thp: fix khugepaged defrag tunable documentation

e27e6151b154 ("mm/thp: use conventional format for boolean attributes")
changed /sys/kernel/mm/transparent_hugepage/khugepaged/defrag to be tuned
by using 1 (enabled) or 0 (disabled) instead of "yes" and "no",
respectively.

Update the documentation.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 Documentation/vm/transhuge.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/transhuge.txt~thp-fix-khugepaged-defrag-tunable-documentation Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-fix-khugepaged-defrag-tunable-documentation
+++ a/Documentation/vm/transhuge.txt
@@ -123,10 +123,11 @@ be automatically shutdown if it's set to
 khugepaged runs usually at low frequency so while one may not want to
 invoke defrag algorithms synchronously during the page faults, it
 should be worth invoking defrag at least in khugepaged. However it's
-also possible to disable defrag in khugepaged:
+also possible to disable defrag in khugepaged by writing 0 or enable
+defrag in khugepaged by writing 1:
 
-echo yes >/sys/kernel/mm/transparent_hugepage/khugepaged/defrag
-echo no >/sys/kernel/mm/transparent_hugepage/khugepaged/defrag
+echo 0 >/sys/kernel/mm/transparent_hugepage/khugepaged/defrag
+echo 1 >/sys/kernel/mm/transparent_hugepage/khugepaged/defrag
 
 You can also control how many pages khugepaged should scan at each
 pass:
_
Subject: Subject: thp: fix khugepaged defrag tunable documentation

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch
oom-remove-oom_disable_count.patch
oom-fix-race-while-temporarily-setting-currents-oom_score_adj.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
mm-compaction-make-compact_zone_order-static.patch
thp-fix-khugepaged-defrag-tunable-documentation.patch
cpusets-avoid-looping-when-storing-to-mems_allowed-if-one-node-remains-set.patch

