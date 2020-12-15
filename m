Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB37C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFC44223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgLODQR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:42920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgLODPW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:15:22 -0500
Date:   Mon, 14 Dec 2020 19:15:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002101;
        bh=sVFUy8U6+oXlHMBlb3TTMhm0RRavMuDvO8kiF0Vyg6E=;
        h=From:To:Subject:In-Reply-To:From;
        b=gCBuX8BlpQ4i9YfczTnldYX1cM/44S1dpGHbcSMHJ7v+182IWCsWYk6Fvj28nFVlC
         RhqxtQO5PzkLA0xS2HsvXLLpqYG8A2OeEAoxal0HfUbLTi9GFE8yh1iQXVA9daRQyI
         DLXmN/FmI8dxMIDOtWp6jYGOk0NaouuBxAgvgitk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gustavoars@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 199/200] mm: fix fall-through warnings for Clang
Message-ID: <20201215031500.vysL6-o3U%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: mm: fix fall-through warnings for Clang

In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple of
warnings by explicitly adding a break statement instead of just letting
the code fall through to the next, and by adding a fallthrough
pseudo-keyword in places where the code is intended to fall through.

Link: https://github.com/KSPP/linux/issues/115
Link: https://lkml.kernel.org/r/f5756988b8842a3f10008fbc5b0a654f828920a9.1605896059.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 +
 mm/vmscan.c  |    1 +
 2 files changed, 2 insertions(+)

--- a/mm/mm_init.c~mm-fix-fall-through-warnings-for-clang
+++ a/mm/mm_init.c
@@ -173,6 +173,7 @@ static int __meminit mm_compute_batch_no
 	case MEM_ONLINE:
 	case MEM_OFFLINE:
 		mm_compute_batch(sysctl_overcommit_memory);
+		break;
 	default:
 		break;
 	}
--- a/mm/vmscan.c~mm-fix-fall-through-warnings-for-clang
+++ a/mm/vmscan.c
@@ -1369,6 +1369,7 @@ static unsigned int shrink_page_list(str
 				if (PageDirty(page) || PageWriteback(page))
 					goto keep_locked;
 				mapping = page_mapping(page);
+				fallthrough;
 			case PAGE_CLEAN:
 				; /* try to free the page below */
 			}
_
