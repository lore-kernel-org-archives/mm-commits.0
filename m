Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5976FC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41D5561CA3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhGFTZX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhGFTZX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C884161CA3;
        Tue,  6 Jul 2021 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599363;
        bh=Ri6+nuPugLafbn1e5lATB3xlJUVQJunQ9HRNpzNMrAg=;
        h=Date:From:To:Subject:From;
        b=GRmLWlzxktPCHdp4zK3O2JqLiMyfaFAkBBZvZjF639113P9gQkESXPgobvyqi3DVB
         JnmHmJ6iO9kE1hq4QIIGLPXQ6Ab6mLpzlOEUgo/19U9D0j5hpI3T5Exolw2luO0AOk
         zznDuC6KcOww8wUJkOAH1Hm5xZWWUOy7+q7l3qmw=
Date:   Tue, 06 Jul 2021 12:22:43 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] lib-uninline-simple_strtoull.patch removed from
 -mm tree
Message-ID: <20210706192243.4gZtf1pZF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: uninline simple_strtoull()
has been removed from the -mm tree.  Its filename was
     lib-uninline-simple_strtoull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


