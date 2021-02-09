Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57E9C433E0
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 23:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8127864E56
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 23:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhBIXHA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233922AbhBIWRC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 17:17:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3099F64ED1;
        Tue,  9 Feb 2021 21:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906931;
        bh=BgOINZYLdLy8InPCq9hDEhwV8Pk9o0wU1HeH016GAGA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IIzZ5aGbA8x4NXDlxp0eEZyjMBMryi6OWTIL84mpTGhA9g1QbaFcBUpYOfYs3f9jF
         bhlsByo2xWhlkN6FqgXzxKdl63dpxWp2sb2E0+G0/Ffmqy5Dl/9iUMJosmvgCFM6qE
         lFhkCov98OTlgTB+s3VMTYyKUKVQ3gBMS8TeawsU=
Date:   Tue, 09 Feb 2021 13:42:10 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     0x7f454c46@gmail.com, akpm@linux-foundation.org, arnd@arndb.de,
        bgeffon@google.com, kirill.shutemov@linux.intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        richard.weiyang@linux.alibaba.com, sedat.dilek@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 07/14] mm/mremap: fix BUILD_BUG_ON() error in
 get_extent
Message-ID: <20210209214210.G_1knYh_y%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/mremap: fix BUILD_BUG_ON() error in get_extent

clang can't evaluate this function argument at compile time when the
function is not inlined, which leads to a link time failure:

ld.lld: error: undefined symbol: __compiletime_assert_414
>>> referenced by mremap.c
>>>               mremap.o:(get_extent) in archive mm/built-in.a

Mark the function as __always_inline to avoid it.

Link: https://lkml.kernel.org/r/20201230154104.522605-1-arnd@kernel.org
Fixes: 9ad9718bfa41 ("mm/mremap: calculate extent in one place")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-build_bug_on-error-in-get_extent
+++ a/mm/mremap.c
@@ -336,8 +336,9 @@ enum pgt_entry {
  * valid. Else returns a smaller extent bounded by the end of the source and
  * destination pgt_entry.
  */
-static unsigned long get_extent(enum pgt_entry entry, unsigned long old_addr,
-			unsigned long old_end, unsigned long new_addr)
+static __always_inline unsigned long get_extent(enum pgt_entry entry,
+			unsigned long old_addr, unsigned long old_end,
+			unsigned long new_addr)
 {
 	unsigned long next, extent, mask, size;
 
_
