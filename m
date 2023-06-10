Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BD0C7EE2F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjFJApT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjFJApQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA0A3A9A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D84651CF
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DFAC433D2;
        Sat, 10 Jun 2023 00:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357914;
        bh=0ZFQsl+e1cnTLH7MX0oZn+YjIXPfOHQguuqz27TA+P4=;
        h=Date:To:From:Subject:From;
        b=EEFYHOCYuLmlFm+y+yalHr8aNw7aSgSJDogxufhaMQYULnSwgeHTdvW90aJBCBO9w
         fECKg/0h+bXQfAjqZqLaab5JA5Ry4+LkGANAp1sARd5bFPZxloj2r2L/zifTzdksM5
         9EArpXMruGc5qClLgpcnRiPS9WhgEAJKi0sRQdqs=
Date:   Fri, 09 Jun 2023 17:45:13 -0700
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
Subject: [merged mm-nonmm-stable] lib-devmem_is_allowed-include-linux-ioh.patch removed from -mm tree
Message-Id: <20230610004514.83DFAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: devmem_is_allowed: include linux/io.h
has been removed from the -mm tree.  Its filename was
     lib-devmem_is_allowed-include-linux-ioh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: lib: devmem_is_allowed: include linux/io.h
Date: Wed, 17 May 2023 15:10:53 +0200

The devmem_is_allowed() function is defined in a file of the same name,
but the declaration is in asm/io.h, which is not included there, causing a
W=1 warning:

lib/devmem_is_allowed.c:20:5: error: no previous prototype for 'devmem_is_allowed' [-Werror=missing-prototypes]

Include the appropriate header to avoid the warning.

Link: https://lkml.kernel.org/r/20230517131102.934196-6-arnd@kernel.org
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

 lib/devmem_is_allowed.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/devmem_is_allowed.c~lib-devmem_is_allowed-include-linux-ioh
+++ a/lib/devmem_is_allowed.c
@@ -10,6 +10,7 @@
 
 #include <linux/mm.h>
 #include <linux/ioport.h>
+#include <linux/io.h>
 
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
_

Patches currently in -mm which might be from arnd@arndb.de are

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

