Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A020FC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 19:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiEYTGP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 15:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiEYTGO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 15:06:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A567D101CB
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 12:06:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0339ECE1EA4
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 19:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583E3C385B8;
        Wed, 25 May 2022 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653505569;
        bh=LHJkRjcfAafIiPmHRnU4HkSQYWuQEyj4okbKPNRZ9cI=;
        h=Date:To:From:Subject:From;
        b=S1fJyrnHxgfDI/WCt88Gp7O9eFzfU/adyi7xfM0F1tNHDSE01keNxrTpdlTtTgb4e
         hyhw1xJ6Loesg4SEbalAJodK2AoFDJdeVhdXWlxbHasiOLsUGuM6c/MNuUwymnpfC7
         VLe2aJKQi7hyMsyI9qPoOqhoRiKQQKBAzi/l4Buc=
Date:   Wed, 25 May 2022 12:06:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        dhowells@redhat.com, joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-xa_state-and-xa_state_order-to-the-macro-declaration-list.patch added to mm-nonmm-unstable branch
Message-Id: <20220525190609.583E3C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add XA_STATE and XA_STATE_ORDER to the macro declaration list
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-xa_state-and-xa_state_order-to-the-macro-declaration-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-xa_state-and-xa_state_order-to-the-macro-declaration-list.patch

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
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add XA_STATE and XA_STATE_ORDER to the macro declaration list
Date: Wed, 25 May 2022 12:03:17 -0700

XA_STATE() and XA_STATE_ORDER macro uses are declarations.

Add them to the declaration macro list to avoid suggesting a blank line
after declarations when used.

Link: https://lkml.kernel.org/r/144314f4bf2c58cf2336028a75a5127e848abd81.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-xa_state-and-xa_state_order-to-the-macro-declaration-list
+++ a/scripts/checkpatch.pl
@@ -1042,7 +1042,8 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOr
 our $declaration_macros = qr{(?x:
 	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
 	(?:$Storage\s+)?[HLP]?LIST_HEAD\s*\(|
-	(?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(
+	(?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(|
+	(?:$Storage\s+)?(?:XA_STATE|XA_STATE_ORDER)\s*\(
 )};
 
 our %allow_repeated_words = (
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-xa_state-and-xa_state_order-to-the-macro-declaration-list.patch

