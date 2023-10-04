Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2541DE936E0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244907AbjJDUZT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245031AbjJDUYp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:24:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E902310FB
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:24:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5455EC433C8;
        Wed,  4 Oct 2023 20:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451045;
        bh=VxHkyLuUmVhobGIg+UZvFZ3VPXuNASmymwKcwqcorRs=;
        h=Date:To:From:Subject:From;
        b=E0XDvhCAsMgVd7ene0WOjFe8DfZnnQDfhPFXUXfjQvgO7EL/3N1wtGmSyH1Upj+zF
         8rnHuHJ+w2dZ1kDKPzgAEhcB27qU2aW+Bjgy0VwbVz8nKysgc0GyRNHdV4aSj3mAIR
         l+P7wUOTUuQeqQBTi5twl3ubYDbGwVMBk64jAOHk=
Date:   Wed, 04 Oct 2023 13:24:03 -0700
To:     mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        chenjiahao16@huawei.com, catalin.marinas@arm.com, bhe@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_core-move-crashk_res-definition-into-crash_corec.patch removed from -mm tree
Message-Id: <20231004202405.5455EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: crash_core: move crashk_*res definition into crash_core.c
has been removed from the -mm tree.  Its filename was
     crash_core-move-crashk_res-definition-into-crash_corec.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: crash_core: move crashk_*res definition into crash_core.c
Date: Thu, 14 Sep 2023 11:31:38 +0800

Both crashk_res and crashk_low_res are used to mark the reserved
crashkernel regions in iomem_resource tree.  And later the generic
crashkernel resrvation will be added into crash_core.c.  So move
crashk_res and crashk_low_res definition into crash_core.c to avoid
compiling error if CONFIG_CRASH_CORE=on while CONFIG_KEXEC_CORE is unset.

Meanwhile include <asm/crash_core.h> in <linux/crash_core.h> if generic
reservation is needed.  In that case, <asm/crash_core.h> need be added by
ARCH.  In asm/crash_core.h, ARCH can provide its own macro definitions to
override macros in <linux/crash_core.h> if needed.  Wrap the including
into CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION ifdeffery scope to
avoid compiling error in other ARCH-es which don't take the generic
reservation way yet.

Link: https://lkml.kernel.org/r/20230914033142.676708-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Jiahao <chenjiahao16@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_core.h |    8 ++++++++
 include/linux/kexec.h      |    4 ----
 kernel/crash_core.c        |   16 ++++++++++++++++
 kernel/kexec_core.c        |   17 -----------------
 4 files changed, 24 insertions(+), 21 deletions(-)

--- a/include/linux/crash_core.h~crash_core-move-crashk_res-definition-into-crash_corec
+++ a/include/linux/crash_core.h
@@ -5,6 +5,14 @@
 #include <linux/linkage.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#ifdef CONFIG_ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
+#include <asm/crash_core.h>
+#endif
+
+/* Location of a reserved region to hold the crash kernel.
+ */
+extern struct resource crashk_res;
+extern struct resource crashk_low_res;
 
 #define CRASH_CORE_NOTE_NAME	   "CORE"
 #define CRASH_CORE_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
--- a/include/linux/kexec.h~crash_core-move-crashk_res-definition-into-crash_corec
+++ a/include/linux/kexec.h
@@ -22,10 +22,6 @@
 #include <uapi/linux/kexec.h>
 #include <linux/verification.h>
 
-/* Location of a reserved region to hold the crash kernel.
- */
-extern struct resource crashk_res;
-extern struct resource crashk_low_res;
 extern note_buf_t __percpu *crash_notes;
 
 #ifdef CONFIG_KEXEC_CORE
--- a/kernel/crash_core.c~crash_core-move-crashk_res-definition-into-crash_corec
+++ a/kernel/crash_core.c
@@ -35,6 +35,22 @@ u32 *vmcoreinfo_note;
 /* trusted vmcoreinfo, e.g. we can make a copy in the crash memory */
 static unsigned char *vmcoreinfo_data_safecopy;
 
+/* Location of the reserved area for the crash kernel */
+struct resource crashk_res = {
+	.name  = "Crash kernel",
+	.start = 0,
+	.end   = 0,
+	.flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM,
+	.desc  = IORES_DESC_CRASH_KERNEL
+};
+struct resource crashk_low_res = {
+	.name  = "Crash kernel",
+	.start = 0,
+	.end   = 0,
+	.flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM,
+	.desc  = IORES_DESC_CRASH_KERNEL
+};
+
 /*
  * parsing the "crashkernel" commandline
  *
--- a/kernel/kexec_core.c~crash_core-move-crashk_res-definition-into-crash_corec
+++ a/kernel/kexec_core.c
@@ -52,23 +52,6 @@ atomic_t __kexec_lock = ATOMIC_INIT(0);
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
-
-/* Location of the reserved area for the crash kernel */
-struct resource crashk_res = {
-	.name  = "Crash kernel",
-	.start = 0,
-	.end   = 0,
-	.flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM,
-	.desc  = IORES_DESC_CRASH_KERNEL
-};
-struct resource crashk_low_res = {
-	.name  = "Crash kernel",
-	.start = 0,
-	.end   = 0,
-	.flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM,
-	.desc  = IORES_DESC_CRASH_KERNEL
-};
-
 int kexec_should_crash(struct task_struct *p)
 {
 	/*
_

Patches currently in -mm which might be from bhe@redhat.com are


