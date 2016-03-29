From: akpm@linux-foundation.org
Subject: + mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch added to -mm tree
Date: Tue, 29 Mar 2016 14:08:02 -0700
Message-ID: <56faeeb2.ESx2f+6N/2y7bsER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbcC2VID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 17:08:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, hpa@zytor.com, jack@suse.cz, kirill@shutemov.name, mingo@elte.hu, rientjes@google.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mmdebug: always evaluate the arguments to VM_BUG_ON_*
has been added to the -mm tree.  Its filename is
     mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mmdebug: always evaluate the arguments to VM_BUG_ON_*

We have customer demand to use 1GB pages to map DAX files.  Unlike the 2MB
page support, the Linux MM does not currently support PUD pages, so I have
attempted to add support for the necessary pieces for DAX huge PUD pages.

Filesystems still need work to allocate 1GB pages.  With ext4, I can only
get 16MB of contiguous space, although it is aligned.  With XFS, I can get
80MB less than 1GB, and it's not aligned.  The XFS problem may be due to
the small amount of RAM in my test machine.

I'd like to thank Dave Chinner & Kirill Shutemov for their reviews of v1. 
The conversion of pmd_fault & pud_fault to huge_fault is thanks to Dave's
poking, and Kirill spotted a couple of problems in the MM code.

I've done some light testing using a program to mmap a block device with
DAX enabled, calling mincore() and examining /proc/smaps and
/proc/pagemap.


This patch (of 14):

I recently got the order of arguments to VM_BUG_ON_VMA the wrong way
around, which was only noticable when compiling with CONFIG_DEBUG_VM. 
Prevent the next mistake of this kind by making the macros evaluate both
their arguments at compile time (this has no effect on the built kernel).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff -puN include/linux/mmdebug.h~mmdebug-always-evaluate-the-arguments-to-vm_bug_on_ include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mmdebug-always-evaluate-the-arguments-to-vm_bug_on_
+++ a/include/linux/mmdebug.h
@@ -41,9 +41,24 @@ void dump_mm(const struct mm_struct *mm)
 #define VM_WARN_ONCE(cond, format...) WARN_ONCE(cond, format)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
-#define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
-#define VM_BUG_ON_VMA(cond, vma) VM_BUG_ON(cond)
-#define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
+#define VM_BUG_ON_PAGE(cond, page)					\
+	do {								\
+		if (0) dump_page(page, "");				\
+		VM_BUG_ON(cond);					\
+	} while (0)
+
+#define VM_BUG_ON_VMA(cond, vma)					\
+	do {								\
+		if (0) dump_vma(vma);					\
+		VM_BUG_ON(cond);					\
+	} while (0)
+
+#define VM_BUG_ON_MM(cond, mm)						\
+	do {								\
+		if (0) dump_mm(mm);					\
+		VM_BUG_ON(cond);					\
+	} while (0)
+
 #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
_

Patches currently in -mm which might be from willy@linux.intel.com are

mmdebug-always-evaluate-the-arguments-to-vm_bug_on_.patch
mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
mincore-add-support-for-puds.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-unify-native__get_and_clear-smp-case.patch
x86-fix-whitespace-issues.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
dax-use-vmf-gfp_mask.patch
dax-remove-unnecessary-rechecking-of-i_size.patch
dax-use-vmf-pgoff-in-fault-handlers.patch

