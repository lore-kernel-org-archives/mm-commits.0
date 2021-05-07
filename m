Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3CBC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D4CB61041
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbhEGBFK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhEGBFK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 070A5610F7;
        Fri,  7 May 2021 01:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349451;
        bh=ACtvCMKVwBvOfo+HcwPfSiydS+XrG4ctonxG92TgmUA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xjUtkB10oqmVlTULoCkfNTal8wwe1HlOnVSJX3xJvdOeIfzPV35TO96MMYCR2OsAS
         JY0XbMXQUP3yeU1UmROaZVGs49ZCdUTKQuvLHKFgKfeHkrFFy04yf4vCQ4gqz98MRT
         RYv6VXrH8dbsUEaLI06gZWwYE957Eda+mBDv/KQQ=
Date:   Thu, 06 May 2021 18:04:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gustavoars@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 41/91] isofs: fix fall-through warnings for Clang
Message-ID: <20210507010410.arnlf2RCF%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
