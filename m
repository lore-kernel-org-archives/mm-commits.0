Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D84BC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00282221FD
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881711;
	bh=aiwbLXUGJ4OwFSILP8/2SbwYflWux32f7ItbpA1XoY4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JjgmVbOv7aPpBIFH253jRYZp52TBPnCyZiaSlLFrShs/Pl4bS2K5BIcyD6olEtlNz
	 eHhevqAp3zMUNYSiB0WQxpUM/1zF5wuKtfRxX937igg4zqRQVrcD7Xagw7kytXCfGS
	 tUpkOi8JRAhcaq14Ep1XPzJZGgwW/2ibD+U/Rt6g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409434AbgJPUzK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUzK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:55:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A289A221FD;
        Fri, 16 Oct 2020 20:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881709;
        bh=aiwbLXUGJ4OwFSILP8/2SbwYflWux32f7ItbpA1XoY4=;
        h=Date:From:To:Subject:From;
        b=HdGU4AN3BQL6X/D58g3slrnV8nOqmUXOb6YxOqbMYommEAxwCRGFACdTGg2usP0Nr
         XzzqbAyXhYDJ3gJ24IV68tghCgMhsrOS7qug6cnI6DJpNUljxP+/l7I02Ups0PGZvl
         SRa+cDmGU4sEtZkKnZDBZ7QrlL341Vau97ypCQRk=
Date:   Fri, 16 Oct 2020 13:55:09 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sudipm.mukherjee@gmail.com
Subject:  [merged] kernel-relayc-drop-unneeded-initialization.patch
 removed from -mm tree
Message-ID: <20201016205509.r6bJ9SLlM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: drop unneeded initialization
has been removed from the -mm tree.  Its filename was
     kernel-relayc-drop-unneeded-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are


