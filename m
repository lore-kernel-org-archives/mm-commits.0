Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D0BC7EE2F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjFJApP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjFJApO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4433A99
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9403D651D1
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4218C433D2;
        Sat, 10 Jun 2023 00:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357912;
        bh=MgBndN7b4Kg885RFTb4JZaVsb6AACtmGy/9j2SQLhBI=;
        h=Date:To:From:Subject:From;
        b=h49fsXXT4kGixJOkIsVTDmNFLV/0lXOCFIIYpQ4aE6ovT2eeUd51Hg0YUXX8thZ//
         INhoifPQqa2KRwf41yfF8lufM+szEALNXp/omfBCZG7R+EI91C1YgfA5g+HEQ1MUj+
         U1CvXmh8o0oq4YJLFuj7jhSIoq6SJI2pZ+DFQsnE=
Date:   Fri, 09 Jun 2023 17:45:11 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tj@kernel.org, tglx@linutronix.de,
        rafael@kernel.org, peterz@infradead.org, pavel@ucw.cz,
        paul@paul-moore.com, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, longman@redhat.com,
        linux@armlinux.org.uk, hca@linux.ibm.com, eparis@redhat.com,
        dennis@kernel.org, deller@gmx.de, cl@linux.com,
        catalin.marinas@arm.com, boqun.feng@gmail.com, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mm-page_poison-always-declare-__kernel_map_pages-function.patch removed from -mm tree
Message-Id: <20230610004511.E4218C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_poison: always declare __kernel_map_pages() function
has been removed from the -mm tree.  Its filename was
     mm-page_poison-always-declare-__kernel_map_pages-function.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: page_poison: always declare __kernel_map_pages() function
Date: Wed, 17 May 2023 15:10:50 +0200

The __kernel_map_pages() function is mainly used for
CONFIG_DEBUG_PAGEALLOC, but has a number of architecture specific
definitions that may also be used in other configurations, as well as a
global fallback definition for architectures that do not support
DEBUG_PAGEALLOC.

When the option is disabled, any definitions without the prototype cause a
warning:

mm/page_poison.c:102:6: error: no previous prototype for '__kernel_map_pages' [-Werror=missing-prototypes]

The function is a trivial nop here, so just declare it anyway
to avoid the warning.

Link: https://lkml.kernel.org/r/20230517131102.934196-3-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-page_poison-always-declare-__kernel_map_pages-function
+++ a/include/linux/mm.h
@@ -3453,13 +3453,12 @@ static inline bool debug_pagealloc_enabl
 	return static_branch_unlikely(&_debug_pagealloc_enabled);
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 /*
  * To support DEBUG_PAGEALLOC architecture must ensure that
  * __kernel_map_pages() never fails
  */
 extern void __kernel_map_pages(struct page *page, int numpages, int enable);
-
+#ifdef CONFIG_DEBUG_PAGEALLOC
 static inline void debug_pagealloc_map_pages(struct page *page, int numpages)
 {
 	if (debug_pagealloc_enabled_static())
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-sparse-mark-populate_section_memmap-static.patch
lib-devmem_is_allowed-include-linux-ioh.patch
locking-add-lockevent_read-prototype.patch
panic-hide-unused-global-functions.patch
panic-make-function-declarations-visible.patch
kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch
kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

