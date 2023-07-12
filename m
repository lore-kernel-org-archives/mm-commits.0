Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA962EB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 19:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbjGLTTK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 15:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjGLTTJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 15:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21D4198A
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 12:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ED456188F
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 19:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39FFC433C8;
        Wed, 12 Jul 2023 19:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689189547;
        bh=qrFdGY+nkevQ/kH6I/WNpuNRMLQIpx71kX9BCuFdkNg=;
        h=Date:To:From:Subject:From;
        b=j/84Ykfb2Rwzt5hKnSSXtHMyz/JUMaLPF2ht8nIPk1sS12WVYf9TFRo/Ll8h+Rl5T
         XT5MJlPSbpmqKIa9VaudRYRTdY9vqt+qhP5fC0t3OS3JyC/Y2JeaoS5y1/AhlmzjTj
         bMcppFmaoYj03tqDFnddW3K09KaeQHErfzNFyrX0=
Date:   Wed, 12 Jul 2023 12:19:06 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foudation.org,
        kunyu@nfschina.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-relay-remove-unnecessary-null-values-from-relay_open_buf.patch added to mm-nonmm-unstable branch
Message-Id: <20230712191907.B39FFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: relay: remove unnecessary NULL values from relay_open_buf
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-relay-remove-unnecessary-null-values-from-relay_open_buf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-relay-remove-unnecessary-null-values-from-relay_open_buf.patch

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

--- a/kernel/relay.c~kernel-relay-remove-unnecessary-null-values-from-relay_open_buf
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

kernel-relay-remove-unnecessary-null-values-from-relay_open_buf.patch

