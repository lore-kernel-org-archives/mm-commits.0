Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FA8C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 00:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiDAASd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 20:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiDAASc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 20:18:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ADF17539A
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 17:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26D26B82294
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 00:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96BBC340EE;
        Fri,  1 Apr 2022 00:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648772201;
        bh=x9jbPz/shryTV0zqwy8GtI3X1l3Ey38Ui8zUKAPWHQc=;
        h=Date:To:From:Subject:From;
        b=t00cUheKoWbLN+CS1nSYDDqkDfof+KgDRuhvW8h/d7YBvS3+EpA5bJCEnoBiYWE+0
         TSJZmqkJ8F9Iky8UBKeik2L6q3IDzoh41amX2+SEDKzuCs7URVrUvRsBVme2S3Sa68
         lj04WCZZW6ixK0QV4L4iXIMR7GPruVHfbSkPnfnE=
Date:   Thu, 31 Mar 2022 17:16:41 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, ebiederm@xmission.com, bhe@redhat.com,
        michalorzel.eng@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-remove-redundant-assignments.patch added to -mm tree
Message-Id: <20220401001641.B96BBC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: remove redundant assignments
has been added to the -mm tree.  Its filename is
     kexec-remove-redundant-assignments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kexec-remove-redundant-assignments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kexec-remove-redundant-assignments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Orzel <michalorzel.eng@gmail.com>
Subject: kexec: remove redundant assignments

Get rid of redundant assignments which end up in values not being
read either because they are overwritten or the function ends.

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

kexec-remove-redundant-assignments.patch

