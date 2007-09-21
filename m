From: akpm@linux-foundation.org
Subject: + userc-deinline.patch added to -mm tree
Date: Fri, 21 Sep 2007 12:35:03 -0700
Message-ID: <200709211935.l8LJZ37w019076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761503AbXIUTfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 15:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     user.c: deinline
has been added to the -mm tree.  Its filename is
     userc-deinline.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user.c: deinline
From: Alexey Dobriyan <adobriyan@sw.ru>

Save some space because uid_hash_find() has 3 callsites.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/user.c~userc-deinline kernel/user.c
--- a/kernel/user.c~userc-deinline
+++ a/kernel/user.c
@@ -55,17 +55,17 @@ struct user_struct root_user = {
 /*
  * These routines must be called with the uidhash spinlock held!
  */
-static inline void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
+static void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
 {
 	hlist_add_head(&up->uidhash_node, hashent);
 }
 
-static inline void uid_hash_remove(struct user_struct *up)
+static void uid_hash_remove(struct user_struct *up)
 {
 	hlist_del_init(&up->uidhash_node);
 }
 
-static inline struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
+static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
 {
 	struct user_struct *user;
 	struct hlist_node *h;
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
