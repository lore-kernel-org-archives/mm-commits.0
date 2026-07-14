Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFE81A3160
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 00:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989457; cv=none; b=H/vZ1KtwcM4FQPll5gGwsKtQqI6YCdOzgf6b6gQld0vQakV8gdAiaVU8HaLgJhZnPrJW7A3IKF6+1uxpqS1CGXgkZlvhUEg4K77FepIjJwjicxPP3b5Nvg3Br5FQ0Zb03snhFc9qRfcJTGJ3vLO8IoYh+iYdZLlVaCMUZrlRAMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989457; c=relaxed/simple;
	bh=d7mE4jiCgioR9McponX3VHub+3tGhGdsUu5TRUYdaBc=;
	h=Date:To:From:Subject:Message-Id; b=DWEU7V6HeqiysNoUJvYirePPtUxr0Wcy8ertxyMHXlonpOiYZsIbrzMRjffREWE0au8JbSTFEVWumC3CFCA8Sz3R0N9Xrfr54dV7Pwsue/ysGEqlhyZ6eXrnW8K2q2HGeuk+W8OStzXEVdpH0a770ULTgppemj3pvbd8TDODvbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FZlOixY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FZlOixY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B261F000E9;
	Tue, 14 Jul 2026 00:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783989455;
	bh=xSeQWqtVRYahORRrEpAmMbqAow3YfIVMknugJuAjrpY=;
	h=Date:To:From:Subject;
	b=FZlOixY9M44xPjYNmtTDnDwsPsqGHqn86FLCujbRkFe4a3iOQtOZyYmIl4BhE/CRC
	 pbJQv+Sdq7Zz/ZuEimypIXMBiAy7lGLfwA+iDyorm90ThRdaJEfNY2zSBEeavOr5co
	 T4jNlkEmPjMz/V9uGquYkhNvqDInQRI2q3fW1siw=
Date: Mon, 13 Jul 2026 17:37:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leitao@debian.org,geert@linux-m68k.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-confirm-suspected-leaks-with-a-second-scan.patch added to mm-new branch
Message-Id: <20260714003735.72B261F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: confirm suspected leaks with a second scan
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-confirm-suspected-leaks-with-a-second-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-confirm-suspected-leaks-with-a-second-scan.patch

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
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: confirm suspected leaks with a second scan
Date: Mon, 13 Jul 2026 04:48:04 -0700

Patch series "mm: kmemleak: reduce transient false positives by confirming
leaks".

This series combines two kmemleak enhancements that were originally
submitted separately but both required rebasing after commit 79c37ae3733e9
("mm/kmemleak: fix checksum computation for per-cpu objects").

The first feature introduces a second scan to confirm suspected leaks:

        https://lore.kernel.org/all/20260709173347.689607-1-catalin.marinas@arm.com/

The second feature adds a module parameter controlling the minimum number
of consecutive unreferenced scans before a leak is reported, as discussed
in:

        https://lore.kernel.org/all/20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org/

Changes from v1:
Now that commit 79c37ae3733e9 is upstream, the selftest includes an additional
priming phase scan as requested by Catalin.

Additionally, I've factored out the leak-detection conditional into a helper
function to be more digestible for the reader's eye.

This 4-patch series resolves all outstanding kmemleak issues I've been
tracking.


This patch (of 4):

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

Link: https://lore.kernel.org/20260713-catalin_pto-v1-0-5b93b1131089@debian.org
Link: https://lore.kernel.org/20260713-catalin_pto-v1-1-5b93b1131089@debian.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   57 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

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
@@ -1844,16 +1853,16 @@ static void dedup_flush(struct xarray *d
  * kernel's standard allocators. This function must be called with the
  * scan_mutex held.
  */
-static void kmemleak_scan(void)
+static int __kmemleak_scan(bool full)
 {
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

mm-kmemleak-confirm-suspected-leaks-with-a-second-scan.patch

