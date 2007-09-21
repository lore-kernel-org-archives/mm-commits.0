From: akpm@linux-foundation.org
Subject: + userc-ifdef-mq_bytes.patch added to -mm tree
Date: Fri, 21 Sep 2007 12:35:20 -0700
Message-ID: <200709211935.l8LJZKaP019081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbXIUTf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 15:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     user.c: #ifdef ->mq_bytes
has been added to the -mm tree.  Its filename is
     userc-ifdef-mq_bytes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user.c: #ifdef ->mq_bytes
From: Alexey Dobriyan <adobriyan@sw.ru>

For those who deselect POSIX message queues.

Reduces SLAB size of user_struct from 64 to 32 bytes here, SLUB size -- from
40 bytes to 32 bytes.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 ++
 kernel/user.c         |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~userc-ifdef-mq_bytes include/linux/sched.h
--- a/include/linux/sched.h~userc-ifdef-mq_bytes
+++ a/include/linux/sched.h
@@ -515,8 +515,10 @@ struct user_struct {
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
+#ifdef CONFIG_POSIX_MQUEUE
 	/* protected by mq_lock	*/
 	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
+#endif
 	unsigned long locked_shm; /* How many pages of mlocked shm ? */
 
 #ifdef CONFIG_KEYS
diff -puN kernel/user.c~userc-ifdef-mq_bytes kernel/user.c
--- a/kernel/user.c~userc-ifdef-mq_bytes
+++ a/kernel/user.c
@@ -44,7 +44,6 @@ struct user_struct root_user = {
 	.processes	= ATOMIC_INIT(1),
 	.files		= ATOMIC_INIT(0),
 	.sigpending	= ATOMIC_INIT(0),
-	.mq_bytes	= 0,
 	.locked_shm     = 0,
 #ifdef CONFIG_KEYS
 	.uid_keyring	= &root_user_keyring,
_

Patches currently in -mm which might be from adobriyan@sw.ru are

consolidate-ptrace_detach.patch
git-kbuild.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
tweak-proc-ipmi-removal.patch
shrink-task_struct-if-config_futex=n.patch
userc-deinline.patch
userc-ifdef-mq_bytes.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
single_open-seq_release-leak-diagnostics.patch
