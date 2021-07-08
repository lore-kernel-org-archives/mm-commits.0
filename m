Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A66DC11F69
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D14461C77
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 01:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhGHBKX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhGHBKX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 21:10:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 803B261CCA;
        Thu,  8 Jul 2021 01:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625706461;
        bh=oRdzOiaFFOTLzxyuJ6871gTXPrDlsv5AMSSMPTOmuYk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wQGJUkuX3V3DCm5YT9Nc0GS+frP5RnCU02tqnGCKXL9c4bBDQ0W/HlAeOnEx7jU3D
         NfnV2sTZQRir+jtlBPkxms+4qMEqtbOt8f77Dvb8HXT0lAk76a8iREoFRaRuFkQGT9
         27oiA4PRN/z/HP6Kh7DVsBqxPXWYJJyn8vdCyWEU=
Date:   Wed, 07 Jul 2021 18:07:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bcain@codeaurora.org, glittao@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, rientjes@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 05/54] hexagon: use common DISCARDS macro
Message-ID: <20210708010741.7bwSAWT66%akpm@linux-foundation.org>
In-Reply-To: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
