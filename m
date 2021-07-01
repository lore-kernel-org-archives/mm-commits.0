Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC3FC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D0561477
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbhGAB7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB7F (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED7C26147D;
        Thu,  1 Jul 2021 01:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104595;
        bh=t4fUpIseMo9kGaMebfPbXWFx074uUhQC5SxSfDL5mz4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=olspHHV5YGIn1SOEi0AxNYmBqAZewivSKpH5LS1XfMh2IAaz+hNWVF+uvdNrNA5ji
         RidZdrE7QzQbeb7dREfPmD/lVP6/Hkx3j6GlCyUx9sr7sLqUE0A9Vmk3jlx0OzaHR/
         kQRg+7veXhxkk7oxYpERmghj4UrTH7/C3JKSyqgY=
Date:   Wed, 30 Jun 2021 18:56:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        konishi.ryusuke@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 178/192] nilfs2: remove redundant continue
 statement in a while-loop
Message-ID: <20210701015634.WGEgit9PU%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>
Subject: nilfs2: remove redundant continue statement in a while-loop

The continue statement at the end of the while-loop is redundant,
remove it.

Addresses-Coverity: ("Continue has no effect")
Link: https://lkml.kernel.org/r/20210621100519.10257-1-colin.king@canonical.com
Link: https://lkml.kernel.org/r/1624557664-17159-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nilfs2/btree.c~nilfs2-remove-redundant-continue-statement-in-a-while-loop
+++ a/fs/nilfs2/btree.c
@@ -738,7 +738,6 @@ static int nilfs_btree_lookup_contig(con
 			if (ptr2 != ptr + cnt || ++cnt == maxblocks)
 				goto end;
 			index++;
-			continue;
 		}
 		if (level == maxlevel)
 			break;
_
