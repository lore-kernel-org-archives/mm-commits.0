From: akpm@linux-foundation.org
Subject: + sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch added to -mm tree
Date: Mon, 18 Apr 2011 12:41:15 -0700
Message-ID: <201104181941.p3IJfFJm020994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296Ab1DRTlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 15:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, arjan@infradead.org, dave@linux.vnet.ibm.com


The patch titled
     sparse: Undef __compiletime_{warning,error} if __CHECKER__ is defined
has been added to the -mm tree.  Its filename is
     sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch

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
Subject: sparse: Undef __compiletime_{warning,error} if __CHECKER__ is defined
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

sparse can't parse warning and error attribute.  then they should be
hidden from sparse.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc4.h~sparse-undef-__compiletime_warningerror-if-__checker__-is-defined include/linux/compiler-gcc4.h
--- a/include/linux/compiler-gcc4.h~sparse-undef-__compiletime_warningerror-if-__checker__-is-defined
+++ a/include/linux/compiler-gcc4.h
@@ -51,7 +51,7 @@
 #if __GNUC_MINOR__ > 0
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 #endif
-#if __GNUC_MINOR__ >= 4
+#if __GNUC_MINOR__ >= 4 && !defined(__CHECKER__)
 #define __compiletime_warning(message) __attribute__((warning(message)))
 #define __compiletime_error(message) __attribute__((error(message)))
 #endif
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-introduce-wait_on_page_locked_killable.patch
x86mm-make-pagefault-killable.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-mem-hotplug-recalculate-lowmem_reserve-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-convert-vma-vm_flags-to-64-bit.patch
mm-add-__nocast-attribute-to-vm_flags.patch
fremap-convert-vm_flags-to-unsigned-long-long.patch
procfs-convert-vm_flags-to-unsigned-long-long.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj.patch
oom-replace-pf_oom_origin-with-toggling-oom_score_adj-update.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
sparse-define-dummy-build_bug_on-definition-for-sparse.patch
sparse-define-__must_be_array-for-__checker__.patch
sparse-undef-__compiletime_warningerror-if-__checker__-is-defined.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

