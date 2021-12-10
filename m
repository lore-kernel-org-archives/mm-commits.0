Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C66C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344718AbhLJWuK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:10 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57036 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbhLJWuK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D399CCE2D89
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0E2C341C8;
        Fri, 10 Dec 2021 22:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176392;
        bh=dkRHMIqz/dfKDhYUha0Dlons28x7fLueubWS67Pql5E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bi9EPknyp5jqCHIXdZ+wt33rBUsyAP7tWehtsGVU+gLFHEHayM5rsaEGW6FvY8O4b
         0nKu16VA4PaSP5UUix+JzjzIVqbGEOPbLDqD/ZvQQEaAW17XRSI/3cOqZRmEr4/pys
         dKrfeQHcmjCpca8trODK1XI5p39BKAqgcArPMptk=
Date:   Fri, 10 Dec 2021 14:46:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 08/21] mm/damon/dbgfs: remove an unnecessary error
 message
Message-ID: <20211210224631.R7Q2yUS8M%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: remove an unnecessary error message

When wrong scheme action is requested via the debugfs interface, DAMON
prints an error message.  Because the function returns error code, this is
not really needed.  Because the code path is triggered by the user
specified input, this can result in kernel log mistakenly being messy.  To
avoid the case, this commit removes the message.

Link: https://lkml.kernel.org/r/20211201150440.1088-3-sj@kernel.org
Fixes: af122dd8f3c0 ("mm/damon/dbgfs: support DAMON-based Operation Schemes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-remove-an-unnecessary-error-message
+++ a/mm/damon/dbgfs.c
@@ -210,10 +210,8 @@ static struct damos **str_to_schemes(con
 				&wmarks.low, &parsed);
 		if (ret != 18)
 			break;
-		if (!damos_action_valid(action)) {
-			pr_err("wrong action %d\n", action);
+		if (!damos_action_valid(action))
 			goto fail;
-		}
 
 		pos += parsed;
 		scheme = damon_new_scheme(min_sz, max_sz, min_nr_a, max_nr_a,
_
