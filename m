Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8A0C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 20:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343956AbiEYUGn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 16:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiEYUGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 16:06:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084E65FAD
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 13:06:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 815B961A0F
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 20:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC9BC385B8;
        Wed, 25 May 2022 20:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653509187;
        bh=LF3dpNUPlOEyjKGOi31SkTUCF4m49YVm7XlJcX9Y31c=;
        h=Date:To:From:Subject:From;
        b=RtfQnZ/tHZiLPCpbe0E+P/63qEm0DmvFSYKpziOda1YF4HlP2lBOtoMMAgHPB6kWT
         N5/UZFk/kadz4H7xr9QPgEo95kZ/UjK+TKNLjH/YWHRqVRqNHD0Y0SaXilza8fckYt
         C68a7phGOWoZbW14F9jGUSkuoeoCEgEdhEejVDWk=
Date:   Wed, 25 May 2022 13:06:27 -0700
To:     mm-commits@vger.kernel.org, dvyukov@google.com,
        andreyknvl@gmail.com, liu3101@purdue.edu, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-update-pos-before-writing-pc-in-trace-function.patch removed from -mm tree
Message-Id: <20220525200627.CAC9BC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kcov: update pos before writing pc in trace function
has been removed from the -mm tree.  Its filename was
     kcov-update-pos-before-writing-pc-in-trace-function.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


