Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28962C433E6
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0182764F0C
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhCOR4F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231940AbhCORsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1F8264F0C;
        Mon, 15 Mar 2021 17:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830462;
        bh=LZSebfBdrFmJAKq8F2SkpAQjuCqhm+Ks+QXP+B8u4CE=;
        h=Date:From:To:Subject:From;
        b=tZmEVDvY+WV9kU1yufmL2rsGXUlN5ZDxkuDS98IErL9dzi/cD95gCR75iD1VfEGEF
         pHDCwiZpNaXPzdPjvt1yW3no01Jns5KBNcOEBeO9Xy3DhOqzLv3MfK99rpkDziuwBb
         n2lzOjXynQZ8JABj50gG3FhkEh5dtLkxsoeJAouE=
Date:   Mon, 15 Mar 2021 10:47:41 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, aslan@fb.com, bhe@redhat.com, david@redhat.com,
        faiyazm@codeaurora.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, rppt@linux.ibm.com,
        tsbogend@alpha.franken.de
Subject:  [merged] memblock-fix-section-mismatch-warning.patch
 removed from -mm tree
Message-ID: <20210315174741.ijExTOoHw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     memblock-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: memblock: fix section mismatch warning

The inlining logic in clang-13 is rewritten to often not inline some
functions that were inlined by all earlier compilers.

In case of the memblock interfaces, this exposed a harmless bug of a
missing __init annotation:

WARNING: modpost: vmlinux.o(.text+0x507c0a): Section mismatch in reference from the function memblock_bottom_up() to the variable .meminit.data:memblock
The function memblock_bottom_up() references
the variable __meminitdata memblock.
This is often because memblock_bottom_up lacks a __meminitdata
annotation or the annotation of memblock is wrong.

Interestingly, these annotations were present originally, but got removed
with the explanation that the __init annotation prevents the function from
getting inlined.  I checked this again and found that while this is the
case with clang, gcc (version 7 through 10, did not test others) does
inline the functions regardless.

As the previous change was apparently intended to help the clang builds,
reverting it to help the newer clang versions seems appropriate as well. 
gcc builds don't seem to care either way.

Link: https://lkml.kernel.org/r/20210225133808.2188581-1-arnd@kernel.org
Fixes: 5bdba520c1b3 ("mm: memblock: drop __init from memblock functions to make it inline")
Reference: 2cfb3665e864 ("include/linux/memblock.h: add __init to memblock_set_bottom_up()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Aslan Bakirov <aslan@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/memblock.h~memblock-fix-section-mismatch-warning
+++ a/include/linux/memblock.h
@@ -460,7 +460,7 @@ static inline void memblock_free_late(ph
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
-static inline void memblock_set_bottom_up(bool enable)
+static inline __init void memblock_set_bottom_up(bool enable)
 {
 	memblock.bottom_up = enable;
 }
@@ -470,7 +470,7 @@ static inline void memblock_set_bottom_u
  * if this is true, that said, memblock will allocate memory
  * in bottom-up direction.
  */
-static inline bool memblock_bottom_up(void)
+static inline __init bool memblock_bottom_up(void)
 {
 	return memblock.bottom_up;
 }
_

Patches currently in -mm which might be from arnd@arndb.de are


