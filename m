Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CBAC4363A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6330922200
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633204;
	bh=GF09NVJtBVs1gTLe/m/MvSCBtUzH1ujS5HRkUN1/55I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BxByRFf1XiJAtsKj1+Tym2LJnpw3gB2OYAu7eWBY/GLb4u68iJS7YF1mIjvZRozMx
	 mqYlK4jVrKnJA7JmkUapOGWKssXrdAyH0wSluCPhr4V9FaxD10iGlVcZPTGXYr7Nhh
	 BhX/fmAP45lxNVemgt8ZCjN2J2sGwRhW7Ou4KyD4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgJMXxX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730077AbgJMXwb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 764D322201;
        Tue, 13 Oct 2020 23:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633150;
        bh=GF09NVJtBVs1gTLe/m/MvSCBtUzH1ujS5HRkUN1/55I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=G67jkW1wDAPhPOu46Q9gHFmvTHEpsIoVZCwYkL82tC3PuWqUIHUB7VuaiC/e3KbVv
         CkK5IFQpKDdj/o8NUHDE8ePaa6we2t/yG/pz0d6xrzDphY6IB8tEc5Ky2C+nececxw
         jgvycfTvvOLWnGtKdWC0szkD3dTB6i1asivB7C1A=
Date:   Tue, 13 Oct 2020 16:52:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, darrick.wong@oracle.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 076/181] mm/swapfile.c: fix potential memory leak
 in sys_swapon
Message-ID: <20201013235230.5_jVCBMHF%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: fix potential memory leak in sys_swapon

If we failed to drain inode, we would forget to free the swap address
space allocated by init_swap_address_space() above.

Link: https://lkml.kernel.org/r/20200930101803.53884-1-linmiaohe@huawei.com
Fixes: dc617f29dbe5 ("vfs: don't allow writes to swap files")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-fix-potential-memory-leak-in-sys_swapon
+++ a/mm/swapfile.c
@@ -3342,7 +3342,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = inode_drain_writes(inode);
 	if (error) {
 		inode->i_flags &= ~S_SWAPFILE;
-		goto bad_swap_unlock_inode;
+		goto free_swap_address_space;
 	}
 
 	mutex_lock(&swapon_mutex);
@@ -3367,6 +3367,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	error = 0;
 	goto out;
+free_swap_address_space:
+	exit_swap_address_space(p->type);
 bad_swap_unlock_inode:
 	inode_unlock(inode);
 bad_swap:
_
