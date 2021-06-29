Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAF7C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395FA61CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhF2AdB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:33:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:32824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhF2Ac7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:32:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CD2D61CDA;
        Tue, 29 Jun 2021 00:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926633;
        bh=MkjN4j9uJo6HwVlUvw5RvUCU86EYouP3C/JjFFlYg5Q=;
        h=Date:From:To:Subject:From;
        b=uu2LA29+GLrM2eoweEl+6VANIrA+UQ+GZHahzQGVkrQ3dC8y7/T36eKhHigPzZgMA
         lcEcG0+NmHRPuv3TZFZD9FTz8F2Pe6DTiVXODz3aM+d3GEVkOIAoRpOKRp/UyEhw6Z
         aoC0P6zeV5nQXblD4x/IANcnuDvAgRivEA3jO6HI=
Date:   Mon, 28 Jun 2021 17:30:32 -0700
From:   akpm@linux-foundation.org
To:     elver@google.com, glider@google.com, lkp@intel.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged] printk-introduce-dump_stack_lvl-fix.patch
 removed from -mm tree
Message-ID: <20210629003032.yBwY2eCIH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fix for "printk: introduce dump_stack_lvl()"
has been removed from the -mm tree.  Its filename was
     printk-introduce-dump_stack_lvl-fix.patch

This patch was dropped because it was folded into printk-introduce-dump_stack_lvl.patch

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: fix for "printk: introduce dump_stack_lvl()"

Add missing dump_stack_lvl() stub if CONFIG_PRINTK=n.

Link: https://lkml.kernel.org/r/YJ0KAM0hQev1AmWe@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/printk.h~printk-introduce-dump_stack_lvl-fix
+++ a/include/linux/printk.h
@@ -270,6 +270,10 @@ static inline void show_regs_print_info(
 {
 }
 
+static inline void dump_stack_lvl(const char *log_lvl)
+{
+}
+
 static inline void dump_stack(void)
 {
 }
_

Patches currently in -mm which might be from elver@google.com are

printk-introduce-dump_stack_lvl.patch
kfence-unconditionally-use-unbound-work-queue.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v2.patch
kcov-add-__no_sanitize_coverage-to-fix-noinstr-for-all-architectures-v3.patch

