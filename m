Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D0725A359
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 16:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355136; cv=none; b=qpqDJ1nqItYel3rlWOul9EPRW6duW9+EJB1ektl8hWDM6C9Tem2Z9YP7Bl+SXPN3CpOKIwXtDKI3RMFR0g2JvjGN25TQEkafQ5/tHeiRWGZUJFk1KDrFUt+wbx7RbXFL8sijyB5JExIv6PPcSQyemyZnlbqG/OKl8AoC6A+kldw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355136; c=relaxed/simple;
	bh=Otrd1JMfZ/m54T/KQTOYK39BQi8xyaru4GeZ/LtDNME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nih3rlDa/9daMaqHPiLAJZUXJmI1HFgzM/kvPSpdlh5gLR75W6XwxZNWOKsrwQGsfTL/IJbC4YL6ludkVu597BIfa6NOwL4MKwwf2LQbb839SMTqrIYvcuFSFAMNwGPnSyakgwwQ9A2IgPN/o7mJ1rkAaUsEUZgfrM19c2C8PDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X8CwmnzH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X8CwmnzH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB2421713;
	Mon,  6 Jul 2026 09:25:23 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14BDC3F905;
	Mon,  6 Jul 2026 09:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783355128; bh=Otrd1JMfZ/m54T/KQTOYK39BQi8xyaru4GeZ/LtDNME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X8CwmnzHvTnP4L5uQ1gpTaCm3G7oaAPXMK96Dv4cui9LWTjdT2INAv4V10nFUVeN2
	 wrVcnyTusQsOteRg/tT4jaT+ZngbI7j1KAWw6WDwteSpQL1lXItJ1SqXnT7TfkUU/g
	 IlfZRPR7oJ9JcRJR5lEIISoAcQMc4jXcm+3ueRDY=
Date: Mon, 6 Jul 2026 17:25:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	mm-commits@vger.kernel.org, kent.overstreet@linux.dev,
	bigeasy@linutronix.de, arnd@arndb.de
Subject: Re: +
 radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
 added to mm-new branch
Message-ID: <akvW9RwjVmRnNzHM@arm.com>
References: <20260705021240.79E101F000E9@smtp.kernel.org>
 <ako1sMPVu4dfQR4K@casper.infradead.org>
 <akuFSv7JaXo6M8gx@gmail.com>
 <akuT8pEjBKvByPlA@arm.com>
 <akuzsny_3EpxaPww@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akuzsny_3EpxaPww@gmail.com>

On Mon, Jul 06, 2026 at 07:53:30AM -0700, Breno Leitao wrote:
> On Mon, Jul 06, 2026 at 12:39:30PM +0100, Catalin Marinas wrote:
> > I wonder whether we should force the scanning to happen twice in a row
> > and drop the min_unref_count. Those transient leaks happen because of
> > some micro/milliseconds miss of a pointer. If we have new white objects
> > of the end of a scan, go one more round through the root and gray
> > objects (but do not reset them to white) and only then report the leaks.
> > If the white objects have been reported already or we don't have any
> > left, skip this additional scan or bail out early. We could have a
> > tunable for this one to go 2-3 times if needed, though I guess twice is
> > sufficient. The interface is also preserved as you do an echo scan only
> > once (or twice initially with the checksum calculation).
> 
> That is a good proposal, and I am happy to hack it up.
> 
> On the other side, I _think_ we want to have both approaches
> (your rescan-after-white) and min_unref_count. They serve different
> purposes. This is how I see them serving different purposes:
> 
> 1) This rescan-after-white proposal:
> 
>   Target: Developers that cat manually scanning for leaks when they
>   develop something.
> 
>     a) The goal is to produce a memory leaks after the scan is done.
>     b) Latency is more important than false positives
>     c) min_unref_count = 1
> 
> 2) min_unref_count 
> 
>   Target: Production servers running kmemleak on some cloud "probe
>   points", where the service will run for hours/days.
> 
>     a) Latency is not important (system is automatically deployed and
>     tested)
>     b) False positives is heavily undesirable. It causes an alarm to get
>     some engineer to investigate.
>     c) In this case min_unref_count will be super high (>10)
>       - I.e, just report when you are pretty sure this is a real issue.
>    
> Anyway, that's what I'm seeing from my angle. Let me know if I'm way
> off.

You are right. If you only ever use min_unref_count of 2, then the first
option might be alright but for larger numbers, you can't just keep
scanning 10 times in a row. If option 1 works, we might be able to get
rid of the transient leak annotations.

I got Claude to refactor for the first idea and it mostly works. For
some reason, after modprobe kmemleak-test, it always does the
confirmation scan. There's an object (vmalloc) left that's reported as
a potential leak candidate but not confirmed in the subsequent scan.
I'll check tomorrow, need to finish the day early.

Pasting the diff I was playing with below for reference (with some debug
printks):

---------------8<--------------------
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 7c7ba17ce7af..fad0a01ddbcf 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1797,13 +1797,13 @@ static void dedup_flush(struct xarray *dedup)
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
+
+	printk("### %s scan started\n", full ? "full" : "confirmation");
 
 	jiffies_last_scan = jiffies;
 
@@ -1833,8 +1833,13 @@ static void kmemleak_scan(void)
 				__paint_it(object, KMEMLEAK_BLACK);
 		}
 
-		/* reset the reference count (whiten the object) */
-		object->count = 0;
+		/*
+		 * Reset the reference count (whiten the object). A confirmation
+		 * scan re-tests only the objects still white, keeping (and
+		 * re-scanning) the references already found by the full scan.
+		 */
+		if (full || color_white(object))
+			object->count = 0;
 		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
 
@@ -1904,6 +1909,10 @@ static void kmemleak_scan(void)
 	 */
 	scan_gray_list();
 
+	/* a confirmation scan does not look for modified objects */
+	if (!full)
+		return;
+
 	/*
 	 * Check for new or unreferenced objects modified since the previous
 	 * scan and color them gray until the next scan.
@@ -1935,6 +1944,47 @@ static void kmemleak_scan(void)
 	 * Re-scan the gray list for modified unreferenced objects.
 	 */
 	scan_gray_list();
+}
+
+/*
+ * Return true if the last scan left any object that would be reported as a
+ * leak. Racy: it only gates the optional confirmation scan.
+ */
+static bool kmemleak_has_candidates(void)
+{
+	struct kmemleak_object *object;
+	int candidates = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list) {
+		if (unreferenced_object(object) &&
+		    !(object->flags & OBJECT_REPORTED)) {
+			candidates++;
+			printk("### candidate 0x%px size %zu comm %s\n",
+			       (void *)object->pointer, object->size,
+			       object->comm);
+		}
+		if (need_resched())
+			kmemleak_cond_resched(object);
+	}
+	rcu_read_unlock();
+
+	printk("### has_candidates: %d\n", candidates);
+	return candidates != 0;
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
+	printk("### ===== scan start =====\n");
+	__kmemleak_scan(true);
 
 	/*
 	 * If scanning was stopped do not report any new unreferenced objects.
@@ -1942,6 +1992,20 @@ static void kmemleak_scan(void)
 	if (scan_should_stop())
 		return;
 
+	/*
+	 * The marking phase is not atomic: a live object whose only reference
+	 * is moved by a concurrent RCU update can be missed for one scan and
+	 * reported as a transient false positive. If a leak is suspected, mark
+	 * again keeping the references already found; an object referenced by
+	 * either scan is not reported, a genuine leak (white in both) still is.
+	 */
+	if (kmemleak_has_candidates()) {
+		printk("### running confirmation scan\n");
+		__kmemleak_scan(false);
+		if (scan_should_stop())
+			return;
+	}
+
 	/*
 	 * Scanning result reporting. When verbose printing is enabled, dedupe
 	 * by stackdepot trace_handle so each unique backtrace is logged once
@@ -1971,6 +2035,9 @@ static void kmemleak_scan(void)
 		if (unreferenced_object(object) &&
 		    !(object->flags & OBJECT_REPORTED)) {
 			object->flags |= OBJECT_REPORTED;
+			printk("### reported 0x%px size %zu comm %s\n",
+			       (void *)object->pointer, object->size,
+			       object->comm);
 			if (kmemleak_verbose) {
 				trace_handle = object->trace_handle;
 				dedup_print = true;
