Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7200AC2BB48
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5123422D07
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgLPAA3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbgLOX2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:12 -0500
Date:   Tue, 15 Dec 2020 15:24:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074688;
        bh=a7szcpR59A5YAOU8oMn4KiHFVMQbwNzOc0DwNPTFhLI=;
        h=From:To:Subject:From;
        b=iF4z58KbcD6tYlY1OjGmaoPb08sYNmn1TQc+BDEa5t8iWMsAvIuyGzeSX/oKVDix2
         mvJvraAbjELFVSUvHKg77IHwjB2qTSlW/n3/vZuIhDcf/etXeZGHw7nWm8ArGPpzVl
         VAZMQS1hQT6iXg8p7PB3uZSBJRQ0pMHaKN9+CbLg=
From:   akpm@linux-foundation.org
To:     gustavoars@kernel.org, mm-commits@vger.kernel.org
Subject:  [merged] mm-fix-fall-through-warnings-for-clang.patch
 removed from -mm tree
Message-ID: <20201215232448.ex_WUE2ZB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix fall-through warnings for Clang
has been removed from the -mm tree.  Its filename was
     mm-fix-fall-through-warnings-for-clang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from gustavoars@kernel.org are

lib-stackdepotc-replace-one-element-array-with-flexible-array-member.patch
lib-stackdepotc-use-flex_array_size-helper-in-memcpy.patch
lib-stackdepotc-use-array_size-helper-in-jhash2.patch

