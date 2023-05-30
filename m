Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50068C7EE2F
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjE3WE4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbjE3WEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38903BE
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0E2560F93
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B3DC433EF;
        Tue, 30 May 2023 22:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685484279;
        bh=CFcu/7pp21tjq1Q+O3lBvgWDt495BRAPbjhQpvyMidc=;
        h=Date:To:From:Subject:From;
        b=ugxUTGHCZ2xchcx04LrxN//nSU61HLGJQ9KYaaLSLIA/WOvbUJ21g+45cGLqOApbV
         26G0OkfMa+3aLYfaVQkkpvFABqIUVgetPCBFYBToxz1+7HV9LjJL89kpYg710PHwZg
         PH4TMrUxaq/KPTSAX+q7+9sx6zVrJNo9klNelECc=
Date:   Tue, 30 May 2023 15:04:38 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-improve-the-readability-of-crash_shrink_memory.patch added to mm-nonmm-unstable branch
Message-Id: <20230530220439.27B3DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: improve the readability of crash_shrink_memory()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-improve-the-readability-of-crash_shrink_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-improve-the-readability-of-crash_shrink_memory.patch

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
Subject: kexec: improve the readability of crash_shrink_memory()
Date: Sat, 27 May 2023 20:34:37 +0800

The major adjustments are:
1. end = start + new_size.
   The 'end' here is not an accurate representation, because it is not the
   new end of crashk_res, but the start of ram_res, difference 1. So
   eliminate it and replace it with ram_res->start.
2. Use 'ram_res->start' and 'ram_res->end' as arguments to
   crash_free_reserved_phys_range() to indicate that the memory covered by
   'ram_res' is released from the crashk. And keep it close to
   insert_resource().
3. Replace 'if (start == end)' with 'if (!new_size)', clear indication that
   all crashk memory will be shrunken.

No functional change.

Link: https://lkml.kernel.org/r/20230527123439.772-5-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/kernel/kexec_core.c~kexec-improve-the-readability-of-crash_shrink_memory
+++ a/kernel/kexec_core.c
@@ -1108,7 +1108,6 @@ ssize_t crash_get_memory_size(void)
 int crash_shrink_memory(unsigned long new_size)
 {
 	int ret = 0;
-	unsigned long start, end;
 	unsigned long old_size;
 	struct resource *ram_res;
 
@@ -1119,9 +1118,7 @@ int crash_shrink_memory(unsigned long ne
 		ret = -ENOENT;
 		goto unlock;
 	}
-	start = crashk_res.start;
-	end = crashk_res.end;
-	old_size = (end == 0) ? 0 : end - start + 1;
+	old_size = !crashk_res.end ? 0 : resource_size(&crashk_res);
 	new_size = roundup(new_size, KEXEC_CRASH_MEM_ALIGN);
 	if (new_size >= old_size) {
 		ret = (new_size == old_size) ? 0 : -EINVAL;
@@ -1134,22 +1131,20 @@ int crash_shrink_memory(unsigned long ne
 		goto unlock;
 	}
 
-	end = start + new_size;
-	crash_free_reserved_phys_range(end, crashk_res.end);
-
-	ram_res->start = end;
+	ram_res->start = crashk_res.start + new_size;
 	ram_res->end = crashk_res.end;
 	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
 	ram_res->name = "System RAM";
 
-	if (start == end) {
+	if (!new_size) {
 		release_resource(&crashk_res);
 		crashk_res.start = 0;
 		crashk_res.end = 0;
 	} else {
-		crashk_res.end = end - 1;
+		crashk_res.end = ram_res->start - 1;
 	}
 
+	crash_free_reserved_phys_range(ram_res->start, ram_res->end);
 	insert_resource(&iomem_resource, ram_res);
 
 unlock:
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

kexec-fix-a-memory-leak-in-crash_shrink_memory.patch
kexec-delete-a-useless-check-in-crash_shrink_memory.patch
kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch
kexec-improve-the-readability-of-crash_shrink_memory.patch
kexec-add-helper-__crash_shrink_memory.patch
kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

