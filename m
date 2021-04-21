Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F52C433B4
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 00:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F74613AB
	for <mm-commits@archiver.kernel.org>; Wed, 21 Apr 2021 00:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhDUASI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:18:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233752AbhDUASH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 20:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE3696044F;
        Wed, 21 Apr 2021 00:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618964254;
        bh=tLwSO8sLSjPv+OkPmZhBP48j//rZfdG8gh9kCReoSuE=;
        h=Date:From:To:Subject:From;
        b=tnBKsB9BXj+RR6FkTiFdV33qs3gpZC6LrDL68eduy54/VQmn2xnFW7bBdknRTkEoF
         Bor8a0ZxmltY9zSCxg5Xj7qD6qrsr5RosmyKT8wt8JW7G4zG7TgkiMWBcn6pLPWgC1
         d2g/Up86Pd8WeC5Ni4y0Qv761doqx8+Iwy3e7bBk=
Date:   Tue, 20 Apr 2021 17:17:33 -0700
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, mm-commits@vger.kernel.org
Subject:  + isofs-fix-fall-through-warnings-for-clang.patch added
 to -mm tree
Message-ID: <20210421001733.h9XZsyUNe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: isofs: fix fall-through warnings for Clang
has been added to the -mm tree.  Its filename is
     isofs-fix-fall-through-warnings-for-clang.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/isofs-fix-fall-through-warnings-for-clang.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/isofs-fix-fall-through-warnings-for-clang.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: isofs: fix fall-through warnings for Clang

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Link: https://lkml.kernel.org/r/5b7caa73958588065fabc59032c340179b409ef5.1605896059.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/rock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/isofs/rock.c~isofs-fix-fall-through-warnings-for-clang
+++ a/fs/isofs/rock.c
@@ -767,6 +767,7 @@ repeat:
 			rs.cont_extent = isonum_733(rr->u.CE.extent);
 			rs.cont_offset = isonum_733(rr->u.CE.offset);
 			rs.cont_size = isonum_733(rr->u.CE.size);
+			break;
 		default:
 			break;
 		}
_

Patches currently in -mm which might be from gustavoars@kernel.org are

isofs-fix-fall-through-warnings-for-clang.patch
hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr.patch
hpfs-replace-one-element-array-with-flexible-array-member.patch

