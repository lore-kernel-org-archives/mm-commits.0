Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF044C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbiEJEY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbiEJEXM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A893614B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AE75B81B05
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1D5C385A6;
        Tue, 10 May 2022 04:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156274;
        bh=ALt7j7A7l9Uw7mkp2vWg7WAHgX6fYQ2S4/tYPh2WqdY=;
        h=Date:To:From:Subject:From;
        b=jysWa11xubKf9H91CppniD2UrY9oa5TEqWxt13CC4XKH/zC0FumZ/GHddwq6QhkY9
         OkZXI0gaE+g4HQwPfGPzirTlUfYgpYw8sYmguqTtVnfghm9pxxx9eIubkXGV+9ey/K
         0N8Cgpl3DvZP73bjOytGp8FGcDCX13DVlj+ssbhs=
Date:   Mon, 09 May 2022 21:17:54 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, ebiederm@xmission.com, bhe@redhat.com,
        michalorzel.eng@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-remove-redundant-assignments.patch removed from -mm tree
Message-Id: <20220510041754.BB1D5C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kexec: remove redundant assignments
has been removed from the -mm tree.  Its filename was
     kexec-remove-redundant-assignments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Orzel <michalorzel.eng@gmail.com>
Subject: kexec: remove redundant assignments

Get rid of redundant assignments which end up in values not being read
either because they are overwritten or the function ends.

Reported by clang-tidy [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220326180948.192154-1-michalorzel.eng@gmail.com
Signed-off-by: Michal Orzel <michalorzel.eng@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Michal Orzel <michalorzel.eng@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/kexec_core.c~kexec-remove-redundant-assignments
+++ a/kernel/kexec_core.c
@@ -768,7 +768,6 @@ static struct page *kimage_alloc_page(st
 				kimage_free_pages(old_page);
 				continue;
 			}
-			addr = old_addr;
 			page = old_page;
 			break;
 		}
@@ -788,7 +787,6 @@ static int kimage_load_normal_segment(st
 	unsigned char __user *buf = NULL;
 	unsigned char *kbuf = NULL;
 
-	result = 0;
 	if (image->file_mode)
 		kbuf = segment->kbuf;
 	else
_

Patches currently in -mm which might be from michalorzel.eng@gmail.com are


