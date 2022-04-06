Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FB0C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 20:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbiDFVAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiDFU7y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2022 16:59:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8A61B29DD
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 12:25:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5977061CD3
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 19:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF84EC385A5;
        Wed,  6 Apr 2022 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649273158;
        bh=J73grTybpWVk2nL0WZRQqYLojwuftDqE4157zER7oq0=;
        h=Date:To:From:Subject:From;
        b=bUHMNL0sPGvkVTj6CXuGHthSGM5FzVn+/HZKuGgVG2Wv9/MwCyTaA7R/V/Yk+NZhB
         ZvuHKM0SQgTyBmbq9foCtVYURpFsGp4G6xtkX9jW3BEXgxXJNIA+hOQ8SpFjlThZWJ
         sd19pYOHqtA2R4amGvenBY//XuG7NvFf0YqECBHo=
Date:   Wed, 06 Apr 2022 12:25:57 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch added to -mm tree
Message-Id: <20220406192558.AF84EC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: remove redudant check of #ifdef PTRACE_SINGLESTEP
has been added to the -mm tree.  Its filename is
     ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: ptrace: remove redudant check of #ifdef PTRACE_SINGLESTEP

Patch series "ptrace: do some cleanup".


This patch (of 3):

PTRACE_SINGLESTEP is always defined as 9 in include/uapi/linux/ptrace.h,
remove redudant check of #ifdef PTRACE_SINGLESTEP.

Link: https://lkml.kernel.org/r/1649240981-11024-2-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/ptrace.c~ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep
+++ a/kernel/ptrace.c
@@ -829,11 +829,7 @@ static long ptrace_get_rseq_configuratio
 }
 #endif
 
-#ifdef PTRACE_SINGLESTEP
 #define is_singlestep(request)		((request) == PTRACE_SINGLESTEP)
-#else
-#define is_singlestep(request)		0
-#endif
 
 #ifdef PTRACE_SINGLEBLOCK
 #define is_singleblock(request)		((request) == PTRACE_SINGLEBLOCK)
@@ -1221,9 +1217,7 @@ int ptrace_request(struct task_struct *c
 	}
 #endif
 
-#ifdef PTRACE_SINGLESTEP
 	case PTRACE_SINGLESTEP:
-#endif
 #ifdef PTRACE_SINGLEBLOCK
 	case PTRACE_SINGLEBLOCK:
 #endif
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch
ptrace-fix-wrong-comment-of-pt_dtrace.patch
maintainers-remove-redundant-file-of-ptrace-support-entry.patch

