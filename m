Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0968CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344764AbhLJWuR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:50:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57076 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344658AbhLJWuQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:50:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08329CE2D7E
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8BCC00446;
        Fri, 10 Dec 2021 22:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176398;
        bh=71xGL9H+mdfTWjOejoxh0aqBq/VbnI2nHzhdMkv6eqQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U8mtuS2F5dhSBiD4CMDAXSoFLfZ4BCOLFITcAAAefeLwj4LXrHlHY6cqMD+Z1H9L2
         TqYqs4RYF6/nd2LoiwZvlkl5dRqpwlHYdDgAyBCiv/gE7ZPiWbMNdQN28y3CF7WdDK
         4mfCW6Znvzihpteh7E6Kgy804fT9BDY1aYKfkZBs=
Date:   Fri, 10 Dec 2021 14:46:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, brendanhiggins@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, shuah@kernel.org,
        sj@kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org
Subject:  [patch 10/21] mm/damon/vaddr: remove an unnecessary
 warning message
Message-ID: <20211210224637.SG3gpIFY6%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: remove an unnecessary warning message

The DAMON virtual address space monitoring primitive prints a warning
message for wrong DAMOS action.  However, it is not essential as the code
returns appropriate failure in the case.  This commit removes the message
to make the log clean.

Link: https://lkml.kernel.org/r/20211201150440.1088-5-sj@kernel.org
Fixes: 6dea8add4d28 ("mm/damon/vaddr: support DAMON-based Operation Schemes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-remove-an-unnecessary-warning-message
+++ a/mm/damon/vaddr.c
@@ -627,7 +627,6 @@ int damon_va_apply_scheme(struct damon_c
 	case DAMOS_STAT:
 		return 0;
 	default:
-		pr_warn("Wrong action %d\n", scheme->action);
 		return -EINVAL;
 	}
 
_
