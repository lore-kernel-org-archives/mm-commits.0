Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920EDC433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4564D64EE2
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhBZBXY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhBZBWt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4241E64F03;
        Fri, 26 Feb 2021 01:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302525;
        bh=Fi6yOwzC/g1bydpzhmjbQY9sFAaDnrS8jdiciF8/vqc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=NS7hivYbD5V9DymQJsnzBvlT6g3PkVmcvKemoBo2o6HATZWhm/rRzFmQmbOAYWdma
         ga2Spct9nTOKCjhWokLILMvLJpPGEX/+bqHfpx9GNSAHF4Yme8SIMQV5woZuc2HXiG
         Nk8a3IdkLR7EvXLXc/hKGvtDxIr9bSRyYi2+m4lM=
Date:   Thu, 25 Feb 2021 17:22:04 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, joe@perches.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 106/118] checkpatch: don't warn about colon
 termination in linker scripts
Message-ID: <20210226012204.xB5hJqZXG%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Link: https://lkml.kernel.org/r/YB6UsjCOy1qrrlSD@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-warn-about-colon-termination-in-linker-scripts
+++ a/scripts/checkpatch.pl
@@ -5044,7 +5044,7 @@ sub process {
 				# A colon needs no spaces before when it is
 				# terminating a case value or a label.
 				} elsif ($opv eq ':C' || $opv eq ':L') {
-					if ($ctx =~ /Wx./) {
+					if ($ctx =~ /Wx./ and $realfile !~ m@.*\.lds\.h$@) {
 						if (ERROR("SPACING",
 							  "space prohibited before that '$op' $at\n" . $hereptr)) {
 							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
_
