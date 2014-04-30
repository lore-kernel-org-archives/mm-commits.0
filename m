From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-fix-comparison-to-bool.patch added to -mm tree
Date: Wed, 30 Apr 2014 14:05:50 -0700
Message-ID: <536165ae.DMNPAigzCjeaJgLf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965178AbaD3VFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 17:05:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + lib-vsprintfc-fix-comparison-to-bool.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 14:05:50 -0700


The patch titled
     Subject: lib/vsprintf.c: fix comparison to bool
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-fix-comparison-to-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-fix-comparison-to-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-fix-comparison-to-bool.patch

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
Subject: lib/vsprintf.c: fix comparison to bool

Fixing 2 coccinelle warnings:
lib/vsprintf.c:2350:2-9: WARNING: Assignment of bool to 0/1
lib/vsprintf.c:2389:3-10: WARNING: Assignment of bool to 0/1

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-fix-comparison-to-bool lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-fix-comparison-to-bool
+++ a/lib/vsprintf.c
@@ -2365,7 +2365,7 @@ int vsscanf(const char *buf, const char
 			break;
 
 		base = 10;
-		is_sign = 0;
+		is_sign = false;
 
 		switch (*fmt++) {
 		case 'c':
@@ -2404,7 +2404,7 @@ int vsscanf(const char *buf, const char
 		case 'i':
 			base = 0;
 		case 'd':
-			is_sign = 1;
+			is_sign = true;
 		case 'u':
 			break;
 		case '%':
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

