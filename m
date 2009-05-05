From: akpm@linux-foundation.org
Subject: + mm-use-roundown_pow_of_two-in-zone_batchsize.patch added to -mm tree
Date: Tue, 05 May 2009 15:16:18 -0700
Message-ID: <200905052216.n45MGIpU016150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152AbZEEWSe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 18:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, lanttor.guo@freescale.com


The patch titled
     mm: use roundown_pow_of_two() in zone_batchsize()
has been added to the -mm tree.  Its filename is
     mm-use-roundown_pow_of_two-in-zone_batchsize.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2707,7 +2707,7 @@ static int zone_batchsize(struct zone *z
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
mm-use-roundown_pow_of_two-in-zone_batchsize.patch
nommu-clamp-zone_batchsize-to-0-under-nommu-conditions.patch
nommu-make-the-initial-mmap-allocation-excess-behaviour-kconfig-configurable.patch
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

