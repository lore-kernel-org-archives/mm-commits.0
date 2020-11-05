Return-Path: <SRS0=UeFd=EL=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99000C55179
	for <mm-commits@archiver.kernel.org>; Thu,  5 Nov 2020 00:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FDC221FA
	for <mm-commits@archiver.kernel.org>; Thu,  5 Nov 2020 00:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604537528;
	bh=+1S6O2/rq8gyLz6Fh+dof8iE5w85cvPjs6oFr6gI+vw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=U7dMocV6TL/ustZIpNmu+uOu8zfbhhXfPw34rdsUlMUCP2kRwYF7mnqzsRRng9/Sv
	 oVDSqP0fnKUzegivK4IzBcgBwj0AWpWP2H4ImxK96WCYMEJlt8m01CkYlOjGj+KSLE
	 ngQXYu80CQAQan4JfXVc2U867NXD0xszigSgZjvU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgKEAwH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Nov 2020 19:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387871AbgKEAwH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 4 Nov 2020 19:52:07 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D47EE21734;
        Thu,  5 Nov 2020 00:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604537525;
        bh=+1S6O2/rq8gyLz6Fh+dof8iE5w85cvPjs6oFr6gI+vw=;
        h=Date:From:To:Subject:From;
        b=E5H7Giu4wZQDJ2dPhoM2ZWsHXGBuV8Ogb2mhqAUlAIQJliwpL27A5BgKiNME9ff2+
         7Wfi6J2KjqVyeamG5W1HWTKdKPXveLiSHZwjHE11DWhstIz1Pjl1gyT5IEQjc0ZLxO
         HMJVtJJWSMDB94PwqOiJMzN4smHvCHhlFb2xEIXU=
Date:   Wed, 04 Nov 2020 16:52:04 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yu.chen.surf@gmail.com,
        songliubraving@fb.com, jarkko@kernel.org, ndesaulniers@google.com
Subject:  + compiler-clang-remove-version-check-for-bpf-tracing.patch
 added to -mm tree
Message-ID: <20201105005204.c5QR2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-clang: remove version check for BPF Tracing
has been added to the -mm tree.  Its filename is
     compiler-clang-remove-version-check-for-bpf-tracing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compiler-clang-remove-version-check-for-bpf-tracing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compiler-clang-remove-version-check-for-bpf-tracing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: compiler-clang: remove version check for BPF Tracing

bpftrace parses the kernel headers and uses Clang under the hood.  Remove
the version check when __BPF_TRACING__ is defined (as bpftrace does) so
that this tool can continue to parse kernel headers, even with older clang
sources.

Link: https://lkml.kernel.org/r/20201104191052.390657-1-ndesaulniers@google.com
Fixes: commit 1f7a44f63e6c ("compiler-clang: add build check for clang 10.0.1")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: Chen Yu <yu.chen.surf@gmail.com>
Reported-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/compiler-clang.h~compiler-clang-remove-version-check-for-bpf-tracing
+++ a/include/linux/compiler-clang.h
@@ -8,8 +8,10 @@
 		     + __clang_patchlevel__)
 
 #if CLANG_VERSION < 100001
+#ifndef __BPF_TRACING__
 # error Sorry, your version of Clang is too old - please use 10.0.1 or newer.
 #endif
+#endif
 
 /* Compiler specific definitions for Clang compiler */
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are

compiler-clang-remove-version-check-for-bpf-tracing.patch

