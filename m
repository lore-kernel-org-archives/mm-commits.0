From: akpm@linux-foundation.org
Subject: [merged] exit-reparent-avoid-find_new_reaper-if-no-children.patch removed from -mm tree
Date: Thu, 11 Dec 2014 11:08:40 -0800
Message-ID: <5489ebb8.rvfSKVxttGp3JMiu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaLKTIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, atomlin@redhat.com, ebiederm@xmission.com, stalexan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: reparent: avoid find_new_reaper() if no children
has been removed from the -mm tree.  Its filename was
     exit-reparent-avoid-find_new_reaper-if-no-children.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: reparent: avoid find_new_reaper() if no children

Now that pid_ns logic was isolated we can change forget_original_parent()
to return right after find_child_reaper() when father->children is empty,
there is nothing to reparent in this case.

In particular this avoids find_alive_thread() and this can help if the
whole process exits and it has a lot of PF_EXITING threads at the start of
the thread list, this can easily lead to O(nr_threads ** 2) iterations.

Trivial test case (tested under KVM, 2 CPUs):

	static void *tfunc(void *arg)
	{
		pause();
		return NULL;
	}

	static int child(unsigned int nt)
	{
		pthread_t pt;

		while (nt--)
			assert(pthread_create(&pt, NULL, tfunc, NULL) == 0);

		pthread_kill(pt, SIGTRAP);
		pause();
		return 0;
	}

	int main(int argc, const char *argv[])
	{
		int stat;
		unsigned int nf = atoi(argv[1]);
		unsigned int nt = atoi(argv[2]);

		while (nf--) {
			if (!fork())
				return child(nt);

			wait(&stat);
			assert(stat == SIGTRAP);
		}

		return 0;
	}

$ time ./test 16 16536 shows:

		real		user		sys
	-	5m37.628s	0m4.437s	8m5.560s
	+	0m50.032s	0m7.130s	1m4.927s

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sterling Alexander <stalexan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/exit.c~exit-reparent-avoid-find_new_reaper-if-no-children kernel/exit.c
--- a/kernel/exit.c~exit-reparent-avoid-find_new_reaper-if-no-children
+++ a/kernel/exit.c
@@ -571,6 +571,8 @@ static void forget_original_parent(struc
 
 	/* Can drop and reacquire tasklist_lock */
 	reaper = find_child_reaper(father);
+	if (list_empty(&father->children))
+		goto unlock;
 
 	reaper = find_new_reaper(father, reaper);
 	list_for_each_entry(p, &father->children, sibling) {
@@ -591,6 +593,7 @@ static void forget_original_parent(struc
 			reparent_leader(father, p, &dead_children);
 	}
 	list_splice_tail_init(&father->children, &reaper->children);
+ unlock:
 	write_unlock_irq(&tasklist_lock);
 
 	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
mm-memoryc-share-the-i_mmap_rwsem.patch
remove-unnecessary-is_valid_nodemask.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
oom-kill-the-insufficient-and-no-longer-needed-pt_trace_exit-check.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

