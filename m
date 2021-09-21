Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE88DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 01:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE86961019
	for <mm-commits@archiver.kernel.org>; Tue, 21 Sep 2021 01:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhIUBF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Sep 2021 21:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233096AbhIUBDs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Sep 2021 21:03:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B937060F36;
        Tue, 21 Sep 2021 01:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632186141;
        bh=TtL7Ka/SqwgHwG8KXFrfoTt6QmELcgUs3sqV1R9QPAA=;
        h=Date:From:To:Subject:From;
        b=paSgbpBzb4y5c3Ve0txTjTMyFDQA/njFkb9W3cDkcVxwv6C/m/fdmu8OLnF3jBoXB
         3GyHAWaY8nZw1RzvedPH0Ii/VGMwHWo8DbIQBvVlgd2aAdUWe11EU+8N4GMYgDLYyP
         JfVtYNGpFWS/wzrxCl8E713o5oWBsrtSjwkIAAbA=
Date:   Mon, 20 Sep 2021 18:02:20 -0700
From:   akpm@linux-foundation.org
To:     benh@kernel.crashing.org, christophe.leroy@csgroup.eu,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, nathan@kernel.org,
        ndesaulniers@google.com, paulus@samba.org, pmenzel@molgen.mpg.de,
        thunder.leizhen@huawei.com
Subject:  +
 =?US-ASCII?Q?lib-zlib=5Finflate-inffast-check-config-in-c-to-avoid-unuse?=
 =?US-ASCII?Q?d-function-warning.patch?= added to -mm tree
Message-ID: <20210921010220.fynr3JNdZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib_inflate/inffast: check config in C to avoid unused function warning
has been added to the -mm tree.  Its filename is
     lib-zlib_inflate-inffast-check-config-in-c-to-avoid-unused-function-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-zlib_inflate-inffast-check-config-in-c-to-avoid-unused-function-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-zlib_inflate-inffast-check-config-in-c-to-avoid-unused-function-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: lib/zlib_inflate/inffast: check config in C to avoid unused function warning

Building Linux for ppc64le with Ubuntu clang version
12.0.0-3ubuntu1~21.04.1 shows the warning below.

    arch/powerpc/boot/inffast.c:20:1: warning: unused function 'get_unaligned16' [-Wunused-function]
    get_unaligned16(const unsigned short *p)
    ^
    1 warning generated.

Fix it, by moving the check from the preprocessor to C, so the compiler
sees the use.

Link: https://lkml.kernel.org/r/20210920084332.5752-1-pmenzel@molgen.mpg.de
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inffast.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/lib/zlib_inflate/inffast.c~lib-zlib_inflate-inffast-check-config-in-c-to-avoid-unused-function-warning
+++ a/lib/zlib_inflate/inffast.c
@@ -253,13 +253,12 @@ void inflate_fast(z_streamp strm, unsign
 
 			sfrom = (unsigned short *)(from);
 			loops = len >> 1;
-			do
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-			    *sout++ = *sfrom++;
-#else
-			    *sout++ = get_unaligned16(sfrom++);
-#endif
-			while (--loops);
+			do {
+			    if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
+				*sout++ = *sfrom++;
+			    else
+				*sout++ = get_unaligned16(sfrom++);
+			} while (--loops);
 			out = (unsigned char *)sout;
 			from = (unsigned char *)sfrom;
 		    } else { /* dist == 1 or dist == 2 */
_

Patches currently in -mm which might be from pmenzel@molgen.mpg.de are

lib-zlib_inflate-inffast-check-config-in-c-to-avoid-unused-function-warning.patch

