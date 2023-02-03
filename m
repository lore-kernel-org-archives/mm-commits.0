Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9988C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjBCGgj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjBCGf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:35:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FF243452
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8D848CE2EC6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D97C433D2;
        Fri,  3 Feb 2023 06:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406153;
        bh=a0yAc/ETMcwatSRRFlODNjnVKETl4C8ZgFg5WBGYCKI=;
        h=Date:To:From:Subject:From;
        b=NwvXS/dpuJwD14FOnjwLAaV3x59GloErxFLZX9HCNXe6xh0ExerTOZFC2U2uF++lw
         a2ApEyqIRKUsafUppvlYfilwD17lKqV0fIAsaAVaClmLzB5yWNF3b8WF/yu06GMkEm
         g7hkFo6DcnM5WhulDS/QwkgoOqf/HZanYhZNj4MQ=
Date:   Thu, 02 Feb 2023 22:35:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-destroy_large_folio-to-use-folio_dtor.patch removed from -mm tree
Message-Id: <20230203063553.A7D97C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert destroy_large_folio() to use folio_dtor
has been removed from the -mm tree.  Its filename was
     mm-convert-destroy_large_folio-to-use-folio_dtor.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert destroy_large_folio() to use folio_dtor
Date: Wed, 11 Jan 2023 14:29:06 +0000

Replace a use of compound_dtor.

Link: https://lkml.kernel.org/r/20230111142915.1001531-21-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-convert-destroy_large_folio-to-use-folio_dtor
+++ a/mm/page_alloc.c
@@ -807,7 +807,7 @@ void prep_compound_page(struct page *pag
 
 void destroy_large_folio(struct folio *folio)
 {
-	enum compound_dtor_id dtor = folio_page(folio, 1)->compound_dtor;
+	enum compound_dtor_id dtor = folio->_folio_dtor;
 
 	VM_BUG_ON_FOLIO(dtor >= NR_COMPOUND_DTORS, folio);
 	compound_page_dtors[dtor](&folio->page);
_

Patches currently in -mm which might be from willy@infradead.org are


