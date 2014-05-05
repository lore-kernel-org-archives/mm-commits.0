From: akpm@linux-foundation.org
Subject: + fs-fscache-replace-seq_printf-by-seq_puts.patch added to -mm
 tree
Date: Mon, 05 May 2014 14:04:54 -0700
Message-ID: <5367fcf6.C0/5Z5Yib0MgjHid%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbaEEVEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 17:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, fabf@skynet.be

Subject: + fs-fscache-replace-seq_printf-by-seq_puts.patch added to -mm tree
To: fabf@skynet.be,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 14:04:54 -0700


The patch titled
     Subject: fs/fscache: replace seq_printf by seq_puts
has been added to the -mm tree.  Its filename is
     fs-fscache-replace-seq_printf-by-seq_puts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fscache-replace-seq_printf-by-seq_puts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fscache-replace-seq_printf-by-seq_puts.patch

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
Subject: fs/fscache: replace seq_printf by seq_puts

Replace seq_printf where possible + coalesce formats from 2 existing
seq_puts

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/histogram.c   |    6 ++----
 fs/fscache/object-list.c |    8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/fscache/histogram.c~fs-fscache-replace-seq_printf-by-seq_puts fs/fscache/histogram.c
--- a/fs/fscache/histogram.c~fs-fscache-replace-seq_printf-by-seq_puts
+++ a/fs/fscache/histogram.c
@@ -31,12 +31,10 @@ static int fscache_histogram_show(struct
 
 	switch ((unsigned long) v) {
 	case 1:
-		seq_puts(m, "JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS "
-			 " RETRV DLY RETRIEVLS\n");
+		seq_puts(m, "JIFS  SECS  OBJ INST  OP RUNS   OBJ RUNS  RETRV DLY RETRIEVLS\n");
 		return 0;
 	case 2:
-		seq_puts(m, "===== ===== ========= ========= ========="
-			 " ========= =========\n");
+		seq_puts(m, "===== ===== ========= ========= ========= ========= =========\n");
 		return 0;
 	default:
 		index = (unsigned long) v - 3;
diff -puN fs/fscache/object-list.c~fs-fscache-replace-seq_printf-by-seq_puts fs/fscache/object-list.c
--- a/fs/fscache/object-list.c~fs-fscache-replace-seq_printf-by-seq_puts
+++ a/fs/fscache/object-list.c
@@ -285,20 +285,20 @@ static int fscache_objlist_show(struct s
 		fscache_unuse_cookie(obj);
 
 		if (keylen > 0 || auxlen > 0) {
-			seq_printf(m, " ");
+			seq_puts(m, " ");
 			for (p = buf; keylen > 0; keylen--)
 				seq_printf(m, "%02x", *p++);
 			if (auxlen > 0) {
 				if (config & FSCACHE_OBJLIST_CONFIG_KEY)
-					seq_printf(m, ", ");
+					seq_puts(m, ", ");
 				for (; auxlen > 0; auxlen--)
 					seq_printf(m, "%02x", *p++);
 			}
 		}
 
-		seq_printf(m, "\n");
+		seq_puts(m, "\n");
 	} else {
-		seq_printf(m, "<no_netfs>\n");
+		seq_puts(m, "<no_netfs>\n");
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-affs-superc-bugfix-double-free.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
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

