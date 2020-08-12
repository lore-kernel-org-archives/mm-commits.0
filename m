Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61230C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 409EE206F2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194377;
	bh=iMjPzPgSWMSRu7t5yF/B6Ut+B5I0EVAORYw3T8Zt5xw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=E0Oi9maMlNYJWaZ/iIFQm8HVO6Krmn5QVQJ96APFgKE684ScTdYhdhBEdgiQlI+1h
	 KZ8UTx2JZzuH+6+QQHmTfyCUnWF5ACcSsFnQUqiOpHSfCRgjJtf4gQ9MB+ozdGJfNG
	 FVV0CRVOvc0f8WWqdGWLt9dowxfQi+cBEHuB8RJk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLBGR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBGQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:06:16 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69B42206B5;
        Wed, 12 Aug 2020 01:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194376;
        bh=iMjPzPgSWMSRu7t5yF/B6Ut+B5I0EVAORYw3T8Zt5xw=;
        h=Date:From:To:Subject:From;
        b=nAKmQurbCWN2T65wILR5/BzxhhAICKnrbb70a0VflO2bScqXHlumAaOr7yzJqXieB
         H/yHSgVqWDgmyJ0NzQNeD9ipC6WvaWeHNfuJmHAO1iZZd7jf85zt+oesiPPz5q4MTj
         wqhq5sbECSrTwLXE9tujuJrVc1sn2ABE3GOns6q0=
Date:   Tue, 11 Aug 2020 18:06:16 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
 removed from -mm tree
Message-ID: <20200812010616._wzr7oPhN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migrate-make-a-standard-migration-target-allocation-function-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch

This patch was dropped because it was folded into mm-migrate-make-a-standard-migration-target-allocation-function.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-migrate-make-a-standard-migration-target-allocation-function-fix

fix typoe in comment

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-migrate-make-a-standard-migration-target-allocation-function-fix
+++ a/include/linux/hugetlb.h
@@ -705,7 +705,7 @@ static inline gfp_t htlb_modify_alloc_ma
 {
 	gfp_t modified_mask = htlb_alloc_mask(h);
 
-	/* Some callers might want to enfoce node */
+	/* Some callers might want to enforce node */
 	modified_mask |= (gfp_mask & __GFP_THISNODE);
 
 	return modified_mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

