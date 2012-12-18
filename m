From: akpm@linux-foundation.org
Subject: [merged] documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:02:32 -0800
Message-ID: <20121218200233.363C020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:38083 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LRUCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:02:35 -0500
Received: by mail-la0-f74.google.com with SMTP id v3so63327lag.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:02:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/kernel-parameters.txt: update mem= option's spec according to its implementation
has been removed from the -mm tree.  Its filename was
     documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: Documentation/kernel-parameters.txt: update mem= option's spec according to its implementation

Current mem= implementation seems buggy because the specification and
implementation don't match.  The current mem= has been working for many
years and it's not buggy - it works as expected.  So we should update the
specification.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-update-mem=-options-spec-according-to-its-implementation
+++ a/Documentation/kernel-parameters.txt
@@ -1503,9 +1503,10 @@ bytes respectively. Such letter suffixes
 	mem=nn[KMG]	[KNL,BOOT] Force usage of a specific amount of memory
 			Amount of memory to be used when the kernel is not able
 			to see the whole system memory or for test.
-			[X86-32] Use together with memmap= to avoid physical
-			address space collisions. Without memmap= PCI devices
-			could be placed at addresses belonging to unused RAM.
+			[X86] Work as limiting max address. Use together
+			with memmap= to avoid physical address space collisions.
+			Without memmap= PCI devices could be placed at addresses
+			belonging to unused RAM.
 
 	mem=nopentium	[BUGS=X86-32] Disable usage of 4MB pages for kernel
 			memory.
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
x86-make-mem=-option-to-work-for-efi-platform.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memory-hotplug-document-and-enable-config_movable_node-fix.patch
mm-memory_hotplugc-improve-comments.patch

