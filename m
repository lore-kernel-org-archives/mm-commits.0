From: akpm@linux-foundation.org
Subject: [folded-merged]
 align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch removed from -mm tree
Date: Wed, 09 Sep 2015 15:11:29 -0700
Message-ID: <55f0ae91.T2GO52rziYfYZtEy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbbIIWLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix
has been removed from the -mm tree.  Its filename was
     align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch

This patch was dropped because it was folded into align-crash_notes-allocation-to-make-it-be-inside-one-physical-page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix

use correct comment layout

Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN kernel/kexec_core.c~align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix kernel/kexec_core.c
--- a/kernel/kexec_core.c~align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix
+++ a/kernel/kexec_core.c
@@ -1006,19 +1006,23 @@ static int __init crash_notes_memory_ini
 	/* Allocate memory for saving cpu registers. */
 	size_t size, align;
 
-	/* crash_notes could be allocated across 2 vmalloc pages when percpu
+	/*
+	 * crash_notes could be allocated across 2 vmalloc pages when percpu
 	 * is vmalloc based . vmalloc doesn't guarantee 2 continuous vmalloc
 	 * pages are also on 2 continuous physical pages. In this case the
 	 * 2nd part of crash_notes in 2nd page could be lost since only the
 	 * starting address and size of crash_notes are exported through sysfs.
 	 * Here round up the size of crash_notes to the nearest power of two
 	 * and pass it to __alloc_percpu as align value. This can make sure
-	 * crash_notes is allocated inside one physical page. */
+	 * crash_notes is allocated inside one physical page.
+	 */
 	size = sizeof(note_buf_t);
 	align = min(roundup_pow_of_two(sizeof(note_buf_t)), PAGE_SIZE);
 
-	/* Break compile if size is bigger than PAGE_SIZE since crash_notes
-	 * definitely will be in 2 pages with that. */
+	/*
+	 * Break compile if size is bigger than PAGE_SIZE since crash_notes
+	 * definitely will be in 2 pages with that.
+	 */
 	BUILD_BUG_ON(size > PAGE_SIZE);
 
 	crash_notes = __alloc_percpu(size, align);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

