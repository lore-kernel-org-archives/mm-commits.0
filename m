Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B47D1C3E8C5
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52C8D2075E
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HkGeACMu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgK1CKA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Nov 2020 21:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730224AbgK1CIa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 21:08:30 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4572075E;
        Sat, 28 Nov 2020 02:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606529307;
        bh=CBMQIlEQ3/17ox5teVTtBHh54A6pRbpVprQ2Vyxw2RE=;
        h=Date:From:To:Subject:From;
        b=HkGeACMuykBsK+e4h+DiBN582F73U/v5y8VVUb9jO3Mjue5eg/mTQ6PdMAWgOubq+
         YEQZeuM0n7MQJqAEpUioLNKBogOPr50MNhkSe3ENCc70Y3iZ8HUoJquz036KTvy4e8
         xnWYbJDq18bLOJG3P6dYaVDLEHgUp8pvJyuP/6Do=
Date:   Fri, 27 Nov 2020 18:08:25 -0800
From:   akpm@linux-foundation.org
To:     jarkko@kernel.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        ojeda@kernel.org, songliubraving@fb.com, yu.chen.surf@gmail.com
Subject:  [merged]
 compiler-clang-remove-version-check-for-bpf-tracing.patch removed from -mm
 tree
Message-ID: <20201128020825.mbJC7e0c4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-clang: remove version check for BPF Tracing
has been removed from the -mm tree.  Its filename was
     compiler-clang-remove-version-check-for-bpf-tracing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
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

lib-string-remove-unnecessary-undefs.patch
gcov-remove-support-for-gcc-49.patch

