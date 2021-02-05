Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72260C433E0
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 310D461606
	for <mm-commits@archiver.kernel.org>; Sat,  6 Feb 2021 03:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhBFDeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:34:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhBFDb4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Feb 2021 22:31:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB33A64FFC;
        Fri,  5 Feb 2021 22:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612565073;
        bh=EVx5NBgxt3QPew0Yr6w7w6Fn2BaSQRouG1XJfynTbsA=;
        h=Date:From:To:Subject:From;
        b=syIPBtcO8SP7mGrVa4rSdWw7Uv17te5RPDJ2jAETdlzZg8bQiK0J8Pd3FpLKkvIIh
         nZ+X5AtC4SmxK4kCmdtzteEB2yo4tpUiHMpT1h7LIGGKsJLmkN/4iC3akjvb44aTI2
         DE9T0k18OIX2rxTmsYKYHJyZ1eEHyzxbCL0EkAws=
Date:   Fri, 05 Feb 2021 14:44:32 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, joe@perches.com, mm-commits@vger.kernel.org
Subject:  +
 checkpatch-dont-warn-about-colon-termination-in-linker-scripts.patch added
 to -mm tree
Message-ID: <20210205224432.QKvrsirHA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't warn about colon termination in linker scripts
has been added to the -mm tree.  Its filename is
     checkpatch-dont-warn-about-colon-termination-in-linker-scripts.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-dont-warn-about-colon-termination-in-linker-scripts.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-dont-warn-about-colon-termination-in-linker-scripts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: checkpatch: don't warn about colon termination in linker scripts

This check erroneously flags cases like the one in my recent printk
enumeration patch[0], where the spaces are syntactic, and `section:' vs. 
`section :' is syntactically important:

    ERROR: space prohibited before that ':' (ctx:WxW)
    #258: FILE: include/asm-generic/vmlinux.lds.h:314:
    +       .printk_fmts : AT(ADDR(.printk_fmts) - LOAD_OFFSET) {

0: https://lore.kernel.org/patchwork/patch/1375749/

Link: https://lkml.kernel.org/r/YBwhqsc2TIVeid3t@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-warn-about-colon-termination-in-linker-scripts
+++ a/scripts/checkpatch.pl
@@ -5053,7 +5053,7 @@ sub process {
 				# A colon needs no spaces before when it is
 				# terminating a case value or a label.
 				} elsif ($opv eq ':C' || $opv eq ':L') {
-					if ($ctx =~ /Wx./) {
+					if ($ctx =~ /Wx./ and $realfile !~ m@.*\.lds\.h$@) {
 						if (ERROR("SPACING",
 							  "space prohibited before that '$op' $at\n" . $hereptr)) {
 							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
_

Patches currently in -mm which might be from chris@chrisdown.name are

checkpatch-dont-warn-about-colon-termination-in-linker-scripts.patch

