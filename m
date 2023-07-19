Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B48C001DC
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 19:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjGSTda (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjGSTdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 15:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E61E1FED
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 12:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F487617F4
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5352C433C9;
        Wed, 19 Jul 2023 19:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689795173;
        bh=loqPV6Csim3Ig4cZT4jbfDNsaS2CjrOg6oqkl18aat8=;
        h=Date:To:From:Subject:From;
        b=uL8WAry9I14AGDOxWx/Vu/kQXlmeZX1FgXqkIursim78jUj+LYARbXu5nRg7LlMXd
         ubMe8EI3HmcYCkhruPyxf3IZqA+9rC9q54JGqAN8moY6hsi8DUL1U17vyl0aGnAPzw
         PPy0zzk5wf+LXWzVlDNcDinNXaC89MpFV2PSUzEU=
Date:   Wed, 19 Jul 2023 12:32:51 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        machel@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-error-inject-remove-error-checking-for-debugfs_create_dir.patch added to mm-nonmm-unstable branch
Message-Id: <20230719193253.B5352C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: error-inject: remove error checking for debugfs_create_dir()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-error-inject-remove-error-checking-for-debugfs_create_dir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-error-inject-remove-error-checking-for-debugfs_create_dir.patch

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
From: Wang Ming <machel@vivo.com>
Subject: lib: error-inject: remove error checking for debugfs_create_dir()
Date: Wed, 19 Jul 2023 14:44:10 +0000

It is expected that most callers should _ignore_ the errors return by
debugfs_create_dir() in ei_debugfs_init().

Link: https://lkml.kernel.org/r/20230719144355.6720-1-machel@vivo.com
Signed-off-by: Wang Ming <machel@vivo.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/error-inject.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/error-inject.c~lib-error-inject-remove-error-checking-for-debugfs_create_dir
+++ a/lib/error-inject.c
@@ -217,8 +217,6 @@ static int __init ei_debugfs_init(void)
 	struct dentry *dir, *file;
 
 	dir = debugfs_create_dir("error_injection", NULL);
-	if (!dir)
-		return -ENOMEM;
 
 	file = debugfs_create_file("list", 0444, dir, NULL, &ei_fops);
 	if (!file) {
_

Patches currently in -mm which might be from machel@vivo.com are

lib-remove-error-checking-for-debugfs_create_dir.patch
lib-error-inject-remove-error-checking-for-debugfs_create_dir.patch

