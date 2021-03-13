Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11F7C43333
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98C0364FC9
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhCMFIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231906AbhCMFH6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C2564E41;
        Sat, 13 Mar 2021 05:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612078;
        bh=k+HOF3cJEROp2rXFGAtK31itT+MlrIOtk1wuYU85+3s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hV3gFv+kfitK3UHsnt/eCqO4LeQHXAP8dsSjEjXD3zk4eZ72jmI+aC7JMCxFg/Wfp
         jg0DXgcJjdvnhM5NIySHtvNPDVmN3dGe822LqZ4FoS0BIfX0XTzTBLsVQYsh/S+ftl
         hdElAj3sFrXiR4gS2CdMJAxSie2cdJhdrteMB66E=
Date:   Fri, 12 Mar 2021 21:07:53 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 16/29] kfence, slab: fix
 cache_alloc_debugcheck_after() for bulk allocations
Message-ID: <20210313050753.8pD6LGmHC%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Marco Elver <elver@google.com>
Subject: kfence, slab: fix cache_alloc_debugcheck_after() for bulk allocations

cache_alloc_debugcheck_after() performs checks on an object, including
adjusting the returned pointer.  None of this should apply to KFENCE
objects.  While for non-bulk allocations, the checks are skipped when we
allocate via KFENCE, for bulk allocations cache_alloc_debugcheck_after()
is called via cache_alloc_debugcheck_after_bulk().

Fix it by skipping cache_alloc_debugcheck_after() for KFENCE objects.

Link: https://lkml.kernel.org/r/20210304205256.2162309-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c~kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations
+++ a/mm/slab.c
@@ -2992,7 +2992,7 @@ static void *cache_alloc_debugcheck_afte
 				gfp_t flags, void *objp, unsigned long caller)
 {
 	WARN_ON_ONCE(cachep->ctor && (flags & __GFP_ZERO));
-	if (!objp)
+	if (!objp || is_kfence_address(objp))
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
 		check_poison_obj(cachep, objp);
_
