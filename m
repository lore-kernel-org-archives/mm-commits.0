From: akpm@linux-foundation.org
Subject: [merged] idr-remove-warn_on_once-on-negative-ids.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:39 -0700
Message-ID: <20130311201639.6DD425A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36953 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3CKUQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:40 -0400
Received: by mail-vc0-f201.google.com with SMTP id n11so423581vch.4
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, markus@trippelsdorf.de, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: remove WARN_ON_ONCE() on negative IDs
has been removed from the -mm tree.  Its filename was
     idr-remove-warn_on_once-on-negative-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: remove WARN_ON_ONCE() on negative IDs

idr_find(), idr_remove() and idr_replace() used to silently ignore the
sign bit and perform lookup with the rest of the bits.  The weird behavior
has been changed such that negative IDs are treated as invalid.  As the
behavior change was subtle, WARN_ON_ONCE() was added in the hope of
determining who's calling idr functions with negative IDs so that they can
be examined for problems.

Up until now, all two reported cases are ID number coming directly from
userland and getting fed into idr_find() and the warnings seem to cause
more problems than being helpful.  Drop the WARN_ON_ONCE()s.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: <markus@trippelsdorf.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff -puN lib/idr.c~idr-remove-warn_on_once-on-negative-ids lib/idr.c
--- a/lib/idr.c~idr-remove-warn_on_once-on-negative-ids
+++ a/lib/idr.c
@@ -569,8 +569,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
-	/* see comment in idr_find_slowpath() */
-	if (WARN_ON_ONCE(id < 0))
+	if (id < 0)
 		return;
 
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
@@ -667,15 +666,7 @@ void *idr_find_slowpath(struct idr *idp,
 	int n;
 	struct idr_layer *p;
 
-	/*
-	 * If @id is negative, idr_find() used to ignore the sign bit and
-	 * performed lookup with the rest of bits, which is weird and can
-	 * lead to very obscure bugs.  We're now returning NULL for all
-	 * negative IDs but just in case somebody was depending on the sign
-	 * bit being ignored, let's trigger WARN_ON_ONCE() so that they can
-	 * be detected and fixed.  WARN_ON_ONCE() can later be removed.
-	 */
-	if (WARN_ON_ONCE(id < 0))
+	if (id < 0)
 		return NULL;
 
 	p = rcu_dereference_raw(idp->top);
@@ -824,8 +815,7 @@ void *idr_replace(struct idr *idp, void
 	int n;
 	struct idr_layer *p, *old_p;
 
-	/* see comment in idr_find_slowpath() */
-	if (WARN_ON_ONCE(id < 0))
+	if (id < 0)
 		return ERR_PTR(-EINVAL);
 
 	p = idp->top;
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
include-linux-res_counterh-needs-errnoh.patch
thinkpad-acpi-kill-hotkey_thread_mutex.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memblock-add-assertion-for-zero-allocation-alignment.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-use-struct-device-as-the-first-argument-for-devm_rtc_device_register.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-introduce-dump_interrupted.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
coredump-change-wait_for_dump_helpers-to-use-wait_event_interruptible.patch
nfsd-remove-unused-get_new_stid.patch
nfsd-convert-to-idr_alloc.patch
workqueue-convert-to-idr_alloc.patch
mlx4-remove-leftover-idr_pre_get-call.patch
zcache-convert-to-idr_alloc.patch
tidspbridge-convert-to-idr_alloc.patch
idr-deprecate-idr_pre_get-and-idr_get_new.patch

