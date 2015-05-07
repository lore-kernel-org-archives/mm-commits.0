From: akpm@linux-foundation.org
Subject: +
 devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
 added to -mm tree
Date: Thu, 07 May 2015 16:00:49 -0700
Message-ID: <554beea1.upvG5CNLJFrOFltz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbbEGXAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2015 19:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix
has been added to the -mm tree.  Its filename is
     devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix

remove unneeded static

Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/devpts/inode.c~devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix
+++ a/fs/devpts/inode.c
@@ -689,7 +689,8 @@ static int __init init_devpts_fs(void)
 	struct ctl_table_header *table;
 
 	if (!err) {
-		static struct vfsmount *mnt;
+		struct vfsmount *mnt;
+
 		table = register_sysctl_table(pty_root_table);
 		mnt = kern_mount(&devpts_fs_type);
 		if (IS_ERR(mnt)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

