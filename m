Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544D4C433DB
	for <mm-commits@archiver.kernel.org>; Tue, 16 Feb 2021 20:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F0164E7D
	for <mm-commits@archiver.kernel.org>; Tue, 16 Feb 2021 20:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBPUVD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Feb 2021 15:21:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhBPUVC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Feb 2021 15:21:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8230B64EB1;
        Tue, 16 Feb 2021 20:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613506790;
        bh=llzUL0SM9JkxpIi7rMeEk3jbGOEDeIpUj4iYcL8BpeY=;
        h=Date:From:To:Subject:From;
        b=a37+2vQgxJM9DU1rXucon7Mga5vs6cB2k1X0azg7uus8Fv+5xIn+rziGplDG1pLt3
         KheErJpTV1mUhX2Bp9N3pPhznRw4pbG3/EANYklq1hBK7PR4Ba8JSwJplgivigMEAv
         /VX0546b5yUl5eGQvWuX8H5YTZ4kTEk4mS8kufHk=
Date:   Tue, 16 Feb 2021 12:19:50 -0800
From:   akpm@linux-foundation.org
To:     lkp@intel.com, mm-commits@vger.kernel.org, rdunlap@infradead.org,
        tglx@linutronix.de, ysato@users.sourceforge.jp
Subject:  [merged]
 h8300-fix-preemption-build-ti_pre_count-undefined.patch removed from -mm
 tree
Message-ID: <20210216201950.gcwNjtgaR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: fix PREEMPTION build, TI_PRE_COUNT undefined
has been removed from the -mm tree.  Its filename was
     h8300-fix-preemption-build-ti_pre_count-undefined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: h8300: fix PREEMPTION build, TI_PRE_COUNT undefined

Fix a build error for undefined 'TI_PRE_COUNT' by adding it to
asm-offsets.c.

h8300-linux-ld: arch/h8300/kernel/entry.o: in function `resume_kernel':
(.text+0x29a): undefined reference to `TI_PRE_COUNT'

Link: https://lkml.kernel.org/r/20210212021650.22740-1-rdunlap@infradead.org
Fixes: df2078b8daa7 ("h8300: Low level entry")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/asm-offsets.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/h8300/kernel/asm-offsets.c~h8300-fix-preemption-build-ti_pre_count-undefined
+++ a/arch/h8300/kernel/asm-offsets.c
@@ -63,6 +63,9 @@ int main(void)
 	OFFSET(TI_FLAGS, thread_info, flags);
 	OFFSET(TI_CPU, thread_info, cpu);
 	OFFSET(TI_PRE, thread_info, preempt_count);
+#ifdef CONFIG_PREEMPTION
+	DEFINE(TI_PRE_COUNT, offsetof(struct thread_info, preempt_count));
+#endif
 
 	return 0;
 }
_

Patches currently in -mm which might be from rdunlap@infradead.org are

hexagon-remove-config_experimental-from-defconfigs.patch
ntfs-layouth-delete-duplicated-words.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch
include-linux-remove-repeated-words.patch
kernel-delete-repeated-words-in-comments.patch

