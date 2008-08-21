From: akpm@linux-foundation.org
Subject: - gcov-add-gcov-profiling-infrastructure-add-datagcov-to-data-section.patch removed from -mm tree
Date: Thu, 21 Aug 2008 09:20:11 -0700
Message-ID: <200808211620.m7LGKBpp013777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307AbYHUQW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 12:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulus@samba.org, peter.oberparleiter@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     gcov: add .data.gcov to data section
has been removed from the -mm tree.  Its filename was
     gcov-add-gcov-profiling-infrastructure-add-datagcov-to-data-section.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: add .data.gcov to data section
From: Paul Mackerras <paulus@samba.org>

Andrew Morton writes:

> ia64 blew up in a perhaps similar fashion.  See lkml thread
> "ia64 allmodconfig on current mainline".
>
> The compiler is from http://userweb.kernel.org/~akpm/cross-compilers/
> (installable on redhatty systems, maybe others).

This is the problem:

Ld versions before about 2.18 or so (older than April 2007, I think)
have a bug where they put things in the wrong order in the output file
if you don't have all the sections listed in the vmlinux.lds with an
AT() clause on each one (it seems they all have to have AT(), or
none).  With the gcov stuff turned on, we get a .data.gcov section
which isn't mentioned in include/asm-generic/vmlinux.lds.h, which
triggers this bug.  This works around the ld bug by making sure
.data.gcov is mentioned in DATA_DATA.

The patch below should work around the problem, and may help ia64 as
well if it's the same problem there.  If it does fix it for you, you
can push it to Linus, since it touches a generic file.  Here's a SOB
in case you decide to do that (the previous paragraph should serve as
a patch description).  If you don't want to push this, I can do an
equivalent fix in arch/powerpc/kernel/vmlinux.lds.S.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-generic/vmlinux.lds.h~gcov-add-gcov-profiling-infrastructure-add-datagcov-to-data-section include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~gcov-add-gcov-profiling-infrastructure-add-datagcov-to-data-section
+++ a/include/asm-generic/vmlinux.lds.h
@@ -43,6 +43,7 @@
 	*(.data)							\
 	*(.data.init.refok)						\
 	*(.ref.data)							\
+	*(.data.gcov)							\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
 	CPU_KEEP(init.data)						\
_

Patches currently in -mm which might be from paulus@samba.org are

linux-next.patch
git-powerpc.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
gcov-add-gcov-profiling-infrastructure-add-datagcov-to-data-section.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
powerpc-hugetlb-pgtable-cache-access-cleanup.patch

