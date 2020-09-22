Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BFDC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7492B207C3
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794653;
	bh=yYgr0KECvVMqDm5HVxk0pBVahHNoJPUb8vmJoqzfxYQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xhv9eCbNBFLVzZ80RZWWVPKy89y204sq+T6ByH7sWNqiQMDSr/w7eMYcwmJL3pgHF
	 ZJaeIJ7wtaFKboSo8+OnMUBWU2Pg6atR0hF0zgr7E4LebSrg5RJBw+aDo8lp1LVW22
	 3vhsa1RDYgNjxhVeave5pNpIa8d7odmbcyU4THvM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIVRKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgIVRKx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:10:53 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C18420672;
        Tue, 22 Sep 2020 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794652;
        bh=yYgr0KECvVMqDm5HVxk0pBVahHNoJPUb8vmJoqzfxYQ=;
        h=Date:From:To:Subject:From;
        b=AM3s3hC/O8eO2NtbWrwT2W283VkXyHB8FhFA9gqnHo46G291j0YHfVebyATz+7Gtm
         cWA+ysa0DReksZBOg6c6XVIDUPpRPi0FqPC3nTNeSVUKNp69jUZW3PqwG8sQG1LEE2
         gca7XZiDZ0ERtyP5RwQEU6FXF8tzj2iABL/SEw58=
Date:   Tue, 22 Sep 2020 10:10:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, david@redhat.com,
        natechancellor@gmail.com
Subject:  +
 kernel-resource-make-release_mem_region_adjustable-never-fail-fix.patch added
 to -mm tree
Message-ID: <20200922171051.u_Jcf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/resource: fix use of ternary condition in release_mem_region_adjustable
has been added to the -mm tree.  Its filename is
     kernel-resource-make-release_mem_region_adjustable-never-fail-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-resource-make-release_mem_region_adjustable-never-fail-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-resource-make-release_mem_region_adjustable-never-fail-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: kernel/resource: fix use of ternary condition in release_mem_region_adjustable

Clang warns:

kernel/resource.c:1281:53: warning: operator '?:' has lower precedence
than '|'; '|' will be evaluated first
[-Wbitwise-conditional-parentheses]
        new_res = alloc_resource(GFP_KERNEL | alloc_nofail ? __GFP_NOFAIL : 0);
                                 ~~~~~~~~~~~~~~~~~~~~~~~~~ ^
kernel/resource.c:1281:53: note: place parentheses around the '|'
expression to silence this warning
        new_res = alloc_resource(GFP_KERNEL | alloc_nofail ? __GFP_NOFAIL : 0);
                                 ~~~~~~~~~~~~~~~~~~~~~~~~~ ^
kernel/resource.c:1281:53: note: place parentheses around the '?:'
expression to evaluate it first
        new_res = alloc_resource(GFP_KERNEL | alloc_nofail ? __GFP_NOFAIL : 0);
                                                           ^
                                              (                              )
1 warning generated.

Add the parentheses as it was clearly intended for the ternary condition
to be evaluated first.

Link: https://lkml.kernel.org/r/20200922060748.2452056-1-natechancellor@gmail.com
Fixes: 5fd23bd0d739 ("kernel/resource: make release_mem_region_adjustable() never fail")
Link: https://github.com/ClangBuiltLinux/linux/issues/1159
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/resource.c~kernel-resource-make-release_mem_region_adjustable-never-fail-fix
+++ a/kernel/resource.c
@@ -1279,7 +1279,7 @@ void release_mem_region_adjustable(struc
 	 * similarly).
 	 */
 retry:
-	new_res = alloc_resource(GFP_KERNEL | alloc_nofail ? __GFP_NOFAIL : 0);
+	new_res = alloc_resource(GFP_KERNEL | (alloc_nofail ? __GFP_NOFAIL : 0));
 
 	p = &parent->child;
 	write_lock(&resource_lock);
_

Patches currently in -mm which might be from natechancellor@gmail.com are

kernel-resource-make-release_mem_region_adjustable-never-fail-fix.patch

