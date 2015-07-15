From: akpm@linux-foundation.org
Subject: +
 procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
 added to -mm tree
Date: Wed, 15 Jul 2015 15:50:26 -0700
Message-ID: <55a6e3b2.jiXzsX389XvF70l4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbbGOWu1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 18:50:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, calvinowens@fb.com, gorcunov@openvz.org, joe@perches.com, keescook@chromium.org, kirill@shutemov.name, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix
has been added to the -mm tree.  Its filename is
     procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch

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
Subject: procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix

git it correcter

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Calvin Owens <calvinowens@fb.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix fs/proc/base.c
--- a/fs/proc/base.c~procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix
+++ a/fs/proc/base.c
@@ -1955,8 +1955,8 @@ struct map_files_info {
  * symlinks may be used to bypass permissions on ancestor directories in the
  * path to the file in question.
  */
-static void *
-proc_map_files_follow_link(struct dentry *dentry, struct nameidata *nd)
+static const char *
+proc_map_files_follow_link(struct dentry *dentry, void **cookie)
 {
 	if (!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
openrisc-fix-config_uid16-setting.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
mm-page-refine-the-calculation-of-highest-possible-node-id.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

