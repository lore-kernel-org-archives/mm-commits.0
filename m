Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48DDC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F22860F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347901AbhIBV7g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347960AbhIBV7e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B650603E9;
        Thu,  2 Sep 2021 21:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619915;
        bh=clngBQX16TbNZJKLv4olP771s4RnxVWjtc4v6LMGSYo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M6scOGqO8fpY+21OHVwRo8Jh+Ef6CE5lM16UPrWLzgBsknLqQgtOspZ7ku+iKS1F2
         2YAqc2gwxWXuGtRRJNl/Ed4WEZSOgFqOArTzlW190cwsVRyhUKuuOkSqlUicQjOpw0
         hBt6U2gvz757iCvjsZRSuMJ6kPayU9vrsYnqySTc=
Date:   Thu, 02 Sep 2021 14:58:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, shy828301@gmail.com,
        tdmackey@twitter.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 163/212] doc: hwpoison: correct the support for
 hugepage
Message-ID: <20210902215834.2NaKEkm8v%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: doc: hwpoison: correct the support for hugepage

The hwpoison support for huge page, both hugetlb and THP, has been in
kernel for a while, the statement in document is obsolete, correct it.

Link: https://lkml.kernel.org/r/20210819054116.266126-2-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Mackey <tdmackey@twitter.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/hwpoison.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/vm/hwpoison.rst~doc-hwpoison-correct-the-support-for-hugepage
+++ a/Documentation/vm/hwpoison.rst
@@ -180,7 +180,6 @@ Limitations
 ===========
 - Not all page types are supported and never will. Most kernel internal
   objects cannot be recovered, only LRU pages for now.
-- Right now hugepage support is missing.
 
 ---
 Andi Kleen, Oct 2009
_
