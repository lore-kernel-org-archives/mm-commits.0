From: akpm@linux-foundation.org
Subject: + proc-sysvipc-shm-fix-32-bit-truncation-of-segment-sizes.patch added to -mm tree
Date: Wed, 11 Jun 2008 13:49:06 -0700
Message-ID: <200806112049.m5BKn7FJ017258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYFKUuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 16:50:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, Nadia.Derbey@bull.net, manfred@colorfullife.com, peifferp@gmail.com


The patch titled
     /proc/sysvipc/shm: fix 32-bit truncation of segment sizes
has been added to the -mm tree.  Its filename is
     proc-sysvipc-shm-fix-32-bit-truncation-of-segment-sizes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/sysvipc/shm: fix 32-bit truncation of segment sizes
From: Paul Menage <menage@google.com>

sysvipc_shm_proc_show() picks between format strings (based on the
expected maximum length of a SHM segment) in a way that prevents gcc from
performing format checks on the seq_printf() parameters.  This hid two
format errors - shp->shm_segsz and shp->shm_nattach are both unsigned
long, but were being printed as unsigned int and signed int respectively. 
This leads to 32-bit truncation of SHM segment sizes reported in
/proc/sysvipc/shm.  (And for nattach, but that's less of a problem for
most users).

This patch makes the format string directly visible to gcc's format
specifier checker, and fixes the two broken format specifiers.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN ipc/shm.c~proc-sysvipc-shm-fix-32-bit-truncation-of-segment-sizes ipc/shm.c
--- a/ipc/shm.c~proc-sysvipc-shm-fix-32-bit-truncation-of-segment-sizes
+++ a/ipc/shm.c
@@ -1060,16 +1060,16 @@ asmlinkage long sys_shmdt(char __user *s
 static int sysvipc_shm_proc_show(struct seq_file *s, void *it)
 {
 	struct shmid_kernel *shp = it;
-	char *format;
 
-#define SMALL_STRING "%10d %10d  %4o %10u %5u %5u  %5d %5u %5u %5u %5u %10lu %10lu %10lu\n"
-#define BIG_STRING   "%10d %10d  %4o %21u %5u %5u  %5d %5u %5u %5u %5u %10lu %10lu %10lu\n"
+#if BITS_PER_LONG <= 32
+#define SIZE_SPEC "%10lu"
+#else
+#define SIZE_SPEC "%21lu"
+#endif
 
-	if (sizeof(size_t) <= sizeof(int))
-		format = SMALL_STRING;
-	else
-		format = BIG_STRING;
-	return seq_printf(s, format,
+	return seq_printf(s,
+			  "%10d %10d  %4o " SIZE_SPEC " %5u %5u  "
+			  "%5lu %5u %5u %5u %5u %10lu %10lu %10lu\n",
 			  shp->shm_perm.key,
 			  shp->shm_perm.id,
 			  shp->shm_perm.mode,
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
proc-sysvipc-shm-fix-32-bit-truncation-of-segment-sizes.patch
call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch

