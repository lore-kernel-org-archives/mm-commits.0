From: akpm@linux-foundation.org
Subject: +
 kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
 added to -mm tree
Date: Fri, 21 Mar 2014 14:30:11 -0700
Message-ID: <532caf63.eaT+mfz6PwWed4YZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaCUVaM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Mar 2014 17:30:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: + kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch added to -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com
From: akpm@linux-foundation.org
Date: Fri, 21 Mar 2014 14:30:11 -0700


The patch titled
     Subject: kmemleak: allow freeing internal objects after kmemleak was disabled
has been added to the -mm tree.  Its filename is
     kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak: allow freeing internal objects after kmemleak was disabled

Currently if kmemleak is disabled, the kmemleak objects can never be
freed, no matter if it's disabled by a user or due to fatal errors.

Those objects can be a big waste of memory.

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
1200264 1197433  99%    0.30K  46164       26    369312K kmemleak_object

With this patch, internal objects will be freed immediately if kmemleak is
disabled explicitly by a user.  If it's disabled due to a kmemleak error,
The user will be informed, and then he/she can reclaim memory with:

	# echo off > /sys/kernel/debug/kmemleak

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kmemleak.txt |   14 +++++++++++++-
 mm/kmemleak.c              |   21 ++++++++++++++++-----
 2 files changed, 29 insertions(+), 6 deletions(-)

diff -puN Documentation/kmemleak.txt~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled Documentation/kmemleak.txt
--- a/Documentation/kmemleak.txt~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled
+++ a/Documentation/kmemleak.txt
@@ -44,7 +44,8 @@ objects to be reported as orphan.
 Memory scanning parameters can be modified at run-time by writing to the
 /sys/kernel/debug/kmemleak file. The following parameters are supported:
 
-  off		- disable kmemleak (irreversible)
+  off		- disable kmemleak, or free all kmemleak objects if kmemleak
+		  has been disabled due to fatal errors. (irreversible).
   stack=on	- enable the task stacks scanning (default)
   stack=off	- disable the tasks stacks scanning
   scan=on	- start the automatic memory scanning thread (default)
@@ -120,6 +121,17 @@ Then as usual to get your report with:
 
   # cat /sys/kernel/debug/kmemleak
 
+Freeing kmemleak internal objects
+---------------------------------
+
+To allow access to previously found memory leaks even when an error fatal
+to kmemleak happens, internal kmemleak objects won't be freed in this case.
+Those objects may occupy a large part of physical memory.
+
+You can reclaim memory from those objects with:
+
+  # echo off > /sys/kernel/debug/kmemleak
+
 Kmemleak API
 ------------
 
diff -puN mm/kmemleak.c~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled
+++ a/mm/kmemleak.c
@@ -1616,9 +1616,6 @@ static ssize_t kmemleak_write(struct fil
 	int buf_size;
 	int ret;
 
-	if (!atomic_read(&kmemleak_enabled))
-		return -EBUSY;
-
 	buf_size = min(size, (sizeof(buf) - 1));
 	if (strncpy_from_user(buf, user_buf, buf_size) < 0)
 		return -EFAULT;
@@ -1628,9 +1625,18 @@ static ssize_t kmemleak_write(struct fil
 	if (ret < 0)
 		return ret;
 
-	if (strncmp(buf, "off", 3) == 0)
+	if (strncmp(buf, "off", 3) == 0) {
+		stop_scan_thread();
 		kmemleak_disable();
-	else if (strncmp(buf, "stack=on", 8) == 0)
+		goto out;
+	}
+
+	if (!atomic_read(&kmemleak_enabled)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (strncmp(buf, "stack=on", 8) == 0)
 		kmemleak_stack_scan = 1;
 	else if (strncmp(buf, "stack=off", 9) == 0)
 		kmemleak_stack_scan = 0;
@@ -1695,6 +1701,11 @@ static void kmemleak_do_cleanup(struct w
 		list_for_each_entry_rcu(object, &object_list, object_list)
 			delete_object_full(object->pointer);
 		rcu_read_unlock();
+	} else {
+		pr_info("Disable kmemleak without freeing internal objects, "
+			"so you may still check information on memory leak. "
+			"You may reclaim memory by writing \"off\" to "
+			"/sys/kernel/debug/kmemleak\n");
 	}
 	mutex_unlock(&scan_mutex);
 }
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
kmemleak-remove-redundant-code.patch
kmemleak-change-some-global-variables-to-int.patch
kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch
linux-next.patch

