Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21B5C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1845642AbiDFB57 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573210AbiDESTo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 14:19:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE69FEF087
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 11:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 420EB618CD
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF35C385A1;
        Tue,  5 Apr 2022 18:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649182664;
        bh=zIwe1nBhrSxkFBNm86QUu3Sdwjn7zakwvgzwfDjHnLo=;
        h=Date:To:From:Subject:From;
        b=IcbCOtYr4IE2meQgabruo1zX4P3MCyaKfJhb51lwTl2mN+tLj8Ypk5z0i3sCDVrdd
         jSlJqll4IwSWh759iYi/MacEBD6IRi+zmbnPhaauCeJw9I0NL1ggvHPxy06a30doqx
         aQzWRsJI5ZLwKC4fRxtxeTmiiLinQXHklYT0Aigw=
Date:   Tue, 05 Apr 2022 11:17:43 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, trix@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-remove-back_str-initialization.patch added to -mm tree
Message-Id: <20220405181744.8AF35C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: remove back_str initialization
has been added to the -mm tree.  Its filename is
     lib-remove-back_str-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-remove-back_str-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-remove-back_str-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: lib: remove back_str initialization

Clang static analysis reports this false positive
glob.c:48:32: warning: Assigned value is garbage
  or undefined
  char const *back_pat = NULL, *back_str = back_str;
                                ^~~~~~~~   ~~~~~~~~

back_str is set after back_pat and it's use is protected by the !back_pat
check.  It is not necessary to initialize back_str, so remove the
initialization.

Link: https://lkml.kernel.org/r/20220402131546.3383578-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/glob.c~lib-remove-back_str-initialization
+++ a/lib/glob.c
@@ -45,7 +45,7 @@ bool __pure glob_match(char const *pat,
 	 * (no exception for /), it can be easily proved that there's
 	 * never a need to backtrack multiple levels.
 	 */
-	char const *back_pat = NULL, *back_str = back_str;
+	char const *back_pat = NULL, *back_str;
 
 	/*
 	 * Loop over each token (character or class) in pat, matching
_

Patches currently in -mm which might be from trix@redhat.com are

lib-remove-back_str-initialization.patch

