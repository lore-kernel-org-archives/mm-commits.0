From: akpm@linux-foundation.org
Subject: +
 mm-add-private-lock-to-serialize-memory-hotplug-operations.patch added to
 -mm tree
Date: Tue, 14 Mar 2017 14:49:06 -0700
Message-ID: <58c86552.VfA0pjXNrXjUSoqV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752317AbdCNVtI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2017 17:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, ben@decadent.org.uk, dan.j.williams@intel.com, gerald.schaefer@de.ibm.com, gregkh@linuxfoundation.org, mhocko@suse.com, rafael.j.wysocki@intel.com, schwidefsky@de.ibm.com, sebott@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add private lock to serialize memory hotplug operations
has been added to the -mm tree.  Its filename is
     mm-add-private-lock-to-serialize-memory-hotplug-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-private-lock-to-serialize-memory-hotplug-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-private-lock-to-serialize-memory-hotplug-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: mm: add private lock to serialize memory hotplug operations

Commit bfc8c90139eb ("mem-hotplug: implement get/put_online_mems")
introduced new functions get/put_online_mems() and mem_hotplug_begin/end()
in order to allow similar semantics for memory hotplug like for cpu
hotplug.

The corresponding functions for cpu hotplug are get/put_online_cpus() and
cpu_hotplug_begin/done() for cpu hotplug.

The commit however missed to introduce functions that would serialize
memory hotplug operations like they are done for cpu hotplug with
cpu_maps_update_begin/done().

This basically leaves mem_hotplug.active_writer unprotected and allows
concurrent writers to modify it, which may lead to problems as outlined by
commit f931ab479dd2 ("mm: fix devm_memremap_pages crash, use
mem_hotplug_{begin, done}").

That commit was extended again with commit b5d24fda9c3d ("mm,
devm_memremap_pages: hold device_hotplug lock over mem_hotplug_{begin,
done}") which serializes memory hotplug operations for some call sites by
using the device_hotplug lock.

In addition with commit 3fc21924100b ("mm: validate device_hotplug is held
for memory hotplug") a sanity check was added to mem_hotplug_begin() to
verify that the device_hotplug lock is held.

This in turn triggers the following warning on s390:

WARNING: CPU: 6 PID: 1 at drivers/base/core.c:643 assert_held_device_hotplug+0x4a/0x58
 Call Trace:
  assert_held_device_hotplug+0x40/0x58)
  mem_hotplug_begin+0x34/0xc8
  add_memory_resource+0x7e/0x1f8
  add_memory+0xda/0x130
  add_memory_merged+0x15c/0x178
  sclp_detect_standby_memory+0x2ae/0x2f8
  do_one_initcall+0xa2/0x150
  kernel_init_freeable+0x228/0x2d8
  kernel_init+0x2a/0x140
  kernel_thread_starter+0x6/0xc

One possible fix would be to add more lock_device_hotplug() and
unlock_device_hotplug() calls around each call site of
mem_hotplug_begin/end().  But that would give the device_hotplug lock
additional semantics it better should not have (serialize memory hotplug
operations).

Instead add a new memory_add_remove_lock which has the similar semantics
like cpu_add_remove_lock for cpu hotplug.

To keep things hopefully a bit easier the lock will be locked and unlocked
within the mem_hotplug_begin/end() functions.

Link: http://lkml.kernel.org/r/20170314125226.16779-2-heiko.carstens@de.ibm.com
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c   |    4 ----
 mm/memory_hotplug.c |    6 +++++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/memremap.c~mm-add-private-lock-to-serialize-memory-hotplug-operations kernel/memremap.c
--- a/kernel/memremap.c~mm-add-private-lock-to-serialize-memory-hotplug-operations
+++ a/kernel/memremap.c
@@ -247,11 +247,9 @@ static void devm_memremap_pages_release(
 	align_start = res->start & ~(SECTION_SIZE - 1);
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 
-	lock_device_hotplug();
 	mem_hotplug_begin();
 	arch_remove_memory(align_start, align_size);
 	mem_hotplug_done();
-	unlock_device_hotplug();
 
 	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
 	pgmap_radix_release(res);
@@ -364,11 +362,9 @@ void *devm_memremap_pages(struct device
 	if (error)
 		goto err_pfn_remap;
 
-	lock_device_hotplug();
 	mem_hotplug_begin();
 	error = arch_add_memory(nid, align_start, align_size, true);
 	mem_hotplug_done();
-	unlock_device_hotplug();
 	if (error)
 		goto err_add_memory;
 
diff -puN mm/memory_hotplug.c~mm-add-private-lock-to-serialize-memory-hotplug-operations mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-add-private-lock-to-serialize-memory-hotplug-operations
+++ a/mm/memory_hotplug.c
@@ -125,9 +125,12 @@ void put_online_mems(void)
 
 }
 
+/* Serializes write accesses to mem_hotplug.active_writer. */
+static DEFINE_MUTEX(memory_add_remove_lock);
+
 void mem_hotplug_begin(void)
 {
-	assert_held_device_hotplug();
+	mutex_lock(&memory_add_remove_lock);
 
 	mem_hotplug.active_writer = current;
 
@@ -147,6 +150,7 @@ void mem_hotplug_done(void)
 	mem_hotplug.active_writer = NULL;
 	mutex_unlock(&mem_hotplug.lock);
 	memhp_lock_release();
+	mutex_unlock(&memory_add_remove_lock);
 }
 
 /* add this memory to iomem resource */
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

mm-add-private-lock-to-serialize-memory-hotplug-operations.patch
drivers-core-remove-assert_held_device_hotplug.patch

