Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3210FC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09DC92076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196313;
	bh=l16bCDlj1WeJgku4mxCfYvvj1+yu1h3+P7NgDyXspT8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zTx0cIfTXVVg0WuwiJ3bofkUdsPS06nWU8v0JBBp+JrVgbz6TVc+bW6Hrp9jOOTnA
	 Zfwz8M6VrwDDAGkx9k+qHAN8Cq2qp8P0g/sDLc7/83mpek0l/170Aqt8nTmOD7Y+0r
	 /IRDgJ41rkkg1AHDn+vkr3RA/a5EfFzPKdnGZs28=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHLBic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:38:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EC4C20658;
        Wed, 12 Aug 2020 01:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196312;
        bh=l16bCDlj1WeJgku4mxCfYvvj1+yu1h3+P7NgDyXspT8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=QjbCN/Uwi04QA8AnFcRULN6yyo3SRJrrXpkGrLQPdkzSTH1pUxffu8EohhtQCXDJs
         bNQPoIIbd0iAGDlcEgmhv9/k4HbqobLYWV5QPgzxNvl4+pgvtj0OKUit7DBSMtw9JS
         5hUoows9/GQHrqv2eMprH3xAmvSdVvGCaVnHyIYo=
Date:   Tue, 11 Aug 2020 18:38:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        paulus@samba.org, peterx@redhat.com, torvalds@linux-foundation.org
Subject:  [patch 156/165] mm/powerpc: use general page fault
 accounting
Message-ID: <20200812013831.YP4VvPPQH%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/powerpc: use general page fault accounting

Use the general page fault accounting by passing regs into
handle_mm_fault().

Link: http://lkml.kernel.org/r/20200707225021.200906-17-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/fault.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/arch/powerpc/mm/fault.c~mm-powerpc-use-general-page-fault-accounting
+++ a/arch/powerpc/mm/fault.c
@@ -511,7 +511,7 @@ retry:
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	fault = handle_mm_fault(vma, address, flags, NULL);
+	fault = handle_mm_fault(vma, address, flags, regs);
 
 	major |= fault & VM_FAULT_MAJOR;
 
@@ -537,14 +537,9 @@ retry:
 	/*
 	 * Major/minor page fault accounting.
 	 */
-	if (major) {
-		current->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, regs, address);
+	if (major)
 		cmo_account_page_fault();
-	} else {
-		current->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, regs, address);
-	}
+
 	return 0;
 }
 NOKPROBE_SYMBOL(__do_page_fault);
_
