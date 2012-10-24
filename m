From: akpm@linux-foundation.org
Subject: [to-be-updated] procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch removed from -mm tree
Date: Wed, 24 Oct 2012 13:39:45 -0700
Message-ID: <20121024203945.9ECA7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64364 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935511Ab2JXUjq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 16:39:46 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so108653vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 13:39:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, a.p.zijlstra@chello.nl, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-add-vmflags-field-in-smaps-output-v3-fix-2
has been removed from the -mm tree.  Its filename was
     procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch

This patch was dropped because an updated version will be merged

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

pidns-limit-the-nesting-depth-of-pid-namespaces.patch
pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch
linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch

