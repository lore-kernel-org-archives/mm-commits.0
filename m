From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 kexec-prevent-removal-of-memory-in-use-by-a-loaded-kexec-image.patch
 removed from -mm tree
Date: Mon, 11 May 2020 13:31:20 -0700
Message-ID: <20200511203120.-GPOoWpwn%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbgEKUbX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 16:31:23 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, bhsharma@redhat.com, catalin.marinas@arm.com, david@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, james.morse@arm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, piliu@redhat.com, will@kernel.org


The patch titled
     Subject: kexec: prevent removal of memory in use by a loaded kexec image
has been removed from the -mm tree.  Its filename was
     kexec-prevent-removal-of-memory-in-use-by-a-loaded-kexec-image.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: James Morse <james.morse@arm.com>
Subject: kexec: prevent removal of memory in use by a loaded kexec image

Patch series "kexec/memory_hotplug: Prevent removal and accidental use".

arm64 recently queued support for memory hotremove, which led to some new
corner cases for kexec.

If the kexec segments are loaded for a removable region, that region may
be removed before kexec actually occurs.  This causes the first kernel to
lockup when applying the relocations.  (I've triggered this on x86 too).

The first patch adds a memory notifier for kexec so that it can refuse to
allow in-use regions to be taken offline.

This doesn't solve the problem for arm64, where the new kernel must
initially rely on the data structures from the first boot to describe
memory.  These don't describe hotpluggable memory.  If kexec places the
kernel in one of these regions, it must also provide a DT that describes
the region in which the kernel was mapped as memory.  (and somehow ensure
its always present in the future...)

To prevent this from happening accidentally with unaware user-space,
patches two and three allow arm64 to give these regions a different name.

This is a change in behaviour for arm64 as memory hotadd and hotremove
were added separately.

I haven't tried kdump.  Unaware kdump from user-space probably won't
describe the hotplug regions if the name is different, which saves us from
problems if the memory is no longer present at kdump time, but means the
vmcore is incomplete.


This patch (of 3):

An image loaded for kexec is not stored in place, instead its segments are
scattered through memory, and are re-assembled when needed.  In the
meantime, the target memory may have been removed.

Because mm is not aware that this memory is still in use, it allows it
to be removed.

Add a memory notifier to prevent the removal of memory regions that
overlap with a loaded kexec image segment.  e.g., when triggered from the
Qemu console:

| kexec_core: memory region in use
| memory memory32: Offline failed.

Kexec allows user-space to specify the address that the kexec image
should be loaded to.  Because this memory may be in use, an image
loaded for kexec is not stored in place, instead its segments are
scattered through memory, and are re-assembled when needed.  In the
meantime, the target memory may have been removed.

The target is described by user space during kexec_load() and that user
space - right now - parses /proc/iomem to find applicable system
memory.

Link: http://lkml.kernel.org/r/20200326180730.4754-1-james.morse@arm.com
Link: http://lkml.kernel.org/r/20200326180730.4754-2-james.morse@arm.com
Signed-off-by: James Morse <james.morse@arm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: piliu <piliu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   56 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/kernel/kexec_core.c~kexec-prevent-removal-of-memory-in-use-by-a-loaded-kexec-image
+++ a/kernel/kexec_core.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/kexec.h>
+#include <linux/memory.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
@@ -22,10 +23,12 @@
 #include <linux/elf.h>
 #include <linux/elfcore.h>
 #include <linux/utsname.h>
+#include <linux/notifier.h>
 #include <linux/numa.h>
 #include <linux/suspend.h>
 #include <linux/device.h>
 #include <linux/freezer.h>
+#include <linux/pfn.h>
 #include <linux/pm.h>
 #include <linux/cpu.h>
 #include <linux/uaccess.h>
@@ -1219,3 +1222,56 @@ void __weak arch_kexec_protect_crashkres
 
 void __weak arch_kexec_unprotect_crashkres(void)
 {}
+
+/*
+ * If user-space wants to offline memory that is in use by a loaded kexec
+ * image, it should unload the image first.
+ */
+static int mem_remove_cb(struct notifier_block *nb, unsigned long action,
+			 void *data)
+{
+	int rv = NOTIFY_OK, i;
+	struct memory_notify *arg = data;
+	unsigned long pfn = arg->start_pfn;
+	unsigned long nr_segments, sstart, send;
+	unsigned long end_pfn = arg->start_pfn + arg->nr_pages;
+
+	might_sleep();
+
+	if (action != MEM_GOING_OFFLINE)
+		return NOTIFY_DONE;
+
+	mutex_lock(&kexec_mutex);
+	if (kexec_image) {
+		nr_segments = kexec_image->nr_segments;
+
+		for (i = 0; i < nr_segments; i++) {
+			sstart = PFN_DOWN(kexec_image->segment[i].mem);
+			send = PFN_UP(kexec_image->segment[i].mem +
+				      kexec_image->segment[i].memsz);
+
+			if ((pfn <= sstart && sstart < end_pfn) ||
+			    (pfn <= send && send < end_pfn)) {
+				pr_warn("Memory region in use\n");
+				rv = NOTIFY_BAD;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&kexec_mutex);
+
+	return rv;
+}
+
+static struct notifier_block mem_remove_nb = {
+	.notifier_call = mem_remove_cb,
+};
+
+static int __init register_mem_remove_cb(void)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
+		return register_memory_notifier(&mem_remove_nb);
+
+	return 0;
+}
+device_initcall(register_mem_remove_cb);
_

Patches currently in -mm which might be from james.morse@arm.com are

mm-memory_hotplug-allow-arch-override-of-non-boot-memory-resource-names.patch
arm64-memory-give-hotplug-memory-a-different-resource-name.patch
