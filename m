Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FE7C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79246233FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgLPRMS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgLPRMS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:18 -0500
Date:   Wed, 16 Dec 2020 09:12:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138722;
        bh=hCabqgc/3YN1h4xnIrUEyl4bjH6yHP2MaBKJS+Vg+pQ=;
        h=From:To:Subject:From;
        b=bHKA9uzgO2WzLw5NXzEGEUjDYoTKJYXnS5KeAcD1+UM+3BlsK9ATb55RoVQYhTqkR
         xue24Jv77966M7royjPlhLga31Yn74Cq0B4fthHexF9Fue2MW8VRk3Hl6ZzszB5drA
         CBkLd5/plnYWkEhC4UM3VARrV8aMofcIkbyjhN5s=
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, jmorris@namei.org,
        john.johansen@canonical.com, mm-commits@vger.kernel.org,
        serge@hallyn.com
Subject:  [merged]
 apparmor-remove-duplicate-macro-list_entry_is_head.patch removed from -mm
 tree
Message-ID: <20201216171202.ww3IihB9W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: apparmor: remove duplicate macro list_entry_is_head()
has been removed from the -mm tree.  Its filename was
     apparmor-remove-duplicate-macro-list_entry_is_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


