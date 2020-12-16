Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1555C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9BBE2313B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgLPEr6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgLPEr6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:58 -0500
Date:   Tue, 15 Dec 2020 20:47:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094037;
        bh=pDmRDphVAFN/tbd7rIyloO9KTHKOFpiEXPo0RZmu+fU=;
        h=From:To:Subject:In-Reply-To:From;
        b=D4C5Vnf02qGpIvmUia7CZ5+Hqbvkxr2jpYiPpR5YtWcymEQGIdTeAtBk9hzIZOQnU
         g3snJuDCG7XByPZBIvhOiU74Nv8A+Xg03LgQTZStxssEpswJzj4ldKWIR5T3pSJZUp
         XqFgmJUyTDnjtV2S/eXRBuZp2oEQJ9u39uqCI62o=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        jmorris@namei.org, john.johansen@canonical.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, serge@hallyn.com,
        torvalds@linux-foundation.org
Subject:  [patch 90/95] apparmor: remove duplicate macro
 list_entry_is_head()
Message-ID: <20201216044716.s7LY0OZvS%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: apparmor: remove duplicate macro list_entry_is_head()

Strangely I hadn't had noticed the existence of the list_entry_is_head()
in apparmor code when added the same one in the list.h.  Luckily it's
fully identical and didn't break builds.  In any case we don't need a
duplicate anymore, thus remove it from apparmor code.

Link: https://lkml.kernel.org/r/20201208100639.88182-1-andriy.shevchenko@linux.intel.com
Fixes: e130816164e244 ("include/linux/list.h: add a macro to test if entry is pointing to the head")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E . Hallyn " <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/apparmor/apparmorfs.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/security/apparmor/apparmorfs.c~apparmor-remove-duplicate-macro-list_entry_is_head
+++ a/security/apparmor/apparmorfs.c
@@ -2046,9 +2046,6 @@ fail2:
 	return error;
 }
 
-
-#define list_entry_is_head(pos, head, member) (&pos->member == (head))
-
 /**
  * __next_ns - find the next namespace to list
  * @root: root namespace to stop search at (NOT NULL)
_
