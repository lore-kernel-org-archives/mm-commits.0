Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC0CC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D74C610FA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhEHWyZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWyY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91126610FA;
        Sat,  8 May 2021 22:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514402;
        bh=zW13CdvaHZ5C4zpuEorTN7tY1r46BpUKMgofSzVUPIM=;
        h=Date:From:To:Subject:From;
        b=TNVIQlkaHRx8P3EWxjvBnug4PzGaef1p8m0Cj+pul//yfenshq7q8/y7mP2FRQx8o
         0ac87HmEiIDMQxBt9/c+MiXicPCeboh0vKnfkecPaE4oqWmF27xuJ7IfIGEb/w9l15
         14vD9BEt2yJU4z15bxgcgo1DkH6YIJqLXwT5p3c4=
Date:   Sat, 08 May 2021 15:53:22 -0700
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged] isofs-fix-fall-through-warnings-for-clang.patch
 removed from -mm tree
Message-ID: <20210508225322.oDa6uIQ8O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: isofs: fix fall-through warnings for Clang
has been removed from the -mm tree.  Its filename was
     isofs-fix-fall-through-warnings-for-clang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

hfsplus-fix-out-of-bounds-warnings-in-__hfsplus_setxattr.patch

