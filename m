Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35002C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC03B208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817826;
	bh=e0Y1tc/FcGX5baonnIlmFlK5G7InsjGC24cSWI+QIcs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Tmmdg8lpl9A20IfW3hYOvHXgeRPqYDAS3Y8q0tCE4MMkHXx1c3dvhP0ccl1glaNiN
	 aNx5GTEUw001cfVZm1C1z9+1udO5jEo5OueCrZdhkv9Pom05rf3uK6Kr5DAIuGLbES
	 +zGvwBGH41chnBOcWUTQPbHk3AWicAu+tQmQ05pM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbgJPDK0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732461AbgJPDK0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEC8C2087D;
        Fri, 16 Oct 2020 03:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817826;
        bh=e0Y1tc/FcGX5baonnIlmFlK5G7InsjGC24cSWI+QIcs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uQ9h/LplxDDmeStBcqHNunRPcxurgGzBDFqmcEJxWrOH4ZPrmsB0NSqCVhodJNg/i
         mi9NIAZ6HULVzDHy7X+Cjr88BrPzjZhhpdx/HUoZaCnCEOoKm8/SX7P9DoL7EiXCeS
         LLnjSdikCgsyouAPY41Fyc83afR5jtuOWOK/7BVY=
Date:   Thu, 15 Oct 2020 20:10:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, liao.pingfang@zte.com.cn,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wang.yi59@zte.com.cn
Subject:  [patch 097/156] kernel/sys.c: replace do_brk with
 do_brk_flags in comment of prctl_set_mm_map()
Message-ID: <20201016031025.kCKoSVVEW%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: kernel/sys.c: replace do_brk with do_brk_flags in comment of prctl_set_mm_map()

Replace do_brk with do_brk_flags in comment of prctl_set_mm_map(), since
do_brk was removed in following commit.

Link: https://lkml.kernel.org/r/1600650751-43127-1-git-send-email-wang.yi59@zte.com.cn
Fixes: bb177a732c4369 ("mm: do not bug_on on incorrect length in __mm_populate()")
Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sys.c~kernel-sysc-replace-do_brk-with-do_brk_flags-in-comment-of-prctl_set_mm_map
+++ a/kernel/sys.c
@@ -2034,7 +2034,7 @@ static int prctl_set_mm_map(int opt, con
 	 * VMAs already unmapped and kernel uses these members for statistics
 	 * output in procfs mostly, except
 	 *
-	 *  - @start_brk/@brk which are used in do_brk but kernel lookups
+	 *  - @start_brk/@brk which are used in do_brk_flags but kernel lookups
 	 *    for VMAs when updating these memvers so anything wrong written
 	 *    here cause kernel to swear at userspace program but won't lead
 	 *    to any problem in kernel itself
_
