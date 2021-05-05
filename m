Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E5CC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B31A61423
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhEEBlQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhEEBlP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06E7F611AB;
        Wed,  5 May 2021 01:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178819;
        bh=D8bIDYN9Fs8tVciGy1zIl5xoQRfryhpx1Jly6UY+7JQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LFAtMAmThl79kY6Edn5mqulS9N5eLSCygSNLi+6miqBDWEh52fvHZfr3nhgfHSKdx
         KKrzZcE0DALXUp6vOF2lGcDKXRqP6pKzNRsnGlpQIRyi9kxMtjhcXGgchoo9D/ON4k
         0EEmMTEC1TWth2O/tXMhHgmSCrlTE7tp2vGygakg=
Date:   Tue, 04 May 2021 18:40:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 140/143] kfence: zero guard page after
 out-of-bounds access
Message-ID: <20210505014018.iniqSBnhX%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
