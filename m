From: akpm@linux-foundation.org
Subject: [folded-merged]
 arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 16:09:33 -0700
Message-ID: <20200604230933.u9QVNFs2t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:09:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, chris@zankel.net, christian.koenig@amd.com, dan.j.williams@intel.com, daniel.vetter@ffwll.ch, dave.hansen@linux.intel.com, davem@davemloft.net, deller@gmx.de, hch@lst.de, hpa@zytor.com, ira.weiny@intel.com, James.Bottomley@HansenPartnership.com, jcmvbkbc@gmail.com, luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, tsbogend@alpha.franken.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch

This patch was dropped because it was folded into arch-kunmap_atomic-consol=
idate-duplicate-code.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes

Cc: Al Viro <viro@zeniv.linux.org.uk>

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#287: FILE: arch/nds32/mm/highmem.c:50:
+EXPORT_SYMBOL(kunmap_atomic_high);

WARNING: Block comments use a trailing */ on a separate line
#453: FILE: include/linux/highmem.h:153:
+	 * handles re-enabling faults + preemption */

total: 0 errors, 2 warnings, 321 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplac=
e.

./patches/arch-kunmap_atomic-consolidate-duplicate-code.patch has style pro=
blems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/highmem.h~arch-kunmap_atomic-consolidate-duplicate-code=
-checkpatch-fixes
+++ a/include/linux/highmem.h
@@ -154,8 +154,10 @@ static inline void *kmap_atomic(struct p
=20
 static inline void kunmap_atomic_high(void *addr)
 {
-	/* Nothing to do in the CONFIG_HIGHMEM=3Dn case as kunmap_atomic()
-	 * handles re-enabling faults + preemption */
+	/*
+	 * Nothing to do in the CONFIG_HIGHMEM=3Dn case as kunmap_atomic()
+	 * handles re-enabling faults + preemption
+	 */
 }
=20
 #define kmap_atomic_pfn(pfn)	kmap_atomic(pfn_to_page(pfn))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-kunmap_atomic-consolidate-duplicate-code.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.=
patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.p=
atch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-f=
ix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.pa=
tch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
