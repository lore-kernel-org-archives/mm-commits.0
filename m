Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0646C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF3592313C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgLPEnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgLPEnu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:50 -0500
Date:   Tue, 15 Dec 2020 20:42:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093766;
        bh=4Wl9mgxOgHzG0TK/Tzgh+6lCJN38AjG2Gfv+hjDpv1k=;
        h=From:To:Subject:In-Reply-To:From;
        b=UoB3NNN2yrzNv66YMoU+Z/x8KQhS4j7/KB/DYRVnpL8dWDAqHZTsNqTy+Z5cfavXm
         nvissiqIgHRNNy3Vwv9ajp6jT7f+fPbYkW1N8tb7e2Ma8yG0v61ePjnbWyEqEYSRTp
         rHerlCafhxiBfj/L4lLG90EVkF4yXpoHVkSgOMMA=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de,
        christophe.leroy@csgroup.eu, joel@jms.id.au, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, segher@kernel.crashing.org,
        torvalds@linux-foundation.org, yamada.masahiro@socionext.com
Subject:  [patch 08/95] asm-generic: force inlining of get_order()
 to work around gcc10 poor decision
Message-ID: <20201216044245.gdQ1_1QzT%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: asm-generic: force inlining of get_order() to work around gcc10 poor decision

When building mpc885_ads_defconfig with gcc 10.1,
the function get_order() appears 50 times in vmlinux:

[linux]# ppc-linux-objdump -x vmlinux | grep get_order | wc -l
50

[linux]# size vmlinux
   text	   data	    bss	    dec	    hex	filename
3842620	 675624	 135160	4653404	 47015c	vmlinux

In the old days, marking a function 'static inline' was forcing
GCC to inline, but since commit ac7c3e4ff401 ("compiler: enable
CONFIG_OPTIMIZE_INLINING forcibly") GCC may decide to not inline
a function.

It looks like GCC 10 is taking poor decisions on this.

get_order() compiles into the following tiny function,
occupying 20 bytes of text.

0000007c <get_order>:
  7c:   38 63 ff ff     addi    r3,r3,-1
  80:   54 63 a3 3e     rlwinm  r3,r3,20,12,31
  84:   7c 63 00 34     cntlzw  r3,r3
  88:   20 63 00 20     subfic  r3,r3,32
  8c:   4e 80 00 20     blr

By forcing get_order() to be __always_inline, the size of text is
reduced by 1940 bytes, that is almost twice the space occupied by
50 times get_order()

[linux-powerpc]# size vmlinux
   text	   data	    bss	    dec	    hex	filename
3840680	 675588	 135176	4651444	 46f9b4	vmlinux

Link: https://lkml.kernel.org/r/96c6172d619c51acc5c1c4884b80785c59af4102.1602949927.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Cc: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/getorder.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/getorder.h~asm-generic-force-inlining-of-get_order-to-work-around-gcc10-poor-decision
+++ a/include/asm-generic/getorder.h
@@ -26,7 +26,7 @@
  *
  * The result is undefined if the size is 0.
  */
-static inline __attribute_const__ int get_order(unsigned long size)
+static __always_inline __attribute_const__ int get_order(unsigned long size)
 {
 	if (__builtin_constant_p(size)) {
 		if (!size)
_
