Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F478C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3521264F91
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhCMFHG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230309AbhCMFHC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0942F64F76;
        Sat, 13 Mar 2021 05:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612022;
        bh=Raf/ac2LPL74b8yFGB0EqVe/YQ66tZ6NDHEmil1VZb8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q0XWTx2A2GZyo4CdMhYmocXI/jsehFIUKqRnmDxEsDkrlq2/DiH6tCI6n1aoXNSsd
         TLbp0foDTWe3NEaNQRNdKg8DAZUDkDTp8ZIEFM/qQlhXG5qDAjHFKkymtMBIniimOk
         i0EUfeO9vjenC41WgLEtNZKSqw5i7Jj8xApPWSAI=
Date:   Fri, 12 Mar 2021 21:07:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, aslan@fb.com,
        bhe@redhat.com, david@redhat.com, faiyazm@codeaurora.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de
Subject:  [patch 01/29] memblock: fix section mismatch warning
Message-ID: <20210313050701.ETLGdrycV%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
