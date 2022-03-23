Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2D1C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345382AbiCWXHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345392AbiCWXHg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1769027A
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90DC5B8217F
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B31C340E9;
        Wed, 23 Mar 2022 23:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076763;
        bh=LpUvGqO6zTZezH5GVCSw/IQF4F8xd0thXDv9IcXhyMg=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=lpIm9UDMExd6lxgBAxCqgbup2pPH+mpGGz0YwvpB66wz5zjrQ06Nseg/8D+SH/bRG
         g1bs2xjrGVkduqKaLZDaoB+52vQrRKhh99nu9bj3M5rd2g0eyYZ75TihbIr6SR+2/I
         C2HKX9JzY0JYt5aeDFtD7DHe6EQi/VfbUwOIXeEE=
Date:   Wed, 23 Mar 2022 16:06:02 -0700
To:     lukas.bulwahn@gmail.com, dwaipayanray1@gmail.com, joe@perches.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 15/41] checkpatch: add early_param exception to blank line after struct/function test
Message-Id: <20220323230603.47B31C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
