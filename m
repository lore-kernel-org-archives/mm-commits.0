Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B83FC43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379728AbiFQC65 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbiFQC65 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:58:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A17565D13
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2A0DB826EF
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97771C3411A;
        Fri, 17 Jun 2022 02:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434733;
        bh=dOFcBTBZRK06HUv8rXHyBQGFgVX25F7Mvot5m6Xdv58=;
        h=Date:To:From:Subject:From;
        b=zxbR35Gq9TfJAPT97oLmvkKdYECfcZZTYO2xseSkCn1MdP53k9NKCMsOVr0LcJLvz
         eV0904+x8ib0nCLxTGHC2f2kPKkH9FqGAqBxFrBOFGP9x5jILVDfegvTf1N24XvU6H
         TU/mkq3K3azcr+1tHXCS4Ab6R2hdPtnB987VWZWs=
Date:   Thu, 16 Jun 2022 19:58:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        dhowells@redhat.com, joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-xa_state-and-xa_state_order-to-the-macro-declaration-list.patch removed from -mm tree
Message-Id: <20220617025853.97771C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: add XA_STATE and XA_STATE_ORDER to the macro declaration list
has been removed from the -mm tree.  Its filename was
     checkpatch-add-xa_state-and-xa_state_order-to-the-macro-declaration-list.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


