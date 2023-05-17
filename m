Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E21C7EE23
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 21:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjEQVEy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 17:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjEQVEv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 17:04:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0A744A3
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 14:04:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7156D64AC1
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 21:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F19C433EF;
        Wed, 17 May 2023 21:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684357488;
        bh=McOVYB525e28odHmC5Ug+3tOPPrNDvDRy/NPkgjUpSo=;
        h=Date:To:From:Subject:From;
        b=nhpbza5QOpI6YvEhP1lsnPFuscmMNQCeF9nzb77xr52peW544P5tAYmlxRLEAydIV
         ms5OAWgE1CcDY9uW4b7a8uDZL9mnmmGMX6bxY07mBNMOca3VXCuCoT2z0Jgj6P1ZOB
         RqE1jVIhlOrlxOl4PF5dqaebx8JK32gp7VJwqBa8=
Date:   Wed, 17 May 2023 14:04:48 -0700
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
Subject: + panic-hide-unused-global-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20230517210448.C2F19C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic: hide unused global functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-hide-unused-global-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-hide-unused-global-functions.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: panic: hide unused global functions
Date: Wed, 17 May 2023 15:10:55 +0200

Building with W=1 shows warnings about two functions that have no
declaration or caller in certain configurations:

kernel/panic.c:688:6: error: no previous prototype for 'warn_slowpath_fmt' [-Werror=missing-prototypes]
kernel/panic.c:710:6: error: no previous prototype for '__warn_printk' [-Werror=missing-prototypes]

Enclose the definition in the same #ifdef check as the declaration.

Link: https://lkml.kernel.org/r/20230517131102.934196-8-arnd@kernel.org
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

 kernel/panic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/panic.c~panic-hide-unused-global-functions
+++ a/kernel/panic.c
@@ -684,6 +684,7 @@ void __warn(const char *file, int line,
 	add_taint(taint, LOCKDEP_STILL_OK);
 }
 
+#ifdef CONFIG_BUG
 #ifndef __WARN_FLAGS
 void warn_slowpath_fmt(const char *file, int line, unsigned taint,
 		       const char *fmt, ...)
@@ -722,8 +723,6 @@ void __warn_printk(const char *fmt, ...)
 EXPORT_SYMBOL(__warn_printk);
 #endif
 
-#ifdef CONFIG_BUG
-
 /* Support resetting WARN*_ONCE state */
 
 static int clear_warn_once_set(void *data, u64 val)
_

Patches currently in -mm which might be from arnd@arndb.de are

radix-tree-move-declarations-to-header.patch
decompressor-provide-missing-prototypes.patch
kasan-add-kasan_tag_mismatch-prototype.patch
kasan-use-internal-prototypes-matching-gcc-13-builtins.patch
mm-percpu-unhide-pcpu_embed_first_chunk-prototype.patch
mm-page_poison-always-declare-__kernel_map_pages-function.patch
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

