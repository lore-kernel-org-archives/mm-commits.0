From: akpm@linux-foundation.org
Subject: + mm-vmallocc-replace-seq_printf-by-seq_puts.patch added to -mm
 tree
Date: Wed, 30 Apr 2014 15:34:05 -0700
Message-ID: <53617a5d.qRQL2p6LUErFpsbL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759647AbaD3WeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 18:34:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + mm-vmallocc-replace-seq_printf-by-seq_puts.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 15:34:05 -0700


The patch titled
     Subject: mm/vmalloc.c: replace seq_printf by seq_puts
has been added to the -mm tree.  Its filename is
     mm-vmallocc-replace-seq_printf-by-seq_puts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-replace-seq_printf-by-seq_puts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-replace-seq_printf-by-seq_puts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/vmalloc.c: replace seq_printf by seq_puts

Replace seq_printf where possible

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-replace-seq_printf-by-seq_puts mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-replace-seq_printf-by-seq_puts
+++ a/mm/vmalloc.c
@@ -2619,19 +2619,19 @@ static int s_show(struct seq_file *m, vo
 		seq_printf(m, " phys=%llx", (unsigned long long)v->phys_addr);
 
 	if (v->flags & VM_IOREMAP)
-		seq_printf(m, " ioremap");
+		seq_puts(m, " ioremap");
 
 	if (v->flags & VM_ALLOC)
-		seq_printf(m, " vmalloc");
+		seq_puts(m, " vmalloc");
 
 	if (v->flags & VM_MAP)
-		seq_printf(m, " vmap");
+		seq_puts(m, " vmap");
 
 	if (v->flags & VM_USERMAP)
-		seq_printf(m, " user");
+		seq_puts(m, " user");
 
 	if (v->flags & VM_VPAGES)
-		seq_printf(m, " vpages");
+		seq_puts(m, " vpages");
 
 	show_numa_info(m, v);
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch

