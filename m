From: akpm@linux-foundation.org
Subject: + mm-reorder-can_do_mlock-to-fix-audit-denial.patch added to -mm
 tree
Date: Mon, 02 Mar 2015 16:42:33 -0800
Message-ID: <54f50379.WU7A25x9ZfISSt2s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbbCCAme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 19:42:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffv@google.com, cassella@cray.com, nnk@google.com, paulmck@linux.vnet.ibm.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reorder can_do_mlock to fix audit denial
has been added to the -mm tree.  Its filename is
     mm-reorder-can_do_mlock-to-fix-audit-denial.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-reorder-can_do_mlock-to-fix-audit-denial.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-reorder-can_do_mlock-to-fix-audit-denial.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Vander Stoep <jeffv@google.com>
Subject: mm: reorder can_do_mlock to fix audit denial

A userspace call to mmap(MAP_LOCKED) may result in the successful locking
of memory while also producing a confusing audit log denial.  can_do_mlock
checks capable and rlimit.  If either of these return positive
can_do_mlock returns true.  The capable check leads to an LSM hook used by
apparmour and selinux which produce the audit denial.  Reordering so
rlimit is checked first eliminates the denial on success, only recording a
denial when the lock is unsuccessful as a result of the denial.

Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
Acked-by: Nick Kralevich <nnk@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Paul Cassella <cassella@cray.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-reorder-can_do_mlock-to-fix-audit-denial mm/mlock.c
--- a/mm/mlock.c~mm-reorder-can_do_mlock-to-fix-audit-denial
+++ a/mm/mlock.c
@@ -26,10 +26,10 @@
 
 int can_do_mlock(void)
 {
-	if (capable(CAP_IPC_LOCK))
-		return 1;
 	if (rlimit(RLIMIT_MEMLOCK) != 0)
 		return 1;
+	if (capable(CAP_IPC_LOCK))
+		return 1;
 	return 0;
 }
 EXPORT_SYMBOL(can_do_mlock);
_

Patches currently in -mm which might be from jeffv@google.com are

mm-reorder-can_do_mlock-to-fix-audit-denial.patch

