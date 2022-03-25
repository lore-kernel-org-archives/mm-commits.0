Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3C4C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346255AbiCYBhK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357502AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACF5344D3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80C46B8272E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BABC340EC;
        Fri, 25 Mar 2022 01:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172034;
        bh=E1gjSADdo6k4uI31TtjCAEE5vQvS3F+tvfsxZb0SQEM=;
        h=Date:To:From:Subject:From;
        b=uCsWolo39mEHTwcao3cOrnaFVYSSdExh6NTkUDuvptpRfPYqnQBlVKlJKcjuaihgP
         VKxi3B29ASrnTxPGYY83ARrGAF3oMEt1qe1n4xymbB0tQwcGi/eTBVkK+u9OWxt7l6
         CikExmQPIfndlBxbm6LP1OnGuFZHu4hWGVxjDvMU=
Date:   Thu, 24 Mar 2022 18:33:53 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        dwaipayanray1@gmail.com, joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test.patch removed from -mm tree
Message-Id: <20220325013354.21BABC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add early_param exception to blank line after struct/function test
has been removed from the -mm tree.  Its filename was
     checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add early_param exception to blank line after struct/function test

Add early_param as another exception to the blank line preferred after
function/struct/union declaration or definition test.

Link: https://lkml.kernel.org/r/3bd6ada59f411a7685d7e64eeb670540d4bfdcde.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test
+++ a/scripts/checkpatch.pl
@@ -3926,7 +3926,7 @@ sub process {
 		if ($prevline =~ /^[\+ ]};?\s*$/ &&
 		    $line =~ /^\+/ &&
 		    !($line =~ /^\+\s*$/ ||
-		      $line =~ /^\+\s*EXPORT_SYMBOL/ ||
+		      $line =~ /^\+\s*(?:EXPORT_SYMBOL|early_param)/ ||
 		      $line =~ /^\+\s*MODULE_/i ||
 		      $line =~ /^\+\s*\#\s*(?:end|elif|else)/ ||
 		      $line =~ /^\+[a-z_]*init/ ||
_

Patches currently in -mm which might be from joe@perches.com are


