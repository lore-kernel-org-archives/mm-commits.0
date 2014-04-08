From: akpm@linux-foundation.org
Subject: [merged]
 mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 13:38:03 -0700
Message-ID: <53445e2b.91RFmTR2Si4hW3bl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbaDHUiF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com, peterz@infradead.org, pbonzini@redhat.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com, hannes@cmpxchg.org, gerald.schaefer@de.ibm.com, ebiederm@xmission.com, borntraeger@de.ibm.com, aarcange@redhat.com, athorlton@sgi.com

Subject: [merged] mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch removed from -mm tree
To: athorlton@sgi.com,aarcange@redhat.com,borntraeger@de.ibm.com,ebiederm@xmission.com,gerald.schaefer@de.ibm.com,hannes@cmpxchg.org,heiko.carstens@de.ibm.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,pbonzini@redhat.com,peterz@infradead.org,riel@redhat.com,rientjes@google.com,schwidefsky@de.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:38:03 -0700


The patch titled
     Subject: mm: revert "thp: make MADV_HUGEPAGE check for mm->def_flags"
has been removed from the -mm tree.  Its filename was
     mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Thorlton <athorlton@sgi.com>
Subject: mm: revert "thp: make MADV_HUGEPAGE check for mm->def_flags"

The main motivation behind this patch is to provide a way to disable THP
for jobs where the code cannot be modified, and using a malloc hook with
madvise is not an option (i.e.  statically allocated data).  This patch
allows us to do just that, without affecting other jobs running on the
system.

We need to do this sort of thing for jobs where THP hurts performance, due
to the possibility of increased remote memory accesses that can be created
by situations such as the following:

When you touch 1 byte of an untouched, contiguous 2MB chunk, a THP will be
handed out, and the THP will be stuck on whatever node the chunk was
originally referenced from.  If many remote nodes need to do work on that
same chunk, they'll be making remote accesses.

With THP disabled, 4K pages can be handed out to separate nodes as
they're needed, greatly reducing the amount of remote accesses to
memory.

This patch is based on some of my work combined with some
suggestions/patches given by Oleg Nesterov.  The main goal here is to add
a prctl switch to allow us to disable to THP on a per mm_struct basis.


Here's a bit of test data with the new patch in place...

First with the flag unset:

# perf stat -a ./prctl_wrapper_mmv3 0 ./thp_pthread -C 0 -m 0 -c 512 -b 256g                  
Setting thp_disabled for this task...
thp_disable: 0
Set thp_disabled state to 0
Process pid = 18027

                                                                                                                     PF/
                                MAX        MIN                                  TOTCPU/      TOT_PF/   TOT_PF/     WSEC/
TYPE:               CPUS       WALL       WALL        SYS     USER     TOTCPU       CPU     WALL_SEC   SYS_SEC       CPU   NODES
 512      1.120      0.060      0.000    0.110      0.110     0.000    28571428864 -9223372036854775808  55803572      23

 Performance counter stats for './prctl_wrapper_mmv3_hack 0 ./thp_pthread -C 0 -m 0 -c 512 -b 256g':

  273719072.841402 task-clock                #  641.026 CPUs utilized           [100.00%]
         1,008,986 context-switches          #    0.000 M/sec                   [100.00%]
             7,717 CPU-migrations            #    0.000 M/sec                   [100.00%]
         1,698,932 page-faults               #    0.000 M/sec
355,222,544,890,379 cycles                    #    1.298 GHz                     [100.00%]
536,445,412,234,588 stalled-cycles-frontend   #  151.02% frontend cycles idle    [100.00%]
409,110,531,310,223 stalled-cycles-backend    #  115.17% backend  cycles idle    [100.00%]
148,286,797,266,411 instructions              #    0.42  insns per cycle
                                             #    3.62  stalled cycles per insn [100.00%]
27,061,793,159,503 branches                  #   98.867 M/sec                   [100.00%]
     1,188,655,196 branch-misses             #    0.00% of all branches

     427.001706337 seconds time elapsed

Now with the flag set:

# perf stat -a ./prctl_wrapper_mmv3 1 ./thp_pthread -C 0 -m 0 -c 512 -b 256g
Setting thp_disabled for this task...
thp_disable: 1
Set thp_disabled state to 1
Process pid = 144957

                                                                                                                     PF/
                                MAX        MIN                                  TOTCPU/      TOT_PF/   TOT_PF/     WSEC/
TYPE:               CPUS       WALL       WALL        SYS     USER     TOTCPU       CPU     WALL_SEC   SYS_SEC       CPU   NODES
 512      0.620      0.260      0.250    0.320      0.570     0.001    51612901376 128000000000 100806448      23

 Performance counter stats for './prctl_wrapper_mmv3_hack 1 ./thp_pthread -C 0 -m 0 -c 512 -b 256g':

  138789390.540183 task-clock                #  641.959 CPUs utilized           [100.00%]
           534,205 context-switches          #    0.000 M/sec                   [100.00%]
             4,595 CPU-migrations            #    0.000 M/sec                   [100.00%]
        63,133,119 page-faults               #    0.000 M/sec
147,977,747,269,768 cycles                    #    1.066 GHz                     [100.00%]
200,524,196,493,108 stalled-cycles-frontend   #  135.51% frontend cycles idle    [100.00%]
105,175,163,716,388 stalled-cycles-backend    #   71.07% backend  cycles idle    [100.00%]
180,916,213,503,160 instructions              #    1.22  insns per cycle
                                             #    1.11  stalled cycles per insn [100.00%]
26,999,511,005,868 branches                  #  194.536 M/sec                   [100.00%]
       714,066,351 branch-misses             #    0.00% of all branches

     216.196778807 seconds time elapsed

As with previous versions of the patch, We're getting about a 2x
performance increase here.  Here's a link to the test case I used, along
with the little wrapper to activate the flag:

http://oss.sgi.com/projects/memtests/thp_pthread_mmprctlv3.tar.gz




This patch (of 3):

Revert 8e72033f2a489b6c98 and add in code to fix up any issues caused by
the revert.

The revert is necessary because hugepage_madvise would return -EINVAL when
VM_NOHUGEPAGE is set, which will break subsequent chunks of this patch
set.

Here's a snip of an e-mail from Gerald detailing the original purpose of
this code, and providing justification for the revert:

<snip>
The intent of 8e72033f2a48 was to guard against any future programming
errors that may result in an madvice(MADV_HUGEPAGE) on guest mappings,
which would crash the kernel.

Martin suggested adding the bit to arch/s390/mm/pgtable.c, if 8e72033f2a48
was to be reverted, because that check will also prevent a kernel crash
in the case described above, it will now send a SIGSEGV instead.

This would now also allow to do the madvise on other parts, if needed,
so it is a more flexible approach. One could also say that it would have
been better to do it this way right from the beginning...
</snip>

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgtable.c |    3 +++
 mm/huge_memory.c       |   13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN arch/s390/mm/pgtable.c~mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags
+++ a/arch/s390/mm/pgtable.c
@@ -505,6 +505,9 @@ static int gmap_connect_pgtable(unsigned
 	if (!pmd_present(*pmd) &&
 	    __pte_alloc(mm, vma, pmd, vmaddr))
 		return -ENOMEM;
+	/* large pmds cannot yet be handled */
+	if (pmd_large(*pmd))
+		return -EFAULT;
 	/* pmd now points to a valid segment table entry. */
 	rmap = kmalloc(sizeof(*rmap), GFP_KERNEL|__GFP_REPEAT);
 	if (!rmap)
diff -puN mm/huge_memory.c~mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags mm/huge_memory.c
--- a/mm/huge_memory.c~mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags
+++ a/mm/huge_memory.c
@@ -1891,17 +1891,22 @@ out:
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
 {
-	struct mm_struct *mm = vma->vm_mm;
-
 	switch (advice) {
 	case MADV_HUGEPAGE:
+#ifdef CONFIG_S390
+		/*
+		 * qemu blindly sets MADV_HUGEPAGE on all allocations, but s390
+		 * can't handle this properly after s390_enable_sie, so we simply
+		 * ignore the madvise to prevent qemu from causing a SIGSEGV.
+		 */
+		if (mm_has_pgste(vma->vm_mm))
+			return 0;
+#endif
 		/*
 		 * Be somewhat over-protective like KSM for now!
 		 */
 		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
 			return -EINVAL;
-		if (mm->def_flags & VM_NOHUGEPAGE)
-			return -EINVAL;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		/*
_

Patches currently in -mm which might be from athorlton@sgi.com are

origin.patch

