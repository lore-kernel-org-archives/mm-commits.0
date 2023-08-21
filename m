Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B551BEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjHUUoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjHUUnY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E7F13E
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49AA76154F
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25D8C433C7;
        Mon, 21 Aug 2023 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650519;
        bh=p25rDK5WTWr5JYSvjdlqUBTI49YoATOXoQaT9bjVIOo=;
        h=Date:To:From:Subject:From;
        b=Vvlx/cPKvocrXgQGnVKTgNvtetZP0VbSmbZZ0r4oxwie1YF2ZUwdg8UG2B7ZHWN0+
         SBViuaIrGjkRL24LozjFby+sNqZnOUpYOczpt2UK84lwsyZKjW3Of0y/TQUMZ3dvHb
         bMWZTZkuvcl4NiHZT/pYoW9u0rxAWmryTopUxk4U=
Date:   Mon, 21 Aug 2023 13:41:59 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, palmer@dabbelt.com,
        mike.kravetz@oracle.com, linux@armlinux.org.uk,
        catalin.marinas@arm.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-include-asm-cacheflushh-in-asm-hugetlbh.patch removed from -mm tree
Message-Id: <20230821204159.A25D8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: include asm/cacheflush.h in asm/hugetlb.h
has been removed from the -mm tree.  Its filename was
     arm64-include-asm-cacheflushh-in-asm-hugetlbh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: arm64: include asm/cacheflush.h in asm/hugetlb.h
Date: Sun, 13 Aug 2023 21:53:17 -0700 (PDT)

PG_dcache_clean is used in asm/hugetlb.h but defined in asm/cacheflush.h:
builds rely on an accident of that being included via linux/mempolicy.h,
but better include it directly (like arch/sh/include/asm/hugetlb.h does).

Link: https://lkml.kernel.org/r/bd77cc1b-e83b-f276-9e27-c19e7c9119aa@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/include/asm/hugetlb.h~arm64-include-asm-cacheflushh-in-asm-hugetlbh
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -10,6 +10,7 @@
 #ifndef __ASM_HUGETLB_H
 #define __ASM_HUGETLB_H
 
+#include <asm/cacheflush.h>
 #include <asm/page.h>
 
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
_

Patches currently in -mm which might be from hughd@google.com are

tmpfsxattr-gfp_kernel_account-for-simple-xattrs.patch

