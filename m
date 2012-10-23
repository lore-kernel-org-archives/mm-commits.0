From: akpm@linux-foundation.org
Subject: + procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:02:59 -0700
Message-ID: <20121023220300.1185C200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:62092 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab2JWWDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:03:02 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so257922bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:03:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, a.p.zijlstra@chello.nl, xemul@parallels.com


The patch titled
     Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix-2
has been added to the -mm tree.  Its filename is
     procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix-2

Use designated init to assign "??" mnemonic on unknown flags.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v3-fix-2 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~procfs-add-vmflags-field-in-smaps-output-v3-fix-2
+++ a/fs/proc/task_mmu.c
@@ -534,6 +534,11 @@ static void show_smap_vma_flags(struct s
 	static const struct {
 		const char l[2];
 	} mnemonics[BITS_PER_LONG] = {
+		/*
+		 * In case if we meet a flag we don't know about.
+		 */
+		[0 ... (BITS_PER_LONG-1)] = { {'?', '?'} },
+
 		[ilog2(VM_READ)]	= { {'r', 'd'} },
 		[ilog2(VM_WRITE)]	= { {'w', 'r'} },
 		[ilog2(VM_EXEC)]	= { {'e', 'x'} },
_

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
procfs-add-vmflags-field-in-smaps-output-v3.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

