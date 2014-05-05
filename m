From: akpm@linux-foundation.org
Subject: + fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch added to
 -mm tree
Date: Mon, 05 May 2014 14:13:01 -0700
Message-ID: <5367fedd.WD9Aylr39JmssIJe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaEEVNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 17:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sage@inktank.com, fabf@skynet.be

Subject: + fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch added to -mm tree
To: fabf@skynet.be,sage@inktank.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 14:13:01 -0700


The patch titled
     Subject: fs/ceph/debugfs.c: replace seq_printf by seq_puts
has been added to the -mm tree.  Its filename is
     fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch

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
Subject: fs/ceph/debugfs.c: replace seq_printf by seq_puts

Replace seq_printf where possible.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Sage Weil <sage@inktank.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ceph/debugfs.c~fs-ceph-debugfsc-replace-seq_printf-by-seq_puts fs/ceph/debugfs.c
--- a/fs/ceph/debugfs.c~fs-ceph-debugfsc-replace-seq_printf-by-seq_puts
+++ a/fs/ceph/debugfs.c
@@ -71,9 +71,9 @@ static int mdsc_show(struct seq_file *s,
 		seq_printf(s, "%s", ceph_mds_op_name(req->r_op));
 
 		if (req->r_got_unsafe)
-			seq_printf(s, "\t(unsafe)");
+			seq_puts(s, "\t(unsafe)");
 		else
-			seq_printf(s, "\t");
+			seq_puts(s, "\t");
 
 		if (req->r_inode) {
 			seq_printf(s, " #%llx", ceph_ino(req->r_inode));
@@ -119,7 +119,7 @@ static int mdsc_show(struct seq_file *s,
 				seq_printf(s, " %s", req->r_path2);
 		}
 
-		seq_printf(s, "\n");
+		seq_puts(s, "\n");
 	}
 	mutex_unlock(&mdsc->mutex);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-affs-superc-bugfix-double-free.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch

