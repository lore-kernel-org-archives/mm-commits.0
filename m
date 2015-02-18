From: akpm@linux-foundation.org
Subject: [merged]
 vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch removed from -mm
 tree
Date: Wed, 18 Feb 2015 11:43:19 -0800
Message-ID: <54e4eb57.2REV/+tujRvkpfXt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbbBRTnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaowang@redhat.com, anderson@redhat.com, bhe@redhat.com, fabf@skynet.be, greg.pearson@hp.com, paul.gortmaker@windriver.com, rashika.kheria@gmail.com, rwright@hp.com, vgoyal@redhat.com, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: fix PT_NOTE n_namesz, n_descsz overflow issue
has been removed from the -mm tree.  Its filename was
     vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: WANG Chao <chaowang@redhat.com>
Subject: vmcore: fix PT_NOTE n_namesz, n_descsz overflow issue

When updating PT_NOTE header size (ie.  p_memsz), an overflow issue
happens with the following bogus note entry:

n_namesz = 0xFFFFFFFF
n_descsz = 0x0
n_type   = 0x0

This kind of note entry should be dropped during updating p_memsz.  But
because n_namesz is 32bit, after (n_namesz + 3) & (~3), it's overflow to
0x0, the note entry size looks sane and reserved.

When userspace (eg.  crash utility) is trying to access such bogus note,
it could lead to an unexpected behavior (eg.  crash utility segment fault
because it's reading bogus address).

The source of bogus note hasn't been identified yet.  At least we could
drop the bogus note so user space wouldn't be surprised.

Signed-off-by: WANG Chao <chaowang@redhat.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Randy Wright <rwright@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>
Cc: Greg Pearson <greg.pearson@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-fix-pt_note-n_namesz-n_descsz-overflow-issue
+++ a/fs/proc/vmcore.c
@@ -546,8 +546,8 @@ static int __init update_note_header_siz
 		nhdr_ptr = notes_section;
 		while (nhdr_ptr->n_namesz != 0) {
 			sz = sizeof(Elf64_Nhdr) +
-				((nhdr_ptr->n_namesz + 3) & ~3) +
-				((nhdr_ptr->n_descsz + 3) & ~3);
+				(((u64)nhdr_ptr->n_namesz + 3) & ~3) +
+				(((u64)nhdr_ptr->n_descsz + 3) & ~3);
 			if ((real_sz + sz) > max_sz) {
 				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
 					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
@@ -732,8 +732,8 @@ static int __init update_note_header_siz
 		nhdr_ptr = notes_section;
 		while (nhdr_ptr->n_namesz != 0) {
 			sz = sizeof(Elf32_Nhdr) +
-				((nhdr_ptr->n_namesz + 3) & ~3) +
-				((nhdr_ptr->n_descsz + 3) & ~3);
+				(((u64)nhdr_ptr->n_namesz + 3) & ~3) +
+				(((u64)nhdr_ptr->n_descsz + 3) & ~3);
 			if ((real_sz + sz) > max_sz) {
 				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
 					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
_

Patches currently in -mm which might be from chaowang@redhat.com are

origin.patch

