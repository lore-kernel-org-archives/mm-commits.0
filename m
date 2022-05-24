Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D55C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 24 May 2022 18:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbiEXSTU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 May 2022 14:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiEXSTU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2022 14:19:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165EA72237
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 11:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A060661563
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 18:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4D0C34100;
        Tue, 24 May 2022 18:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653416358;
        bh=D/Nk/MC24XLXxDyfn4vIRFYxk3s5Qt7iWTz47X2z8Vk=;
        h=Date:To:From:Subject:From;
        b=2Fs0IcnbZfWTUKWRpjeo3utucDR3zZUytbotfhWbmB3dZkUE091enrhnfwn1uzebS
         Ybh9d6kZyLAe8MFoupAECfn+lwFUzeFZdebYpJ+2r2TLB/7dfP0IFm5wS1i4OJOcBH
         J/wkEntZ3TOB8lucrc++mI9lz9s2zxYGZBFUl8Ts=
Date:   Tue, 24 May 2022 11:19:17 -0700
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        andreyknvl@gmail.com, liu3101@purdue.edu, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-update-pos-before-writing-pc-in-trace-function.patch added to mm-nonmm-unstable branch
Message-Id: <20220524181917.ED4D0C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: update pos before writing pc in trace function
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-update-pos-before-writing-pc-in-trace-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-update-pos-before-writing-pc-in-trace-function.patch

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
From: Congyu Liu <liu3101@purdue.edu>
Subject: kcov: update pos before writing pc in trace function
Date: Mon, 23 May 2022 05:35:31 +0000

In __sanitizer_cov_trace_pc(), previously we write pc before updating pos.
However, some early interrupt code could bypass check_kcov_mode() check
and invoke __sanitizer_cov_trace_pc().  If such interrupt is raised
between writing pc and updating pos, the pc could be overitten by the
recursive __sanitizer_cov_trace_pc().

As suggested by Dmitry, we cold update pos before writing pc to avoid such
interleaving.

Apply the same change to write_comp_data().

Link: https://lkml.kernel.org/r/20220523053531.1572793-1-liu3101@purdue.edu
Signed-off-by: Congyu Liu <liu3101@purdue.edu>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/kernel/kcov.c~kcov-update-pos-before-writing-pc-in-trace-function
+++ a/kernel/kcov.c
@@ -204,8 +204,16 @@ void notrace __sanitizer_cov_trace_pc(vo
 	/* The first 64-bit word is the number of subsequent PCs. */
 	pos = READ_ONCE(area[0]) + 1;
 	if (likely(pos < t->kcov_size)) {
-		area[pos] = ip;
+		/* Previously we write pc before updating pos. However, some
+		 * early interrupt code could bypass check_kcov_mode() check
+		 * and invoke __sanitizer_cov_trace_pc(). If such interrupt is
+		 * raised between writing pc and updating pos, the pc could be
+		 * overitten by the recursive __sanitizer_cov_trace_pc().
+		 * Update pos before writing pc to avoid such interleaving.
+		 */
 		WRITE_ONCE(area[0], pos);
+		barrier();
+		area[pos] = ip;
 	}
 }
 EXPORT_SYMBOL(__sanitizer_cov_trace_pc);
@@ -236,11 +244,13 @@ static void notrace write_comp_data(u64
 	start_index = 1 + count * KCOV_WORDS_PER_CMP;
 	end_pos = (start_index + KCOV_WORDS_PER_CMP) * sizeof(u64);
 	if (likely(end_pos <= max_pos)) {
+		/* See comment in __sanitizer_cov_trace_pc(). */
+		WRITE_ONCE(area[0], count + 1);
+		barrier();
 		area[start_index] = type;
 		area[start_index + 1] = arg1;
 		area[start_index + 2] = arg2;
 		area[start_index + 3] = ip;
-		WRITE_ONCE(area[0], count + 1);
 	}
 }
 
_

Patches currently in -mm which might be from liu3101@purdue.edu are

kcov-update-pos-before-writing-pc-in-trace-function.patch

