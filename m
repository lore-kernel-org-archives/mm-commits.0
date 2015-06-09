From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2.patch
 added to -mm tree
Date: Tue, 09 Jun 2015 13:21:07 -0700
Message-ID: <55774ab3.ZbTV2WsR94t/sRSc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbFIUVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 16:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2
has been added to the -mm tree.  Its filename is
     mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2

- scan_block() allow_resched logic moved outside the function since the
  interrupts inside kmemleak_lock region are disabled.
- introduced a scan_large_block() function to split large memory blocks
  in MAX_SCAN_SIZE chunks
- redundant object->flags & OBJECT_NO_SCAN check removed

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |   66 ++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 29 deletions(-)

diff -puN mm/kmemleak.c~mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2 mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2
+++ a/mm/kmemleak.c
@@ -1171,24 +1171,18 @@ static int scan_should_stop(void)
  * found to the gray list.
  */
 static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned, int allow_resched)
+		       struct kmemleak_object *scanned)
 {
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
-	unsigned long klflags;
+	unsigned long flags;
 
-	read_lock_irqsave(&kmemleak_lock, klflags);
+	read_lock_irqsave(&kmemleak_lock, flags);
 	for (ptr = start; ptr < end; ptr++) {
 		struct kmemleak_object *object;
-		unsigned long flags;
 		unsigned long pointer;
 
-		if (allow_resched && need_resched()) {
-			read_unlock_irqrestore(&kmemleak_lock, klflags);
-			cond_resched();
-			read_lock_irqsave(&kmemleak_lock, klflags);
-		}
 		if (scan_should_stop())
 			break;
 
@@ -1222,11 +1216,10 @@ static void scan_block(void *_start, voi
 		 * previously acquired in scan_object(). These locks are
 		 * enclosed by scan_mutex.
 		 */
-		spin_lock_irqsave_nested(&object->lock, flags,
-					 SINGLE_DEPTH_NESTING);
+		spin_lock_nested(&object->lock, SINGLE_DEPTH_NESTING);
 		if (!color_white(object)) {
 			/* non-orphan, ignored or new */
-			spin_unlock_irqrestore(&object->lock, flags);
+			spin_unlock(&object->lock);
 			continue;
 		}
 
@@ -1241,13 +1234,25 @@ static void scan_block(void *_start, voi
 			/* put_object() called when removing from gray_list */
 			WARN_ON(!get_object(object));
 			list_add_tail(&object->gray_list, &gray_list);
-			spin_unlock_irqrestore(&object->lock, flags);
-			continue;
 		}
+		spin_unlock(&object->lock);
+	}
+	read_unlock_irqrestore(&kmemleak_lock, flags);
+}
 
-		spin_unlock_irqrestore(&object->lock, flags);
+/*
+ * Scan a large memory block in MAX_SCAN_SIZE chunks to reduce the latency.
+ */
+static void scan_large_block(void *start, void *end)
+{
+	void *next;
+
+	while (start < end) {
+		next = min(start + MAX_SCAN_SIZE, end);
+		scan_block(start, next, NULL);
+		start = next;
+		cond_resched();
 	}
-	read_unlock_irqrestore(&kmemleak_lock, klflags);
 }
 
 /*
@@ -1272,22 +1277,25 @@ static void scan_object(struct kmemleak_
 	if (hlist_empty(&object->area_list)) {
 		void *start = (void *)object->pointer;
 		void *end = (void *)(object->pointer + object->size);
+		void *next;
 
-		while (start < end && (object->flags & OBJECT_ALLOCATED) &&
-		       !(object->flags & OBJECT_NO_SCAN)) {
-			scan_block(start, min(start + MAX_SCAN_SIZE, end),
-				   object, 0);
-			start += MAX_SCAN_SIZE;
+		do {
+			next = min(start + MAX_SCAN_SIZE, end);
+			scan_block(start, next, object);
+
+			start = next;
+			if (start >= end)
+				break;
 
 			spin_unlock_irqrestore(&object->lock, flags);
 			cond_resched();
 			spin_lock_irqsave(&object->lock, flags);
-		}
+		} while (object->flags & OBJECT_ALLOCATED);
 	} else
 		hlist_for_each_entry(area, &object->area_list, node)
 			scan_block((void *)area->start,
 				   (void *)(area->start + area->size),
-				   object, 0);
+				   object);
 out:
 	spin_unlock_irqrestore(&object->lock, flags);
 }
@@ -1364,14 +1372,14 @@ static void kmemleak_scan(void)
 	rcu_read_unlock();
 
 	/* data/bss scanning */
-	scan_block(_sdata, _edata, NULL, 1);
-	scan_block(__bss_start, __bss_stop, NULL, 1);
+	scan_large_block(_sdata, _edata);
+	scan_large_block(__bss_start, __bss_stop);
 
 #ifdef CONFIG_SMP
 	/* per-cpu sections scanning */
 	for_each_possible_cpu(i)
-		scan_block(__per_cpu_start + per_cpu_offset(i),
-			   __per_cpu_end + per_cpu_offset(i), NULL, 1);
+		scan_large_block(__per_cpu_start + per_cpu_offset(i),
+				 __per_cpu_end + per_cpu_offset(i));
 #endif
 
 	/*
@@ -1392,7 +1400,7 @@ static void kmemleak_scan(void)
 			/* only scan if page is in use */
 			if (page_count(page) == 0)
 				continue;
-			scan_block(page, page + 1, NULL, 1);
+			scan_block(page, page + 1, NULL);
 		}
 	}
 	put_online_mems();
@@ -1406,7 +1414,7 @@ static void kmemleak_scan(void)
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			scan_block(task_stack_page(p), task_stack_page(p) +
-				   THREAD_SIZE, NULL, 0);
+				   THREAD_SIZE, NULL);
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
 	}
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
mm-kmemleak-allow-safe-memory-scanning-during-kmemleak-disabling.patch
mm-kmemleak-fix-delete_object_-race-when-called-on-the-same-memory-block.patch
mm-kmemleak-do-not-acquire-scan_mutex-in-kmemleak_do_cleanup.patch
mm-kmemleak-avoid-deadlock-on-the-kmemleak-object-insertion-error-path.patch
mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan.patch
mm-kmemleak-optimise-kmemleak_lock-acquiring-during-kmemleak_scan-v2.patch
linux-next.patch

