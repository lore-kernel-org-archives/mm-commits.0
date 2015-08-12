From: akpm@linux-foundation.org
Subject: [to-be-updated]
 user_ns-use-correct-check-for-single-threadedness.patch removed from -mm
 tree
Date: Wed, 12 Aug 2015 15:49:43 -0700
Message-ID: <55cbcd87.tcHrDw14FOmQSNjy%akpm__33171.8369889588$1439419797$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbbHLWtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Aug 2015 18:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickyz@chromium.org, ebiederm@xmission.com, jln@google.com, keescook@chromium.org, kirill.shutemov@linux.intel.com, mingo@kernel.org, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: user_ns: use correct check for single-threadedness
has been removed from the -mm tree.  Its filename was
     user_ns-use-correct-check-for-single-threadedness.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ricky Zhou <rickyz@chromium.org>
Subject: user_ns: use correct check for single-threadedness

Checking mm_users > 1 does not mean a process is multithreaded.  For
example, reading /proc/PID/maps temporarily increments mm_users, allowing
other processes to (accidentally) interfere with unshare() calls.

This fixes observed failures of unshare(CLONE_NEWUSER) incorrectly
returning EINVAL if another processes happened to be simultaneously
reading the maps file.

Signed-off-by: Ricky Zhou <rickyz@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Julien Tinnes <jln@google.com>
Cc: <stable@vger.kernel.org>	[3.9+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c           |    4 ++--
 kernel/user_namespace.c |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/fork.c~user_ns-use-correct-check-for-single-threadedness kernel/fork.c
--- a/kernel/fork.c~user_ns-use-correct-check-for-single-threadedness
+++ a/kernel/fork.c
@@ -75,6 +75,7 @@
 #include <linux/aio.h>
 #include <linux/compiler.h>
 #include <linux/sysctl.h>
+#include <linux/sched.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1876,8 +1877,7 @@ static int check_unshare_flags(unsigned
 	 * needs to unshare vm.
 	 */
 	if (unshare_flags & (CLONE_THREAD | CLONE_SIGHAND | CLONE_VM)) {
-		/* FIXME: get_task_mm() increments ->mm_users */
-		if (atomic_read(&current->mm->mm_users) > 1)
+		if (!current_is_single_threaded())
 			return -EINVAL;
 	}
 
diff -puN kernel/user_namespace.c~user_ns-use-correct-check-for-single-threadedness kernel/user_namespace.c
--- a/kernel/user_namespace.c~user_ns-use-correct-check-for-single-threadedness
+++ a/kernel/user_namespace.c
@@ -22,6 +22,7 @@
 #include <linux/ctype.h>
 #include <linux/projid.h>
 #include <linux/fs_struct.h>
+#include <linux/sched.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
 static DEFINE_MUTEX(userns_state_mutex);
@@ -977,7 +978,7 @@ static int userns_install(struct nsproxy
 		return -EINVAL;
 
 	/* Threaded processes may not enter a different user namespace */
-	if (atomic_read(&current->mm->mm_users) > 1)
+	if (!current_is_single_threaded())
 		return -EINVAL;
 
 	if (current->fs->users != 1)
_

Patches currently in -mm which might be from rickyz@chromium.org are

unshare-unsharing-a-thread-does-not-require-unsharing-a-vm.patch

