Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1D0C2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B47D8610F7
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 00:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhFOAFb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 20:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhFOAFa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 20:05:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABF6D60FEA;
        Tue, 15 Jun 2021 00:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623715391;
        bh=zmx2B3Nc+sMWlBdF/09tMN5bNiwvXovzObzQULC371k=;
        h=Date:From:To:Subject:From;
        b=Cy2uFa5yil/fxQG83SATKI6PSdxQimV5Ds7tM7j76eY4GjEwhob25AU290yrAHKh6
         FZaO+IJwenUw96p1MDC2Tho6T8U+aCimYu/oPxwtXMKt4OtKZk+C6jhfJxEzdn/hd+
         gI7xnBxl2qhFx+9TdqF8QgzkQgDXMN6KTXs959tw=
Date:   Mon, 14 Jun 2021 17:03:11 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, denghuilong@cdjrlc.com, guro@fb.com,
        hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com
Subject:  + mm-memcontrol-remove-trailing-semicolon-in-macros.patch
 added to -mm tree
Message-ID: <20210615000311.joyBnzIL2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove trailing semicolon in macros
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-trailing-semicolon-in-macros.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-trailing-semicolon-in-macros.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-trailing-semicolon-in-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huilong Deng <denghuilong@cdjrlc.com>
Subject: mm: memcontrol: remove trailing semicolon in macros

Macros should not use a trailing semicolon.

Link: https://lkml.kernel.org/r/20210614091530.22117-1-denghuilong@cdjrlc.com
Signed-off-by: Huilong Deng <denghuilong@cdjrlc.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
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

Patches currently in -mm which might be from denghuilong@cdjrlc.com are

mm-memcontrol-remove-trailing-semicolon-in-macros.patch

