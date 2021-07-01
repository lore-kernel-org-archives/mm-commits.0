Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81581C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF9A61420
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbhGAB6f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238467AbhGAB6e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A505F61418;
        Thu,  1 Jul 2021 01:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104564;
        bh=rZZI2bnSbL3/duuUqmmIHxEEwnOkYYkO7iPqhrm/TQc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IE1qrrxv7cvAwCczh8zriRfwzdelO3pE4x55J83e0a41OSqESireQfnVQA0c8W7zv
         al0T8nu3oA/RIO/45f1fkU6Kd9bnhozqKa4O4VL4BslAYvC1Cz5m7OFG7rB87UWtsQ
         +pKuWb5GeXqfpkivcvN0+Sl95Fj81T98PODuLZtc=
Date:   Wed, 30 Jun 2021 18:56:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 168/192] lib: uninline simple_strtoull()
Message-ID: <20210701015604.siv4k3Srj%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: lib: uninline simple_strtoull()

Gcc inlines simple_strtoull() too agressively.

Given that all 4 signatures match, everything very efficiently calls or
tailcalls into simple_strtoull():

	ffffffff81da0240 <simple_strtoll>:
	ffffffff81da0240:       80 3f 2d                cmp    BYTE PTR [rdi],0x2d
	ffffffff81da0243:       74 05                   je     ffffffff81da024a <simple_strtoll+0xa>
	ffffffff81da0245:       e9 76 ff ff ff          jmp    simple_strtoull
	ffffffff81da024a:       48 83 c7 01             add    rdi,0x1
	ffffffff81da024e:       e8 6d ff ff ff          call   simple_strtoull
	ffffffff81da0253:       48 f7 d8                neg    rax
	ffffffff81da0256:       c3                      ret

Space savings (on F34-ish .config)

	add/remove: 0/0 grow/shrink: 1/3 up/down: 52/-313 (-261)
	Function                                     old     new   delta
	vsscanf                                     2167    2219     +52
	simple_strtoul                                72       2     -70
	simple_strtoll                               143      23    -120
	simple_strtol                                143      20    -123

Link: https://lkml.kernel.org/r/YMO2zoOQk2eF34tn@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/vsprintf.c~lib-uninline-simple_strtoull
+++ a/lib/vsprintf.c
@@ -61,6 +61,7 @@
  *
  * This function has caveats. Please use kstrtoull instead.
  */
+noinline
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long long result;
_
