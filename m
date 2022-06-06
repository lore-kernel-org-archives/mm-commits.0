Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35057CCA47F
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 19:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiFFTSE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 15:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiFFTSB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 15:18:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E22F8BD2B
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 12:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE9E361459
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 19:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FED8C34115;
        Mon,  6 Jun 2022 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654543079;
        bh=qHtLwAM+f852ccDR2jfJJawTqYRf81aD71yci3C6Ot0=;
        h=Date:To:From:Subject:From;
        b=RfMOjdpcRXeyG9YFAfEi/Bi41/pq7jyiNwgGp9qAW2CV6umbXLmwxUZZcr+I08wxr
         N9NbzPOEHDJP1pTfiUtCd2wr3SSpmAps7UNlG382BIF7zxHvbMenTsJo6figbTHn1t
         9ztAxekEzWx1U8b4Ldib1UgqzxVarZl8oy2V+WI0=
Date:   Mon, 06 Jun 2022 12:17:58 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch added to mm-unstable branch
Message-Id: <20220606191759.4FED8C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/reclaim: add 'damon_reclaim_' prefix to 'enabled_store()'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: add 'damon_reclaim_' prefix to 'enabled_store()'
Date: Mon, 6 Jun 2022 18:23:10 +0000

This commit adds 'damon_reclaim_' prefix to 'enabled_store()', so that we
can distinguish it easily from the stack trace using 'faddr2line.sh' like
tools.

Link: https://lkml.kernel.org/r/20220606182310.48781-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store
+++ a/mm/damon/reclaim.c
@@ -369,7 +369,7 @@ static void damon_reclaim_timer_fn(struc
 }
 static DECLARE_DELAYED_WORK(damon_reclaim_timer, damon_reclaim_timer_fn);
 
-static int enabled_store(const char *val,
+static int damon_reclaim_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
 	int rc = param_set_bool(val, kp);
@@ -382,7 +382,7 @@ static int enabled_store(const char *val
 }
 
 static const struct kernel_param_ops enabled_param_ops = {
-	.set = enabled_store,
+	.set = damon_reclaim_enabled_store,
 	.get = param_get_bool,
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-damon-reclaim-remove-a-paragraph-that-been-obsolete-due-to-online-tuning-support.patch
mm-damon-dbgfssysfs-move-target_has_pid-from-dbgfs-to-damonh.patch
mm-damon-reclaim-deduplicate-commit_inputs-handling.patch
mm-damon-sysfs-deduplicate-inputs-applying.patch
mm-damon-reclaim-make-enabled-checking-timer-simpler.patch
mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch

