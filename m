Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4D5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 31 Dec 2021 02:26:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240940AbhLaC0A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Dec 2021 21:26:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55506 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhLaCZ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Dec 2021 21:25:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 510C0B81D38
        for <mm-commits@vger.kernel.org>; Fri, 31 Dec 2021 02:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECB3C36AEE;
        Fri, 31 Dec 2021 02:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640917557;
        bh=GBwXkcnm+mdTwyoH0OzFDiskMYavPx2VzI5Dx9rKgro=;
        h=Date:From:To:Subject:From;
        b=t62sG3pj72/xb7YBKTV7hCmdGd46VyiQAqH8R8Xej1zSbEeBeVqjY+pNtZBj5RPkB
         DCUDjEDwmrl7QrH4vkTSHpWLNpG9WOA20eO6Av1GB+w94+CR45pZpwz1DVUPRIGUHP
         w54vHzE3ML3VOJP1xRPDeU5g5K4I3wQJIrw281hc=
Date:   Thu, 30 Dec 2021 18:25:56 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jarkko@kernel.org,
        colin.i.king@gmail.com
Subject:  + lib-remove-redundant-assignment-to-variable-ret.patch
 added to -mm tree
Message-ID: <20211231022556.8iY1i%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: remove redundant assignment to variable ret
has been added to the -mm tree.  Its filename is
     lib-remove-redundant-assignment-to-variable-ret.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-remove-redundant-assignment-to-variable-ret.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-remove-redundant-assignment-to-variable-ret.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: lib: remove redundant assignment to variable ret

Variable ret is being assigned a value that is never read.  If the
for-loop is entered then ret is immediately re-assigned a new value.  If
the for-loop is not executed ret is never read.  The assignment is
redundant and can be removed.

Link: https://lkml.kernel.org/r/20211230134557.83633-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/asn1_encoder.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/asn1_encoder.c~lib-remove-redundant-assignment-to-variable-ret
+++ a/lib/asn1_encoder.c
@@ -164,8 +164,6 @@ asn1_encode_oid(unsigned char *data, con
 
 	data_len -= 3;
 
-	ret = 0;
-
 	for (i = 2; i < oid_len; i++) {
 		ret = asn1_encode_oid_digit(&d, &data_len, oid[i]);
 		if (ret < 0)
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

ocfs2-remove-redundant-assignment-to-pointer-root_bh.patch
mm-migrate-remove-redundant-variables-used-in-a-for-loop.patch
lib-remove-redundant-assignment-to-variable-ret.patch
nilfs2-remove-redundant-pointer-sbufs.patch
kernel-sysctlc-remove-unused-variable-ten_thousand.patch

