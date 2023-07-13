Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D36C001DD
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 16:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbjGMQpJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 12:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbjGMQpG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 12:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBA71FC0
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 09:45:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7984C61999
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 16:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14FCC433C7;
        Thu, 13 Jul 2023 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689266703;
        bh=OCW01xivr8cHUDFwOOlchqDJIwRVOoL7wgA1aTw62TQ=;
        h=Date:To:From:Subject:From;
        b=l9Sy+6Otufby27dPyCHtfkTN0Jx+C7dadMQjf3q6WFj6PdHHd+bYgGa7OozJf7OXC
         Dc4SQjamh4WcXxNhIT8LYvY4h+Elbcx0hGWdxB2WBxY5gH5sVSHwo3RMir8j6WWW/R
         /xLlCnmxg2Gbiepx4VdaxL96hlWcZ0A5k/ROamj0=
Date:   Thu, 13 Jul 2023 09:45:03 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        david@redhat.com, akinobu.mita@gmail.com, machel@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-remove-error-checking-for-debugfs_create_dir.patch added to mm-nonmm-unstable branch
Message-Id: <20230713164503.C14FCC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: remove error checking for debugfs_create_dir()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-remove-error-checking-for-debugfs_create_dir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-remove-error-checking-for-debugfs_create_dir.patch

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
Subject: lib: remove error checking for debugfs_create_dir()
Date: Thu, 13 Jul 2023 16:24:43 +0800

It is expected that most callers should _ignore_ the errors return by
debugfs_create_dir() in err_inject_init().

Link: https://lkml.kernel.org/r/20230713082455.2415-1-machel@vivo.com
Signed-off-by: Wang Ming <machel@vivo.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/notifier-error-inject.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/notifier-error-inject.c~lib-remove-error-checking-for-debugfs_create_dir
+++ a/lib/notifier-error-inject.c
@@ -83,9 +83,6 @@ static int __init err_inject_init(void)
 	notifier_err_inject_dir =
 		debugfs_create_dir("notifier-error-inject", NULL);
 
-	if (!notifier_err_inject_dir)
-		return -ENOMEM;
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from machel@vivo.com are

lib-remove-error-checking-for-debugfs_create_dir.patch

