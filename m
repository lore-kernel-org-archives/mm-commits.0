Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E6CC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F4C4208B3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633206;
	bh=4xNFQvYul0G8BmnabgLQDG6cp957a2ONS9ghFW6GDq0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fT3BMnT3lHURJmvHKn3CAJ34EH1UoR7h7ye8b/z3//xDmS/DDqdF2/MIJlO4fpWvf
	 VcgqYv8GrenywF0Ep+DOuJMAITEY2UcP1abA8c0IJ8sFCp7Rjd5dcBPF7WOjRujN6h
	 f+Gr2192WiPZ/SpTiV+ZA0FvEvI4ONWUFG3Lub58=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgJMXxY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbgJMXw1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D54521D7B;
        Tue, 13 Oct 2020 23:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633147;
        bh=4xNFQvYul0G8BmnabgLQDG6cp957a2ONS9ghFW6GDq0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eFWaDatAumSTLR8lyJTX9AYiIzT2e+lJenmSMzaONU7RD41bpMhN0DLwxO2ZWchcS
         jFuWyImirSOXTC0QCcNEywxOK3c5+fxdpIU09F2Guvg4y8cPdI+G5xRh37e6y2oCbJ
         Q+CyMpUd+L2BS3SDHxF2SLEcJ1PHNhMOLIzslv0s=
Date:   Tue, 13 Oct 2020 16:52:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 075/181] mm/swapfile.c: remove unnecessary goto
 out in _swap_info_get()
Message-ID: <20201013235227.qZIt910oy%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swapfile.c: remove unnecessary goto out in _swap_info_get()

It's unnecessary to goto the out label while out label is just below.

Link: https://lkml.kernel.org/r/20200930102549.1885-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-remove-unnecessary-goto-out-in-_swap_info_get
+++ a/mm/swapfile.c
@@ -1184,7 +1184,6 @@ static struct swap_info_struct *_swap_in
 
 bad_free:
 	pr_err("swap_info_get: %s%08lx\n", Unused_offset, entry.val);
-	goto out;
 out:
 	return NULL;
 }
_
