Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5990EC61DA4
	for <mm-commits@archiver.kernel.org>; Tue, 14 Feb 2023 21:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBNVp0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Feb 2023 16:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjBNVpZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2023 16:45:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D942943A
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 13:45:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60CE3CE21B8
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2023 21:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D56C433EF;
        Tue, 14 Feb 2023 21:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676411120;
        bh=bDqE+EPsY7ebIOCjKj/xIY376B+kIFimuoHZAy/BQOA=;
        h=Date:To:From:Subject:From;
        b=S20wH7h7tiAA8e1imj6URlvQhoi1nwr53VnsIrVkJ46H/pjUbKCN3vJjbDbP7+ArI
         O2YwV4ZbVG7NWAVUA01bYZONqizrDhZCJb6HK5x9pDaL4SkHF6KJlbD+zTfRn5gDvj
         wS3oItdGXWgOlJcUJjZybBKiOmZSyY87JxPLX32w=
Date:   Tue, 14 Feb 2023 13:45:19 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        linux@roeck-us.net, glaubitz@physik.fu-berlin.de,
        gerg@linux-m68k.org, geert@linux-m68k.org, dalias@libc.org,
        arnd@arndb.de, rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-nommu-add-missing-definition-of-arch_pfn_offset.patch added to mm-unstable branch
Message-Id: <20230214214520.77D56C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k/nommu: add missing definition of ARCH_PFN_OFFSET
has been added to the -mm mm-unstable branch.  Its filename is
     m68k-nommu-add-missing-definition-of-arch_pfn_offset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-nommu-add-missing-definition-of-arch_pfn_offset.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
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

m68k-nommu-add-missing-definition-of-arch_pfn_offset.patch
sh-initialize-max_mapnr.patch

