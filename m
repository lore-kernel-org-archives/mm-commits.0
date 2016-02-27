From: akpm@linux-foundation.org
Subject: +
 mm-memory-hotplug-print-debug-message-in-the-proper-way-for-online_pages.patch added to -mm tree
Date: Fri, 26 Feb 2016 17:00:41 -0800
Message-ID: <56d0f539.BLooNLfeFd/2aKgE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbcB0BAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 20:00:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slaoub@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory hotplug: print debug message in the proper way for online_pages
has been added to the -mm tree.  Its filename is
     mm-memory-hotplug-print-debug-message-in-the-proper-way-for-online_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-hotplug-print-debug-message-in-the-proper-way-for-online_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-hotplug-print-debug-message-in-the-proper-way-for-online_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: mm, memory hotplug: print debug message in the proper way for online_pages

online_pages() simply returns an error value if
memory_notify(MEM_GOING_ONLINE, &arg) return a value that is not what we
want for successfully onlining target pages.  This patch arms to print
more failure information like offline_pages() in online_pages.

This patch also converts printk(KERN_<LEVEL>) to pr_<level>(), and moves
__offline_pages() to not print failure information with KERN_INFO
according to David Rientjes's suggestion[1].

[1] https://lkml.org/lkml/2016/2/24/1094

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory-hotplug-print-debug-message-in-the-proper-way-for-online_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hotplug-print-debug-message-in-the-proper-way-for-online_pages
+++ a/mm/memory_hotplug.c
@@ -1059,10 +1059,9 @@ int __ref online_pages(unsigned long pfn
 
 	ret = memory_notify(MEM_GOING_ONLINE, &arg);
 	ret = notifier_to_errno(ret);
-	if (ret) {
-		memory_notify(MEM_CANCEL_ONLINE, &arg);
-		return ret;
-	}
+	if (ret)
+		goto failed_addition;
+
 	/*
 	 * If this zone is not populated, then it is not in zonelist.
 	 * This means the page allocator ignores this zone.
@@ -1080,12 +1079,7 @@ int __ref online_pages(unsigned long pfn
 		if (need_zonelists_rebuild)
 			zone_pcp_reset(zone);
 		mutex_unlock(&zonelists_mutex);
-		printk(KERN_DEBUG "online_pages [mem %#010llx-%#010llx] failed\n",
-		       (unsigned long long) pfn << PAGE_SHIFT,
-		       (((unsigned long long) pfn + nr_pages)
-			    << PAGE_SHIFT) - 1);
-		memory_notify(MEM_CANCEL_ONLINE, &arg);
-		return ret;
+		goto failed_addition;
 	}
 
 	zone->present_pages += onlined_pages;
@@ -1118,6 +1112,13 @@ int __ref online_pages(unsigned long pfn
 	if (onlined_pages)
 		memory_notify(MEM_ONLINE, &arg);
 	return 0;
+
+failed_addition:
+	pr_debug("online_pages [mem %#010llx-%#010llx] failed\n",
+		 (unsigned long long) pfn << PAGE_SHIFT,
+		 (((unsigned long long) pfn + nr_pages) << PAGE_SHIFT) - 1);
+	memory_notify(MEM_CANCEL_ONLINE, &arg);
+	return ret;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
@@ -1529,8 +1530,7 @@ do_migrate_range(unsigned long start_pfn
 
 		} else {
 #ifdef CONFIG_DEBUG_VM
-			printk(KERN_ALERT "removing pfn %lx from LRU failed\n",
-			       pfn);
+			pr_alert("removing pfn %lx from LRU failed\n", pfn);
 			dump_page(page, "failed to remove from LRU");
 #endif
 			put_page(page);
@@ -1858,7 +1858,7 @@ repeat:
 		ret = -EBUSY;
 		goto failed_removal;
 	}
-	printk(KERN_INFO "Offlined Pages %ld\n", offlined_pages);
+	pr_info("Offlined Pages %ld\n", offlined_pages);
 	/* Ok, all of our target is isolated.
 	   We cannot do rollback at this point. */
 	offline_isolated_pages(start_pfn, end_pfn);
@@ -1895,9 +1895,9 @@ repeat:
 	return 0;
 
 failed_removal:
-	printk(KERN_INFO "memory offlining [mem %#010llx-%#010llx] failed\n",
-	       (unsigned long long) start_pfn << PAGE_SHIFT,
-	       ((unsigned long long) end_pfn << PAGE_SHIFT) - 1);
+	pr_debug("memory offlining [mem %#010llx-%#010llx] failed\n",
+		 (unsigned long long) start_pfn << PAGE_SHIFT,
+		 ((unsigned long long) end_pfn << PAGE_SHIFT) - 1);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 	/* pushback to free area */
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
_

Patches currently in -mm which might be from slaoub@gmail.com are

mm-memory-hotplug-print-debug-message-in-the-proper-way-for-online_pages.patch

