Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE7EE7734E
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbjI3AVr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbjI3AVb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8871B4;
        Fri, 29 Sep 2023 17:21:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8161C433C9;
        Sat, 30 Sep 2023 00:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033289;
        bh=KWCr9dYQNzeQe6FCZub4/z6A8j+mp/OhQUm5ZVb38Uo=;
        h=Date:To:From:Subject:From;
        b=bOXTHTFpBHX6DRokhqQBBDPz1/C1ne45jK0niWgqASeAXxHBAnIQIddD1Lg9zByX1
         tWbPHFTcrsmIWj1PrV6RL0HFL8WqY0tzlHoh1vJ+hwFivgFvPFdBoi0vX5ErAOLM0V
         zf4GZCRIuEMafgkJ+EpuAOCn/Zy869zWI8JtwJoM=
Date:   Fri, 29 Sep 2023 17:21:29 -0700
To:     mm-commits@vger.kernel.org, vschneid@redhat.com,
        stable@vger.kernel.org, sourabhjain@linux.ibm.com,
        eric.devolder@oracle.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] crash-add-lock-to-serialize-crash-hotplug-handling.patch removed from -mm tree
Message-Id: <20230930002129.A8161C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Crash: add lock to serialize crash hotplug handling
has been removed from the -mm tree.  Its filename was
     crash-add-lock-to-serialize-crash-hotplug-handling.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: Crash: add lock to serialize crash hotplug handling
Date: Tue, 26 Sep 2023 20:09:05 +0800

Eric reported that handling corresponding crash hotplug event can be
failed easily when many memory hotplug event are notified in a short
period.  They failed because failing to take __kexec_lock.

=======
[   78.714569] Fallback order for Node 0: 0
[   78.714575] Built 1 zonelists, mobility grouping on.  Total pages: 1817886
[   78.717133] Policy zone: Normal
[   78.724423] crash hp: kexec_trylock() failed, elfcorehdr may be inaccurate
[   78.727207] crash hp: kexec_trylock() failed, elfcorehdr may be inaccurate
[   80.056643] PEFILE: Unsigned PE binary
=======

The memory hotplug events are notified very quickly and very many, while
the handling of crash hotplug is much slower relatively.  So the atomic
variable __kexec_lock and kexec_trylock() can't guarantee the
serialization of crash hotplug handling.

Here, add a new mutex lock __crash_hotplug_lock to serialize crash hotplug
handling specifically.  This doesn't impact the usage of __kexec_lock.

Link: https://lkml.kernel.org/r/20230926120905.392903-1-bhe@redhat.com
Fixes: 247262756121 ("crash: add generic infrastructure for crash hotplug support")
Signed-off-by: Baoquan He <bhe@redhat.com>
Tested-by: Eric DeVolder <eric.devolder@oracle.com>
Reviewed-by: Eric DeVolder <eric.devolder@oracle.com>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/kernel/crash_core.c~crash-add-lock-to-serialize-crash-hotplug-handling
+++ a/kernel/crash_core.c
@@ -740,6 +740,17 @@ subsys_initcall(crash_notes_memory_init)
 #define pr_fmt(fmt) "crash hp: " fmt
 
 /*
+ * Different than kexec/kdump loading/unloading/jumping/shrinking which
+ * usually rarely happen, there will be many crash hotplug events notified
+ * during one short period, e.g one memory board is hot added and memory
+ * regions are online. So mutex lock  __crash_hotplug_lock is used to
+ * serialize the crash hotplug handling specifically.
+ */
+DEFINE_MUTEX(__crash_hotplug_lock);
+#define crash_hotplug_lock() mutex_lock(&__crash_hotplug_lock)
+#define crash_hotplug_unlock() mutex_unlock(&__crash_hotplug_lock)
+
+/*
  * This routine utilized when the crash_hotplug sysfs node is read.
  * It reflects the kernel's ability/permission to update the crash
  * elfcorehdr directly.
@@ -748,9 +759,11 @@ int crash_check_update_elfcorehdr(void)
 {
 	int rc = 0;
 
+	crash_hotplug_lock();
 	/* Obtain lock while reading crash information */
 	if (!kexec_trylock()) {
 		pr_info("kexec_trylock() failed, elfcorehdr may be inaccurate\n");
+		crash_hotplug_unlock();
 		return 0;
 	}
 	if (kexec_crash_image) {
@@ -761,6 +774,7 @@ int crash_check_update_elfcorehdr(void)
 	}
 	/* Release lock now that update complete */
 	kexec_unlock();
+	crash_hotplug_unlock();
 
 	return rc;
 }
@@ -783,9 +797,11 @@ static void crash_handle_hotplug_event(u
 {
 	struct kimage *image;
 
+	crash_hotplug_lock();
 	/* Obtain lock while changing crash information */
 	if (!kexec_trylock()) {
 		pr_info("kexec_trylock() failed, elfcorehdr may be inaccurate\n");
+		crash_hotplug_unlock();
 		return;
 	}
 
@@ -852,6 +868,7 @@ static void crash_handle_hotplug_event(u
 out:
 	/* Release lock now that update complete */
 	kexec_unlock();
+	crash_hotplug_unlock();
 }
 
 static int crash_memhp_notifier(struct notifier_block *nb, unsigned long val, void *v)
_

Patches currently in -mm which might be from bhe@redhat.com are

crash_corec-remove-unnecessary-parameter-of-function.patch
crash_core-change-the-prototype-of-function-parse_crashkernel.patch
crash_core-change-parse_crashkernel-to-support-crashkernel=highlow-parsing.patch
crash_core-add-generic-function-to-do-reservation.patch
crash_core-move-crashk_res-definition-into-crash_corec.patch
x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code.patch
x86-kdump-use-generic-interface-to-simplify-crashkernel-reservation-code-fix.patch
arm64-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
riscv-kdump-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash_corec-remove-unneeded-functions.patch

