Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279FB1A3160
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 00:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989459; cv=none; b=oa7Dmhx5Crks624/jFjkCHTrqJMvCAfUbl58Ns/vwDG4nPGn4j/qF5mXP55d0pYYQ12BgawxK5DwgtFq6aTpEoyudCWk1jDecTcheSuKB3UQIgNiYIG41UAtNEv/8sf5dj3tfMibSgQbKklknSxCnattGo7F5tbNNAocDb1NIaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989459; c=relaxed/simple;
	bh=LfYCJgKYtS3/wAr9FKAVrV7mNp1ZadDv4YCn7fIppj4=;
	h=Date:To:From:Subject:Message-Id; b=vBKX1OztWLtMNeZK5fzD2ATwZ6ephpcFj+uDQnFbwyXZFhjUle0UmlTUU7hFqkqt/1q0OyB3+Gem4pem9Z3y4JllbaYYF8ArKVie9j0FuBySI3vF3m8us+acYOB3NGHBf+ogd1mRIwW7lo+82LVxNurgIT4+71bg25botyXfiEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TbuQBmYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TbuQBmYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCC51F000E9;
	Tue, 14 Jul 2026 00:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783989457;
	bh=9Lo8GNe9cPQvfMTaxU5IRDqV9E++aL40/eK2GukA+fM=;
	h=Date:To:From:Subject;
	b=TbuQBmYpE93g9UgAPHrx/3HB5DPoggORfV+e9gQi3nB/ZiicZmGJDYEJ2qrXzvmKo
	 Nqd7T4XlLCIPpujjbZeWhRDNkQ9mB23aA+91HgjO1G6mATqyx0gDmAYq9RO59SSoib
	 BvPdliTjUXHI0kskJejpNusFDHQ3s92/LsAQymcg=
Date: Mon, 13 Jul 2026 17:37:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,geert@linux-m68k.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch added to mm-new branch
Message-Id: <20260714003737.ADCC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: report leaks only after N consecutive unreferenced scans
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch

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
Subject: mm: kmemleak: report leaks only after N consecutive unreferenced scans
Date: Mon, 13 Jul 2026 04:48:05 -0700

kmemleak reports an object the first scan it is found unreferenced.  Its
mark phase runs without stopping the rest of the kernel and without a
write barrier, so a live object whose only reference is briefly invisible
during a concurrent RCU update -- e.g.  a VMA moved between maple tree
nodes, or a page-cache xa_node -- can be seen as unreferenced for that one
scan.  Because an object is flagged as reported only once, such a
transient race turns into a permanent false positive.

Track how many consecutive scans each object has been seen unreferenced
and only report it once that reaches min_unref_scans, a new module
parameter.  It defaults to 1, leaving the behaviour unchanged; setting it
higher (e.g.  2) still reports a genuine leak, one scan later, while an
object referenced again before the threshold restarts its run and is never
reported.

min_unref_scans can be set at boot with kmemleak.min_unref_scans=<n> or at
run-time via /sys/module/kmemleak/parameters/min_unref_scans.

Link: https://lore.kernel.org/20260713-catalin_pto-v1-2-5b93b1131089@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmemleak.rst |    8 ++++++++
 mm/kmemleak.c                        |   13 ++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/Documentation/dev-tools/kmemleak.rst~mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -198,6 +198,14 @@ systems, because of pointers temporarily
 stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
 the minimum age of an object to be reported as a memory leak.
 
+The ``min_unref_scans`` module parameter (default 1) requires an object to
+be seen unreferenced in that many consecutive scans before it is reported.
+Keeping it at 1 preserves the historical behaviour; higher values filter
+the transient false positives described above, at the cost of delaying
+genuine reports by up to that many scans. It can be set at boot with
+``kmemleak.min_unref_scans=<n>`` or at run-time via
+``/sys/module/kmemleak/parameters/min_unref_scans``.
+
 Limitations and Drawbacks
 -------------------------
 
--- a/mm/kmemleak.c~mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans
+++ a/mm/kmemleak.c
@@ -151,6 +151,8 @@ struct kmemleak_object {
 	int min_count;
 	/* the total number of pointers found pointing to this object */
 	int count;
+	/* consecutive scans the object has been seen unreferenced */
+	unsigned int unref_scans;
 	/* checksum for detecting modified objects */
 	u32 checksum;
 	depot_stack_handle_t trace_handle;
@@ -234,6 +236,9 @@ static unsigned long max_percpu_addr;
 static struct task_struct *scan_thread;
 /* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
+/* consecutive scans an object must stay unreferenced before reporting */
+static unsigned int min_unref_scans = 1;
+module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
 static unsigned long jiffies_scan_wait;
@@ -692,6 +697,7 @@ static struct kmemleak_object *__alloc_o
 	object->excess_ref = 0;
 	object->count = 0;			/* white color initially */
 	object->checksum = ~0;
+	object->unref_scans = 0;
 	object->del_state = 0;
 
 	/* task information */
@@ -1890,6 +1896,9 @@ static int __kmemleak_scan(bool full)
 				__paint_it(object, KMEMLEAK_BLACK);
 		}
 
+		/* referenced last scan: restart the unreferenced run */
+		if (!color_white(object))
+			object->unref_scans = 0;
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
 		if (full)
@@ -2064,9 +2073,11 @@ static void kmemleak_scan(void)
 		raw_spin_lock_irq(&object->lock);
 		trace_handle = 0;
 		dedup_print = false;
+
 		if (unreferenced_object(object) &&
 		    (object->flags & OBJECT_SUSPECT) &&
-		    !(object->flags & OBJECT_REPORTED)) {
+		    !(object->flags & OBJECT_REPORTED) &&
+		    ++object->unref_scans >= min_unref_scans) {
 			object->flags |= OBJECT_REPORTED;
 			if (kmemleak_verbose) {
 				trace_handle = object->trace_handle;
_

Patches currently in -mm which might be from leitao@debian.org are

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

