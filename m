Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021E0C64EC4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBQEqN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBQEpj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:45:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A265A399
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF9E5B829C0
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFD4C4339E;
        Fri, 17 Feb 2023 04:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609095;
        bh=E2IOVc5EUKQAMV3ebtNx6XeWxC/OYfYdE/oW2FiuZOc=;
        h=Date:To:From:Subject:From;
        b=e/y1bdhQqp6F9jurqoyzHb6sXCXOAcvobC7nBcs4/lgnNNkhQoX7HRzLsqbtgZPDW
         iKGOY6F++MBS5EwPcLeACBilqotf1UmXfXXaprTrZ3kTuSiIHlURDanqt1eTOFXLB3
         n0ePl7fRBeUpbIDGkCNcEz1bzNUBWBAh0VzqJpMY=
Date:   Thu, 16 Feb 2023 20:44:55 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        linux@roeck-us.net, glaubitz@physik.fu-berlin.de,
        gerg@linux-m68k.org, geert@linux-m68k.org, david@redhat.com,
        dalias@libc.org, arnd@arndb.de, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-nommu-add-missing-definition-of-arch_pfn_offset.patch removed from -mm tree
Message-Id: <20230217044455.8FFD4C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: m68k/nommu: add missing definition of ARCH_PFN_OFFSET
has been removed from the -mm tree.  Its filename was
     m68k-nommu-add-missing-definition-of-arch_pfn_offset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: m68k/nommu: add missing definition of ARCH_PFN_OFFSET
Date: Tue, 14 Feb 2023 16:07:28 +0200

Patch series "fixups for generic implementation of pfn_valid()".

Guenter reported boot failures on m68k-nommu and sh caused by the switch to
the generic implementation of pfn_valid():

https://lore.kernel.org/all/20230212173513.GA4052259@roeck-us.net
https://lore.kernel.org/all/20230212161320.GA3784076@roeck-us.net

These are small fixups that address the issues.


This patch (of 2):

On m68k/nommu RAM does not necessarily start at 0x0 and when it does not
pfn_valid() uses a wrong offset into the memory map which causes silent
boot failures.

Define ARCH_PFN_OFFSET to make pfn_valid() use the correct offset.

Link: https://lkml.kernel.org/r/20230214140729.1649961-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20230214140729.1649961-2-rppt@kernel.org
Fixes: d82f07f06cf8 ("m68k: use asm-generic/memory_model.h for both MMU and !MMU")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/m68k/include/asm/page_no.h~m68k-nommu-add-missing-definition-of-arch_pfn_offset
+++ a/arch/m68k/include/asm/page_no.h
@@ -28,6 +28,8 @@ extern unsigned long memory_end;
 #define	virt_addr_valid(kaddr)	(((unsigned long)(kaddr) >= PAGE_OFFSET) && \
 				((unsigned long)(kaddr) < memory_end))
 
+#define ARCH_PFN_OFFSET PHYS_PFN(PAGE_OFFSET_RAW)
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _M68K_PAGE_NO_H */
_

Patches currently in -mm which might be from rppt@kernel.org are


