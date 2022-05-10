Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB903C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiEJEYw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbiEJEXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B13B21AF
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BDFCB81AF1
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C410DC385A6;
        Tue, 10 May 2022 04:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156271;
        bh=XlR7As5gLHRBvS4sW1W2/WW1dUyWTSHKXqdMh2QsQ3s=;
        h=Date:To:From:Subject:From;
        b=WvPiyKvXavrgAaY2ZBVIkwP0Q0JnA1Q3Ckl0OAbzIm02GOPgqeeMwKNO5BueWTghj
         4SukUNOGb3qol4ChHeQXg5XclgT8QGDd+4vX+WF8hW3h4z0yc9XpRKByBUuOgfLLRj
         IRReA2l2fmUZh7Pit/jGpgxf77PxJe/U99igY+JA=
Date:   Mon, 09 May 2022 21:17:51 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch removed from -mm tree
Message-Id: <20220510041751.C410DC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ptrace: remove redudant check of #ifdef PTRACE_SINGLESTEP
has been removed from the -mm tree.  Its filename was
     ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


