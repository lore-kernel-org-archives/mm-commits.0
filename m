Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC553C7EE2F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjFJApj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjFJApV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A783A98
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C5A651DE
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C835CC433EF;
        Sat, 10 Jun 2023 00:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357918;
        bh=23sB7xRJJviwTNv4Lmm4ITLFnSL0kUm19VubKC3qEv8=;
        h=Date:To:From:Subject:From;
        b=MgtsTeJgGrMToOlgYB2FgvjVgAOtWhZyw26yGwyh8walgUy+9ALNJPj3ZnqiOccdc
         9Cc/0TWqiObn+WgYGJ3doR7SqRiGD51+zSyNQh0SJHa9EUrx4jZaB5WevBF+0z7do/
         vegwevMoAv1i69BE4ZQNsFZ+WQmLS8DSsUmpwt+c=
Date:   Fri, 09 Jun 2023 17:45:18 -0700
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
Subject: [merged mm-nonmm-stable] panic-make-function-declarations-visible.patch removed from -mm tree
Message-Id: <20230610004518.C835CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: panic: make function declarations visible
has been removed from the -mm tree.  Its filename was
     panic-make-function-declarations-visible.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: panic: make function declarations visible
Date: Wed, 17 May 2023 15:10:56 +0200

A few panic() related functions have a global definition but not
declaration, which causes a warning with W=1:

kernel/panic.c:710:6: error: no previous prototype for '__warn_printk' [-Werror=missing-prototypes]
kernel/panic.c:756:24: error: no previous prototype for '__stack_chk_fail' [-Werror=missing-prototypes]
kernel/exit.c:1917:32: error: no previous prototype for 'abort' [-Werror=missing-prototypes]

__warn_printk() is called both as a global function when CONFIG_BUG
is enabled, and as a local function in other configs. The other
two here are called indirectly from generated or assembler code.

Add prototypes for all of these.

Link: https://lkml.kernel.org/r/20230517131102.934196-9-arnd@kernel.org
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

 include/asm-generic/bug.h |    5 +++--
 include/linux/panic.h     |    3 +++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/include/asm-generic/bug.h~panic-make-function-declarations-visible
+++ a/include/asm-generic/bug.h
@@ -87,10 +87,12 @@ struct bug_entry {
  *
  * Use the versions with printk format strings to provide better diagnostics.
  */
-#ifndef __WARN_FLAGS
 extern __printf(4, 5)
 void warn_slowpath_fmt(const char *file, const int line, unsigned taint,
 		       const char *fmt, ...);
+extern __printf(1, 2) void __warn_printk(const char *fmt, ...);
+
+#ifndef __WARN_FLAGS
 #define __WARN()		__WARN_printf(TAINT_WARN, NULL)
 #define __WARN_printf(taint, arg...) do {				\
 		instrumentation_begin();				\
@@ -98,7 +100,6 @@ void warn_slowpath_fmt(const char *file,
 		instrumentation_end();					\
 	} while (0)
 #else
-extern __printf(1, 2) void __warn_printk(const char *fmt, ...);
 #define __WARN()		__WARN_FLAGS(BUGFLAG_TAINT(TAINT_WARN))
 #define __WARN_printf(taint, arg...) do {				\
 		instrumentation_begin();				\
--- a/include/linux/panic.h~panic-make-function-declarations-visible
+++ a/include/linux/panic.h
@@ -32,6 +32,9 @@ extern int sysctl_panic_on_stackoverflow
 
 extern bool crash_kexec_post_notifiers;
 
+extern void __stack_chk_fail(void);
+void abort(void);
+
 /*
  * panic_cpu is used for synchronizing panic() and crash_kexec() execution. It
  * holds a CPU number which is executing panic() currently. A value of
_

Patches currently in -mm which might be from arnd@arndb.de are

kunit-include-debugfs-header-file.patch
init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch
kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

