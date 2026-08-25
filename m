Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C097937187E
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622906; cv=none; b=Vk26RONabbG/nuxhSBqQgR9K1GY2c3+Q8V5Itbu1oPlPrULkIPN3o41b3ttUqkuFe0NRywvAXAzd8itgJmrZF6jL+gel1+qhXpI8svtPhCGdVk8jHPdxQe36afpYojKX/7pQ6MV0IXd20NQvdH6t7uPXR/8OplEJv7ptK8GZnZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622906; c=relaxed/simple;
	bh=TA25AFZP6cMPNxWvNhnLXdlFq8dbrTfw3U4M7iTxlZE=;
	h=Date:To:From:Subject:Message-Id; b=fSwOAH2WAnW8DcKowwG0uslHX4ufCMDdG4UAho6NhcpXH4kJL0RtS05pPKa/u1OWmU38ocSFasq8HiUVRG3Wtxzn/ZenI2M4DuJcpETJvTjZWqZNlMqgCPiVtdYPOhNnFoAaiY9IDq3B/tVyGZ0rXCsnGFdP1OySt0nuyppZ+D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CZUxstUl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CZUxstUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800271F000E9;
	Tue, 25 Aug 2026 01:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622904;
	bh=+ohhxn3idbr4hdNynNunfWPgoP8L2fu/hXaHrdlrXhY=;
	h=Date:To:From:Subject;
	b=CZUxstUl2VUDaGbMKo9T5XotF9qbzJKE02lUANyLp+PIqHhFcxLvOpwoR4TBpt/X4
	 ecyG5WKBNIlyg1KhYuShIXOP3l3/cNC0hpn/bs7E151flxs1Gz58qEYhvBChJVzX0v
	 wtYGdBQdPKULjbQrZvpFVj8uWeYLJMx7JsmrOtis=
Date: Mon, 24 Aug 2026 18:55:04 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,geert@linux-m68k.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch removed from -mm tree
Message-Id: <20260825015504.800271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: report leaks only after N consecutive unreferenced scans
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


