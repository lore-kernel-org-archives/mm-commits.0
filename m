Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA90C4332B
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BAFC64F1F
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhB0Cdi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230139AbhB0CdC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:33:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BEA064F21;
        Sat, 27 Feb 2021 02:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393149;
        bh=xXgcohioe6/d6r7d3DhxpeTS1kEHXn+mg6xgtJSLBhI=;
        h=Date:From:To:Subject:From;
        b=nOyx9RWGlzPFSlMw5eCWyxw0Jp+ZqusUCEGo4uVu1eMWQX0KpZejyvmBVFYhlYVrd
         0gmZ3nngPS0HpFyO9ePScMxGOrycg0N5/T4xJBrEEOIE+wuFY16iVj6ZhDn+SGYSI4
         4/h8HJnRZYR4Yq5W1zs6b8x7NkaF+95OUdsKlzOM=
Date:   Fri, 26 Feb 2021 18:32:29 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, joe@perches.com, mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-dont-warn-about-colon-termination-in-linker-scripts.patch
 removed from -mm tree
Message-ID: <20210227023229.anCbVZ3HL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't warn about colon termination in linker scripts
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-warn-about-colon-termination-in-linker-scripts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from chris@chrisdown.name are


