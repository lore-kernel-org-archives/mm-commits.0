From: akpm@linux-foundation.org
Subject: [merged] idr-idr_alloc-shouldnt-trigger-lowmem-warning-when-preloaded.patch removed from -mm tree
Date: Thu, 14 Mar 2013 11:52:54 -0700
Message-ID: <20130314185254.7DED531C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:56867 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3CNSwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 14:52:55 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so250881vbb.0
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 11:52:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: idr_alloc() shouldn't trigger lowmem warning when preloaded
has been removed from the -mm tree.  Its filename was
     idr-idr_alloc-shouldnt-trigger-lowmem-warning-when-preloaded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: idr_alloc() shouldn't trigger lowmem warning when preloaded

GFP_NOIO is often used for idr_alloc() inside preloaded section as the
allocation mask doesn't really matter.  If the idr tree needs to be
expanded, idr_alloc() first tries to allocate using the specified
allocation mask and if it fails falls back to the preloaded buffer.  This
order prevent non-preloading idr_alloc() users from taking advantage of
preloading ones by using preload buffer without filling it shifting the
burden of allocation to the preload users.

Unfortunately, this allowed/expected-to-fail kmem_cache allocation ends up
generating spurious slab lowmem warning before succeeding the request from
the preload buffer.

This patch makes idr_layer_alloc() add __GFP_NOWARN to the first
kmem_cache attempt and try kmem_cache again w/o __GFP_NOWARN after
allocation from preload_buffer fails so that lowmem warning is generated
if not suppressed by the original @gfp_mask.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Teigland <teigland@redhat.com>
Tested-by: David Teigland <teigland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff -puN lib/idr.c~idr-idr_alloc-shouldnt-trigger-lowmem-warning-when-preloaded lib/idr.c
--- a/lib/idr.c~idr-idr_alloc-shouldnt-trigger-lowmem-warning-when-preloaded
+++ a/lib/idr.c
@@ -106,8 +106,14 @@ static struct idr_layer *idr_layer_alloc
 	if (layer_idr)
 		return get_from_free_list(layer_idr);
 
-	/* try to allocate directly from kmem_cache */
-	new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
+	/*
+	 * Try to allocate directly from kmem_cache.  We want to try this
+	 * before preload buffer; otherwise, non-preloading idr_alloc()
+	 * users will end up taking advantage of preloading ones.  As the
+	 * following is allowed to fail for preloaded cases, suppress
+	 * warning this time.
+	 */
+	new = kmem_cache_zalloc(idr_layer_cache, gfp_mask | __GFP_NOWARN);
 	if (new)
 		return new;
 
@@ -115,18 +121,24 @@ static struct idr_layer *idr_layer_alloc
 	 * Try to fetch one from the per-cpu preload buffer if in process
 	 * context.  See idr_preload() for details.
 	 */
-	if (in_interrupt())
-		return NULL;
-
-	preempt_disable();
-	new = __this_cpu_read(idr_preload_head);
-	if (new) {
-		__this_cpu_write(idr_preload_head, new->ary[0]);
-		__this_cpu_dec(idr_preload_cnt);
-		new->ary[0] = NULL;
+	if (!in_interrupt()) {
+		preempt_disable();
+		new = __this_cpu_read(idr_preload_head);
+		if (new) {
+			__this_cpu_write(idr_preload_head, new->ary[0]);
+			__this_cpu_dec(idr_preload_cnt);
+			new->ary[0] = NULL;
+		}
+		preempt_enable();
+		if (new)
+			return new;
 	}
-	preempt_enable();
-	return new;
+
+	/*
+	 * Both failed.  Try kmem_cache again w/o adding __GFP_NOWARN so
+	 * that memory allocation failure warning is printed as intended.
+	 */
+	return kmem_cache_zalloc(idr_layer_cache, gfp_mask);
 }
 
 static void idr_layer_rcu_free(struct rcu_head *head)
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
kernel-sysc-use-the-simpler-call_usermodehelper.patch
usermodehelper-export-_exec-and-_setup-functions.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kmod-split-call-to-call_usermodehelper_fns.patch
keys-split-call-to-call_usermodehelper_fns.patch
coredump-remove-trailling-whitespaces.patch
split-remaining-calls-to-call_usermodehelper_fns.patch
kmod-remove-call_usermodehelper_fns.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch

