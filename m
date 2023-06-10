Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FC7C7EE2E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjFJApR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFJApP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C4430F6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF699651B5
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF2BC433D2;
        Sat, 10 Jun 2023 00:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357913;
        bh=tbNgTWgYVag2q9+DDyGGu/4hf+J9w7P//MZ8JvfBBKY=;
        h=Date:To:From:Subject:From;
        b=JRViHiqPfgJ4egNmev4x5O1Dr6MP2DVJRfEMsEcukhPmU5yAnJqCYd39bKe6hsweO
         0jzBfBYLzRUs9waIRuT6l+9B9Ctrj2WQlML7tALFpO08sKjj+o7AyLKlxxEEYZBxAy
         szR2gsKWYWD1LTubLaC1wcBKNOMEMXZ/Q3yQJ59k=
Date:   Fri, 09 Jun 2023 17:45:12 -0700
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
Subject: [merged mm-nonmm-stable] mm-sparse-mark-populate_section_memmap-static.patch removed from -mm tree
Message-Id: <20230610004513.3BF2BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: sparse: mark populate_section_memmap() static
has been removed from the -mm tree.  Its filename was
     mm-sparse-mark-populate_section_memmap-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: sparse: mark populate_section_memmap() static
Date: Wed, 17 May 2023 15:10:51 +0200

There are two definitions of this function, but the second one lacks the
'static' annotation:

mm/sparse.c:704:25: error: no previous prototype for 'populate_section_memmap' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20230517131102.934196-4-arnd@kernel.org
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

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-mark-populate_section_memmap-static
+++ a/mm/sparse.c
@@ -701,7 +701,7 @@ static int fill_subsection_map(unsigned
 	return rc;
 }
 #else
-struct page * __meminit populate_section_memmap(unsigned long pfn,
+static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

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

