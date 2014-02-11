From: akpm@linux-foundation.org
Subject: +
 include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch added to
 -mm tree
Date: Tue, 11 Feb 2014 14:36:35 -0800
Message-ID: <52faa5f3.G2XyrqSiRdgkKCZf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaBKWgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 17:36:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rashika.kheria@gmail.com, josh@joshtriplett.org, benh@kernel.crashing.org, akpm@linux-foundation.org

Subject: + include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch added to -mm tree
To: akpm@linux-foundation.org,benh@kernel.crashing.org,josh@joshtriplett.org,rashika.kheria@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 14:36:35 -0800


The patch titled
     Subject: include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix
has been added to the -mm tree.  Its filename is
     include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix

clean up powerpc, remove unneeded EXPORT_SYMBOL

Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fadump.h |    1 -
 fs/proc/vmcore.c                  |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/powerpc/include/asm/fadump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix arch/powerpc/include/asm/fadump.h
--- a/arch/powerpc/include/asm/fadump.h~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix
+++ a/arch/powerpc/include/asm/fadump.h
@@ -210,7 +210,6 @@ extern int is_fadump_active(void);
 extern void crash_fadump(struct pt_regs *, const char *);
 extern void fadump_cleanup(void);
 
-extern void vmcore_cleanup(void);
 #else	/* CONFIG_FA_DUMP */
 static inline int is_fadump_active(void) { return 0; }
 static inline void crash_fadump(struct pt_regs *regs, const char *str) { }
diff -puN fs/proc/vmcore.c~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix
+++ a/fs/proc/vmcore.c
@@ -1118,4 +1118,3 @@ void vmcore_cleanup(void)
 	}
 	free_elfcorebuf();
 }
-EXPORT_SYMBOL_GPL(vmcore_cleanup);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

