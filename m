Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA654C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DDA120897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817857;
	bh=2/8ECjCgW3QvhDHckgxnMp2TAjIKszuUmyfQ2L017U0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=vlsvPTztCT09wzcc7TIOkMgidun/0grs2MIM5JU2F+AphRCRFbPHE8yaPDKybHJ/m
	 Llf/x1reOHKqOqe91IZ328WEDjsY0PQ0sFWxdqdIWdM6wg+Yg6c55O5kSzWEeWM18U
	 wjqQYGYCumrZ8ouDFjEyDhONMtpaN//l4a41XWqI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388011AbgJPDK5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDK5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23AC020789;
        Fri, 16 Oct 2020 03:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817855;
        bh=2/8ECjCgW3QvhDHckgxnMp2TAjIKszuUmyfQ2L017U0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BIc4hFGvsHjo3ET5JwJNz8GrAyVzBc5zijNzs1cbYffoqFwXXj1A+rcfFGPhfjmFg
         4J++SXU98331j3RG3rYKPFxstiMllvm6J2naZQF0KA5qjUR4huKrxR3KJZDULP6vFU
         jkRulEmHK1e5HTblrVcDkwpNkDbIAy+l5JjxjGCk=
Date:   Thu, 15 Oct 2020 20:10:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 105/156] lib: decompress_bunzip2: delete
 duplicated words
Message-ID: <20201016031051.90HAVjXHF%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: decompress_bunzip2: delete duplicated words

Drop the repeated word "how".

Link: https://lkml.kernel.org/r/20200823040436.25852-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_bunzip2.c~lib-decompress_bunzip2-delete-duplicated-words
+++ a/lib/decompress_bunzip2.c
@@ -390,7 +390,7 @@ static int INIT get_next_block(struct bu
 		j = (bd->inbufBits >> bd->inbufBitCount)&
 			((1 << hufGroup->maxLen)-1);
 got_huff_bits:
-		/* Figure how how many bits are in next symbol and
+		/* Figure how many bits are in next symbol and
 		 * unget extras */
 		i = hufGroup->minLen;
 		while (j > limit[i])
_
