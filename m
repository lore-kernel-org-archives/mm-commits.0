From: akpm@linux-foundation.org
Subject: [merged]
 kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:26 -0700
Message-ID: <533f0816.d/yYr/PGXW+FYZBi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDT31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: [merged] kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch removed from -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:26 -0700


The patch titled
     Subject: kmemleak: allow freeing internal objects after kmemleak was disabled
has been removed from the -mm tree.  Its filename was
     kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak: allow freeing internal objects after kmemleak was disabled

Currently if kmemleak is disabled, the kmemleak objects can never be
freed, no matter if it's disabled by a user or due to fatal errors.

Those objects can be a big waste of memory.

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
1200264 1197433  99%    0.30K  46164       26    369312K kmemleak_object

With this patch, after kmemleak was disabled you can reclaim memory with:

	# echo clear > /sys/kernel/debug/kmemleak

Also inform users about this with a printk.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kmemleak.txt |   15 ++++++++++-
 mm/kmemleak.c              |   46 ++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 15 deletions(-)

diff -puN Documentation/kmemleak.txt~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled Documentation/kmemleak.txt
--- a/Documentation/kmemleak.txt~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled
+++ a/Documentation/kmemleak.txt
@@ -53,7 +53,8 @@ Memory scanning parameters can be modifi
 		  (default 600, 0 to stop the automatic scanning)
   scan		- trigger a memory scan
   clear		- clear list of current memory leak suspects, done by
-		  marking all current reported unreferenced objects grey
+		  marking all current reported unreferenced objects grey,
+		  or free all kmemleak objects if kmemleak has been disabled.
   dump=<addr>	- dump information about the object found at <addr>
 
 Kmemleak can also be disabled at boot-time by passing "kmemleak=off" on
@@ -120,6 +121,18 @@ Then as usual to get your report with:
 
   # cat /sys/kernel/debug/kmemleak
 
+Freeing kmemleak internal objects
+---------------------------------
+
+To allow access to previosuly found memory leaks after kmemleak has been
+disabled by the user or due to an fatal error, internal kmemleak objects
+won't be freed when kmemleak is disabled, and those objects may occupy
+a large part of physical memory.
+
+In this situation, you may reclaim memory with:
+
+  # echo clear > /sys/kernel/debug/kmemleak
+
 Kmemleak API
 ------------
 
diff -puN mm/kmemleak.c~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled
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
@@ -1622,9 +1625,6 @@ static ssize_t kmemleak_write(struct fil
 	int buf_size;
 	int ret;
 
-	if (!atomic_read(&kmemleak_enabled))
-		return -EBUSY;
-
 	buf_size = min(size, (sizeof(buf) - 1));
 	if (strncpy_from_user(buf, user_buf, buf_size) < 0)
 		return -EFAULT;
@@ -1634,6 +1634,19 @@ static ssize_t kmemleak_write(struct fil
 	if (ret < 0)
 		return ret;
 
+	if (strncmp(buf, "clear", 5) == 0) {
+		if (atomic_read(&kmemleak_enabled))
+			kmemleak_clear();
+		else
+			__kmemleak_do_cleanup();
+		goto out;
+	}
+
+	if (!atomic_read(&kmemleak_enabled)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	if (strncmp(buf, "off", 3) == 0)
 		kmemleak_disable();
 	else if (strncmp(buf, "stack=on", 8) == 0)
@@ -1657,8 +1670,6 @@ static ssize_t kmemleak_write(struct fil
 		}
 	} else if (strncmp(buf, "scan", 4) == 0)
 		kmemleak_scan();
-	else if (strncmp(buf, "clear", 5) == 0)
-		kmemleak_clear();
 	else if (strncmp(buf, "dump=", 5) == 0)
 		ret = dump_str_object_info(buf + 5);
 	else
@@ -1683,6 +1694,16 @@ static const struct file_operations kmem
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
@@ -1690,17 +1711,14 @@ static const struct file_operations kmem
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
kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch
linux-next.patch

