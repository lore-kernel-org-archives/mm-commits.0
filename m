Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A9DC4363A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 00:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B3E20760
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 00:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601942942;
	bh=PZLO/HuwgYpcQ/StjkRYLYbwcIk7SikmnUK3BYDUwYk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Kv5ncQWVAZlLDnJbGG+i1AhehXplg02THvvPvbLBp9V4EBF/Xs9fmnJtqbkUKtTE+
	 eavBcQRSdG9fspbl0F57BfQp2ydhRNtmh6435gAcpA69eKpgr0Wq18rXDM+D7hDwUo
	 a5NVYjEl7LMC2dBPfPuZPXTT9x6pfVJbySGLqcvU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgJFAJB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Oct 2020 20:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgJFAJB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Oct 2020 20:09:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A93E3206F4;
        Tue,  6 Oct 2020 00:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601942939;
        bh=PZLO/HuwgYpcQ/StjkRYLYbwcIk7SikmnUK3BYDUwYk=;
        h=Date:From:To:Subject:From;
        b=BS12Dxct1Bt+GfFoc6w65Q+fHL3l/kvEcZ31ZrprE5hP/zhe2uCSTrKAHFU47jeui
         6QRT0PF0ZEinhuc1KIm7z3dQ2RjZtoKhmIvH6ldshH6dg04ZznWK+NJMg7Pb/QjuNh
         OCL1o8lD2eBM90UTgh00HKdfzPBpOqifzFDEFblg=
Date:   Mon, 05 Oct 2020 17:08:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sudipm.mukherjee@gmail.com
Subject:  + kernel-relayc-drop-unneeded-initialization.patch added
 to -mm tree
Message-ID: <20201006000859.1UezxuBAm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/relay.c: drop unneeded initialization
has been added to the -mm tree.  Its filename is
     kernel-relayc-drop-unneeded-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-relayc-drop-unneeded-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-relayc-drop-unneeded-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-relayc-drop-unneeded-initialization.patch

