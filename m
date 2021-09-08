Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A636FC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 921E461152
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbhIHC6m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347409AbhIHC6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76D0E61153;
        Wed,  8 Sep 2021 02:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069847;
        bh=KCeFamD3+yu2IP2kG803DYdWWNNiJJNKTG1/8HLuiIs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Rb0SV99AD1sN1Q7Ae6mUvKcUJyEwtDPy7ZtB/aI0igmkrVAlklpMGAIClmvWqZQSY
         ZNBQXlR4enDcxGw3XXD8jR/q3mLKpJ1d2S2gJFk1wh73Qxxsknkd98wSgiYCChH1Sk
         dowpzrwysmrkZv1UcDux10pq0YAH6/7cqGiagm74=
Date:   Tue, 07 Sep 2021 19:57:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, dennis@kernel.org,
        gregkh@linuxfoundation.org, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 078/147] percpu: remove export of pcpu_base_addr
Message-ID: <20210908025727.o4i9tf480%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: percpu: remove export of pcpu_base_addr

This is not needed by any modules, so remove the export.

Link: https://lkml.kernel.org/r/20210722185814.504541-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/percpu.c~percpu-remove-export-of-pcpu_base_addr
+++ a/mm/percpu.c
@@ -146,7 +146,6 @@ static unsigned int pcpu_high_unit_cpu _
 
 /* the address of the first chunk which starts with the kernel static area */
 void *pcpu_base_addr __ro_after_init;
-EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
 static const int *pcpu_unit_map __ro_after_init;		/* cpu -> unit */
 const unsigned long *pcpu_unit_offsets __ro_after_init;	/* cpu -> unit offset */
_
