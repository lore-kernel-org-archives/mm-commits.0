From: akpm@linux-foundation.org
Subject: [merged] kdump-add-kexec_crash_control_memory_limit.patch removed from -mm tree
Date: Tue, 23 Aug 2011 12:18:29 -0700
Message-ID: <201108231915.p7NJFSoX000986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab1HWTPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Aug 2011 15:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kdump: add KEXEC_CRASH_CONTROL_MEMORY_LIMIT
has been removed from the -mm tree.  Its filename was
     kdump-add-kexec_crash_control_memory_limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kdump: add KEXEC_CRASH_CONTROL_MEMORY_LIMIT
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

On s390 there is a different KEXEC_CONTROL_MEMORY_LIMIT for the normal and
the kdump kexec case. Therefore this patch introduces a new macro
KEXEC_CRASH_CONTROL_MEMORY_LIMIT. This is set to
KEXEC_CONTROL_MEMORY_LIMIT for all architectures that do not define
KEXEC_CRASH_CONTROL_MEMORY_LIMIT.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    4 ++++
 kernel/kexec.c        |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/kexec.h~kdump-add-kexec_crash_control_memory_limit include/linux/kexec.h
--- a/include/linux/kexec.h~kdump-add-kexec_crash_control_memory_limit
+++ a/include/linux/kexec.h
@@ -33,6 +33,10 @@
 #error KEXEC_ARCH not defined
 #endif
 
+#ifndef KEXEC_CRASH_CONTROL_MEMORY_LIMIT
+#define KEXEC_CRASH_CONTROL_MEMORY_LIMIT KEXEC_CONTROL_MEMORY_LIMIT
+#endif
+
 #define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
 #define KEXEC_CORE_NOTE_NAME "CORE"
 #define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
diff -puN kernel/kexec.c~kdump-add-kexec_crash_control_memory_limit kernel/kexec.c
--- a/kernel/kexec.c~kdump-add-kexec_crash_control_memory_limit
+++ a/kernel/kexec.c
@@ -498,7 +498,7 @@ static struct page *kimage_alloc_crash_c
 	while (hole_end <= crashk_res.end) {
 		unsigned long i;
 
-		if (hole_end > KEXEC_CONTROL_MEMORY_LIMIT)
+		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
 			break;
 		if (hole_end > crashk_res.end)
 			break;
_

Patches currently in -mm which might be from holzheu@linux.vnet.ibm.com are

linux-next.patch

