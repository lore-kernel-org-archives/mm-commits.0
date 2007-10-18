From: akpm@linux-foundation.org
Subject: + memory-hotplug-make-description-of-memory-hotplug-notifier-in-document.patch added to -mm tree
Date: Wed, 17 Oct 2007 20:47:10 -0700
Message-ID: <200710180347.l9I3lAma023787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762228AbXJRDrO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 23:47:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com


The patch titled
     memory hotplug: document the memory hotplug notifier
has been added to the -mm tree.  Its filename is
     memory-hotplug-make-description-of-memory-hotplug-notifier-in-document.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory hotplug: document the memory hotplug notifier
From: Yasunori Goto <y-goto@jp.fujitsu.com>

Add description about event notification callback routine to the document

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |   58 +++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 3 deletions(-)

diff -puN Documentation/memory-hotplug.txt~memory-hotplug-make-description-of-memory-hotplug-notifier-in-document Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~memory-hotplug-make-description-of-memory-hotplug-notifier-in-document
+++ a/Documentation/memory-hotplug.txt
@@ -2,7 +2,8 @@
 Memory Hotplug
 ==============
 
-Last Updated: Jul 28 2007
+Created:					Jul 28 2007
+Add description of notifier of memory hotplug	Oct 11 2007
 
 This document is about memory hotplug including how-to-use and current status.
 Because Memory Hotplug is still under development, contents of this text will
@@ -24,7 +25,8 @@ be changed often.
   6.1 Memory offline and ZONE_MOVABLE
   6.2. How to offline memory
 7. Physical memory remove
-8. Future Work List
+8. Memory hotplug event notifier
+9. Future Work List
 
 Note(1): x86_64's has special implementation for memory hotplug.
          This text does not describe it.
@@ -307,8 +309,58 @@ Need more implementation yet....
  - Notification completion of remove works by OS to firmware.
  - Guard from remove if not yet.
 
+--------------------------------
+8. Memory hotplug event notifier
+--------------------------------
+Memory hotplug has event notifer. There are 6 types of notification.
+
+MEMORY_GOING_ONLINE
+  Generated before new memory becomes available in order to be able to
+  prepare subsystems to handle memory. The page allocator is still unable
+  to allocate from the new memory.
+
+MEMORY_CANCEL_ONLINE
+  Generated if MEMORY_GOING_ONLINE fails.
+
+MEMORY_ONLINE
+  Generated when memory has succesfully brought online. The callback may
+  allocate pages from the new memory.
+
+MEMORY_GOING_OFFLINE
+  Generated to begin the process of offlining memory. Allocations are no
+  longer possible from the memory but some of the memory to be offlined
+  is still in use. The callback can be used to free memory known to a
+  subsystem from the indicated memory section.
+
+MEMORY_CANCEL_OFFLINE
+  Generated if MEMORY_GOING_OFFLINE fails. Memory is available again from
+  the section that we attempted to offline.
+
+MEMORY_OFFLINE
+  Generated after offlining memory is complete.
+
+A callback routine can be registered by
+  hotplug_memory_notifier(callback_func, priority)
+
+The second argument of callback function (action) is event types of above.
+The third argument is passed by pointer of struct memory_notify.
+
+struct memory_notify {
+       unsigned long start_pfn;
+       unsigned long nr_pages;
+       int status_cahnge_nid;
+}
+
+start_pfn is start_pfn of online/offline memory.
+nr_pages is # of pages of online/offline memory.
+status_change_nid is set node id when N_HIGH_MEMORY of nodemask is (will be)
+set/clear. It means a new(memoryless) node gets new memory by online and a
+node loses all memory. If this is -1, then nodemask status is not changed.
+If status_changed_nid >= 0, callback should create/discard structures for the
+node if necessary.
+
 --------------
-8. Future Work
+9. Future Work
 --------------
   - allowing memory hot-add to ZONE_MOVABLE. maybe we need some switch like
     sysctl or new control file.
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
memory-hotplug-make-description-of-memory-hotplug-notifier-in-document.patch
memory-hotplug-rearrange-patch-for-notifier-of-memory-hotplug.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
