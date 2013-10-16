From: akpm@linux-foundation.org
Subject: [folded-merged] ipc-update-locking-scheme-comments-fix.patch
 removed from -mm tree
Date: Wed, 16 Oct 2013 13:43:41 -0700
Message-ID: <525efa7d.9rR3NHmrFDHu8jcH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab3JPUnm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Oct 2013 16:43:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] ipc-update-locking-scheme-comments-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 16 Oct 2013 13:43:41 -0700


The patch titled
     Subject: ipc-update-locking-scheme-comments-fix
has been removed from the -mm tree.  Its filename was
     ipc-update-locking-scheme-comments-fix.patch

This patch was dropped because it was folded into ipc-update-locking-scheme-comments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-update-locking-scheme-comments-fix

make it more readable in 80 columns

Cc: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff -puN ipc/util.c~ipc-update-locking-scheme-comments-fix ipc/util.c
--- a/ipc/util.c~ipc-update-locking-scheme-comments-fix
+++ a/ipc/util.c
@@ -17,21 +17,27 @@
  *            Pavel Emelianov <xemul@openvz.org>
  *
  * General sysv ipc locking scheme:
- *      rcu_read_lock()
- *          obtain the ipc object (kern_ipc_perm) by looking up the id in an idr tree.
- *          - perform initial checks (capabilities, auditing and permission, etc).
- *          - perform read-only operations, such as STAT, INFO commands.
- *          acquire the ipc lock (kern_ipc_perm.lock) through ipc_lock_object()
- *             - perform data updates, such as SET, RMID commands and
- *               mechanism-specific operations (semop/semtimedop, msgsnd/msgrcv, shmat/shmdt).
- *          drop the ipc lock, through ipc_unlock_object().
- *     rcu_read_unlock()
+ *	rcu_read_lock()
+ *          obtain the ipc object (kern_ipc_perm) by looking up the id in an idr
+ *	    tree.
+ *	    - perform initial checks (capabilities, auditing and permission,
+ *	      etc).
+ *	    - perform read-only operations, such as STAT, INFO commands.
+ *	      acquire the ipc lock (kern_ipc_perm.lock) through
+ *	      ipc_lock_object()
+ *		- perform data updates, such as SET, RMID commands and
+ *		  mechanism-specific operations (semop/semtimedop,
+ *		  msgsnd/msgrcv, shmat/shmdt).
+ *	    drop the ipc lock, through ipc_unlock_object().
+ *	rcu_read_unlock()
  *
  *  The ids->rwsem must be taken when:
- *     - creating, removing and iterating the existing entries in ipc identifier sets.
- *     - iterating through /proc/sysvipc/* files.
+ *	- creating, removing and iterating the existing entries in ipc
+ *	  identifier sets.
+ *	- iterating through /proc/sysvipc/* files.
  *
- *  Note that sems have a special fast path that avoids kern_ipc_perm.lock - see sem_lock().
+ *  Note that sems have a special fast path that avoids kern_ipc_perm.lock -
+ *  see sem_lock().
  */
 
 #include <linux/mm.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments.patch
mm-zswap-bugfix-memory-leak-when-re-swapon.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

