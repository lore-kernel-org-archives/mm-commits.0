From: akpm@linux-foundation.org
Subject: [merged] mm-use-roundown_pow_of_two-in-zone_batchsize.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:19 -0700
Message-ID: <200905071916.n47JGJPx020258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbZEGTTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, lanttor.guo@freescale.com, mm-commits@vger.kernel.org


The patch titled
     mm: use roundown_pow_of_two() in zone_batchsize()
has been removed from the -mm tree.  Its filename was
     mm-use-roundown_pow_of_two-in-zone_batchsize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: use roundown_pow_of_two() in zone_batchsize()
From: David Howells <dhowells@redhat.com>

Use roundown_pow_of_two(N) in zone_batchsize() rather than (1 <<
(fls(N)-1)) as they are equivalent, and with the former it is easier to
see what is going on.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Lanttor Guo <lanttor.guo@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-use-roundown_pow_of_two-in-zone_batchsize mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-roundown_pow_of_two-in-zone_batchsize
+++ a/mm/page_alloc.c
@@ -2706,7 +2706,7 @@ static int zone_batchsize(struct zone *z
 	 * of pages of one half of the possible page colors
 	 * and the other with pages of the other colors.
 	 */
-	batch = (1 << (fls(batch + batch/2)-1)) - 1;
+	batch = rounddown_pow_of_two(batch + batch/2) - 1;
 
 	return batch;
 }
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-remove-in-kernel-strace-code.patch
frv-implement-tif_notify_resume.patch
frv-dont-turn-on-tif_syscall_trace-unconditionally-in-syscall-prologue.patch
frv-implement-new-style-ptrace.patch
frv-duplicate-output_buffer-of-e03.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
kmap_types-make-most-arches-use-generic-header-file.patch
flat-fix-data-sections-alignment.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
mutex-subsystem-synchro-test-module.patch

