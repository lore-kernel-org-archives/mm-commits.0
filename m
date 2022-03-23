Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F87BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 22:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345310AbiCWWsw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 18:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345274AbiCWWsv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 18:48:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE0C7CB23
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 15:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6661B82126
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 22:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64477C340E8;
        Wed, 23 Mar 2022 22:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648075638;
        bh=QsYnF3HkjNj2Lx0/5gN8vK+uujwDyr+oSzucQc7ytCI=;
        h=Date:To:From:Subject:From;
        b=S6F8i71j8kt8lqFi27nBhV5ZmDAcqDrtb1Fu+56CpZzy0WgIRpul4SUIu5mQ16lLR
         CR/zmaxcjRPJG7IMb4ufBh+B0aIamBb/Rkow4mTqqqUfaa6YT/TwHj6IfT4AVN76bM
         RQDv4JpqAkWCKnYh2YHRUSlsLpCZdpmLz6aR5TCk=
Date:   Wed, 23 Mar 2022 15:47:17 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        gpiccoli@igalia.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch removed from -mm tree
Message-Id: <20220323224718.64477C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: documentation: fix table format warning
has been removed from the -mm tree.  Its filename was
     docs-sysctl-kernel-add-missing-bit-to-panic_print-fix.patch

This patch was dropped because it was folded into docs-sysctl-kernel-add-missing-bit-to-panic_print.patch

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: sysctl: documentation: fix table format warning

Fix malformed table warning in sysctl documentation:
(don't use ':'s)

Documentation/admin-guide/sysctl/kernel.rst:798: WARNING: Malformed table.
Text in column margin in table line 7.

=====  ============================================
bit 0  print all tasks info
bit 1  print system memory info
bit 2  print timer info
bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
bit 4  print ftrace buffer
bit 5: print all printk messages in buffer
bit 6: print all CPUs backtrace (if available in the arch)

Link: https://lkml.kernel.org/r/20220109055635.6999-1-rdunlap@infradead.org
Fixes: 934d51cad60c ("docs: sysctl/kernel: add missing bit to panic_print")
Fixes: addc64999934 ("panic: add option to dump all CPUs backtraces in panic_print")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~docs-sysctl-kernel-add-missing-bit-to-panic_print-fix
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -806,7 +806,7 @@ bit 1  print system memory info
 bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
-bit 5: print all printk messages in buffer
+bit 5  print all printk messages in buffer
 =====  ============================================
 
 So for example to print tasks and memory info on panic, user can::
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-memcontrol-return-1-from-cgroupmemory-__setup-handler.patch
mm-mmap-return-1-from-stack_guard_gap-__setup-handler.patch
mm-usercopy-return-1-from-hardened_usercopy-__setup-handler.patch
lib-bitmap-fix-many-kernel-doc-warnings.patch
inith-improve-__setup-and-early_param-documentation.patch
init-mainc-return-1-from-handled-__setup-functions.patch
docs-sysctl-kernel-add-missing-bit-to-panic_print.patch

