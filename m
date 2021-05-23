Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EEEC2B9F2
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E2760FE5
	for <mm-commits@archiver.kernel.org>; Sun, 23 May 2021 00:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhEWAnL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 20:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231451AbhEWAnK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 20:43:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14FBE6052B;
        Sun, 23 May 2021 00:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621730504;
        bh=iM2B8UWXE4v1znhoH+nIKmP1uXhneVYX4vNQ4IV3Sz8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JGWPLyJPIl6FDsBMGdOnvIy6iDk0kVUYM90ELFjKPq5yA4yMFP2G/851317a8JQas
         AlqdvgAjuaHGvvNJ/Q0+9B9zqsVxuHVoeRe2pUCEajxyXmbb/YC/CTT49+9iXYu4+t
         9k8rOb9VIY7fX638Xqgo92McNIbZFjKQkWZ3jiS8=
Date:   Sat, 22 May 2021 17:41:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, dan.j.williams@intel.com,
        david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com,
        richard.weiyang@linux.alibaba.com, torvalds@linux-foundation.org
Subject:  [patch 01/10] mm/shuffle: fix section mismatch warning
Message-ID: <20210523004143.dqNN_f0TJ%akpm@linux-foundation.org>
In-Reply-To: <20210522174113.47fd4c853c0a1470c57deefa@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/shuffle: fix section mismatch warning

clang sometimes decides not to inline shuffle_zone(), but it calls a
__meminit function.  Without the extra __meminit annotation we get this
warning:

WARNING: modpost: vmlinux.o(.text+0x2a86d4): Section mismatch in reference from the function shuffle_zone() to the function .meminit.text:__shuffle_zone()
The function shuffle_zone() references
the function __meminit __shuffle_zone().
This is often because shuffle_zone lacks a __meminit
annotation or the annotation of __shuffle_zone is wrong.

shuffle_free_memory() did not show the same problem in my tests, but it
could happen in theory as well, so mark both as __meminit.

Link: https://lkml.kernel.org/r/20210514135952.2928094-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shuffle.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shuffle.h~mm-shuffle-fix-section-mismatch-warning
+++ a/mm/shuffle.h
@@ -10,7 +10,7 @@
 DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
 extern void __shuffle_free_memory(pg_data_t *pgdat);
 extern bool shuffle_pick_tail(void);
-static inline void shuffle_free_memory(pg_data_t *pgdat)
+static inline void __meminit shuffle_free_memory(pg_data_t *pgdat)
 {
 	if (!static_branch_unlikely(&page_alloc_shuffle_key))
 		return;
@@ -18,7 +18,7 @@ static inline void shuffle_free_memory(p
 }
 
 extern void __shuffle_zone(struct zone *z);
-static inline void shuffle_zone(struct zone *z)
+static inline void __meminit shuffle_zone(struct zone *z)
 {
 	if (!static_branch_unlikely(&page_alloc_shuffle_key))
 		return;
_
