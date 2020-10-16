Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A354C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C2F2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816565;
	bh=pMsQ5TWVu8f3N0dTVqVu0NXUQPYASWgT4Q+oTMgr+yQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=an24HjjxOjFHRx6YeRrFJOn8cs3qiI+vOTJlOFBOSXMixGJui8QlYJzo9WB8VvUqh
	 gPD6YMi17TcDnmNFjfxLifeml+NO5in+8JU3sovDF1Rqw8WD3evV0Dhe+U9Hd96+mo
	 Vk2uYmcWQp6lYUFVqjlCn5WUQXjkNSeo1s8YDqpg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404385AbgJPCtZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404364AbgJPCtW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:49:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB48208C7;
        Fri, 16 Oct 2020 02:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816560;
        bh=pMsQ5TWVu8f3N0dTVqVu0NXUQPYASWgT4Q+oTMgr+yQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v33v2WefVLp+YWrRyiXx3E+eGNpFm43J8zTaejQ4Wq/d0RqFA24hbi+P9WcZEQ7YX
         +b9/t1NhXxglcoxBAT1dfzmBHY2JJRzHuJ2YxI3AfctBlKmHJ9ycugRlqLZC20C9mV
         PADHfQzQFp3SS3cjVeff5cOi5svo6SccuoPEtsx8=
Date:   Thu, 15 Oct 2020 19:49:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, b.zolnierkie@samsung.co,
        joe@perches.com, l.stelmach@samsung.com, linux-mm@kvack.org,
        m.szyprowski@samsung.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 132/156] checkpatch: fix false positive on empty
 block comment lines
Message-ID: <20201016024919.EyIEDSv-j%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
Subject: checkpatch: fix false positive on empty block comment lines

To avoid false positives in presence of SPDX-License-Identifier in
networking files it is required to increase the leeway for empty block
comment lines by one line.

For example, checking drivers/net/loopback.c which starts with

    // SPDX-License-Identifier: GPL-2.0-or-later
    /*
     * INET          An implementation of the TCP/IP protocol suite for the=
 LINUX

rsults in an unnecessary warning

    WARNING: networking block comments don't use an empty /* line, use /* C=
omment...
    +/*
    + * INET                An implementation of the TCP/IP protocol suite =
for the LINUX

Link: https://lkml.kernel.org/r/20201006083509.19934-1-l.stelmach@samsung.c=
om
Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Bart=C5=82omiej =C5=BBolnierkiewicz  <b.zolnierkie@samsung.co>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-fix-false-positive-on-empty-block-co=
mment-lines
+++ a/scripts/checkpatch.pl
@@ -3464,7 +3464,7 @@ sub process {
 		if ($realfile =3D~ m@^(drivers/net/|net/)@ &&
 		    $prevrawline =3D~ /^\+[ \t]*\/\*[ \t]*$/ &&
 		    $rawline =3D~ /^\+[ \t]*\*/ &&
-		    $realline > 2) {
+		    $realline > 3) { # Do not warn about the initial copyright comment b=
lock after SPDX-License-Identifier
 			WARN("NETWORKING_BLOCK_COMMENT_STYLE",
 			     "networking block comments don't use an empty /* line, use /* Comm=
ent...\n" . $hereprev);
 		}
_
