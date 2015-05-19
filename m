From: akpm@linux-foundation.org
Subject: +
 fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
 added to -mm tree
Date: Tue, 19 May 2015 12:52:19 -0700
Message-ID: <555b9473.jKjI5I34LEFfdPZz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbESTwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 15:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, james.hogan@imgtec.com, md@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/binfmt_elf.c:load_elf_binary(): return -EINVAL on zero-length mappings
has been added to the -mm tree.  Its filename is
     fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch

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
Subject: fs/binfmt_elf.c:load_elf_binary(): return -EINVAL on zero-length mappings

load_elf_binary() returns `retval', not `error'.

Fixes: a87938b2e246b81b4fb ("fs/binfmt_elf.c: fix bug in loading of PIE binaries")
Reported-by: James Hogan <james.hogan@imgtec.com>
Cc: Michael Davidson <md@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings
+++ a/fs/binfmt_elf.c
@@ -918,7 +918,7 @@ static int load_elf_binary(struct linux_
 			total_size = total_mapping_size(elf_phdata,
 							loc->elf_ex.e_phnum);
 			if (!total_size) {
-				error = -EINVAL;
+				retval = -EINVAL;
 				goto out_free_dentry;
 			}
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
fs-binfmt_elfc-load_elf_binary-return-einval-on-zero-length-mappings.patch
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
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
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

