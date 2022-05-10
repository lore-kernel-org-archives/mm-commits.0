Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6E4C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbiEJEXq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbiEJEXI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FADD1C15C6
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6265B81AF7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728AEC385C2;
        Tue, 10 May 2022 04:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156264;
        bh=euE2zhwfqfVPFvAMJuue1eI5b8ufXSLsLDhvUx6O/Io=;
        h=Date:To:From:Subject:From;
        b=pAqxj7D/nMNHrxJ+dK4FkWvpEffK5qXYvIGJOoGD3RtFbBaZX3o7Doz7ORhzotYSH
         pLdH+tfxuJ8RQZUqzG+bu6D3tRJzvU15+JHHPWUevAnj2eg2qSAhvAHZ7lnsOyvEMM
         Yp/St6N9Ct6Nupg1Vqa4ndgF1Qp2WXNshD2q5gDU=
Date:   Mon, 09 May 2022 21:17:43 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, trix@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-remove-back_str-initialization.patch removed from -mm tree
Message-Id: <20220510041744.728AEC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: remove back_str initialization
has been removed from the -mm tree.  Its filename was
     lib-remove-back_str-initialization.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


