From: akpm@linux-foundation.org
Subject: [merged] idr-explain-warn_on_once-on-negative-ids-out-of-range-id.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:23 -0800
Message-ID: <20130228201623.9891A31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:44178 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3B1UQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:24 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so245443qen.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: explain WARN_ON_ONCE() on negative IDs out-of-range ID
has been removed from the -mm tree.  Its filename was
     idr-explain-warn_on_once-on-negative-ids-out-of-range-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: idr: explain WARN_ON_ONCE() on negative IDs out-of-range ID

Until recently, when an negative ID is specified, idr functions used to
ignore the sign bit and proceeded with the operation with the rest of
bits, which is bizarre and error-prone.  The behavior recently got changed
so that negative IDs are treated as invalid but we're triggering
WARN_ON_ONCE() on negative IDs just in case somebody was depending on the
sign bit being ignored, so that those can be detected and fixed easily.

We only need this for a while.  Explain why WARN_ON_ONCE()s are there and
that they can be removed later.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN lib/idr.c~idr-explain-warn_on_once-on-negative-ids-out-of-range-id lib/idr.c
--- a/lib/idr.c~idr-explain-warn_on_once-on-negative-ids-out-of-range-id
+++ a/lib/idr.c
@@ -569,6 +569,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *p;
 	struct idr_layer *to_free;
 
+	/* see comment in idr_find_slowpath() */
 	if (WARN_ON_ONCE(id < 0))
 		return;
 
@@ -666,6 +667,14 @@ void *idr_find_slowpath(struct idr *idp,
 	int n;
 	struct idr_layer *p;
 
+	/*
+	 * If @id is negative, idr_find() used to ignore the sign bit and
+	 * performed lookup with the rest of bits, which is weird and can
+	 * lead to very obscure bugs.  We're now returning NULL for all
+	 * negative IDs but just in case somebody was depending on the sign
+	 * bit being ignored, let's trigger WARN_ON_ONCE() so that they can
+	 * be detected and fixed.  WARN_ON_ONCE() can later be removed.
+	 */
 	if (WARN_ON_ONCE(id < 0))
 		return NULL;
 
@@ -815,6 +824,7 @@ void *idr_replace(struct idr *idp, void 
 	int n;
 	struct idr_layer *p, *old_p;
 
+	/* see comment in idr_find_slowpath() */
 	if (WARN_ON_ONCE(id < 0))
 		return ERR_PTR(-EINVAL);
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

