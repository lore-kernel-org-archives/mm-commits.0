From: akpm@linux-foundation.org
Subject: + kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff.patch added to -mm tree
Date: Tue, 10 Jul 2012 13:11:17 -0700
Message-ID: <20120710201118.7F54420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57901 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab2GJULV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jul 2012 16:11:21 -0400
Received: by fat25 with SMTP id 25so17712fat.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jul 2012 13:11:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com


The patch titled
     Subject: kernel/sys.c: fix mishandling of out of memory in poweroff
has been added to the -mm tree.  Its filename is
     kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: kernel/sys.c: fix mishandling of out of memory in poweroff

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-fix-mishandling-of-out-of-memory-in-poweroff.patch
qla2xxx-print-the-right-array-elements.patch
fcoe-unsigned-long-can-never-be-negative.patch

