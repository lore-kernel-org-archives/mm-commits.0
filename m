Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6850C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5451921775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881582;
	bh=qG8/lLhnPb6k8lwU8l9pFuCHx6au1jmEqasG6De9MIQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KNkhuyDqW2Ujak6uHvFBoqE384oLgZVg+06lXj8RyuTGep++DLTLXny3Ub6tb7T2k
	 Hjche7Jml37Sg0uQwMafo0HhoidRXX7UNBgqywIJHKKVstD6s/E7+yBYceXK2NqVO6
	 HgcSKfkcZ8Lfn5zrg/w6dQ42/F/kiYANuDLSp8C4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409096AbgJPUw7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393599AbgJPUw6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F232145D;
        Fri, 16 Oct 2020 20:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881577;
        bh=qG8/lLhnPb6k8lwU8l9pFuCHx6au1jmEqasG6De9MIQ=;
        h=Date:From:To:Subject:From;
        b=pQjmq3kX54POyuKyyOg9WuKedAnfiCIEbn1zX6R3PE8EdV1XMwUp/xw3BhL9O1L19
         F3qx+NipVd0fQYiWoLSoYoODJTBk/J3Uq4BQN8+s3dLtlzWHixs9bh2ycJ8/2Ro+/w
         FfMzFcgmmht/oPbi3AM/eN5Cy4eopirdusNOV4IE=
Date:   Fri, 16 Oct 2020 13:52:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 lib-decompress_bunzip2-delete-duplicated-words.patch removed from -mm tree
Message-ID: <20201016205257.KwEQkzUGJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: decompress_bunzip2: delete duplicated words
has been removed from the -mm tree.  Its filename was
     lib-decompress_bunzip2-delete-duplicated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


