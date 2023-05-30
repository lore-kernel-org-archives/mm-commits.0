Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFFEC7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 22:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbjE3WEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 18:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbjE3WEl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 18:04:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64589102
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 15:04:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA8516283A
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 22:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7EAC4339C;
        Tue, 30 May 2023 22:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685484277;
        bh=RhLv6TB7xlhIdByv+AokRLavyS1HoEz3SqUk/VMOUt4=;
        h=Date:To:From:Subject:From;
        b=ZqoAa60ge6FOEFploTjy13gumdYIa+RLj7rOs1XDKMQWv0f2+MgYJj3PrKkJEg8ek
         T2qzIdJ9Cy+7EgcJ/AOj3LdXU0DDxx+BNtBlXrR+O1phHduqeUdLMYdQV82ePwLPdN
         d1denH9x8gB0+7AvRlhlVU2T2bDknZMNiORKF1Jc=
Date:   Tue, 30 May 2023 15:04:36 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch added to mm-nonmm-unstable branch
Message-Id: <20230530220437.4C7EAC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: clear crashk_res if all its memory has been released
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch

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
Subject: kexec: clear crashk_res if all its memory has been released
Date: Sat, 27 May 2023 20:34:36 +0800

If the resource of crashk_res has been released, it is better to clear
crashk_res.start and crashk_res.end.  Because 'end = start - 1' is not
reasonable, and in some places the test is based on crashk_res.end, not
resource_size(&crashk_res).

Link: https://lkml.kernel.org/r/20230527123439.772-4-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/kernel/kexec_core.c~kexec-clear-crashk_res-if-all-its-memory-has-been-released
+++ a/kernel/kexec_core.c
@@ -1137,15 +1137,18 @@ int crash_shrink_memory(unsigned long ne
 	end = start + new_size;
 	crash_free_reserved_phys_range(end, crashk_res.end);
 
-	if (start == end)
-		release_resource(&crashk_res);
-
 	ram_res->start = end;
 	ram_res->end = crashk_res.end;
 	ram_res->flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
 	ram_res->name = "System RAM";
 
-	crashk_res.end = end - 1;
+	if (start == end) {
+		release_resource(&crashk_res);
+		crashk_res.start = 0;
+		crashk_res.end = 0;
+	} else {
+		crashk_res.end = end - 1;
+	}
 
 	insert_resource(&iomem_resource, ram_res);
 
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

kexec-fix-a-memory-leak-in-crash_shrink_memory.patch
kexec-delete-a-useless-check-in-crash_shrink_memory.patch
kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch
kexec-improve-the-readability-of-crash_shrink_memory.patch
kexec-add-helper-__crash_shrink_memory.patch
kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

