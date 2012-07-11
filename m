From: akpm@linux-foundation.org
Subject: [alternative-merged] kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff.patch removed from -mm tree
Date: Wed, 11 Jul 2012 16:29:17 -0700
Message-ID: <20120711232917.ECFCE1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:58769 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2GKX3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 19:29:18 -0400
Received: by ghbz15 with SMTP id z15so181421ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 16:29:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: fix mishandling of out of memory in poweroff
has been removed from the -mm tree.  Its filename was
     kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: kernel/sys.c: fix mishandling of out of memory in poweroff

Coverity 703573

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff
+++ a/kernel/sys.c
@@ -2217,13 +2217,13 @@ int orderly_poweroff(bool force)
 
 	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
 				      NULL, argv_cleanup, NULL);
-out:
 	if (likely(!ret))
 		return 0;
 
 	if (ret == -ENOMEM)
 		argv_free(argv);
 
+out:
 	if (force) {
 		printk(KERN_WARNING "Failed to start orderly shutdown: "
 		       "forcing the issue\n");
_

Patches currently in -mm which might be from alan@linux.intel.com are

xtensa-fix-incorrect-memset.patch
linux-next.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-avoid-argv_freenull.patch

