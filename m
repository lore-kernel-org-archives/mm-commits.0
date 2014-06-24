From: akpm@linux-foundation.org
Subject: [merged]
 mm-hotplug-probe-interface-is-available-on-several-platforms.patch removed
 from -mm tree
Date: Tue, 24 Jun 2014 12:02:13 -0700
Message-ID: <53a9cb35.+IecUIb5hip1JIat%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaFXTCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hotplug: probe interface is available on several platforms
has been removed from the -mm tree.  Its filename was
     mm-hotplug-probe-interface-is-available-on-several-platforms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hotplug: probe interface is available on several platforms

Documentation/memory-hotplug.txt incorrectly states that the memory driver
"probe" interface is only supported on powerpc and is vague about its
application on x86.  Clarify the platforms that make this interface
available if memory hotplug is enabled.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-hotplug.txt |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN Documentation/memory-hotplug.txt~mm-hotplug-probe-interface-is-available-on-several-platforms Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt~mm-hotplug-probe-interface-is-available-on-several-platforms
+++ a/Documentation/memory-hotplug.txt
@@ -209,15 +209,12 @@ If memory device is found, memory hotplu
 
 4.2 Notify memory hot-add event by hand
 ------------
-On powerpc, the firmware does not notify a memory hotplug event to the kernel.
-Therefore, "probe" interface is supported to notify the event to the kernel.
-This interface depends on CONFIG_ARCH_MEMORY_PROBE.
-
-CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
-option is disabled by default since ACPI notifies a memory hotplug event to
-the kernel, which performs its hotplug operation as the result. Please
-enable this option if you need the "probe" interface for testing purposes
-on x86.
+On some architectures, the firmware may not notify the kernel of a memory
+hotplug event.  Therefore, the memory "probe" interface is supported to
+explicitly notify the kernel.  This interface depends on
+CONFIG_ARCH_MEMORY_PROBE and can be configured on powerpc, sh, and x86
+if hotplug is supported, although for x86 this should be handled by ACPI
+notification.
 
 Probe interface is located at
 /sys/devices/system/memory/probe
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
lib-add-size-unit-t-p-e-to-memparse.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-stat-convert-to-single_open_size.patch
fs-seq_file-fallback-to-vmalloc-allocation.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

