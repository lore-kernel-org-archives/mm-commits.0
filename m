Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1911CC4363D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 21:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B62720897
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602021008;
	bh=308j2qyzPHcHd36EA7Dd1j76IPQzr4Lej0QOK4AGOJo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RYXNnkAyRwUCGso9WjoezWnmd0O9wvlPf5jlVhWP+UZm9VyWQ5bk3+UKAv4+oU4D+
	 Qkzp+RBC7iZmqCh38EAXOIV56f9DcyNSdl60COrg3d0LImu2NeZ/05FbDLaOgyEY4T
	 DgK0ggobBzkNeWH+jC+RvGY/+hBLISB8seFyAEcg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFVuI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Oct 2020 17:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJFVuH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Oct 2020 17:50:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E1C62083B;
        Tue,  6 Oct 2020 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602021005;
        bh=308j2qyzPHcHd36EA7Dd1j76IPQzr4Lej0QOK4AGOJo=;
        h=Date:From:To:Subject:From;
        b=2YTtz1SicNOCzxFmZs5l2mbtKYyfay+Q+8YmQbkfEBRUVi2gw6yrLLV5a2mGZ1yJK
         +1y9tq3U9ci+VxhRx9nQ+TtXoacUh58r7tn1d9KvSj0gXOfsU9at5q032b1PLEgfVg
         DPdCW0LYKG2qf6xhapY7O5X6Xm3Zfbn95MiEeu74=
Date:   Tue, 06 Oct 2020 14:50:04 -0700
From:   akpm@linux-foundation.org
To:     b.zolnierkie@samsung.co, joe@perches.com, l.stelmach@samsung.com,
        m.szyprowski@samsung.com, mm-commits@vger.kernel.org
Subject:  +
 checkpatch-fix-false-positive-on-empty-block-comment-lines.patch added to
 -mm tree
Message-ID: <20201006215004.sDAPxd7nU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix false positive on empty block comment lines
has been added to the -mm tree.  Its filename is
     checkpatch-fix-false-positive-on-empty-block-comment-lines.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-fix-false-positive=
-on-empty-block-comment-lines.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-fix-false-positive=
-on-empty-block-comment-lines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3466,7 +3466,7 @@ sub process {
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

Patches currently in -mm which might be from l.stelmach@samsung.com are

checkpatch-fix-false-positive-on-empty-block-comment-lines.patch

