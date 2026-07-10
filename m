Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A93F30FF2A
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 03:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783653201; cv=none; b=sXVT1vtDlR2rswD4J0nO3ddPccdyPNv6jc1LTImTpbd2ld0dK+oicSPeCmy1B0RMlyUN9cM1luJAe4LAeqOnQAG8kYRT6zM2M368W25kYufd+IKUCq44UGF83VoXKoKM3dRHva3G5knCyaCZvXDw25fDfcDiResAgfEwx7ttycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783653201; c=relaxed/simple;
	bh=EmW4ODr736n+YZUI3dxliuQCRE8WXLx/vUHrCn98mws=;
	h=Date:To:From:Subject:Message-Id; b=Gah6Zi7djhonkXBHFYieW/rL+WkLWcmlNUD5i02xMpmQW1JUe10V/knif/c6xDI3u6TET+c3U1NfEzKX4b92q8RMnkkNVhODwI9VSfSC5RPpDYQbXheOjFuCnUgu0cLJnDFunHtLO9Wx8Y6bdkpbC5HyBuFTjg2x3yafDBr98jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TyRqMjg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TyRqMjg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7651F000E9;
	Fri, 10 Jul 2026 03:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783653199;
	bh=1lY0xUDXmD16w1CzkyGnANCTQTsAgrIM0E8TIfAYVXo=;
	h=Date:To:From:Subject;
	b=TyRqMjg5wQzUxoewJTfbDL1diR9aCwUmPrUGqMAtTTdEF2t1YUKK33GGUd8ccDrL/
	 4IGTK3bKG+W7kwIV4wJV5XRtkHxXBjYXWt4CKyfbp/rs/q2adVxANDRMGqnF4+0UgY
	 t535grErpXVGz/CHrmqBPKPdRlaLAS1t7XxEhfes=
Date: Thu, 09 Jul 2026 20:13:19 -0700
To: mm-commits@vger.kernel.org,leitao@debian.org,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-kmemleak-confirm-suspected-leaks-with-a-second-scan.patch removed from -mm tree
Message-Id: <20260710031319.AC7651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: confirm suspected leaks with a second scan
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-confirm-suspected-leaks-with-a-second-scan.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: confirm suspected leaks with a second scan
Date: Thu, 9 Jul 2026 18:24:47 +0100

The kmemleak marking phase is not atomic.  While the object graph is
traversed, the kernel can modify pointers, free objects or allocate new
ones.  If a reference to an object is moved from one location to another,
kmemleak scanning may miss it.  We have explicit annotations like
kmemleak_transient_leak() but identifying and maintaining them is not
trivial.

Given that such transient leaks are short-lived, rather than just
reporting such objects as leaks, do another scan to confirm the suspected
objects.  If no new leaks are found during the first scan, skip the
confirmation one.

Link: https://lore.kernel.org/20260709173347.689607-1-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Assisted-by: Claude:claude-opus-4-8
Cc: Breno Leitao <leitao@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-confirm-suspected-leaks-with-a-second-scan
+++ a/mm/kmemleak.c
@@ -175,6 +175,8 @@ struct kmemleak_object {
 #define OBJECT_PHYS		(1 << 4)
 /* flag set for per-CPU pointers */
 #define OBJECT_PERCPU		(1 << 5)
+/* flag set on an object left unreferenced by the full scan, pending confirmation */
+#define OBJECT_SUSPECT		(1 << 6)
 
 /* set when __remove_object() called */
 #define DELSTATE_REMOVED	(1 << 0)
@@ -235,6 +237,8 @@ static unsigned long jiffies_min_age;
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
 static unsigned long jiffies_scan_wait;
+/* number of objects flagged OBJECT_SUSPECT during the current scan */
+static int nr_suspects;
 /* enables or disables the task stacks scanning */
 static int kmemleak_stack_scan = 1;
 /* protects the memory scanning, parameters and debug/kmemleak file access */
@@ -1440,6 +1444,11 @@ static void update_refs(struct kmemleak_
 	 */
 	object->count++;
 	if (color_gray(object)) {
+		/* referenced after all, no longer a suspect */
+		if (object->flags & OBJECT_SUSPECT) {
+			object->flags &= ~OBJECT_SUSPECT;
+			nr_suspects--;
+		}
 		/* put_object() called when removing from gray_list */
 		WARN_ON(!get_object(object));
 		list_add_tail(&object->gray_list, &gray_list);
@@ -1849,11 +1858,11 @@ static void kmemleak_scan(void)
 	struct kmemleak_object *object;
 	struct zone *zone;
 	int __maybe_unused i;
-	struct xarray dedup;
-	int new_leaks = 0;
 	int stop = 0;
 
 	jiffies_last_scan = jiffies;
+	if (full)
+		nr_suspects = 0;
 
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
@@ -1883,6 +1892,8 @@ static void kmemleak_scan(void)
 
 		/* reset the reference count (whiten the object) */
 		object->count = 0;
+		if (full)
+			object->flags &= ~OBJECT_SUSPECT;
 		if (color_gray(object) && get_object(object))
 			list_add_tail(&object->gray_list, &gray_list);
 
@@ -1950,6 +1961,10 @@ static void kmemleak_scan(void)
 scan_gray:
 	scan_gray_list();
 
+	/* a confirmation scan does not look for modified objects */
+	if (!full)
+		return nr_suspects;
+
 	/*
 	 * Check for new or unreferenced objects modified since the previous
 	 * scan and color them gray until the next scan.
@@ -1972,6 +1987,11 @@ scan_gray:
 			/* color it gray temporarily */
 			object->count = object->min_count;
 			list_add_tail(&object->gray_list, &gray_list);
+		} else if (unreferenced_object(object) &&
+			   !(object->flags & OBJECT_REPORTED)) {
+			/* flag the objects left unreferenced by this scan */
+			object->flags |= OBJECT_SUSPECT;
+			nr_suspects++;
 		}
 		raw_spin_unlock_irq(&object->lock);
 	}
@@ -1982,6 +2002,26 @@ scan_gray:
 	 */
 	scan_gray_list();
 
+	return nr_suspects;
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
+	/*
+	 * Full scan. Objects left unreferenced are flagged OBJECT_SUSPECT and
+	 * counted in the return value; nothing to confirm or report otherwise.
+	 */
+	if (!__kmemleak_scan(true))
+		return;
+
 	/*
 	 * If scanning was stopped do not report any new unreferenced objects.
 	 */
@@ -1989,6 +2029,16 @@ scan_gray:
 		return;
 
 	/*
+	 * A live object whose only reference is moved by, for example, a
+	 * concurrent RCU update can be missed for one scan and reported as a
+	 * transient false positive. Scan again and only report the objects
+	 * left unreferenced (still flagged OBJECT_SUSPECT) by both scans.
+	 */
+	__kmemleak_scan(false);
+	if (scan_should_stop())
+		return;
+
+	/*
 	 * Scanning result reporting. When verbose printing is enabled, dedupe
 	 * by stackdepot trace_handle so each unique backtrace is logged once
 	 * per scan, annotated with the number of objects that share it. The
@@ -2015,6 +2065,7 @@ scan_gray:
 		trace_handle = 0;
 		dedup_print = false;
 		if (unreferenced_object(object) &&
+		    (object->flags & OBJECT_SUSPECT) &&
 		    !(object->flags & OBJECT_REPORTED)) {
 			object->flags |= OBJECT_REPORTED;
 			if (kmemleak_verbose) {
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


