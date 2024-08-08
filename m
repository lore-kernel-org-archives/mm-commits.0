Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26289473;
	Thu,  8 Aug 2024 01:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081326; cv=none; b=Qj+47oiVq2sG+ZTQgrXqNPh2xBn+o8s5jSnPv/r6vl+V9VluGZPPyEKtv+W7EWptEGW+e4OqyiHvGHaqUEhH4Zv/RBB89HuoVKOX0TH6FgqwG6CViBiQ2P4Nn5oo3FuaWW3cMj8wXndwZ4HTteFlCIQGCQGb3ybQBJ0/fXdizwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081326; c=relaxed/simple;
	bh=Gj8vMxY8eI2uXfyC7yecHkSU/Z4pFWxfGjlbSJ76K6U=;
	h=Date:To:From:Subject:Message-Id; b=DrfAka00lUg6hBk4ZYnmlaGjMx57/oygSMKsAXxPcgPrnxMX8w523IxFTEy8Bims0Z6euwga74pvibjdHlZ8V3+AxSEa/uxGC2NIiLlnXaf/niOlgCVbR7JtKZFizWmUoSLHRfX0R62kBj/UKKtLZ0a9xALzfP5xFRdlcV8oDbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKUEKAHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKUEKAHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3716FC32781;
	Thu,  8 Aug 2024 01:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723081326;
	bh=Gj8vMxY8eI2uXfyC7yecHkSU/Z4pFWxfGjlbSJ76K6U=;
	h=Date:To:From:Subject:From;
	b=RKUEKAHMT2Nm3141mZCc7lxUAVEDhA+3kS0DFq24V50bVlemhUNHOgXXqQVMCVs/Z
	 Y+jzOFkO5UTFuPXuR2aTmeHxnYchUEKMkEw1TQUEd415JxPAnjHCZxC+fpM0mYBndA
	 V0JMl38B9Oc3xLTTd11i1GztxirVqZm8YS+gcg5c=
Date: Wed, 07 Aug 2024 18:42:05 -0700
To: mm-commits@vger.kernel.org,sylv@sylv.io,stern@rowland.harvard.edu,stable@vger.kernel.org,nogikh@google.com,gregkh@linuxfoundation.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kcov-properly-check-for-softirq-context.patch removed from -mm tree
Message-Id: <20240808014206.3716FC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: properly check for softirq context
has been removed from the -mm tree.  Its filename was
     kcov-properly-check-for-softirq-context.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kcov: properly check for softirq context
Date: Mon, 29 Jul 2024 04:21:58 +0200

When collecting coverage from softirqs, KCOV uses in_serving_softirq() to
check whether the code is running in the softirq context.  Unfortunately,
in_serving_softirq() is > 0 even when the code is running in the hardirq
or NMI context for hardirqs and NMIs that happened during a softirq.

As a result, if a softirq handler contains a remote coverage collection
section and a hardirq with another remote coverage collection section
happens during handling the softirq, KCOV incorrectly detects a nested
softirq coverate collection section and prints a WARNING, as reported by
syzbot.

This issue was exposed by commit a7f3813e589f ("usb: gadget: dummy_hcd:
Switch to hrtimer transfer scheduler"), which switched dummy_hcd to using
hrtimer and made the timer's callback be executed in the hardirq context.

Change the related checks in KCOV to account for this behavior of
in_serving_softirq() and make KCOV ignore remote coverage collection
sections in the hardirq and NMI contexts.

This prevents the WARNING printed by syzbot but does not fix the inability
of KCOV to collect coverage from the __usb_hcd_giveback_urb when dummy_hcd
is in use (caused by a7f3813e589f); a separate patch is required for that.

Link: https://lkml.kernel.org/r/20240729022158.92059-1-andrey.konovalov@linux.dev
Fixes: 5ff3b30ab57d ("kcov: collect coverage from interrupts")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: syzbot+2388cdaeb6b10f0c13ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2388cdaeb6b10f0c13ac
Acked-by: Marco Elver <elver@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marcello Sylvester Bauer <sylv@sylv.io>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/kernel/kcov.c~kcov-properly-check-for-softirq-context
+++ a/kernel/kcov.c
@@ -161,6 +161,15 @@ static void kcov_remote_area_put(struct
 	kmsan_unpoison_memory(&area->list, sizeof(area->list));
 }
 
+/*
+ * Unlike in_serving_softirq(), this function returns false when called during
+ * a hardirq or an NMI that happened in the softirq context.
+ */
+static inline bool in_softirq_really(void)
+{
+	return in_serving_softirq() && !in_hardirq() && !in_nmi();
+}
+
 static notrace bool check_kcov_mode(enum kcov_mode needed_mode, struct task_struct *t)
 {
 	unsigned int mode;
@@ -170,7 +179,7 @@ static notrace bool check_kcov_mode(enum
 	 * so we ignore code executed in interrupts, unless we are in a remote
 	 * coverage collection section in a softirq.
 	 */
-	if (!in_task() && !(in_serving_softirq() && t->kcov_softirq))
+	if (!in_task() && !(in_softirq_really() && t->kcov_softirq))
 		return false;
 	mode = READ_ONCE(t->kcov_mode);
 	/*
@@ -849,7 +858,7 @@ void kcov_remote_start(u64 handle)
 
 	if (WARN_ON(!kcov_check_handle(handle, true, true, true)))
 		return;
-	if (!in_task() && !in_serving_softirq())
+	if (!in_task() && !in_softirq_really())
 		return;
 
 	local_lock_irqsave(&kcov_percpu_data.lock, flags);
@@ -991,7 +1000,7 @@ void kcov_remote_stop(void)
 	int sequence;
 	unsigned long flags;
 
-	if (!in_task() && !in_serving_softirq())
+	if (!in_task() && !in_softirq_really())
 		return;
 
 	local_lock_irqsave(&kcov_percpu_data.lock, flags);
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kcov-dont-instrument-lib-find_bitc.patch

