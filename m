Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F035FC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A49912083B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817947;
	bh=pMsQ5TWVu8f3N0dTVqVu0NXUQPYASWgT4Q+oTMgr+yQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mQZZT7K/9AEh6teKX2CoEBTm48Y8g6naZrpkRmb0z00uGzwAr2bptA0ejeFQShPe2
	 wss8Vel/n8yisBHyVEzLHoTSgPj32K94TuzkLnEyB2xho8elj6Mavjr5iNAbeTGuP9
	 71e4i/7sGyi6SvjMC2fL2wAdcEFlbKVoJzd6EWx8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387864AbgJPDM1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389873AbgJPDM1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2527020789;
        Fri, 16 Oct 2020 03:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817946;
        bh=pMsQ5TWVu8f3N0dTVqVu0NXUQPYASWgT4Q+oTMgr+yQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lD9hCOtkP1Gu/iYIC0FJ4hdQomZ9uLvuCUFio47wo6AVrKGqyEitkmO9RKe336IbE
         7h2Jm5Bm55PokTttJHxUQWixQ8QogTL0S8xnbivAPuVOXmwA+FJaT/rR54A8PVXSjn
         OlfAUlWDITcUkx5vCiiNU23ioslKLG2t3SjrYUkc=
Date:   Thu, 15 Oct 2020 20:12:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, b.zolnierkie@samsung.co,
        joe@perches.com, l.stelmach@samsung.com, m.szyprowski@samsung.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 132/156] checkpatch: fix false positive on empty
 block comment lines
Message-ID: <20201016031225.meh_ppwrl%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
