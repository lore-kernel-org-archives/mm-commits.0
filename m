Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4683C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8533A60E0B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhEHWwg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEHWwd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:52:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9B996100C;
        Sat,  8 May 2021 22:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514291;
        bh=LgHg3Utn+qwe91HJz7pR/ORaiOBwGNamna0AV09piNE=;
        h=Date:From:To:Subject:From;
        b=R3owSEl5guSZlWA1IIP5UeyOtREH+V5ICNl8B3a0fNegA3szcom9FL9oCGKbSm1l3
         3PM6LG+qK/veSxLQ1peZrnwwczq6pfpQvtsPsXN77pUdFLuJoRRr9A/PaiTNMfcWCB
         qXQyGtqvJVqyFCSDIzQHFPHQ/IaocorYWy+rlAaE=
Date:   Sat, 08 May 2021 15:51:30 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org
Subject:  [merged]
 kfence-zero-guard-page-after-out-of-bounds-access.patch removed from -mm
 tree
Message-ID: <20210508225130.R3GsxLli4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: zero guard page after out-of-bounds access
has been removed from the -mm tree.  Its filename was
     kfence-zero-guard-page-after-out-of-bounds-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: zero guard page after out-of-bounds access

After an out-of-bounds accesses, zero the guard page before re-protecting
in kfence_guarded_free().  On one hand this helps make the failure mode of
subsequent out-of-bounds accesses more deterministic, but could also
prevent certain information leaks.

Link: https://lkml.kernel.org/r/20210312121653.348518-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kfence/core.c~kfence-zero-guard-page-after-out-of-bounds-access
+++ a/mm/kfence/core.c
@@ -372,6 +372,7 @@ static void kfence_guarded_free(void *ad
 
 	/* Restore page protection if there was an OOB access. */
 	if (meta->unprotected_page) {
+		memzero_explicit((void *)ALIGN_DOWN(meta->unprotected_page, PAGE_SIZE), PAGE_SIZE);
 		kfence_protect(meta->unprotected_page);
 		meta->unprotected_page = 0;
 	}
_

Patches currently in -mm which might be from elver@google.com are


