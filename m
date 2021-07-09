Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346C8C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22314613C8
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhGIVfE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGIVfE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:35:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A0E613C2;
        Fri,  9 Jul 2021 21:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866339;
        bh=h1eFqY+KpeXvcL+z92nNSKp+N7OK32J5492Ju7HyuNU=;
        h=Date:From:To:Subject:From;
        b=KBsY67Z9hmt2/z2U0eKvijkOpImVxFNbXnZEfwzNfi+ykixrhPOpsVEcO+52PIBnt
         KFd0qN70IiH8BnmWxFkmWo7MI6Lzoe2OvdvdfAdNv5UR4QMI/Q1NHb5OcxDEWSuguv
         Z9m3Hw6L8oGotUIi0Unh+AaEKJKhdJMfUKjo5X/A=
Date:   Fri, 09 Jul 2021 14:32:19 -0700
From:   akpm@linux-foundation.org
To:     bcain@codeaurora.org, glittao@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, rientjes@google.com, vbabka@suse.cz
Subject:  [merged] hexagon-use-common-discards-macro.patch removed
 from -mm tree
Message-ID: <20210709213219.R1Qwpj5Cg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: use common DISCARDS macro
has been removed from the -mm tree.  Its filename was
     hexagon-use-common-discards-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: use common DISCARDS macro

ld.lld warns that the '.modinfo' section is not currently handled:

ld.lld: warning: kernel/built-in.a(workqueue.o):(.modinfo) is being placed in '.modinfo'
ld.lld: warning: kernel/built-in.a(printk/printk.o):(.modinfo) is being placed in '.modinfo'
ld.lld: warning: kernel/built-in.a(irq/spurious.o):(.modinfo) is being placed in '.modinfo'
ld.lld: warning: kernel/built-in.a(rcu/update.o):(.modinfo) is being placed in '.modinfo'

The '.modinfo' section was added in commit 898490c010b5 ("moduleparam:
Save information about built-in modules in separate file") to the DISCARDS
macro but Hexagon has never used that macro.  The unification of DISCARDS
happened in commit 023bf6f1b8bf ("linker script: unify usage of discard
definition") in 2009, prior to Hexagon being added in 2011.

Switch Hexagon over to the DISCARDS macro so that anything that is
expected to be discarded gets discarded.

Link: https://lkml.kernel.org/r/20210521011239.1332345-3-nathan@kernel.org
Fixes: e95bf452a9e2 ("Hexagon: Add configuration and makefiles for the Hexagon architecture.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/vmlinux.lds.S |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/hexagon/kernel/vmlinux.lds.S~hexagon-use-common-discards-macro
+++ a/arch/hexagon/kernel/vmlinux.lds.S
@@ -61,14 +61,9 @@ SECTIONS
 
 	_end = .;
 
-	/DISCARD/ : {
-		EXIT_TEXT
-		EXIT_DATA
-		EXIT_CALL
-	}
-
 	STABS_DEBUG
 	DWARF_DEBUG
 	ELF_DETAILS
 
+	DISCARDS
 }
_

Patches currently in -mm which might be from nathan@kernel.org are


