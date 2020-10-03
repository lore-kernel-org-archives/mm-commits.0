Return-Path: <SRS0=eNRM=DK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFB9C4727E
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 05:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 462382072E
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 05:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601702509;
	bh=+089qr0wOBWMQr+iiivHJuKDHLjhCGC8a89mfc4juFM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=FFllQ7TdlcVYZ7iByekpKfPc9kkPCv2gOT9BPQro4cNpK+TDjqXjNkvan4UJioRZp
	 c1nD1iDSwDpcaqJvN+2jU8Uxu1olel3QhZUnBjleSZVsX1P+5NLFMScKJQkF83ZeZx
	 5UKz3B70QzyQGGJ6Mslk+uVz+LSP2jKlgc/jWTGk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725681AbgJCFVs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJCFVs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 3 Oct 2020 01:21:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64FBE206A1;
        Sat,  3 Oct 2020 05:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601702508;
        bh=+089qr0wOBWMQr+iiivHJuKDHLjhCGC8a89mfc4juFM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1whkWeA/c/JLKjLMSNxOZTdSRnBLXPr9go6DDbNVHm+SgR/Cfrs9A2uz1RcGejiC6
         jF+r2u52+2QhzDlmVbgiZy+z9/7AAlZ4LrCmKYzDNdUbKOA48yv08fXpG4BWFOmrV0
         f1reidBpVsvCjl5vyh9SfsGsOATG//Q5EVZMADvw=
Date:   Fri, 02 Oct 2020 22:21:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiggers@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 3/3] scripts/spelling.txt: fix malformed entry
Message-ID: <20201003052148.fcwAvM0jF%akpm@linux-foundation.org>
In-Reply-To: <20201002222038.4f81529dcd31eb8328d562a6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>
Subject: scripts/spelling.txt: fix malformed entry

One of the entries has three fields "mistake||correction||correction"
rather than the expected two fields "mistake||correction".  Fix it.

Link: https://lkml.kernel.org/r/20200930234359.255295-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-fix-malformed-entry
+++ a/scripts/spelling.txt
@@ -589,7 +589,7 @@ explictly||explicitly
 expresion||expression
 exprimental||experimental
 extened||extended
-exteneded||extended||extended
+exteneded||extended
 extensability||extensibility
 extention||extension
 extenstion||extension
_
