Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEE1C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 02:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiCaCpE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Mar 2022 22:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiCaCpD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Mar 2022 22:45:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F348240A8
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 19:43:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3118CCE1F81
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C131C340EC;
        Thu, 31 Mar 2022 02:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648694591;
        bh=x7AXbkz2YKz2m/koFaqpRWUPdI4ZjjkBlI8r1RtxDAc=;
        h=Date:To:From:Subject:From;
        b=xGoPiSdUjvjFuPRJnuGNySYdW55Iqfp6seknamaFX7y4pCHE0JgTWZOvI6+hdm77E
         p1Y1yC9uDoZjPdwBYKQCAObqCwWhBNozaHB3pPF930JwUdV4eWmfeWq/HuqGj2mHnL
         cHsXruYJO3xLT6GeHqdMYQ3pB21tbuT1NdMkYJyc=
Date:   Wed, 30 Mar 2022 19:43:10 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, tome01@ajou.ac.kr,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-prevent-activated-scheme-from-sleeping-by-deactivated-schemes.patch added to -mm tree
Message-Id: <20220331024311.5C131C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: prevent activated scheme from sleeping by deactivated schemes
has been added to the -mm tree.  Its filename is
     mm-damon-prevent-activated-scheme-from-sleeping-by-deactivated-schemes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-prevent-activated-scheme-from-sleeping-by-deactivated-schemes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-prevent-activated-scheme-from-sleeping-by-deactivated-schemes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jonghyeon Kim <tome01@ajou.ac.kr>
Subject: mm/damon: prevent activated scheme from sleeping by deactivated schemes

In the DAMON, the minimum wait time of the schemes decides whether the
kernel wakes up 'kdamon_fn()'.  But since the minimum wait time is
initialized to zero, there are corner cases against the original
objective.

For example, if we have several schemes for one target, and if the wait
time of the first scheme is zero, the minimum wait time will set zero,
which means 'kdamond_fn()' should wake up to apply this scheme.  However,
in the following scheme, wait time can be set to non-zero.  Thus, the
mininum wait time will be set to non-zero, which can cause sleeping this
interval for 'kdamon_fn()' due to one deactivated last scheme.

This commit prevents making DAMON monitoring inactive state due to other
deactivated schemes.

Link: https://lkml.kernel.org/r/20220330105302.32114-1-tome01@ajou.ac.kr
Signed-off-by: Jonghyeon Kim <tome01@ajou.ac.kr>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-prevent-activated-scheme-from-sleeping-by-deactivated-schemes
+++ a/mm/damon/core.c
@@ -1019,12 +1019,15 @@ static int kdamond_wait_activation(struc
 	struct damos *s;
 	unsigned long wait_time;
 	unsigned long min_wait_time = 0;
+	bool init_wait_time = false;
 
 	while (!kdamond_need_stop(ctx)) {
 		damon_for_each_scheme(s, ctx) {
 			wait_time = damos_wmark_wait_us(s);
-			if (!min_wait_time || wait_time < min_wait_time)
+			if (!init_wait_time || wait_time < min_wait_time) {
+				init_wait_time = true;
 				min_wait_time = wait_time;
+			}
 		}
 		if (!min_wait_time)
 			return 0;
_

Patches currently in -mm which might be from tome01@ajou.ac.kr are

mm-damon-prevent-activated-scheme-from-sleeping-by-deactivated-schemes.patch

