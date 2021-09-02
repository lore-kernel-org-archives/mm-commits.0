Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2B6C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF376610CF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347969AbhIBWBg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347929AbhIBWBf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E930660FA0;
        Thu,  2 Sep 2021 22:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620037;
        bh=ivMUD5TycflJDfArzZzdjrEa9+evSgEF8MbZzJU/fuE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BhBekNjwgNV6gx0VrGRl/ocX41IBN1Y2y5SbP/TprcZJpPGeAGs3DQeVYzmMmNBz3
         xf7juXzqf6P2EAFzhyfcSYrnxs5Jtcgk7TXvhfIN1IMI1lCTIaIMEw6Ns0HTwwJOut
         3IfgiHc1WvdNc1s/pgVsFQizqfIcblKVOX+2o13o=
Date:   Thu, 02 Sep 2021 15:00:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 200/212] mm/migrate: correct kernel-doc notation
Message-ID: <20210902220036.tDtb0jfvZ%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/migrate: correct kernel-doc notation

Use the expected "Return:" format to prevent a kernel-doc warning.

mm/migrate.c:1157: warning: Excess function parameter 'returns' description in 'next_demotion_node'

Link: https://lkml.kernel.org/r/20210808203151.10632-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-correct-kernel-doc-notation
+++ a/mm/migrate.c
@@ -1149,7 +1149,7 @@ static int node_demotion[MAX_NUMNODES] _
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
  *
- * @returns: node id for next memory node in the demotion path hierarchy
+ * Return: node id for next memory node in the demotion path hierarchy
  * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
  * @node online or guarantee that it *continues* to be the next demotion
  * target.
_
