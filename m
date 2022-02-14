Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF72C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 14 Feb 2022 23:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiBNXMl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Feb 2022 18:12:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiBNXMl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Feb 2022 18:12:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AE7139108
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 15:12:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E1E16151E
        for <mm-commits@vger.kernel.org>; Mon, 14 Feb 2022 23:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BA9C340E9;
        Mon, 14 Feb 2022 23:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644880351;
        bh=6sMz+AAV/MqZYe+JiUyFd47LIlSyqe0GxVAx0ffVQRw=;
        h=Date:To:From:Subject:From;
        b=okZe1lvQN4OrPjC0LR5RQ42Atnxf841w4Mmi99Dbv4+/g9eYWyKVwjUZezPXHwC+T
         R1pMmXE2wDjWd8tZZqxQx6btGXpmuH2AoxMY3ov7KaP7gvPjvJgK/ba3ltJJEpmOqj
         8NeHRqTcyVxg8JWVeL5SmmbCVEafn68f9CwlpII4=
Date:   Mon, 14 Feb 2022 15:12:31 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        dwaipayanray1@gmail.com, joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test.patch added to -mm tree
Message-Id: <20220214231231.A3BA9C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add early_param exception to blank line after struct/function test
has been added to the -mm tree.  Its filename is
     checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2.patch
checkpatch-add-fix-option-for-some-trailing_statements.patch
checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test.patch

