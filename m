Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B701F63D9
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 22:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778278668; cv=none; b=WrbhvHlS/KD5GsGBkKEb5xaMyb5bvfZd4kCVGvJj3Vtz2rEUkLSeVka4PLByv1bX4ZfkJQhUlViVEerB3Xvl1IbIPfxyxe4oBJB3HJ2+413Roq9vU+jT2s7CbEVJENT8HEwa2zqY05HwMiqHSRlxK9BZHrKjEPYNuyflTHUK7kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778278668; c=relaxed/simple;
	bh=fQLyVjuV3IpSopy1FbtoIVnHeZZniuuxwP6q013bP6U=;
	h=Date:To:From:Subject:Message-Id; b=j63+YKjvnRp3c9uBHhxYZu9bYB5jTWXIBIbh5674g2pv+gLsY+QaV1fdPkrhX7G9N5NYDCiQcqjC43PEjOq9zEX4vEs7RSaUaxDDjgANFgTecPl/il4+UAwkhwJrYgZ7PhPlx1FaDtApWJkeUEZ781bintUkQrdaz8NDCL0wTzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lTCApo50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lTCApo50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3097DC2BCB0;
	Fri,  8 May 2026 22:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778278668;
	bh=fQLyVjuV3IpSopy1FbtoIVnHeZZniuuxwP6q013bP6U=;
	h=Date:To:From:Subject:From;
	b=lTCApo50/I92QB2Qg7OO1aue38Z/TnT4JxYbqMv9WSLUoix4sm+yA2mAgtEiUHcH/
	 YDAupNZWT01kll2eTU9uVjHQdLu03PfsW4iCaRGypzGfwGUyJ5cDy9isk0ptsMEURi
	 upMoBzae/aYpEd3Novqli+L2Qf37PARgujRmkmms=
Date: Fri, 08 May 2026 15:17:47 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-dedupe-verbose-scan-output-by-allocation-backtrace.patch added to mm-new branch
Message-Id: <20260508221748.3097DC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: dedupe verbose scan output by allocation backtrace
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-dedupe-verbose-scan-output-by-allocation-backtrace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-dedupe-verbose-scan-output-by-allocation-backtrace.patch

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
Subject: mm/kmemleak: dedupe verbose scan output by allocation backtrace
Date: Wed, 06 May 2026 05:58:24 -0700

Patch series "mm/kmemleak: dedupe verbose scan output", v3.

I am starting to run with kmemleak in verbose enabled in some "probe
points" across the my employers fleet so that suspected leaks land in
dmesg without needing a separate read of /sys/kernel/debug/kmemleak.

The downside is that workloads which leak many objects from a single
allocation site flood the console with byte-for-byte identical backtraces.
Hundreds of duplicates per scan are common, drowning out distinct leaks
and unrelated kernel messages, while adding no signal beyond the first
occurrence.

This series collapses those duplicates inside kmemleak itself.  Each
unique stackdepot trace_handle prints once per scan, followed by a short
summary line when more than one object shares it:

  kmemleak: unreferenced object 0xff110001083beb00 (size 192):
  kmemleak:   comm "modprobe", pid 974, jiffies 4294754196
  kmemleak:   ...
  kmemleak:   backtrace (crc 6f361828):
  kmemleak:     __kmalloc_cache_noprof+0x1af/0x650
  kmemleak:     ...
  kmemleak:   ... and 71 more object(s) with the same backtrace

The "N new suspected memory leaks" tally and the contents of
/sys/kernel/debug/kmemleak are unchanged - the per-object detail is still
available on demand, only the verbose (dmesg) output is collapsed.

Patch 1 is the kmemleak change.

Patch 2 adds a selftest that loads samples/kmemleak's CONFIG_SAMPLE
kmemleak-test module to generate ten leaks sharing one call site and
checks that the printed count is strictly less than the reported leak
total.  Not sure if Patch 2 is useful or not, if not, it is easier to
discard.


This patch (of 2):

In kmemleak's verbose mode, every unreferenced object found during a scan
is logged with its full header, hex dump and 16-frame backtrace. 
Workloads that leak many objects from a single allocation site flood dmesg
with byte-for-byte identical backtraces, drowning out distinct leaks and
other kernel messages.

Dedupe within each scan using stackdepot's trace_handle as the key: for
every leaked object with a recorded stack trace, look up the
representative kmemleak_object in a per-scan xarray keyed by trace_handle.
The first sighting stores the object pointer (with a get_object()
reference) and sets object->dup_count to 1; later sightings just bump
dup_count on the representative.  After the scan, walk the xarray once and
emit each unique backtrace, followed by a single summary line when more
than one object shares it.

Leaks whose trace_handle is 0 (early-boot allocations tracked before
kmemleak_init() set up object_cache, or stack_depot_save() failures under
memory pressure) cannot be deduped, so they are still printed inline via
the same locked OBJECT_ALLOCATED-checked helper.  The contents of
/sys/kernel/debug/kmemleak are unchanged - only the verbose console output
is collapsed.

Safety notes:

 - The xarray store happens outside object->lock: object->lock is a
   raw spinlock, while xa_store() may grab xa_node slab locks at a
   higher wait-context level which lockdep flags as invalid.
   trace_handle is captured under object->lock (which serialises with
   kmemleak_update_trace()'s writer), so it is safe to use after
   dropping the lock.

 - get_object() pins the kmemleak_object metadata across
   rcu_read_unlock(), but the underlying tracked allocation can still
   be freed concurrently. The deferred print path therefore re-acquires
   object->lock and re-checks OBJECT_ALLOCATED via print_leak_locked()
   before touching object->pointer; __delete_object() clears that flag
   under the same lock before the user memory goes away. The same
   helper is used by the trace_handle == 0 and xa_store() failure
   fallbacks, so every printer in the new path has identical safety
   guarantees.

 - If get_object() fails after we set OBJECT_REPORTED, the object is
   already being torn down (use_count hit zero); the leak count is
   still accurate but the verbose line is dropped, which is correct
   - the memory was freed concurrently and is no longer a leak.

 - If xa_store() fails to allocate an xa_node under memory pressure,
   we fall back to printing inline via print_leak_locked() instead of
   silently dropping the leak.

 - The hex dump is skipped for coalesced entries (dup_count > 1):
   bytes would differ across objects sharing a backtrace anyway, and
   skipping it removes the only remaining read of object->pointer's
   contents in the deferred path. The representative's reported size
   may also differ from the coalesced objects' sizes; the printed
   trace_handle reflects the representative's current value rather
   than the value used as the dedup key, which is normally - but not
   strictly - identical.

Link: https://lore.kernel.org/20260506-kmemleak_dedup-v3-0-2d36aafc34da@debian.org
Link: https://lore.kernel.org/20260506-kmemleak_dedup-v3-1-2d36aafc34da@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |  148 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 140 insertions(+), 8 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-dedupe-verbose-scan-output-by-allocation-backtrace
+++ a/mm/kmemleak.c
@@ -92,6 +92,7 @@
 #include <linux/nodemask.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 #include <linux/crc32.h>
 
 #include <asm/sections.h>
@@ -157,6 +158,8 @@ struct kmemleak_object {
 	struct hlist_head area_list;
 	unsigned long jiffies;		/* creation timestamp */
 	pid_t pid;			/* pid of the current task */
+	/* per-scan dedup count, valid only while in scan-local dedup xarray */
+	unsigned int dup_count;
 	char comm[TASK_COMM_LEN];	/* executable name */
 };
 
@@ -360,8 +363,9 @@ static const char *__object_type_str(str
  * Printing of the unreferenced objects information to the seq file. The
  * print_unreferenced function must be called with the object->lock held.
  */
-static void print_unreferenced(struct seq_file *seq,
-			       struct kmemleak_object *object)
+static void __print_unreferenced(struct seq_file *seq,
+				 struct kmemleak_object *object,
+				 bool hex_dump)
 {
 	int i;
 	unsigned long *entries;
@@ -373,7 +377,8 @@ static void print_unreferenced(struct se
 			   object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
 			   object->comm, object->pid, object->jiffies);
-	hex_dump_object(seq, object);
+	if (hex_dump)
+		hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace (crc %x):\n", object->checksum);
 
 	for (i = 0; i < nr_entries; i++) {
@@ -382,6 +387,12 @@ static void print_unreferenced(struct se
 	}
 }
 
+static void print_unreferenced(struct seq_file *seq,
+			       struct kmemleak_object *object)
+{
+	__print_unreferenced(seq, object, true);
+}
+
 /*
  * Print the kmemleak_object information. This function is used mainly for
  * debugging special cases when kmemleak operations. It must be called with
@@ -1685,6 +1696,103 @@ unlock_put:
 }
 
 /*
+ * Print one leak inline. The hex dump is gated on OBJECT_ALLOCATED so it
+ * does not touch user memory that was freed concurrently; the rest of the
+ * report (backtrace, comm, pid) is always emitted since the kmemleak_object
+ * metadata is pinned by the caller.
+ */
+static void print_leak_locked(struct kmemleak_object *object, bool hex_dump)
+{
+	raw_spin_lock_irq(&object->lock);
+	__print_unreferenced(NULL, object,
+			     hex_dump && (object->flags & OBJECT_ALLOCATED));
+	raw_spin_unlock_irq(&object->lock);
+}
+
+/*
+ * Per-scan dedup table for verbose leak printing. The xarray is keyed by
+ * stackdepot trace_handle and stores a pointer to the representative
+ * kmemleak_object. The per-scan repeat count lives in object->dup_count.
+ *
+ * dedup_record() must run outside object->lock: xa_store() may take
+ * mutexes (xa_node slab allocation) which lockdep would flag against the
+ * raw spinlock object->lock.
+ */
+static void dedup_record(struct xarray *dedup, struct kmemleak_object *object,
+			 depot_stack_handle_t trace_handle)
+{
+	struct kmemleak_object *rep;
+	void *old;
+
+	/*
+	 * No stack trace to dedup against: early-boot allocation tracked
+	 * before kmemleak_init() set up object_cache, or stack_depot_save()
+	 * failure under memory pressure.
+	 */
+	if (!trace_handle) {
+		print_leak_locked(object, true);
+		return;
+	}
+
+	/* stack is available, now we can de-dup */
+	rep = xa_load(dedup, trace_handle);
+	if (rep) {
+		rep->dup_count++;
+		return;
+	}
+
+	/*
+	 * Object is being torn down (use_count already hit zero); the
+	 * tracked memory at object->pointer is unsafe to read, so skip.
+	 */
+	if (!get_object(object))
+		return;
+
+	object->dup_count = 1;
+	old = xa_store(dedup, trace_handle, object, GFP_ATOMIC);
+	if (xa_is_err(old)) {
+		/* xa_node allocation failed; fall back to inline print. */
+		print_leak_locked(object, true);
+		put_object(object);
+		return;
+	}
+	/*
+	 * scan_mutex serialises all writers to the dedup xarray, so xa_store()
+	 * after a NULL xa_load() must always overwrite an empty slot.
+	 */
+	WARN_ON_ONCE(old);
+}
+
+/*
+ * Drain the dedup table. Re-acquires object->lock and re-checks
+ * OBJECT_ALLOCATED before printing: while get_object() pins the
+ * kmemleak_object metadata, the underlying tracked allocation may have
+ * been freed since the scan walked it (kmemleak_free clears
+ * OBJECT_ALLOCATED under object->lock before the user memory goes away).
+ * The hex dump is skipped for coalesced entries since the bytes would
+ * differ across objects anyway.
+ */
+static void dedup_flush(struct xarray *dedup)
+{
+	struct kmemleak_object *object;
+	unsigned long idx;
+	unsigned int dup;
+	bool coalesced;
+
+	xa_for_each(dedup, idx, object) {
+		dup = object->dup_count;
+		coalesced = dup > 1;
+
+		print_leak_locked(object, !coalesced);
+		if (coalesced)
+			pr_warn("  ... and %u more object(s) with the same backtrace\n",
+				dup - 1);
+		put_object(object);
+		xa_erase(dedup, idx);
+	}
+}
+
+/*
  * Scan data sections and all the referenced memory blocks allocated via the
  * kernel's standard allocators. This function must be called with the
  * scan_mutex held.
@@ -1694,6 +1802,7 @@ static void kmemleak_scan(void)
 	struct kmemleak_object *object;
 	struct zone *zone;
 	int __maybe_unused i;
+	struct xarray dedup;
 	int new_leaks = 0;
 
 	jiffies_last_scan = jiffies;
@@ -1834,10 +1943,18 @@ static void kmemleak_scan(void)
 		return;
 
 	/*
-	 * Scanning result reporting.
+	 * Scanning result reporting. When verbose printing is enabled, dedupe
+	 * by stackdepot trace_handle so each unique backtrace is logged once
+	 * per scan, annotated with the number of objects that share it. The
+	 * per-leak count below still reflects every object, and
+	 * /sys/kernel/debug/kmemleak still lists them individually.
 	 */
+	xa_init(&dedup);
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {
+		depot_stack_handle_t trace_handle;
+		bool dedup_print;
+
 		if (need_resched())
 			kmemleak_cond_resched(object);
 
@@ -1849,18 +1966,33 @@ static void kmemleak_scan(void)
 		if (!color_white(object))
 			continue;
 		raw_spin_lock_irq(&object->lock);
+		trace_handle = 0;
+		dedup_print = false;
 		if (unreferenced_object(object) &&
 		    !(object->flags & OBJECT_REPORTED)) {
 			object->flags |= OBJECT_REPORTED;
-
-			if (kmemleak_verbose)
-				print_unreferenced(NULL, object);
-
+			if (kmemleak_verbose) {
+				trace_handle = object->trace_handle;
+				dedup_print = true;
+			}
 			new_leaks++;
 		}
 		raw_spin_unlock_irq(&object->lock);
+
+		/*
+		 * Defer the verbose print outside object->lock: xa_store()
+		 * may take xa_node slab locks at a higher wait-context level
+		 * which lockdep would flag against the raw_spinlock_t
+		 * object->lock. rcu_read_lock() keeps the kmemleak_object
+		 * alive across the call.
+		 */
+		if (dedup_print)
+			dedup_record(&dedup, object, trace_handle);
 	}
 	rcu_read_unlock();
+	/* Flush'em all */
+	dedup_flush(&dedup);
+	xa_destroy(&dedup);
 
 	if (new_leaks) {
 		kmemleak_found_leaks = true;
_

Patches currently in -mm which might be from leitao@debian.org are

mm-huge_memory-use-sysfs_match_string-in-defrag_store.patch
mm-huge_memory-refactor-defrag_show-to-use-defrag_flags.patch
mm-kmemleak-dedupe-verbose-scan-output-by-allocation-backtrace.patch
selftests-mm-add-kmemleak-verbose-dedup-test.patch

