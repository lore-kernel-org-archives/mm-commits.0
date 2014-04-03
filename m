From: akpm@linux-foundation.org
Subject: [folded-merged]
 kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:01:33 -0700
Message-ID: <533dcc2d.x6Xy2kD9dtGoa2a6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaDCVBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: [folded-merged] kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4.patch removed from -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:01:33 -0700


The patch titled
     Subject: kmemleak: allow freeing internal objects after kmemleak was disabled
has been removed from the -mm tree.  Its filename was
     kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4.patch

This patch was dropped because it was folded into kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak: allow freeing internal objects after kmemleak was disabled

v4: rephrase the printk string.

v3: Catalin wasn't suggesting to use "off" handler, but he wants to be
    able to read memory leaks even when kmemleak is explicitly disabled.

v2: use "off" handler instead of "clear" handler to do this, suggested
    by Catalin.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kmemleak.txt |   17 ++++++------
 mm/kmemleak.c              |   47 ++++++++++++++++++++---------------
 2 files changed, 36 insertions(+), 28 deletions(-)

diff -puN Documentation/kmemleak.txt~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4 Documentation/kmemleak.txt
--- a/Documentation/kmemleak.txt~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4
+++ a/Documentation/kmemleak.txt
@@ -44,8 +44,7 @@ objects to be reported as orphan.
 Memory scanning parameters can be modified at run-time by writing to the
 /sys/kernel/debug/kmemleak file. The following parameters are supported:
 
-  off		- disable kmemleak, or free all kmemleak objects if kmemleak
-		  has been disabled due to fatal errors. (irreversible).
+  off		- disable kmemleak (irreversible)
   stack=on	- enable the task stacks scanning (default)
   stack=off	- disable the tasks stacks scanning
   scan=on	- start the automatic memory scanning thread (default)
@@ -54,7 +53,8 @@ Memory scanning parameters can be modifi
 		  (default 600, 0 to stop the automatic scanning)
   scan		- trigger a memory scan
   clear		- clear list of current memory leak suspects, done by
-		  marking all current reported unreferenced objects grey
+		  marking all current reported unreferenced objects grey,
+		  or free all kmemleak objects if kmemleak has been disabled.
   dump=<addr>	- dump information about the object found at <addr>
 
 Kmemleak can also be disabled at boot-time by passing "kmemleak=off" on
@@ -124,13 +124,14 @@ Then as usual to get your report with:
 Freeing kmemleak internal objects
 ---------------------------------
 
-To allow access to previously found memory leaks even when an error fatal
-to kmemleak happens, internal kmemleak objects won't be freed in this case.
-Those objects may occupy a large part of physical memory.
+To allow access to previosuly found memory leaks after kmemleak has been
+disabled by the user or due to an fatal error, internal kmemleak objects
+won't be freed when kmemleak is disabled, and those objects may occupy
+a large part of physical memory.
 
-You can reclaim memory from those objects with:
+In this situation, you may reclaim memory with:
 
-  # echo off > /sys/kernel/debug/kmemleak
+  # echo clear > /sys/kernel/debug/kmemleak
 
 Kmemleak API
 ------------
diff -puN mm/kmemleak.c~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4 mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled-v4
+++ a/mm/kmemleak.c
@@ -1600,6 +1600,8 @@ static void kmemleak_clear(void)
 	kmemleak_found_leaks = false;
 }
 
+static void __kmemleak_do_cleanup(void);
+
 /*
  * File write operation to configure kmemleak at run-time. The following
  * commands can be written to the /sys/kernel/debug/kmemleak file:
@@ -1612,7 +1614,8 @@ static void kmemleak_clear(void)
  *		  disable it)
  *   scan	- trigger a memory scan
  *   clear	- mark all current reported unreferenced kmemleak objects as
- *		  grey to ignore printing them
+ *		  grey to ignore printing them, or free all kmemleak objects
+ *		  if kmemleak has been disabled.
  *   dump=...	- dump information about the object found at the given address
  */
 static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
@@ -1631,9 +1634,11 @@ static ssize_t kmemleak_write(struct fil
 	if (ret < 0)
 		return ret;
 
-	if (strncmp(buf, "off", 3) == 0) {
-		stop_scan_thread();
-		kmemleak_disable();
+	if (strncmp(buf, "clear", 5) == 0) {
+		if (atomic_read(&kmemleak_enabled))
+			kmemleak_clear();
+		else
+			__kmemleak_do_cleanup();
 		goto out;
 	}
 
@@ -1642,7 +1647,9 @@ static ssize_t kmemleak_write(struct fil
 		goto out;
 	}
 
-	if (strncmp(buf, "stack=on", 8) == 0)
+	if (strncmp(buf, "off", 3) == 0)
+		kmemleak_disable();
+	else if (strncmp(buf, "stack=on", 8) == 0)
 		kmemleak_stack_scan = 1;
 	else if (strncmp(buf, "stack=off", 9) == 0)
 		kmemleak_stack_scan = 0;
@@ -1663,8 +1670,6 @@ static ssize_t kmemleak_write(struct fil
 		}
 	} else if (strncmp(buf, "scan", 4) == 0)
 		kmemleak_scan();
-	else if (strncmp(buf, "clear", 5) == 0)
-		kmemleak_clear();
 	else if (strncmp(buf, "dump=", 5) == 0)
 		ret = dump_str_object_info(buf + 5);
 	else
@@ -1689,6 +1694,16 @@ static const struct file_operations kmem
 	.release	= kmemleak_release,
 };
 
+static void __kmemleak_do_cleanup(void)
+{
+	struct kmemleak_object *object;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list)
+		delete_object_full(object->pointer);
+	rcu_read_unlock();
+}
+
 /*
  * Stop the memory scanning thread and free the kmemleak internal objects if
  * no previous scan thread (otherwise, kmemleak may still have some useful
@@ -1696,22 +1711,14 @@ static const struct file_operations kmem
  */
 static void kmemleak_do_cleanup(struct work_struct *work)
 {
-	struct kmemleak_object *object;
-
 	mutex_lock(&scan_mutex);
 	stop_scan_thread();
 
-	if (!kmemleak_found_leaks) {
-		rcu_read_lock();
-		list_for_each_entry_rcu(object, &object_list, object_list)
-			delete_object_full(object->pointer);
-		rcu_read_unlock();
-	} else {
-		pr_info("Disable kmemleak without freeing internal objects, "
-			"so you may still check information on memory leak. "
-			"You may reclaim memory by writing \"off\" to "
-			"/sys/kernel/debug/kmemleak\n");
-	}
+	if (!kmemleak_found_leaks)
+		__kmemleak_do_cleanup();
+	else
+		pr_info("Kmemleak disabled without freeing internal data. "
+			"Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\"\n");
 	mutex_unlock(&scan_mutex);
 }
 
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch
kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
kmemleak-remove-redundant-code.patch
kmemleak-change-some-global-variables-to-int.patch
kmemleak-change-some-global-variables-to-int-v4.patch

