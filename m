Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1D0C7EE25
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 17:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjFGR0c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjFGR0b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 13:26:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A72C2102
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 10:26:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2227641ED
        for <mm-commits@vger.kernel.org>; Wed,  7 Jun 2023 17:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131A4C433EF;
        Wed,  7 Jun 2023 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686158770;
        bh=dzy346vFc4tRE8I+gOlTH8Onllxizdl+7FK9ZLvKIKk=;
        h=Date:To:From:Subject:From;
        b=C4LthYZI7WJwdsYKqo/d4iYFrW1gyGRBZJ3hkv2x+3n8RA0PK491VWLD+fTaFfb5T
         TuJSI1mxHl3uFjHrbu7zl3zuqPb9mSlrc5FWM6VusAa7aW0koX89iXH+J3OuZEGBaI
         1LDdzwehBWucpBr4Zd+f/3xuIcmbWV/jVyvZlDMU=
Date:   Wed, 07 Jun 2023 10:26:09 -0700
To:     mm-commits@vger.kernel.org, arnd@arndb.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + syscalls-add-sys_ni_posix_timers-prototype.patch added to mm-nonmm-unstable branch
Message-Id: <20230607172610.131A4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: syscalls: add sys_ni_posix_timers prototype
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     syscalls-add-sys_ni_posix_timers-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/syscalls-add-sys_ni_posix_timers-prototype.patch

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
Subject: syscalls: add sys_ni_posix_timers prototype
Date: Wed, 7 Jun 2023 16:28:45 +0200

The sys_ni_posix_timers() definition causes a warning when the declaration
is missing, so this needs to be added along with the normal syscalls,
outside of the #ifdef.

kernel/time/posix-stubs.c:26:17: error: no previous prototype for 'sys_ni_posix_timers' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20230607142925.3126422-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c |    2 --
 include/linux/syscalls.h    |    1 +
 kernel/time/posix-stubs.c   |    1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/osf_sys.c~syscalls-add-sys_ni_posix_timers-prototype
+++ a/arch/alpha/kernel/osf_sys.c
@@ -1014,8 +1014,6 @@ SYSCALL_DEFINE2(osf_settimeofday, struct
 	return do_sys_settimeofday64(tv ? &kts : NULL, tz ? &ktz : NULL);
 }
 
-asmlinkage long sys_ni_posix_timers(void);
-
 SYSCALL_DEFINE2(osf_utimes, const char __user *, filename,
 		struct timeval32 __user *, tvs)
 {
--- a/include/linux/syscalls.h~syscalls-add-sys_ni_posix_timers-prototype
+++ a/include/linux/syscalls.h
@@ -1285,6 +1285,7 @@ asmlinkage long sys_ni_syscall(void);
 
 #endif /* CONFIG_ARCH_HAS_SYSCALL_WRAPPER */
 
+asmlinkage long sys_ni_posix_timers(void);
 
 /*
  * Kernel code should not call syscalls (i.e., sys_xyzyyz()) directly.
--- a/kernel/time/posix-stubs.c~syscalls-add-sys_ni_posix_timers-prototype
+++ a/kernel/time/posix-stubs.c
@@ -16,6 +16,7 @@
 #include <linux/posix-timers.h>
 #include <linux/time_namespace.h>
 #include <linux/compat.h>
+#include <linux/syscalls.h>
 
 #ifdef CONFIG_ARCH_HAS_SYSCALL_WRAPPER
 /* Architectures may override SYS_NI and COMPAT_SYS_NI */
_

Patches currently in -mm which might be from arnd@arndb.de are

radix-tree-move-declarations-to-header.patch
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
kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

