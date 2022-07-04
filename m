Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6581EC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiGDBJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiGDBJj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:09:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F36617D
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 617CBCE107C
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCC7C341C7;
        Mon,  4 Jul 2022 01:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656896974;
        bh=kmyMt86OJF4RGKM1rLxk/EwJByda+egdyVhjRdHylWA=;
        h=Date:To:From:Subject:From;
        b=ajn2JpWGIfhCxg0/1vq4+WJ1nCsSx9niUIls1z0s+nsWKWJzMIrzSQ5TwRx0qihKV
         tT6LSCzrr1yDAK1tplW0A4yXoKljwbc9dXetOTK9lIbdQK7DkItjbGqQ53HrHtcFp9
         LCE6jIPmuaZa8EXX1gTFrHOClMROCXovJLjdrMEE=
Date:   Sun, 03 Jul 2022 18:09:33 -0700
To:     mm-commits@vger.kernel.org, corbet@lwn.net, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch removed from -mm tree
Message-Id: <20220704010934.6FCC7C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: add 'damon_reclaim_' prefix to 'enabled_store()'
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-add-damon_reclaim_-prefix-to-enabled_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -371,7 +371,7 @@ static DECLARE_DELAYED_WORK(damon_reclai
 
 static bool damon_reclaim_initialized;
 
-static int enabled_store(const char *val,
+static int damon_reclaim_enabled_store(const char *val,
 		const struct kernel_param *kp)
 {
 	int rc = param_set_bool(val, kp);
@@ -388,7 +388,7 @@ static int enabled_store(const char *val
 }
 
 static const struct kernel_param_ops enabled_param_ops = {
-	.set = enabled_store,
+	.set = damon_reclaim_enabled_store,
 	.get = param_get_bool,
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-dbgfs-add-and-use-mappings-between-schemes-action-inputs-and-damos_action-values.patch
mm-damon-paddr-use-a-separate-function-for-damos_pageout-handling.patch
mm-damon-schemes-add-lru_prio-damos-action.patch
docs-admin-guide-damon-sysfs-document-lru_prio-scheme-action.patch
mm-damon-schemes-add-lru_deprio-action.patch
docs-admin-guide-damon-sysfs-document-lru_deprio-scheme-action.patch
mm-damon-introduce-damon-based-lru-lists-sorting.patch
docs-admin-guide-damon-add-a-document-for-damon_lru_sort.patch

