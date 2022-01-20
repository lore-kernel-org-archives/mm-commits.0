Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24564C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiATCKl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:10:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51608 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbiATCKl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:10:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D862B81C9F
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09730C004E1;
        Thu, 20 Jan 2022 02:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644639;
        bh=1buiz3LHKvr/5IDVWEP49jRTxNZHKmv7vHP3bJrx57E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zds32Qt7DOdiLkcSbfYL6i6QGhRjF7ge8d3WcSd0RLLOxBG+6PNpyq+c3IE65LMeJ
         nkpG0LWfj+CN5Hg3Opx26kPinPBYBK43HemmV7v5LBT3aXj+8p3SQ/cVC5w3cLX7dv
         I5ywOvcRWaz4jhE+WXq9br/NCkIUcdxVmDe4sMmk=
Date:   Wed, 19 Jan 2022 18:10:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.i.king@gmail.com,
        jarkko@kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 55/55] lib: remove redundant assignment to
 variable ret
Message-ID: <20220120021038.j92W3L8QA%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>
Subject: lib: remove redundant assignment to variable ret

Variable ret is being assigned a value that is never read.  If the
for-loop is entered then ret is immediately re-assigned a new value.  If
the for-loop is not executed ret is never read.  The assignment is
redundant and can be removed.

Link: https://lkml.kernel.org/r/20211230134557.83633-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
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
