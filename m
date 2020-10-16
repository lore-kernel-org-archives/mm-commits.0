Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E5DC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6172B216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881659;
	bh=8DUApqhb9BtGtRj6KiQnNu6uFF+Jhhr40hvTda2bpLc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=1ldZXfjGfVEc+d0SLSTBSwcDUgoBqHFFZ7cKizk2IDem4LPIfR9dSMV0OxZ8pnzyh
	 n5ff6uLurcLcZXw06CC4p/P7pj4GjuMwrhKn3Dk4r7HKGBqTKwjOP7ffGXgnzxOFmy
	 26mlXeyklzGRpXcSySfsDWSQiRMgFmmv5k9Qpbew=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409233AbgJPUyT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409202AbgJPUyS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D03422076C;
        Fri, 16 Oct 2020 20:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881658;
        bh=8DUApqhb9BtGtRj6KiQnNu6uFF+Jhhr40hvTda2bpLc=;
        h=Date:From:To:Subject:From;
        b=N5B2WCkkCRuZwHlZvPQ1i4jVahjNyxzJ2a9abTiXqrtgyVU1ibY+eNzy+HI6TnMfe
         9QLaTcVEGPZ3o200hmvmKYXnzwasNhaBMvUiW+aIGjqUAKe5sxznfnBkd4IbUcpTQt
         6vVqf3LXvjWhxvpVGnzagvhhvIFgMY9oop1ySXgU=
Date:   Fri, 16 Oct 2020 13:54:17 -0700
From:   akpm@linux-foundation.org
To:     b.zolnierkie@samsung.co, joe@perches.com, l.stelmach@samsung.com,
        m.szyprowski@samsung.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-fix-false-positive-on-empty-block-comment-lines.patch removed
 from -mm tree
Message-ID: <20201016205417.QaP6Uga5J%akpm@linux-foundation.org>
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
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-false-positive-on-empty-block-comment-lines.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

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

Patches currently in -mm which might be from l.stelmach@samsung.com are


