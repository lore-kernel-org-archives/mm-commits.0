Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D596DC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6EE22CB8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgLODK4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:10:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbgLODKw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:10:52 -0500
Date:   Mon, 14 Dec 2020 19:08:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001734;
        bh=Cl51eIpOHIY29d4fpwUTVRXc5WT1t2IL8vDJEsCL/vg=;
        h=From:To:Subject:In-Reply-To:From;
        b=ASEy23RGuxxfLClzleyYMuQ99w3zsZgKSHupQrlLkZ9dLIcf1fbRTGIZJ4qk1ZaCs
         uyV36gdYAwbsQaU0byE3bKXYAo0s7bCPkJ+G7o/qQvM4vUkBaNy4P+ggIpBSO07IGd
         kgutPQh82EmIAWL1OXhfPi6Dx1BvFkeZbN9/51R0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        corbet@lwn.net, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 096/200] mm/vmalloc: add 'align' parameter
 explanation for pvm_determine_end_from_reverse
Message-ID: <20201215030853.Iv4o7l2mL%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/vmalloc: add 'align' parameter explanation for pvm_determine_end_from_reverse

Kernel-doc markup has a issue on pvm_determine_end_from_reverse:
mm/vmalloc.c:3145: warning: Function parameter or member 'align' not
described in 'pvm_determine_end_from_reverse'
Add a explanation for it to remove the warning.

Link: https://lkml.kernel.org/r/1605605088-30668-3-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-add-align-parameter-explanation-for-pvm_determine_end_from_reverse
+++ a/mm/vmalloc.c
@@ -3151,6 +3151,7 @@ pvm_find_va_enclose_addr(unsigned long a
  * @va:
  *   in - the VA we start the search(reverse order);
  *   out - the VA with the highest aligned end address.
+ * @align: alignment for required highest address
  *
  * Returns: determined end address within vmap_area
  */
_
