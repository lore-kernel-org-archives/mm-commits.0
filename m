Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC0EECAAD5
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 16:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiIBQ0T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 12:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbiIBQ0T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 12:26:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486605FF65
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 09:26:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C906B82C74
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 16:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1B5C433C1;
        Fri,  2 Sep 2022 16:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662135974;
        bh=eVBfffx80PAruiEtLRXU4Qka3FZJftMxZaJvvSmF0lk=;
        h=Date:To:From:Subject:From;
        b=Vy7IXMLnMSwMqn5TIjj5VPuPw+ljNn+NL7J2M9QvTyOvbaToYouYUOW/XbmLrlNhl
         2BYgD9Lvf80DZsm2qB0JnEx87tZoREsU0j0zmo/K30OJBwuQBcOCExvbRjWojonsqs
         97Z1C+G5h4JdblbCjG1xs1eEZtx2s+o+GYY/Wtck=
Date:   Fri, 02 Sep 2022 09:26:13 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        mic@digikod.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-handle-file-pointer-type.patch added to mm-nonmm-unstable branch
Message-Id: <20220902162614.9C1B5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: Handle FILE pointer type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-handle-file-pointer-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-handle-file-pointer-type.patch

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
From: Mickaël Salaün <mic@digikod.net>
Subject: checkpatch: Handle FILE pointer type
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

checkpatch-handle-file-pointer-type.patch

