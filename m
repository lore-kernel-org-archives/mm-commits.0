Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE429C77B7F
	for <mm-commits@archiver.kernel.org>; Sat, 13 May 2023 00:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240903AbjEMA1b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 20:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240901AbjEMA11 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 20:27:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6E559F3
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 17:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54629653F7
        for <mm-commits@vger.kernel.org>; Sat, 13 May 2023 00:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEE3C433EF;
        Sat, 13 May 2023 00:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683937642;
        bh=OuaQ6IewE+pyOzq6g3bx5JtdX5IU8NH0JZruUQqgsms=;
        h=Date:To:From:Subject:From;
        b=sJI/zawPc/E9WX/MqD8C81l2BknlHqZmfsR3jcsc0qtnY9RNcxGFdacqPRMaZSvVy
         /3kS3Quza5YX7orcqckSv0obK394Tlb6oP2IS0njbxBL8rimFocwpfOkMRWhIpl9Uk
         ayKdpG4X+MJs4p/HuNqbDk0c5AbgdwFBhjbjMn9c=
Date:   Fri, 12 May 2023 17:27:22 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, luto@kernel.org,
        haifeng.xu@shopee.com, bristot@kernel.org, bigeasy@linutronix.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230513002722.ADEE3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fork-optimize-memcg_charge_kernel_stack-a-bit-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fork-optimize-memcg_charge_kernel_stack-a-bit-fix
Date: Fri May 12 05:26:41 PM PDT 2023

remove assertion that PAGE_SIZE is a multiple of 1k

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: Haifeng Xu <haifeng.xu@shopee.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/fork.c~fork-optimize-memcg_charge_kernel_stack-a-bit-fix
+++ a/kernel/fork.c
@@ -254,7 +254,6 @@ static int memcg_charge_kernel_stack(str
 	int ret;
 	int nr_charged = 0;
 
-	BUILD_BUG_ON(PAGE_SIZE % 1024 != 0);
 	BUG_ON(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
 
 	for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch

