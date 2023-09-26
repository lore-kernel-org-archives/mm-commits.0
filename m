Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC98E7F124
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 20:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbjIZUuS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 16:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbjIZUuR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 16:50:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2328612A
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 13:50:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A43C433C7;
        Tue, 26 Sep 2023 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695761409;
        bh=oWLYC5Lb5Hk7yLfrbppMw0fJerNrJi0BaL4d/qkR94o=;
        h=Date:To:From:Subject:From;
        b=XtSlB563dfd+luD6zWUzr6P+3G8qZBXwbcs+NKwSbjOYa62OBU9bA8nUFKJ5LfF1l
         m542aoPvVYMk20p6nIz9bWBiNkIr5gpSDYngwnUvu5LjbxJcN7fTLvLVh56Ehaa8Kz
         CqDC0cc8i4rBSbq9KR0kzg8oyod4rsBj4kAqutfc=
Date:   Tue, 26 Sep 2023 13:50:08 -0700
To:     mm-commits@vger.kernel.org, vschneid@redhat.com,
        sourabhjain@linux.ibm.com, eric.devolder@oracle.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-add-lock-to-serialize-crash-hotplug-handling.patch added to mm-hotfixes-unstable branch
Message-Id: <20230926205009.A5A43C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Crash: add lock to serialize crash hotplug handling
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     crash-add-lock-to-serialize-crash-hotplug-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-add-lock-to-serialize-crash-hotplug-handling.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Signed-off-by: Baoquan He <bhe@redhat.com>
Tested-by: Eric DeVolder <eric.devolder@oracle.com>
Reviewed-by: Eric DeVolder <eric.devolder@oracle.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Valentin Schneider <vschneid@redhat.com>
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

crash-add-lock-to-serialize-crash-hotplug-handling.patch
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

