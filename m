Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A86C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40B8D21D7F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632881;
	bh=vzDXxFsSO1DZX/hgtZ+DzAKN9rn31dYC6ZMvp7j1xN0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1s0/ozoxJ2TDQ0nN0NZOYHqRUfTEWzszJ/T2inl23apMaMAc6cHFljTf50vvfoV60
	 xym9FlLBYWmnyfHgr8zbobHn86GwJdRZoV1lS5CfV4+a+UVy9CXW7wpkNeu+H7KGmn
	 MZpnZjbM4y8zmXug9AWoQGNl6Xndj4LTKOPvtiqQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389126AbgJMXsA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXr7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:47:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F3421D7A;
        Tue, 13 Oct 2020 23:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632879;
        bh=vzDXxFsSO1DZX/hgtZ+DzAKN9rn31dYC6ZMvp7j1xN0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KrtGEnt2aIHGfzcj1Yj0sEl6GXYUrBYFDWV92azbBUUZXpdnKsRb3/YDacwX2FC0a
         /R2xgIHdCgb2qyutxJe/U2D0XvWuiUlrS/6XmT+/5dFmaQOua6W0e4JC9j8RoYAs7O
         AwHFtWtBNjT9Ijg00yMNUAQSoiKy730xnWm8iXTU=
Date:   Tue, 13 Oct 2020 16:47:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        luc.vanoostenryck@gmail.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, nivedita@alum.mit.edu,
        torvalds@linux-foundation.org
Subject:  [patch 008/181] compiler.h: avoid escaped section names
Message-ID: <20201013234758.d5YBasJCH%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
