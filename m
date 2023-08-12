Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CD4C001E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjHLWGB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjHLWFq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A23019B3
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95724620CD
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA80BC433C7;
        Sat, 12 Aug 2023 22:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877942;
        bh=mVwCqCPg2ch4nFSR42OfE7eNckVCT/LI4LvVKpIqrF4=;
        h=Date:To:From:Subject:From;
        b=fUR0v9KdfibqCHswbghLKxRqu1zjycHgAsrcx0xY0pqca6sHxjnmfCqBbCQC21Wzh
         XzpIRO+UdVc0yTrF7ieMfbCsgOheMLKp8JOXra8e1K6hYB1pRbTsdtXJtQycoFPr0O
         RaW6otkR4NgVOfdDEJonIZzOqT7owfNqpyMo/Ujc=
Date:   Sat, 12 Aug 2023 15:05:41 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        david@redhat.com, akinobu.mita@gmail.com, machel@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-remove-error-checking-for-debugfs_create_dir.patch removed from -mm tree
Message-Id: <20230812220541.EA80BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: remove error checking for debugfs_create_dir()
has been removed from the -mm tree.  Its filename was
     lib-remove-error-checking-for-debugfs_create_dir.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


