Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A1EC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E2B922257
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708945;
	bh=yaRCii/ilOqq8cFfm5MYK5blJtbtiqkYYuzuG2dKOdA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZgV4/sCKMklbDYrPT5OUTyj6xOXKFTbJX3GheW/vOXDvclI9dwT9aaJmqmXQWqMEi
	 7o7g+3KVNwkJfmVBAJc5fqmR5gi1chgY6anyzgHJdJMGICrsNrITDt0YQx19fP5E5H
	 +K2DRQeL5XdeP5bqAvP1P0YiCx2Bshf+d1rhkygE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387906AbgJNUzo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNUzo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:44 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B031B22253;
        Wed, 14 Oct 2020 20:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708944;
        bh=yaRCii/ilOqq8cFfm5MYK5blJtbtiqkYYuzuG2dKOdA=;
        h=Date:From:To:Subject:From;
        b=eHEMMInG0cPWysualuAYQk1vcasqlmgcin4k25L5LIXS4Br3WSlIgDUFRd9Uc36oa
         AO8KUY+PoAP2P6VE89W8foHVQFhjkC5wf4xn0iaAKAfFxqsfc+sHOHNwfY3SKny1/1
         WQ2L1KV99b4vlMzFNFkseAdKxhxML2aks8BExzAg=
Date:   Wed, 14 Oct 2020 13:55:43 -0700
From:   akpm@linux-foundation.org
To:     luc.vanoostenryck@gmail.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, nivedita@alum.mit.edu
Subject:  [merged] compilerh-avoid-escaped-section-names.patch
 removed from -mm tree
Message-ID: <20201014205543.G6qGQWlB8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h: avoid escaped section names
has been removed from the -mm tree.  Its filename was
     compilerh-avoid-escaped-section-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: compiler.h: avoid escaped section names

The stringification operator, `#`, in the preprocessor escapes strings. 
For example, `# "foo"` becomes `"\"foo\""`.  GCC and Clang differ in how
they treat section names that contain \".

The portable solution is to not use a string literal with the preprocessor
stringification operator.

In this case, since __section unconditionally uses the stringification
operator, we actually want the more verbose
__attribute__((__section__())).

Link: https://bugs.llvm.org/show_bug.cgi?id=42950
Link: https://lkml.kernel.org/r/20200929194318.548707-1-ndesaulniers@google.com
Fixes: commit e04462fb82f8 ("Compiler Attributes: remove uses of __attribute__ from compiler.h")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler.h~compilerh-avoid-escaped-section-names
+++ a/include/linux/compiler.h
@@ -155,7 +155,7 @@ void ftrace_likely_update(struct ftrace_
 	extern typeof(sym) sym;					\
 	static const unsigned long __kentry_##sym		\
 	__used							\
-	__section("___kentry" "+" #sym )			\
+	__attribute__((__section__("___kentry+" #sym)))		\
 	= (unsigned long)&sym;
 #endif
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are


