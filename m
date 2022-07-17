Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C94C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 04:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiGQEcS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 00:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGQEcS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 00:32:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F239D17074
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 21:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BBFC60F98
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 04:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5349C3411E;
        Sun, 17 Jul 2022 04:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032335;
        bh=tuiJfNvGrb1m0cXehS2skDsLzzs9t/6pkMkTueCsHaU=;
        h=Date:To:From:Subject:From;
        b=uMh6qV0TveBsUZYWM2q35k8w1IhrroMh9jDTpKeWyEw9Wyg6CyYM4r/EGVi/ihv+/
         CuOs5vifkP00VfkhVBfbmb7fe7209RrQ9fhJl8O3qj9OzMhUJaNeKUzRMc1FLigXtt
         NgjV7IadkVZgeKe993uLRZNrtrBVQTwumIz4QHeY=
Date:   Sat, 16 Jul 2022 21:32:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, riel@surriel.com,
        kirill.shutemov@linux.intel.com, clm@fb.com, josef@toxicpanda.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2.patch removed from -mm tree
Message-Id: <20220717043215.B5349C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2
has been removed from the -mm tree.  Its filename was
     mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2.patch

This patch was dropped because it was folded into mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2
Date: Wed, 13 Jul 2022 10:13:37 -0400

Link: https://lkml.kernel.org/r/e90c8f0dbae836632b669c2afc434006a00d4a67.1657721478.git.josef@toxicpanda.com
Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Chris Mason <clm@fb.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-fix-page-leak-with-multiple-threads-mapping-the-same-page-v2
+++ a/mm/memory.c
@@ -4369,7 +4369,10 @@ vm_fault_t finish_fault(struct vm_fault
 			return VM_FAULT_OOM;
 	}
 
-	/* See comment in handle_pte_fault() */
+	/*
+	 * See comment in handle_pte_fault() for how this scenario happens, we
+	 * need to return NOPAGE so that we drop this page.
+	 */
 	if (pmd_devmap_trans_unstable(vmf->pmd))
 		return VM_FAULT_NOPAGE;
 
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-fix-page-leak-with-multiple-threads-mapping-the-same-page.patch

