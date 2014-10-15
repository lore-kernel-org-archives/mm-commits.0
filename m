From: akpm@linux-foundation.org
Subject: + fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch added to -mm tree
Date: Wed, 15 Oct 2014 14:37:58 -0700
Message-ID: <543ee936.Iyhyyn2NgtCLzpju%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaJOVh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Oct 2014 17:37:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, ebiederm@xmission.com, nicolas.dichtel@6wind.com, thierry.herbelot@6wind.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-use-a-rb-tree-for-the-directory-entries-fix
has been added to the -mm tree.  Its filename is
     fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch

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
Subject: fs-proc-use-a-rb-tree-for-the-directory-entries-fix

initialise proc_root.subdir at compile time

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Thierry Herbelot <thierry.herbelot@6wind.com>.
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/root.c~fs-proc-use-a-rb-tree-for-the-directory-entries-fix fs/proc/root.c
--- a/fs/proc/root.c~fs-proc-use-a-rb-tree-for-the-directory-entries-fix
+++ a/fs/proc/root.c
@@ -166,7 +166,6 @@ void __init proc_root_init(void)
 {
 	int err;
 
-	proc_root.subdir = RB_ROOT;
 	proc_init_inodecache();
 	err = register_filesystem(&proc_fs_type);
 	if (err)
@@ -252,6 +251,7 @@ struct proc_dir_entry proc_root = {
 	.proc_iops	= &proc_root_inode_operations, 
 	.proc_fops	= &proc_root_operations,
 	.parent		= &proc_root,
+	.subdir		= RB_ROOT,
 	.name		= "/proc",
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

