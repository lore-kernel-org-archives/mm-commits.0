From: akpm@linux-foundation.org
Subject: + mmvmacache-optimize-overflow-system-wide-flushing.patch added
 to -mm tree
Date: Tue, 15 Apr 2014 13:52:21 -0700
Message-ID: <534d9c05.9rfCvIRor7DzVFS7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaDOUwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Apr 2014 16:52:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oleg@redhat.com, aswin@hp.com, davidlohr@hp.com

Subject: + mmvmacache-optimize-overflow-system-wide-flushing.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com,oleg@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 15 Apr 2014 13:52:21 -0700


The patch titled
     Subject: mm,vmacache: optimize overflow system-wide flushing
has been added to the -mm tree.  Its filename is
     mmvmacache-optimize-overflow-system-wide-flushing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmvmacache-optimize-overflow-system-wide-flushing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmvmacache-optimize-overflow-system-wide-flushing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm,vmacache: optimize overflow system-wide flushing

For single threaded workloads, we can avoid flushing and iterating through
the entire list of tasks, making the whole function a lot faster,
requiring only a single atomic read for the mm_users.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/vmacache.c~mmvmacache-optimize-overflow-system-wide-flushing mm/vmacache.c
--- a/mm/vmacache.c~mmvmacache-optimize-overflow-system-wide-flushing
+++ a/mm/vmacache.c
@@ -17,6 +17,16 @@ void vmacache_flush_all(struct mm_struct
 {
 	struct task_struct *g, *p;
 
+	/*
+	 * Single threaded tasks need not iterate the entire
+	 * list of process. We can avoid the flushing as well
+	 * since the mm's seqnum was increased and don't have
+	 * to worry about other threads' seqnum. Current's
+	 * flush will occur upon the next lookup.
+	 */
+	if (atomic_read(&mm->mm_users) == 1)
+		return;
+
 	rcu_read_lock();
 	for_each_process_thread(g, p) {
 		/*
_

Patches currently in -mm which might be from davidlohr@hp.com are

mm-fix-config_debug_vm_rb-description.patch
mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
ipc-constify-ipc_ops.patch

