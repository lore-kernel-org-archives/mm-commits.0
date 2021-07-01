Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE1AC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DABF061483
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhGAB7T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238662AbhGAB7Q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA6E86147E;
        Thu,  1 Jul 2021 01:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104606;
        bh=+PhBcqb+MsvVrRS+Aj75Y1qdvvqJBHiUbaDUyHX3OPA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eC5NDlbU085RVBmPJyVSJBAD3yWQOfm6umfP4sJPjTT5/6KVoPLAJ9gPn5+QbXmGj
         X0Vwe+wr2UIOPMWC6D+MMoj/FHt/BCPjpDk62czvUNVBVPkf82r/WRw2Nw69wtUN9B
         zi0VmmTN5dGHcygTUoraOJm0wxPhgHwQoake45o4=
Date:   Wed, 30 Jun 2021 18:56:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 182/192] exec: remove checks in
 __register_bimfmt()
Message-ID: <20210701015646.oDCgWS-8y%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: exec: remove checks in __register_bimfmt()

Delete NULL check, all callers pass valid pointer.

Delete ->load_binary check -- failure to provide hook in a custom module
will be very noticeable at the very first execve call.

Link: https://lkml.kernel.org/r/YK1Gy1qXaLAR+tPl@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/exec.c~exec-remove-checks-in-__register_bimfmt
+++ a/fs/exec.c
@@ -84,9 +84,6 @@ static DEFINE_RWLOCK(binfmt_lock);
 
 void __register_binfmt(struct linux_binfmt * fmt, int insert)
 {
-	BUG_ON(!fmt);
-	if (WARN_ON(!fmt->load_binary))
-		return;
 	write_lock(&binfmt_lock);
 	insert ? list_add(&fmt->lh, &formats) :
 		 list_add_tail(&fmt->lh, &formats);
_
