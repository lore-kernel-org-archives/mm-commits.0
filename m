Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9F9C433E5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4557D2064B
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564119;
	bh=G/wTxNE4Iu39BL5jRshmlFvJbVBTa7OMxxcJ5Dre+w0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=MVuprcY3JjjFHgv8JAYtb3nJh73MfhNw/9Fb/05hs+18mS29b68hm059YSRNmPMnB
	 +RgVXgfASoS6wetCMR2cx1OeQQ04IZvqLsOgk+1108Q6kAib3iDsN3vrthk88iefzs
	 sxPBp05EIBQTCel4jVVaiDtk8QJsktcJdt99QXU0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgGXEPT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgGXEPS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63F21206F0;
        Fri, 24 Jul 2020 04:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564118;
        bh=G/wTxNE4Iu39BL5jRshmlFvJbVBTa7OMxxcJ5Dre+w0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mHtwXnpxMvQWi7T+km/0UsiKf5SrjxVTmP6xLp30BcYfdZw5ZBX+NuXTULV9FrMWO
         tGXe69MQQZDSk/mDkwWV3zk2v5+/CDcptO0ziJIJfMXKbwjQtp9naoC35s8pe/uSrU
         EUNcbg7DvZRQWrVSdcKyzrJmPI/trDXA8xxCCEo8=
Date:   Thu, 23 Jul 2020 21:15:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        trix@redhat.com
Subject:  [patch 04/15] mm: initialize return of vm_insert_pages
Message-ID: <20200724041518.SVl_3hkf2%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Tom Rix <trix@redhat.com>
Subject: mm: initialize return of vm_insert_pages

clang static analysis reports a garbage return

In file included from mm/memory.c:84:
mm/memory.c:1612:2: warning: Undefined or garbage value returned to caller [core.uninitialized.UndefReturn]
        return err;
        ^~~~~~~~~~

The setting of err depends on a loop executing.
So initialize err.

Link: http://lkml.kernel.org/r/20200703155354.29132-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-initialize-return-of-vm_insert_pages
+++ a/mm/memory.c
@@ -1601,7 +1601,7 @@ int vm_insert_pages(struct vm_area_struc
 	return insert_pages(vma, addr, pages, num, vma->vm_page_prot);
 #else
 	unsigned long idx = 0, pgcount = *num;
-	int err;
+	int err = -EINVAL;
 
 	for (; idx < pgcount; ++idx) {
 		err = vm_insert_page(vma, addr + (PAGE_SIZE * idx), pages[idx]);
_
