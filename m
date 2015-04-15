From: akpm@linux-foundation.org
Subject: [folded-merged]
 proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch removed from -mm tree
Date: Wed, 15 Apr 2015 15:44:46 -0700
Message-ID: <552ee9de.1d4Z1GO7AF7fXoko%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbbDOWor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:44:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenhanxiao@cn.fujitsu.com, ebiederm@xmission.com, nathans@redhat.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-pid-status-show-all-sets-of-pid-according-to-ns-fix
has been removed from the -mm tree.  Its filename was
     proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch

This patch was dropped because it was folded into proc-pid-status-show-all-sets-of-pid-according-to-ns.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-pid-status-show-all-sets-of-pid-according-to-ns-fix

add CONFIG_PID_NS ifdef

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: Nathan Scott <nathans@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/array.c~proc-pid-status-show-all-sets-of-pid-according-to-ns-fix fs/proc/array.c
--- a/fs/proc/array.c~proc-pid-status-show-all-sets-of-pid-according-to-ns-fix
+++ a/fs/proc/array.c
@@ -188,6 +188,7 @@ static inline void task_state(struct seq
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
 
+#ifdef CONFIG_PID_NS
 	seq_puts(m, "\nNStgid:");
 	for (g = ns->level; g <= pid->level; g++)
 		seq_printf(m, "\t%d",
@@ -204,6 +205,7 @@ static inline void task_state(struct seq
 	for (g = ns->level; g <= pid->level; g++)
 		seq_printf(m, "\t%d",
 			task_session_nr_ns(p, pid->numbers[g].ns));
+#endif
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-memblock-add-debug-output-for-the-memblock_add.patch
mm-uninline-and-cleanup-page-mapping-related-helpers.patch
mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

