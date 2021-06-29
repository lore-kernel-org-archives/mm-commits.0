Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E46C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD1961D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhF2Ckx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231799AbhF2Ckv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CF0861D04;
        Tue, 29 Jun 2021 02:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934305;
        bh=48TkQN9JNxl5K1vPy+qs1FSaESbu5TR9y7gUYmS2YTA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gR0010VssV26vYaeZIvwkOIZMOuPCSvkSIZtSemOVmUdO1dM7uXMYc6UKDwel9OVj
         WMStlOOnpP9ynlSSNH52ZGk54ieD/KYjAKoTGNK9NziSzLYygQvOfLxKA6PF6fpPdB
         BY22wdlat8PwYz8UzxUPyF7iHrGtlDKErja78R4Q=
Date:   Mon, 28 Jun 2021 19:38:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, denghuilong@cdjrlc.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 097/192] mm: memcontrol: remove trailing semicolon
 in macros
Message-ID: <20210629023824.CkmVli8Jn%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Huilong Deng <denghuilong@cdjrlc.com>
Subject: mm: memcontrol: remove trailing semicolon in macros

Macros should not use a trailing semicolon.

Link: https://lkml.kernel.org/r/20210614091530.22117-1-denghuilong@cdjrlc.com
Signed-off-by: Huilong Deng <denghuilong@cdjrlc.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-remove-trailing-semicolon-in-macros
+++ a/include/linux/memcontrol.h
@@ -192,7 +192,7 @@ enum memcg_kmem_state {
 struct memcg_padding {
 	char x[0];
 } ____cacheline_internodealigned_in_smp;
-#define MEMCG_PADDING(name)      struct memcg_padding name;
+#define MEMCG_PADDING(name)      struct memcg_padding name
 #else
 #define MEMCG_PADDING(name)
 #endif
_
