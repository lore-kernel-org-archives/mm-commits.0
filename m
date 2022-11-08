Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AD3C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 23:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKHX6p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiKHX6X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 18:58:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6941FB0D
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 15:58:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23EF9B81CC7
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 23:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A6BC433C1;
        Tue,  8 Nov 2022 23:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951898;
        bh=BaCLdXqVyq6Mvm3XWmJZdSuRfWfUIzHrKaZjiP1b5Pk=;
        h=Date:To:From:Subject:From;
        b=QQf9p8dUsrTZM2KxmnzqCG6yH5cdy+L/o3Qq0DID4WDSx38l7IxkirENZQ/wY58p1
         yDNC4T/s39RdDyyFCOuTvutaJDVrAt2ZbdcmOWLGyHf42yLuBbPGBZLVHRsThBnFv0
         fFL2AH8JMjDyqO1QYPaNglPCbgeJ/8pp05GEJ5S8=
Date:   Tue, 08 Nov 2022 15:58:18 -0800
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, ndesaulniers@google.com, mingo@redhat.com,
        masahiroy@kernel.org, keescook@chromium.org, elver@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-uaccess-instrument-copy_from_user_nmi.patch removed from -mm tree
Message-Id: <20221108235818.C5A6BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/uaccess: instrument copy_from_user_nmi()
has been removed from the -mm tree.  Its filename was
     x86-uaccess-instrument-copy_from_user_nmi.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: x86/uaccess: instrument copy_from_user_nmi()
Date: Wed, 2 Nov 2022 12:06:08 +0100

Make sure usercopy hooks from linux/instrumented.h are invoked for
copy_from_user_nmi().  This fixes KMSAN false positives reported when
dumping opcodes for a stack trace.

Link: https://lkml.kernel.org/r/20221102110611.1085175-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lib/usercopy.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/lib/usercopy.c~x86-uaccess-instrument-copy_from_user_nmi
+++ a/arch/x86/lib/usercopy.c
@@ -6,6 +6,7 @@
 
 #include <linux/uaccess.h>
 #include <linux/export.h>
+#include <linux/instrumented.h>
 
 #include <asm/tlbflush.h>
 
@@ -44,7 +45,9 @@ copy_from_user_nmi(void *to, const void
 	 * called from other contexts.
 	 */
 	pagefault_disable();
+	instrument_copy_from_user_before(to, from, n);
 	ret = raw_copy_from_user(to, from, n);
+	instrument_copy_from_user_after(to, from, n, ret);
 	pagefault_enable();
 
 	return ret;
_

Patches currently in -mm which might be from glider@google.com are


