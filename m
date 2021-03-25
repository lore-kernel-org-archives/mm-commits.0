Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF41AC433E1
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9845661A1B
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhCYEiQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhCYEhy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Mar 2021 00:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C415E61A1A;
        Thu, 25 Mar 2021 04:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616647071;
        bh=msCcVHJlS0RJo+KpsBb3jVpNKuTDB3nsOWNNz4sDL2g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dvXbau/Q6kAP4oaprqOQJKT/q+HCJBGrJUYYnDJ232JHwjGs5g0ki/Xc1OHf/Jl+q
         4tZm3dMgLY9u4fZuUVjTAkEsjEK93QjtDi0XjpTXu/YBrhFNS1dKzs1VEiuUexGr98
         6zoRvg+ZXHYE1VH31IO1200P7hN90Q/F0xzL+5gE=
Date:   Wed, 24 Mar 2021 21:37:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, david@redhat.com,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 12/14] mm: memblock: fix section mismatch warning
 again
Message-ID: <20210325043750.LupCgd9Zf%akpm@linux-foundation.org>
In-Reply-To: <20210324213644.bf03a529aec4ef9580e17dbc@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: memblock: fix section mismatch warning again

Commit 34dc2efb39a2 ("memblock: fix section mismatch warning") marked
memblock_bottom_up() and memblock_set_bottom_up() as __init, but they
could be referenced from non-init functions like
memblock_find_in_range_node() on architectures that enable
CONFIG_ARCH_KEEP_MEMBLOCK.

For such builds kernel test robot reports: All warnings (new ones prefixed
by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux.o(.text+0x74fea4): Section mismatch in reference from the function memblock_find_in_range_node() to the function .init.text:memblock_bottom_up()
The function memblock_find_in_range_node() references
the function __init memblock_bottom_up().
This is often because memblock_find_in_range_node lacks a __init
annotation or the annotation of memblock_bottom_up is wrong.

Replace __init annotations with __init_memblock annotations so that the
appropriate section will be selected depending on
CONFIG_ARCH_KEEP_MEMBLOCK.

Link: https://lore.kernel.org/lkml/202103160133.UzhgY0wt-lkp@intel.com
Link: https://lkml.kernel.org/r/20210316171347.14084-1-rppt@kernel.org
Fixes: 34dc2efb39a2 ("memblock: fix section mismatch warning")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memblock.h~memblock-fix-section-mismatch-warning-again
+++ a/include/linux/memblock.h
@@ -460,7 +460,7 @@ static inline void memblock_free_late(ph
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
-static inline __init void memblock_set_bottom_up(bool enable)
+static inline __init_memblock void memblock_set_bottom_up(bool enable)
 {
 	memblock.bottom_up = enable;
 }
@@ -470,7 +470,7 @@ static inline __init void memblock_set_b
  * if this is true, that said, memblock will allocate memory
  * in bottom-up direction.
  */
-static inline __init bool memblock_bottom_up(void)
+static inline __init_memblock bool memblock_bottom_up(void)
 {
 	return memblock.bottom_up;
 }
_
