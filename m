From: akpm@linux-foundation.org
Subject: [merged]
 lib-mpi-mpicoderc-looping-issue-need-stop-when-equal-to-zero-found-by-extra_flags=-w.patch removed from -mm tree
Date: Thu, 13 Jun 2013 11:57:28 -0700
Message-ID: <51ba1618.vqLl46PGEtQVv5C+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:57:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, james.l.morris@oracle.com, dhowells@redhat.com, andriy.shevchenko@linux.intel.com, gang.chen@asianux.com

Subject: [merged] lib-mpi-mpicoderc-looping-issue-need-stop-when-equal-to-zero-found-by-extra_flags=-w.patch removed from -mm tree
To: gang.chen@asianux.com,andriy.shevchenko@linux.intel.com,dhowells@redhat.com,james.l.morris@oracle.com,rusty@rustcorp.com.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:57:28 -0700


The patch titled
     Subject: lib/mpi/mpicoder.c: looping issue, need stop when equal to zero, found by 'EXTRA_FLAGS=-W'.
has been removed from the -mm tree.  Its filename was
     lib-mpi-mpicoderc-looping-issue-need-stop-when-equal-to-zero-found-by-extra_flags=-w.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: lib/mpi/mpicoder.c: looping issue, need stop when equal to zero, found by 'EXTRA_FLAGS=-W'.

For 'while' looping, need stop when 'nbytes == 0', or will cause issue.
('nbytes' is size_t which is always bigger or equal than zero).

The related warning: (with EXTRA_CFLAGS=-W)
  lib/mpi/mpicoder.c:40:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/mpi/mpicoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/mpi/mpicoder.c~lib-mpi-mpicoderc-looping-issue-need-stop-when-equal-to-zero-found-by-extra_flags=-w lib/mpi/mpicoder.c
--- a/lib/mpi/mpicoder.c~lib-mpi-mpicoderc-looping-issue-need-stop-when-equal-to-zero-found-by-extra_flags=-w
+++ a/lib/mpi/mpicoder.c
@@ -37,7 +37,7 @@ MPI mpi_read_raw_data(const void *xbuffe
 	mpi_limb_t a;
 	MPI val = NULL;
 
-	while (nbytes >= 0 && buffer[0] == 0) {
+	while (nbytes > 0 && buffer[0] == 0) {
 		buffer++;
 		nbytes--;
 	}
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
linux-next.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch
mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
arch-frv-kernel-trapsc-using-vsnprintf-instead-of-vsprintf.patch
arch-frv-kernel-setupc-use-strncmp-instead-of-memcmp.patch

