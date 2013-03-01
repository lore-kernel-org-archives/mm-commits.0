From: akpm@linux-foundation.org
Subject: + idr-remove-warn_on_once-on-negative-ids.patch added to -mm tree
Date: Fri, 01 Mar 2013 13:47:31 -0800
Message-ID: <20130301214731.93E865A40AC@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:35678 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3CAVrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Mar 2013 16:47:32 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so385246ghb.2
        for <mm-commits@vger.kernel.org>; Fri, 01 Mar 2013 13:47:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, markus@trippelsdorf.de


The patch titled
     Subject: idr: remove WARN_ON_ONCE() on negative IDs
has been added to the -mm tree.  Its filename is
     idr-remove-warn_on_once-on-negative-ids.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
linux-next.patch
idr-remove-warn_on_once-on-negative-ids.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
rtc-add-devm_rtc_device_registerunregister.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch

