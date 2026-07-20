Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854283E5EC4;
	Mon, 20 Jul 2026 22:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784587162; cv=none; b=q1Dw++zAkJPRvtE9FEe9ZNPGplIwOKtEWMtxoytRdx87XSGm7c0QvPQGE0iaUI+vHe+1d2pm05GgxSOhAbg37bOnCK/dbW62mVU2PpcyeOzSMXzNl7DjwFgswFnsjE8khpDD4qZlSbttMWArPfobkfH5yE+SBJF8/rfF8ifbP/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784587162; c=relaxed/simple;
	bh=M1lcLf/2nkBdFEORCYPgH9FyIbuRYi9Htm9nACtD65k=;
	h=Date:To:From:Subject:Message-Id; b=t0zW1eBBfi8B9ynfNV0Moy4VhFa701WssnAkulh9/59vLmNZUZ892+64/8F2ydBAY42DSH4qygoIPxp7Oa9j/Yuo2c4WTeeHxzeWjay8mEn+3GVtmhcZC/UQ5cJvrB+ftjpPtyLoNNC2aNIHBg1LTNrzBc+mI7+6yGluccBuZDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G/8kbsEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G/8kbsEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC561F000E9;
	Mon, 20 Jul 2026 22:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784587161;
	bh=kjBhCyK6zBXzfwTkUzv2r3pE0FgcDIF63+8jUiVm0YM=;
	h=Date:To:From:Subject;
	b=G/8kbsEHCKoMNPO0Mu24VmGskCHO/RAcJ7Is3yVdXrYK89axjVqJbKRlC0m72QoNm
	 20Hcv5pw7BV+vdIcfoJQ/gdYl4uXnC0iFqdCn/YFNg2baaBWbZe9gk5uJtKgUWYKof
	 1iXhPYi6ib34eey7hJ+RbZaK+f9Da2s3OVEAjv8M=
Date: Mon, 20 Jul 2026 15:39:20 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,puranjay@kernel.org,paulmck@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch added to mm-new branch
Message-Id: <20260720223921.2DC561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: report RCU-tasks quiescent states during the scan
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm/kmemleak: report RCU-tasks quiescent states during the scan
Date: Mon, 20 Jul 2026 06:23:45 -0700

kmemleak_scan() can run for ages on large debug kernels. It was
causing some soft-lockups which I got fixed with commit
3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
stacks") with our beloved cond_resched().

I've got the fix above deployed in the Meta fleet, and now I am seeing:

  INFO: rcu_tasks detected stalls on tasks:
    task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
     scan_block
     scan_gray_list
     kmemleak_scan

and, worse, blocks the callers waiting on that grace period.  Here a BPF
struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
call_rcu_tasks), is stuck long enough to also trip the hung task check:

  INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
     __wait_rcu_gp
     bpf_struct_ops_map_free

Then I've learned that cond_resched() is not an RCU-tasks quiescent
state, so, we need to use stronger primitives.

Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
reports an RCU-tasks quiescent state as it proceeds.

Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
quiescent state for task rcu").

Link: https://lore.kernel.org/20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org
Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Puranjay Mohan <puranjay@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan
+++ a/mm/kmemleak.c
@@ -1586,7 +1586,7 @@ static int scan_large_block(void *start,
 		if (scan_block(start, next, NULL))
 			return 1;
 		start = next;
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	return 0;
@@ -1623,7 +1623,7 @@ static void scan_object(struct kmemleak_
 			scan_block(start, end, object);
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 			if (!(object->flags & OBJECT_ALLOCATED))
 				break;
@@ -1645,7 +1645,7 @@ static void scan_object(struct kmemleak_
 				break;
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 		} while (object->flags & OBJECT_ALLOCATED);
 	} else {
@@ -1673,7 +1673,7 @@ static void scan_gray_list(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1708,7 +1708,7 @@ static void kmemleak_cond_resched(struct
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
 	raw_spin_lock_irq(&kmemleak_lock);
@@ -1753,7 +1753,7 @@ static void kmemleak_scan_task_stacks(vo
 			}
 			put_task_struct(p);
 		}
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	} while (pid && !stop);
 }
 
@@ -1935,7 +1935,7 @@ static int __kmemleak_scan(bool full)
 			struct page *page = pfn_to_online_page(pfn);
 
 			if (!(pfn & 63))
-				cond_resched();
+				cond_resched_tasks_rcu_qs();
 
 			if (!page)
 				continue;
_

Patches currently in -mm which might be from leitao@debian.org are

mm-memcg-initialize-locked-in-memcg1_oom_prepare-stub.patch
mm-kmemleak-avoid-soft-lockup-when-scanning-task-stacks.patch
mm-kmemleak-stop-the-task-stack-scan-early-when-interrupted.patch
mm-kmemleak-stop-the-per-cpu-and-struct-page-scans-early-too.patch
mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
selftests-mm-add-hwpoison-panic-destructive-test.patch
mm-kmemleak-skip-the-remaining-scan-phases-when-interrupted.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch

