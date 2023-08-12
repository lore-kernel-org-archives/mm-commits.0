Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244F6C0015E
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjHLWGC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjHLWFq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:05:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAEA1BD1
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A753B60BFC
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0940CC433C7;
        Sat, 12 Aug 2023 22:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877943;
        bh=mPc1lHs5xBRPhtoLJhVmxQ/FDu+DhYi0SdE8vWSJuqs=;
        h=Date:To:From:Subject:From;
        b=IFo5oPz4meXHzYxCvvpOg8YodhUwJnNOtnKq5CDPGkIw/xu6AgT1fKhiAPAIJmbbg
         X4qhaaBgvYWF+Qs3kIZD16aRS7SHk33px5+Bq0TIzjFNOEfXjJ6OYOh/E0kcW6YFrh
         YDcrLypdJLQY7m9NY9huvuJpDNbo1cbHivoaTRxg=
Date:   Sat, 12 Aug 2023 15:05:42 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        machel@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-error-inject-remove-error-checking-for-debugfs_create_dir.patch removed from -mm tree
Message-Id: <20230812220543.0940CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: error-inject: remove error checking for debugfs_create_dir()
has been removed from the -mm tree.  Its filename was
     lib-error-inject-remove-error-checking-for-debugfs_create_dir.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


