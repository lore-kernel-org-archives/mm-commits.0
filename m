From: akpm@linux-foundation.org
Subject: [merged]
 align-crash_notes-allocation-to-make-it-be-inside-one-physical-page.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:26 -0700
Message-ID: <55f319c6.hLhd7inc4kCSPrGC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbbIKSN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, lisa.mitchell@hp.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: align crash_notes allocation to make it be inside one physical page
has been removed from the -mm tree.  Its filename was
     align-crash_notes-allocation-to-make-it-be-inside-one-physical-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: kexec: align crash_notes allocation to make it be inside one physical page

People reported that crash_notes in /proc/vmcore were corrupted and this
cause crash kdump failure.  With code debugging and log we got the root
cause.  This is because percpu variable crash_notes are allocated in 2
vmalloc pages.  Currently percpu is based on vmalloc by default.  Vmalloc
can't guarantee 2 continuous vmalloc pages are also on 2 continuous
physical pages.  So when 1st kernel exports the starting address and size
of crash_notes through sysfs like below:

/sys/devices/system/cpu/cpux/crash_notes
/sys/devices/system/cpu/cpux/crash_notes_size

kdump kernel use them to get the content of crash_notes.  However the 2nd
part may not be in the next neighbouring physical page as we expected if
crash_notes are allocated accross 2 vmalloc pages.  That's why
nhdr_ptr->n_namesz or nhdr_ptr->n_descsz could be very huge in
update_note_header_size_elf64() and cause note header merging failure or
some warnings.

In this patch change to call __alloc_percpu() to passed in the align value
by rounding crash_notes_size up to the nearest power of two.  This makes
sure the crash_notes is allocated inside one physical page since
sizeof(note_buf_t) in all ARCHS is smaller than PAGE_SIZE.  Meanwhile add
a BUILD_BUG_ON to break compile if size is bigger than PAGE_SIZE since
crash_notes definitely will be in 2 pages.  That need be avoided, and need
be reported if it's unavoidable.

[akpm@linux-foundation.org: use correct comment layout]
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Lisa Mitchell <lisa.mitchell@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff -puN kernel/kexec_core.c~align-crash_notes-allocation-to-make-it-be-inside-one-physical-page kernel/kexec_core.c
--- a/kernel/kexec_core.c~align-crash_notes-allocation-to-make-it-be-inside-one-physical-page
+++ a/kernel/kexec_core.c
@@ -1004,7 +1004,28 @@ void crash_save_cpu(struct pt_regs *regs
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = alloc_percpu(note_buf_t);
+	size_t size, align;
+
+	/*
+	 * crash_notes could be allocated across 2 vmalloc pages when percpu
+	 * is vmalloc based . vmalloc doesn't guarantee 2 continuous vmalloc
+	 * pages are also on 2 continuous physical pages. In this case the
+	 * 2nd part of crash_notes in 2nd page could be lost since only the
+	 * starting address and size of crash_notes are exported through sysfs.
+	 * Here round up the size of crash_notes to the nearest power of two
+	 * and pass it to __alloc_percpu as align value. This can make sure
+	 * crash_notes is allocated inside one physical page.
+	 */
+	size = sizeof(note_buf_t);
+	align = min(roundup_pow_of_two(sizeof(note_buf_t)), PAGE_SIZE);
+
+	/*
+	 * Break compile if size is bigger than PAGE_SIZE since crash_notes
+	 * definitely will be in 2 pages with that.
+	 */
+	BUILD_BUG_ON(size > PAGE_SIZE);
+
+	crash_notes = __alloc_percpu(size, align);
 	if (!crash_notes) {
 		pr_warn("Kexec: Memory allocation for saving cpu register states failed\n");
 		return -ENOMEM;
_

Patches currently in -mm which might be from bhe@redhat.com are


