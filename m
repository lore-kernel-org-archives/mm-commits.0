Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1F7C7EE45
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjFJAqx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjFJAqQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:46:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B85D3AB4
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:46:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B92365354
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C23C433D2;
        Sat, 10 Jun 2023 00:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357961;
        bh=XjGPdvkWUc0U0gIFavBDTK3WH7QFAmpH+e/p4rY/6/c=;
        h=Date:To:From:Subject:From;
        b=As1s5JAN7WY/Y7cA4/lD5pPFs5u4y/MS0XvYkO9c+Cu62dndAW/gyEGL/YxJI+i3P
         abi5sCeYNKJEsANFIMi8Ll53stnyc1yAMEOXfi4Q7EOF6PzwAsMWMMXTakOXaHRZlr
         9YVnBERv1R1L2fNiRrVJrbJMpkYZAr8/kk6xn99k=
Date:   Fri, 09 Jun 2023 17:46:00 -0700
To:     mm-commits@vger.kernel.org, holzheu@linux.vnet.ibm.com,
        ebiederm@xmission.com, bhe@redhat.com, amwang@redhat.com,
        thunder.leizhen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-delete-a-useless-check-in-crash_shrink_memory.patch removed from -mm tree
Message-Id: <20230610004601.62C23C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: delete a useless check in crash_shrink_memory()
has been removed from the -mm tree.  Its filename was
     kexec-delete-a-useless-check-in-crash_shrink_memory.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kexec-clear-crashk_res-if-all-its-memory-has-been-released.patch
kexec-improve-the-readability-of-crash_shrink_memory.patch
kexec-add-helper-__crash_shrink_memory.patch
kexec-enable-kexec_crash_size-to-support-two-crash-kernel-regions.patch

