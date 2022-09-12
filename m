Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C36C6FA82
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiILE6i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiILE5I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C102873A
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9F4060AF4
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4A8C433C1;
        Mon, 12 Sep 2022 04:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958625;
        bh=ccaeLfkobvkcTE1EhhIavay4GFuD8F0I4aL7yqpEA1o=;
        h=Date:To:From:Subject:From;
        b=LwwISNoHZ+r+O5vMWY9cF8hHk93v8j9R99hdTzvGMkrnJuXT2VB1mKsEHzYayZVew
         7/GLDWPdeKa06M3xdYgIIpd4l0Uq6nlESRifxljTN3OFC8jVWC7p+ivdsUIArSfZ5L
         S9mo6UCqOJe69qiOXH0C06E1RUJGu2pvs760UfVw=
Date:   Sun, 11 Sep 2022 21:57:04 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        mic@digikod.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-handle-file-pointer-type.patch removed from -mm tree
Message-Id: <20220912045705.2E4A8C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: handle FILE pointer type
has been removed from the -mm tree.  Its filename was
     checkpatch-handle-file-pointer-type.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mickaël Salaün <mic@digikod.net>
Subject: checkpatch: handle FILE pointer type
Date: Fri, 2 Sep 2022 13:19:23 +0200

When using a "FILE *" type, checkpatch considers this an error:
  ERROR: need consistent spacing around '*' (ctx:WxV)
  #32: FILE: f.c:8:
  +static void a(FILE *const b)
                      ^

Fix this by explicitly defining "FILE" as a common type.  This is useful for
user space patches.

With this patch, we now get:
   <E> <E> <_>WS( )
   <E> <E> <_>IDENT(static)
   <E> <V> <_>WS( )
   <E> <V> <_>DECLARE(void )
   <E> <T> <_>FUNC(a)
   <E> <V> <V>PAREN('(')
   <EV> <N> <_>DECLARE(FILE *const )
   <EV> <T> <_>IDENT(b)
   <EV> <V> <_>PAREN(')') -> V
   <E> <V> <_>WS(
  )
  32 > . static void a(FILE *const b)
  32 > EEVVVVVVVTTTTTVNTTTTTTTTTTTTVVV
  32 >  ______________________________

Link: https://lkml.kernel.org/r/20220902111923.1488671-1-mic@digikod.net
Link: https://lore.kernel.org/r/20220902111923.1488671-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-handle-file-pointer-type
+++ a/scripts/checkpatch.pl
@@ -576,10 +576,14 @@ our $typeKernelTypedefs = qr{(?x:
 	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
 )};
+our $typeStdioTypedefs = qr{(?x:
+	FILE
+)};
 our $typeTypedefs = qr{(?x:
 	$typeC99Typedefs\b|
 	$typeOtherOSTypedefs\b|
-	$typeKernelTypedefs\b
+	$typeKernelTypedefs\b|
+	$typeStdioTypedefs\b
 )};
 
 our $zero_initializer = qr{(?:(?:0[xX])?0+$Int_type?|NULL|false)\b};
_

Patches currently in -mm which might be from mic@digikod.net are


