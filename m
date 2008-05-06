From: akpm@linux-foundation.org
Subject: + move-proc_kmsg_operations-to-fs-proc-internalh.patch added to -mm tree
Date: Tue, 06 May 2008 11:37:33 -0700
Message-ID: <200805061837.m46IbX57021320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbYEFSht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, adobriyan@gmail.com


The patch titled
     move proc_kmsg_operations to fs/proc/internal.h
has been added to the -mm tree.  Its filename is
     move-proc_kmsg_operations-to-fs-proc-internalh.patch

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
Subject: move proc_kmsg_operations to fs/proc/internal.h
From: Adrian Bunk <bunk@kernel.org>

This patch moves the extern of struct proc_kmsg_operations to
fs/proc/internal.h and adds an #include "internal.h" to fs/proc/kmsg.c
so that the latter sees the former.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h      |    1 +
 fs/proc/kmsg.c          |    2 ++
 include/linux/proc_fs.h |    1 -
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/internal.h~move-proc_kmsg_operations-to-fs-proc-internalh fs/proc/internal.h
--- a/fs/proc/internal.h~move-proc_kmsg_operations-to-fs-proc-internalh
+++ a/fs/proc/internal.h
@@ -63,6 +63,7 @@ extern const struct file_operations proc
 extern const struct file_operations proc_clear_refs_operations;
 extern const struct file_operations proc_pagemap_operations;
 extern const struct file_operations proc_net_operations;
+extern const struct file_operations proc_kmsg_operations;
 extern const struct inode_operations proc_net_inode_operations;
 
 void free_proc_entry(struct proc_dir_entry *de);
diff -puN fs/proc/kmsg.c~move-proc_kmsg_operations-to-fs-proc-internalh fs/proc/kmsg.c
--- a/fs/proc/kmsg.c~move-proc_kmsg_operations-to-fs-proc-internalh
+++ a/fs/proc/kmsg.c
@@ -15,6 +15,8 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#include "internal.h"
+
 extern wait_queue_head_t log_wait;
 
 extern int do_syslog(int type, char __user *bug, int count);
diff -puN include/linux/proc_fs.h~move-proc_kmsg_operations-to-fs-proc-internalh include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~move-proc_kmsg_operations-to-fs-proc-internalh
+++ a/include/linux/proc_fs.h
@@ -138,7 +138,6 @@ extern int proc_readdir(struct file *, v
 extern struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
 
 extern const struct file_operations proc_kcore_operations;
-extern const struct file_operations proc_kmsg_operations;
 extern const struct file_operations ppc_htab_operations;
 
 extern int pid_ns_prepare_proc(struct pid_namespace *ns);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

