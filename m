From: akpm@linux-foundation.org
Subject: +
 arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
 added to -mm tree
Date: Wed, 19 Feb 2014 14:20:10 -0800
Message-ID: <53052e1a.hpklOENacistdw6c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaBSWUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 17:20:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegardno@ifi.uio.no, rientjes@google.com

Subject: + arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch added to -mm tree
To: rientjes@google.com,vegardno@ifi.uio.no
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 14:20:10 -0800


The patch titled
     Subject: arch/x86/mm/kmemcheck/kmemcheck.c: use kstrtoint() instead of sscanf()
has been added to the -mm tree.  Its filename is
     arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: arch/x86/mm/kmemcheck/kmemcheck.c: use kstrtoint() instead of sscanf()

Kmemcheck should use the preferred interface for parsing command line
arguments, kstrto*(), rather than sscanf() itself.  Use it appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/kmemcheck/kmemcheck.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/kmemcheck/kmemcheck.c~arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf arch/x86/mm/kmemcheck/kmemcheck.c
--- a/arch/x86/mm/kmemcheck/kmemcheck.c~arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf
+++ a/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -78,10 +78,16 @@ early_initcall(kmemcheck_init);
  */
 static int __init param_kmemcheck(char *str)
 {
+	int val;
+	int ret;
+
 	if (!str)
 		return -EINVAL;
 
-	sscanf(str, "%d", &kmemcheck_enabled);
+	ret = kstrtoint(str, 0, &val);
+	if (ret)
+		return ret;
+	kmemcheck_enabled = val;
 	return 0;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-thp-fix-infinite-loop-on-memcg-oom.patch
memcg-change-oom_info_lock-to-mutex.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
schednuma-add-cond_resched-to-task_numa_work.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
kernel-resourcec-make-reallocate_resource-static.patch
mm-utilc-add-kstrimdup.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
linux-next.patch

