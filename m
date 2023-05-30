Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF14C7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjE3WEk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbjE3WEj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A302B126
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A1E363412
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8527EC433D2;
        Tue, 30 May 2023 22:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685484275;
        bh=pImH1BJQS9HbzAET1gADMg02xQ9E9/zKB6VRJibfyeA=;
        h=Date:To:From:Subject:From;
        b=o8y8bHLR2Jj4FmfxcFxMsjxDcORBMmJkHpw2y+FZ5QmoHKrvHvmrSUTnGOqJao/4Q
         W72MiAsN9Ua4Ge/f4rHo/eCrJygov77k7rbGP+4A+7PJtK+/mp4LQkzrP/5kcDSTBp
         h2KUxHmMrY5BNIC5hmQ0vOCLnIHZvjcERDiIGs9Q=
Date:   Tue, 30 May 2023 15:04:34 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-delete-a-useless-check-in-crash_shrink_memory.patch added to mm-nonmm-unstable branch
Message-Id: <20230530220435.8527EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: delete a useless check in crash_shrink_memory()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-delete-a-useless-check-in-crash_shrink_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-delete-a-useless-check-in-crash_shrink_memory.patch

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
Subject: kexec: delete a useless check in crash_shrink_memory()
Date: Sat, 27 May 2023 20:34:35 +0800

The check '(crashk_res.parent != NULL)' is added by commit e05bd3367bd3
("kexec: fix Oops in crash_shrink_memory()"), but it's stale now.  Because
if 'crashk_res' is not reserved, it will be zero in size and will be
intercepted by the above 'if (new_size >= old_size)'.

Ago:
	if (new_size >= end - start + 1)

Now:
	old_size = (end == 0) ? 0 : end - start + 1;
	if (new_size >= old_size)

Link: https://lkml.kernel.org/r/20230527123439.772-3-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_core.c~kexec-delete-a-useless-check-in-crash_shrink_memory
+++ a/kernel/kexec_core.c
@@ -1137,7 +1137,7 @@ int crash_shrink_memory(unsigned long ne
 	end = start + new_size;
 	crash_free_reserved_phys_range(end, crashk_res.end);
 
-	if ((start == end) && (crashk_res.parent != NULL))
+	if (start == end)
 		release_resource(&crashk_res);
 
 	ram_res->start = end;
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

kexec-fix-a-memory-leak-in-crash_shrink_memory.patch
kexec-delete-a-useless-check-in-crash_shrink_memory.patch
kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch
kexec-improve-the-readability-of-crash_shrink_memory.patch
kexec-add-helper-__crash_shrink_memory.patch
kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

