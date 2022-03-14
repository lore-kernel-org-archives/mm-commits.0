Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B8CC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 14 Mar 2022 20:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245172AbiCNU4y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Mar 2022 16:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbiCNU4x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Mar 2022 16:56:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2703D1ED
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 13:55:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01CEC612FD
        for <mm-commits@vger.kernel.org>; Mon, 14 Mar 2022 20:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567CCC340E9;
        Mon, 14 Mar 2022 20:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647291341;
        bh=bcBp8rGb/t1kw5YwKKTYxCNGxqKb8Qj7mQqX3uEYNCA=;
        h=Date:To:From:Subject:From;
        b=R4WmsQq/gqKTzx+YduY2JTaI0YDhk6b1PDuZRAd/sK6Qo4Ww9gG5/LocoCLl6NFfq
         KYmOyh4Od6fHT+kl9ngjYFzEBt8rg9fp0DuwoFehaUJVnS9uEbHhL5Ued3cKXFecRO
         PWbSzNxX/q24W7Jpp2lg6w11wPkYc08UdbrMJjO8=
Date:   Mon, 14 Mar 2022 13:55:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com, vbabka@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fault-injection-declare-should_fail_alloc_page.patch added to -mm tree
Message-Id: <20220314205541.567CCC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fault-injection: declare should_fail_alloc_page()
has been added to the -mm tree.  Its filename is
     mm-fault-injection-declare-should_fail_alloc_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fault-injection-declare-should_fail_alloc_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fault-injection-declare-should_fail_alloc_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, fault-injection: declare should_fail_alloc_page()

The mm/ directory can almost fully be built with W=1, which would help in
local development.  One remaining issue is missing prototype for
should_fail_alloc_page().  Thus add it next to the should_failslab()
prototype.

Note the previous attempt by commit f7173090033c ("mm/page_alloc: make
should_fail_alloc_page() static") had to be reverted by commit
54aa386661fe as it caused an unresolved symbol error with
CONFIG_DEBUG_INFO_BTF=y

Link: https://lkml.kernel.org/r/20220314165724.16071-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/fault-inject.h~mm-fault-injection-declare-should_fail_alloc_page
+++ a/include/linux/fault-inject.h
@@ -64,6 +64,8 @@ static inline struct dentry *fault_creat
 
 struct kmem_cache;
 
+bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
+
 int should_failslab(struct kmem_cache *s, gfp_t gfpflags);
 #ifdef CONFIG_FAILSLAB
 extern bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fault-injection-declare-should_fail_alloc_page.patch

