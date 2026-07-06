Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1713236F8EF
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 23:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783380000; cv=none; b=TGNcdEfcqEPYSKadMmm3VhJv4dJVTedmj55VLkaFmvz4nEXHFnzAGG83kMK7WoWKVZdg2kH7lD+8Joh1tiW4PaaytK4yHLJw8OZKm86lfR9W5zMZ9z9P9+AB8z3k2xvgqboz3YkOrF6lobuW7FfCGKDfWa42nuRO79IB2jwZmcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783380000; c=relaxed/simple;
	bh=rIBxb5IPAqqDAS60b6si7RnwmY5e8rMe65KBP8ToIyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+hQ4GWJyobs+IIITt20YX3eNpDEstuDHBZOTs8RhdFjD3UFWcE8Y34HcAc3pXNG3H7riCksvgpW8hnU1QvaqTqhohbTxz7RsTmjv+L2aAA1VKoSeYhY5khumz+dQKoKe+bORS/VFQ6EtMHpHlP+5YufvsajZSqUjjn+NXAQVCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gIeCJ3hU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gIeCJ3hU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EC401CE2;
	Mon,  6 Jul 2026 16:19:53 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70D243F7B4;
	Mon,  6 Jul 2026 16:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783379997; bh=rIBxb5IPAqqDAS60b6si7RnwmY5e8rMe65KBP8ToIyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gIeCJ3hUmDaSS979kCQt1E0WNYpvMYE0fq32YCiuAU3EY0LCDwtX9aecJBndovc8K
	 NUoiTMMaPydfxIQafaYSectWeQ61/h0xiO9JLJcjgJqmUhjQ5WBvB9sCo+uaNmhHkT
	 ydasp1zxdLEp4vOSDr8yAvNJDqAUbsx1FXHgNtDw=
Date: Tue, 7 Jul 2026 00:19:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, kent.overstreet@linux.dev,
	bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <akw4FspAoT60tQeu@arm.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
 <akuFSv7JaXo6M8gx@gmail.com>
 <akuT8pEjBKvByPlA@arm.com>
 <akuzsny_3EpxaPww@gmail.com>
 <akvW9RwjVmRnNzHM@arm.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akvW9RwjVmRnNzHM@arm.com>

On Mon, Jul 06, 2026 at 05:25:25PM +0100, Catalin Marinas wrote:
> On Mon, Jul 06, 2026 at 07:53:30AM -0700, Breno Leitao wrote:
> > On Mon, Jul 06, 2026 at 12:39:30PM +0100, Catalin Marinas wrote:
> > > I wonder whether we should force the scanning to happen twice in a row
> > > and drop the min_unref_count. Those transient leaks happen because of
> > > some micro/milliseconds miss of a pointer. If we have new white objects
> > > of the end of a scan, go one more round through the root and gray
> > > objects (but do not reset them to white) and only then report the leaks.
> > > If the white objects have been reported already or we don't have any
> > > left, skip this additional scan or bail out early. We could have a
> > > tunable for this one to go 2-3 times if needed, though I guess twice is
> > > sufficient. The interface is also preserved as you do an echo scan only
> > > once (or twice initially with the checksum calculation).
> > 
> > That is a good proposal, and I am happy to hack it up.
> > 
> > On the other side, I _think_ we want to have both approaches
> > (your rescan-after-white) and min_unref_count. They serve different
> > purposes. This is how I see them serving different purposes:
> > 
> > 1) This rescan-after-white proposal:
> > 
> >   Target: Developers that cat manually scanning for leaks when they
> >   develop something.
> > 
> >     a) The goal is to produce a memory leaks after the scan is done.
> >     b) Latency is more important than false positives
> >     c) min_unref_count = 1
> > 
> > 2) min_unref_count 
> > 
> >   Target: Production servers running kmemleak on some cloud "probe
> >   points", where the service will run for hours/days.
> > 
> >     a) Latency is not important (system is automatically deployed and
> >     tested)
> >     b) False positives is heavily undesirable. It causes an alarm to get
> >     some engineer to investigate.
> >     c) In this case min_unref_count will be super high (>10)
> >       - I.e, just report when you are pretty sure this is a real issue.
> >    
> > Anyway, that's what I'm seeing from my angle. Let me know if I'm way
> > off.
> 
> You are right. If you only ever use min_unref_count of 2, then the first
> option might be alright but for larger numbers, you can't just keep
> scanning 10 times in a row. If option 1 works, we might be able to get
> rid of the transient leak annotations.
> 
> I got Claude to refactor for the first idea and it mostly works. For
> some reason, after modprobe kmemleak-test, it always does the
> confirmation scan. There's an object (vmalloc) left that's reported as
> a potential leak candidate but not confirmed in the subsequent scan.
> I'll check tomorrow, need to finish the day early.

I found the issue. It was the passing of the excess_ref on the
subsequent scan. I thought I could avoid marking gray objects as white
again in the second scan but it messes up the excess_ref since they are
counted only after the object became gray. I had to add a flag,
OBJECT_SUSPECT, since we mark all objects white again for the second
pass. In principle, it's not different from your two scans approach,
only that they are done back to back.

Anyway, a better diff for the first idea below. I need to do more
testing and can turn it into a proper commit (if we don't deem it
redundant because of the other min_unref_count).

FTR, Assisted-by: Claude:claude-opus-4-8.

----------------8<----------------------------
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7c7ba17ce7af..de16c7243847 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -175,6 +175,8 @@ struct kmemleak_object {
 #define OBJECT_PHYS		(1 << 4)
 /* flag set for per-CPU pointers */
 #define OBJECT_PERCPU		(1 << 5)
+/* flag set on an object left unreferenced by the full scan, pending confirmation */
+#define OBJECT_SUSPECT		(1 << 6)
 
 /* set when __remove_object() called */
 #define DELSTATE_REMOVED	(1 << 0)
@@ -1797,13 +1799,11 @@ static void dedup_flush(struct xarray *dedup)
  * kernel's standard allocators. This function must be called with the
  * scan_mutex held.
  */
-static void kmemleak_scan(void)
+static void __kmemleak_scan(bool full)
 {
 	struct kmemleak_object *object;
 	struct zone *zone;
 	int __maybe_unused i;
-	struct xarray dedup;
-	int new_leaks = 0;
 
 	jiffies_last_scan = jiffies;
 
@@ -1904,6 +1904,10 @@ static void kmemleak_scan(void)
 	 */
 	scan_gray_list();
 
+	/* a confirmation scan does not look for modified objects */
+	if (!full)
+		return;
+
 	/*
 	 * Check for new or unreferenced objects modified since the previous
 	 * scan and color them gray until the next scan.
@@ -1935,6 +1939,48 @@ static void kmemleak_scan(void)
 	 * Re-scan the gray list for modified unreferenced objects.
 	 */
 	scan_gray_list();
+}
+
+/*
+ * Mark the objects left unreferenced by the full scan as suspects and return
+ * true if there are any. Only suspects confirmed still unreferenced by the
+ * following scan are reported as leaks.
+ */
+static bool flag_suspects(void)
+{
+	struct kmemleak_object *object;
+	int suspects = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list) {
+		raw_spin_lock_irq(&object->lock);
+		if (unreferenced_object(object) &&
+		    !(object->flags & OBJECT_REPORTED)) {
+			object->flags |= OBJECT_SUSPECT;
+			suspects++;
+		} else {
+			object->flags &= ~OBJECT_SUSPECT;
+		}
+		raw_spin_unlock_irq(&object->lock);
+		if (need_resched())
+			kmemleak_cond_resched(object);
+	}
+	rcu_read_unlock();
+
+	return suspects != 0;
+}
+
+/*
+ * Scan the memory and report the unreferenced objects as leaks. Must be
+ * called with the scan_mutex held.
+ */
+static void kmemleak_scan(void)
+{
+	struct kmemleak_object *object;
+	struct xarray dedup;
+	int new_leaks = 0;
+
+	__kmemleak_scan(true);
 
 	/*
 	 * If scanning was stopped do not report any new unreferenced objects.
@@ -1942,6 +1988,18 @@ static void kmemleak_scan(void)
 	if (scan_should_stop())
 		return;
 
+	/*
+	 * A live object whose only reference is moved by, for example, a
+	 * concurrent RCU update can be missed for one scan and reported as a
+	 * transient false positive. If a leak is suspected, mark again and
+	 * only report the objects left unreferenced by both scans.
+	 */
+	if (flag_suspects()) {
+		__kmemleak_scan(false);
+		if (scan_should_stop())
+			return;
+	}
+
 	/*
 	 * Scanning result reporting. When verbose printing is enabled, dedupe
 	 * by stackdepot trace_handle so each unique backtrace is logged once
@@ -1969,6 +2027,7 @@ static void kmemleak_scan(void)
 		trace_handle = 0;
 		dedup_print = false;
 		if (unreferenced_object(object) &&
+		    (object->flags & OBJECT_SUSPECT) &&
 		    !(object->flags & OBJECT_REPORTED)) {
 			object->flags |= OBJECT_REPORTED;
 			if (kmemleak_verbose) {
