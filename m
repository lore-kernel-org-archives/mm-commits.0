Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E435C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377956AbiATVcF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:32:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40606 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348034AbiATVcE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:32:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 588C4618CC
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04E5C340E0;
        Thu, 20 Jan 2022 21:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714323;
        bh=HOZGVa0aovhNpd1WpNNSwL8SEDPsbr6C+O79W+14gmc=;
        h=Date:From:To:Subject:From;
        b=cWtSdFvBu2/uOB58YfRnGEAjwaOdI11yW9FVusKe0s6ZopNpw8B8HS1DQXPyZqa6E
         sQb5DhhD+WK3DEpLcwtZt+XogjaK2QZXzapS3lSnFMJbh+12I1Jf6ZBrF/Fj1t9m2k
         wwbQR+eYjw0ZXNJZtfEP9z8gZ5aL0kbniXN09rHc=
Date:   Thu, 20 Jan 2022 13:32:03 -0800
From:   akpm@linux-foundation.org
To:     colin.i.king@gmail.com, jarkko@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [merged]
 lib-remove-redundant-assignment-to-variable-ret.patch removed from -mm tree
Message-ID: <20220120213203.ZCqdK3kyA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: remove redundant assignment to variable ret
has been removed from the -mm tree.  Its filename was
     lib-remove-redundant-assignment-to-variable-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kernel-sysctlc-remove-unused-variable-ten_thousand.patch

