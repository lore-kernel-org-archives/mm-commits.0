From: akpm@linux-foundation.org
Subject: [to-be-updated]
 asm-generic-bugh-declare-struct-pt_regs-before-function-prototype.patch
 removed from -mm tree
Date: Wed, 24 May 2017 11:59:26 -0700
Message-ID: <5925d80e.WLVlJwtvDJsyKAn9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754524AbdEXS71 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 14:59:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, arnd@arndb.de, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic/bug.h: declare struct pt_regs; before function prototype
has been removed from the -mm tree.  Its filename was
     asm-generic-bugh-declare-struct-pt_regs-before-function-prototype.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ian Abbott <abbotti@mev.co.uk>
Subject: asm-generic/bug.h: declare struct pt_regs; before function prototype

The declaration of `__warn()` has `struct pt_regs *regs` as one of its
parameters.  This can result in compiler warnings if `struct regs` is not
already declared.  Add an empty declaration of `struct pt_regs` to avoid
the warnings.

Link: http://lkml.kernel.org/r/20170523160112.3446-2-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/bug.h~asm-generic-bugh-declare-struct-pt_regs-before-function-prototype include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~asm-generic-bugh-declare-struct-pt_regs-before-function-prototype
+++ a/include/asm-generic/bug.h
@@ -97,6 +97,7 @@ extern void warn_slowpath_null(const cha
 
 /* used internally by panic.c */
 struct warn_args;
+struct pt_regs;
 
 void __warn(const char *file, int line, void *caller, unsigned taint,
 	    struct pt_regs *regs, struct warn_args *args);
_

Patches currently in -mm which might be from abbotti@mev.co.uk are

kernelh-handle-pointers-to-arrays-better-in-container_of.patch

