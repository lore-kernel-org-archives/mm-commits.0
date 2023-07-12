Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F307CEB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 19:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjGLTTA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 15:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjGLTTA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 15:19:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528BC198A
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 12:18:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E58D9618EE
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 19:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4477CC433C8;
        Wed, 12 Jul 2023 19:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689189538;
        bh=b/GU8DOBttY8e1BZI0zFhQYUBMkw9W2uGzQVGOmG9ow=;
        h=Date:To:From:Subject:From;
        b=05N9JrtvHlZISaWinNaVA/Xcf//slth4rarWIr0pBZ2cS+i2Eaq/Zti8pP0LN8Ag9
         CYxH1qTt/4PG+574IW0xAao3P7Lmc4/MdQBYGUv+x9mg1UyTzd6zJm6Ux8az5neJzR
         YL4cdb95f18YN/LdtRl6dD68MhA8+TlC2DrY/bXQ=
Date:   Wed, 12 Jul 2023 12:18:57 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        kunyu@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + =utf-8qkernel-=20relay-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20relay=5fopen=5fbuf=.patch added to mm-nonmm-unstable branch
Message-Id: <20230712191858.4477CC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: relay: remove unnecessary NULL values from relay_open_buf
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     =utf-8qkernel-=20relay-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20relay=5fopen=5fbuf=.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/=utf-8qkernel-=20relay-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20relay=5fopen=5fbuf=.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Li kunyu <kunyu@nfschina.com>
Subject: kernel: relay: remove unnecessary NULL values from relay_open_buf
Date: Fri, 14 Jul 2023 07:44:59 +0800

buf is assigned first, so it does not need to initialize the assignment.

Link: https://lkml.kernel.org/r/20230713234459.2908-1-kunyu@nfschina.com
Signed-off-by: Li kunyu <kunyu@nfschina.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/relay.c~=utf-8qkernel-=20relay-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20relay=5fopen=5fbuf=
+++ a/kernel/relay.c
@@ -375,7 +375,7 @@ static struct dentry *relay_create_buf_f
  */
 static struct rchan_buf *relay_open_buf(struct rchan *chan, unsigned int cpu)
 {
- 	struct rchan_buf *buf = NULL;
+	struct rchan_buf *buf;
 	struct dentry *dentry;
 
  	if (chan->is_global)
_

Patches currently in -mm which might be from kunyu@nfschina.com are

=utf-8qkernel-=20relay-=20remove=20unnecessary=20=-=utf-8q=e2=80=98null=e2=80=99=20values=20from=20relay=5fopen=5fbuf=.patch

