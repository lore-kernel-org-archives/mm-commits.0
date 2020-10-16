Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C395AC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BF702078A
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602818009;
	bh=2Lrf3xNueGp4Ipkr4K+aKF9mdcpeFyIChR8i8iUna8E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hhniNX+qJOQdbTI/LQ3ec7Y6IMv5c3EmJ+kyCrCR2QDYmzIsllskNI/EraKGahZ34
	 5m/SjSmrjZ76+aEKY6/qVRXrx9gPyYMnOqflY4h0SEGuKIFTySo6JNUTXzylRYgTi8
	 PKcMH3z9h4rvxa9slrSnRYvYr59RmQoW1J0DUwYQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393959AbgJPDN1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393799AbgJPDN1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:13:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609C72078A;
        Fri, 16 Oct 2020 03:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602818006;
        bh=2Lrf3xNueGp4Ipkr4K+aKF9mdcpeFyIChR8i8iUna8E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GGhivTDB88GIxbHIY/ohsYFGL2ky3OeJsupiQL58+gBKzZcLUYHcyaHvEQpWRO0fF
         nvUoh2OwyyEc8vmqniuvFSB1EL1mQuuUCnMszL0sryfmbZSkAsA6S7J+qGEsgdhxdA
         p4hffpmMx+Qm1O2uQcf24N/QiwZzEFivaH7tuKBA=
Date:   Thu, 15 Oct 2020 20:13:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
Subject:  [patch 149/156] kernel/relay.c: drop unneeded
 initialization
Message-ID: <20201016031325.UdPuXUqJr%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: kernel/relay.c: drop unneeded initialization

The variable 'consumed' is initialized with the consumed count but
immediately after that the consumed count is updated and assigned to
'consumed' again thus overwriting the previous value.  So, drop the
unneeded initialization.

Link: https://lkml.kernel.org/r/20201005205727.1147-1-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/relay.c~kernel-relayc-drop-unneeded-initialization
+++ a/kernel/relay.c
@@ -1002,7 +1002,7 @@ static int relay_file_read_avail(struct
 	size_t subbuf_size = buf->chan->subbuf_size;
 	size_t n_subbufs = buf->chan->n_subbufs;
 	size_t produced = buf->subbufs_produced;
-	size_t consumed = buf->subbufs_consumed;
+	size_t consumed;
 
 	relay_file_read_consume(buf, 0, 0);
 
_
