Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55235C7EE2E
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjFJApl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjFJApW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8023A9B
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA64F651B5
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A32C4339B;
        Sat, 10 Jun 2023 00:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357920;
        bh=JP8740UpdV0lIKVNADQuRM0m4yzc8SoN82U27ikkbdw=;
        h=Date:To:From:Subject:From;
        b=P5RJQs0alboDzc5sq+7us8cIeDNeC+l+bU7zgBuI3D0GKJvFhVH24EtJRDtKmUAjW
         T2m4RX2+hFr15F1VoHPklBi1wpvAvjxhD9IuAMjW9VMc1NNC+K8SWBTKpTKYh+19tq
         9rvnAtzQuRhJfVPyf7EY9ru1xwOQa99e25VDDuHw=
Date:   Fri, 09 Jun 2023 17:45:19 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tsbogend@alpha.franken.de, tj@kernel.org, tglx@linutronix.de,
        rafael@kernel.org, peterz@infradead.org, pavel@ucw.cz,
        paul@paul-moore.com, palmer@dabbelt.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, longman@redhat.com,
        linux@armlinux.org.uk, hca@linux.ibm.com, eparis@redhat.com,
        dennis@kernel.org, deller@gmx.de, davidgow@google.com,
        cl@linux.com, catalin.marinas@arm.com, boqun.feng@gmail.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kunit-include-debugfs-header-file.patch removed from -mm tree
Message-Id: <20230610004520.27A32C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kunit: include debugfs header file
has been removed from the -mm tree.  Its filename was
     kunit-include-debugfs-header-file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kunit: include debugfs header file
Date: Wed, 17 May 2023 15:10:57 +0200

An extra #include statement is needed to ensure the prototypes for debugfs
interfaces are visible, avoiding this warning:

lib/kunit/debugfs.c:28:6: error: no previous prototype for 'kunit_debugfs_cleanup' [-Werror=missing-prototypes]
lib/kunit/debugfs.c:33:6: error: no previous prototype for 'kunit_debugfs_init' [-Werror=missing-prototypes]
lib/kunit/debugfs.c:102:6: error: no previous prototype for 'kunit_debugfs_create_suite' [-Werror=missing-prototypes]
lib/kunit/debugfs.c:118:6: error: no previous prototype for 'kunit_debugfs_destroy_suite' [-Werror=missing-prototypes]

Link: https://lkml.kernel.org/r/20230517131102.934196-10-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Gow <davidgow@google.com>
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

 lib/kunit/debugfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/kunit/debugfs.c~kunit-include-debugfs-header-file
+++ a/lib/kunit/debugfs.c
@@ -10,6 +10,7 @@
 #include <kunit/test.h>
 
 #include "string-stream.h"
+#include "debugfs.h"
 
 #define KUNIT_DEBUGFS_ROOT             "kunit"
 #define KUNIT_DEBUGFS_RESULTS          "results"
_

Patches currently in -mm which might be from arnd@arndb.de are

init-consolidate-prototypes-in-linux-inith.patch
init-move-cifs_root_data-prototype-into-linux-mounth.patch
thread_info-move-function-declarations-to-linux-thread_infoh.patch
time_namespace-always-provide-arch_get_vdso_data-prototype-for-vdso.patch
kcov-add-prototypes-for-helper-functions.patch
decompressor-provide-missing-prototypes.patch
syscalls-add-sys_ni_posix_timers-prototype.patch

