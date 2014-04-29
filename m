From: akpm@linux-foundation.org
Subject: + mm-slubc-convert-vnsprintf-static-to-va_format.patch added to
 -mm tree
Date: Tue, 29 Apr 2014 16:33:12 -0700
Message-ID: <536036b8.a4uh8uhk+1CPL/2u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaD2XdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Apr 2014 19:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, joe@perches.com, cl@linux.com, fabf@skynet.be

Subject: + mm-slubc-convert-vnsprintf-static-to-va_format.patch added to -mm tree
To: fabf@skynet.be,cl@linux.com,joe@perches.com,penberg@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 29 Apr 2014 16:33:12 -0700


The patch titled
     Subject: mm/slub.c: convert vnsprintf-static to va_format
has been added to the -mm tree.  Its filename is
     mm-slubc-convert-vnsprintf-static-to-va_format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slubc-convert-vnsprintf-static-to-va_format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slubc-convert-vnsprintf-static-to-va_format.patch

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
Subject: mm/slub.c: convert vnsprintf-static to va_format

Inspired by Joe Perches suggestion in ntfs logging clean-up.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN mm/slub.c~mm-slubc-convert-vnsprintf-static-to-va_format mm/slub.c
--- a/mm/slub.c~mm-slubc-convert-vnsprintf-static-to-va_format
+++ a/mm/slub.c
@@ -581,28 +581,30 @@ static void print_page_info(struct page
 
 static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char buf[100];
 
 	va_start(args, fmt);
-	vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	pr_err("=============================================================================\n");
-	pr_err("BUG %s (%s): %s\n", s->name, print_tainted(), buf);
+	pr_err("BUG %s (%s): %pV\n", s->name, print_tainted(), &vaf);
 	pr_err("-----------------------------------------------------------------------------\n\n");
 
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+	va_end(args);
 }
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char buf[100];
 
 	va_start(args, fmt);
-	vsnprintf(buf, sizeof(buf), fmt, args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_err("FIX %s: %pV\n", s->name, &vaf);
 	va_end(args);
-	pr_err("FIX %s: %s\n", s->name, buf);
 }
 
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
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

