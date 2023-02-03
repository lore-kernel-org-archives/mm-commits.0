Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A478C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbjBCGmn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjBCGlP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A072687A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 22A5DCE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF39C433D2;
        Fri,  3 Feb 2023 06:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406274;
        bh=wvMDrCz0nnATWmKEEKO1QXGxGLhLGdFIHo0YVWJWYJ4=;
        h=Date:To:From:Subject:From;
        b=F1Aq+lSBQn/QB/nQgSJQTlVCQPOauNVLEt1y/+BhaGoGHScrFF6d0J8HPEP6CnMuG
         EcJo1T19CL8yhbs7CzB7m4SYaHRftvcDikUFRTQ5x05lQw73LbSjPB/XcKcPih8Gl9
         UMi6O2lakERyd0KpG8DR6YItQBN52L7LFl4A62Gg=
Date:   Thu, 02 Feb 2023 22:37:53 -0800
To:     mm-commits@vger.kernel.org, minchan@kernel.org,
        mike.kravetz@oracle.com, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-set-default-zspage-chain-size-to-8.patch removed from -mm tree
Message-Id: <20230203063754.5EF39C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: set default zspage chain size to 8
has been removed from the -mm tree.  Its filename was
     zsmalloc-set-default-zspage-chain-size-to-8.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: set default zspage chain size to 8
Date: Wed, 18 Jan 2023 09:52:10 +0900

This changes key characteristics (pages per-zspage and objects per-zspage)
of a number of size classes which in results in different pool
configuration.  With zspage chain size of 8 we have more size clases
clusters (123) and higher huge size class watermark (3632 bytes).

Please read zsmalloc documentation for more details.

Link: https://lkml.kernel.org/r/20230118005210.2814763-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/Kconfig~zsmalloc-set-default-zspage-chain-size-to-8
+++ a/mm/Kconfig
@@ -193,7 +193,7 @@ config ZSMALLOC_STAT
 
 config ZSMALLOC_CHAIN_SIZE
 	int "Maximum number of physical pages per-zspage"
-	default 4
+	default 8
 	range 4 16
 	depends on ZSMALLOC
 	help
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


