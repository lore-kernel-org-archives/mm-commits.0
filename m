Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4907DC7EE2E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjFJAph (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjFJApS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDEF30F6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 947EC651B5
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F63C433EF;
        Sat, 10 Jun 2023 00:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357916;
        bh=RXo8frJlovzd1T2yCrDlSU1v94erYdzJy8McuQ6skLw=;
        h=Date:To:From:Subject:From;
        b=Y1JHz2k5/9r/jhQb59E72N0ovk2FzBqMAFbmaCgvDvEINTEahTLWOvVOQ4bNa3YgH
         IWB2LAUx2P593DlT+zrZpd/haR9akZNRNR+Xq53FDSicys4d+VXjuOJYHW1zIFKO6J
         OeBxmmu7OmiJXOFmW45lIJHi7evHAIb8qlI3/Tgk=
Date:   Fri, 09 Jun 2023 17:45:15 -0700
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
Subject: [merged mm-nonmm-stable] locking-add-lockevent_read-prototype.patch removed from -mm tree
Message-Id: <20230610004515.E3F63C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: locking: add lockevent_read() prototype
has been removed from the -mm tree.  Its filename was
     locking-add-lockevent_read-prototype.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: locking: add lockevent_read() prototype
Date: Wed, 17 May 2023 15:10:54 +0200

lockevent_read() has a __weak definition and the only caller in
kernel/locking/lock_events.c, plus a strong definition in qspinlock_stat.h
that overrides it, but no other declaration.  This causes a W=1 warning:

kernel/locking/lock_events.c:61:16: error: no previous prototype for 'lockevent_read' [-Werror=missing-prototypes]

Add shared prototype to avoid the warnings.

Link: https://lkml.kernel.org/r/20230517131102.934196-7-arnd@kernel.org
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

 kernel/locking/lock_events.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/locking/lock_events.h~locking-add-lockevent_read-prototype
+++ a/kernel/locking/lock_events.h
@@ -57,4 +57,8 @@ static inline void __lockevent_add(enum
 #define lockevent_cond_inc(ev, c)
 
 #endif /* CONFIG_LOCK_EVENT_COUNTS */
+
+ssize_t lockevent_read(struct file *file, char __user *user_buf,
+		       size_t count, loff_t *ppos);
+
 #endif /* __LOCKING_LOCK_EVENTS_H */
_

Patches currently in -mm which might be from arnd@arndb.de are

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

