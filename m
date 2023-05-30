Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92834C77B73
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjE3WE4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbjE3WEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:04:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B2911B
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88FAA6344D
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0801C433EF;
        Tue, 30 May 2023 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685484281;
        bh=drdGhpLyRijdjT+CDeukeyIGIfjNb7t7Bs7L24henfg=;
        h=Date:To:From:Subject:From;
        b=kgcO5za64DKuvgnR/4j4HN4zfSPQRo4dJq3RdN9w3Y41OEPZwOEJ46+Ariwa2TMnZ
         kb9QMjdEtd77DrOetOs+GIdjQCP7NyIB4HFU+bfJaMEcsSY0gTghp9/saXR6xQa93w
         W069BzCcSgY1tGVb7QQlLXWyD86+JCFW8lxZ46Gc=
Date:   Tue, 30 May 2023 15:04:40 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-add-helper-__crash_shrink_memory.patch added to mm-nonmm-unstable branch
Message-Id: <20230530220440.E0801C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: add helper __crash_shrink_memory()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-add-helper-__crash_shrink_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-add-helper-__crash_shrink_memory.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: kexec: add helper __crash_shrink_memory()
Date: Sat, 27 May 2023 20:34:38 +0800

No functional change, in preparation for the next patch so that it is
easier to review.

Link: https://lkml.kernel.org/r/20230527123439.772-6-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   50 +++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

--- a/kernel/kexec_core.c~kexec-add-helper-__crash_shrink_memory
+++ a/kernel/kexec_core.c
@@ -1105,11 +1105,37 @@ ssize_t crash_get_memory_size(void)
 	return size;
 }
 
+int __crash_shrink_memory(struct resource *old_res, unsigned long new_size)
+{
+	struct resource *ram_res;
+
+	ram_res = kzalloc(sizeof(*ram_res), GFP_KERNEL);
+	if (!ram_res)
+		return -ENOMEM;
+
+	ram_res->start = old_res->start + new_size;
+	ram_res->end   = old_res->end;
+	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
+	ram_res->name  = "System RAM";
+
+	if (!new_size) {
+		release_resource(old_res);
+		old_res->start = 0;
+		old_res->end   = 0;
+	} else {
+		crashk_res.end = ram_res->start - 1;
+	}
+
+	crash_free_reserved_phys_range(ram_res->start, ram_res->end);
+	insert_resource(&iomem_resource, ram_res);
+
+	return 0;
+}
+
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
 	unsigned long old_size;
-	struct resource *ram_res;
 
 	if (!kexec_trylock())
 		return -EBUSY;
@@ -1125,27 +1151,7 @@ int crash_shrink_memory(unsigned long ne
 		goto unlock;
 	}
 
-	ram_res = kzalloc(sizeof(*ram_res), GFP_KERNEL);
-	if (!ram_res) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
-
-	ram_res->start = crashk_res.start + new_size;
-	ram_res->end = crashk_res.end;
-	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
-	ram_res->name = "System RAM";
-
-	if (!new_size) {
-		release_resource(&crashk_res);
-		crashk_res.start = 0;
-		crashk_res.end = 0;
-	} else {
-		crashk_res.end = ram_res->start - 1;
-	}
-
-	crash_free_reserved_phys_range(ram_res->start, ram_res->end);
-	insert_resource(&iomem_resource, ram_res);
+	ret = __crash_shrink_memory(&crashk_res, new_size);
 
 unlock:
 	kexec_unlock();
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

kexec-fix-a-memory-leak-in-crash_shrink_memory.patch
kexec-delete-a-useless-check-in-crash_shrink_memory.patch
kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch
kexec-improve-the-readability-of-crash_shrink_memory.patch
kexec-add-helper-__crash_shrink_memory.patch
kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

