Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C59C48BE5
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C353A61182
	for <mm-commits@archiver.kernel.org>; Fri, 11 Jun 2021 22:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhFKWJO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Jun 2021 18:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhFKWJO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 11 Jun 2021 18:09:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C767061182;
        Fri, 11 Jun 2021 22:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623449235;
        bh=7HGbY7SJ5xUQR2LL5OXv0ePs2XeaEAe0PGoGedA8qK4=;
        h=Date:From:To:Subject:From;
        b=sUea7Z9XAJk9EX5r9nmxpcRN0qHxJ3oE41LetRCgl00IwHruWmbqFi6wsMC0B+Rz/
         n6clGaO2v36X6b452klvae2ZaQnhosyV45+CsoT+4E7RK/W/eLENA3qeDZdKNyoOlf
         DP3vNCRcUFsMqT5HjTpIz2GXcmd1TNxYOBVbuRXs=
Date:   Fri, 11 Jun 2021 15:07:15 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  + lib-uninline-simple_strtoull.patch added to -mm tree
Message-ID: <20210611220715.4onHhk5bk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: uninline simple_strtoull()
has been added to the -mm tree.  Its filename is
     lib-uninline-simple_strtoull.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-uninline-simple_strtoull.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-uninline-simple_strtoull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from adobriyan@gmail.com are

lib-memscan-fixlet.patch
lib-uninline-simple_strtoull.patch
exec-remove-checks-in-__register_bimfmt.patch

