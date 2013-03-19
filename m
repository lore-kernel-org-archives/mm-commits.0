From: akpm@linux-foundation.org
Subject: + vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:03:00 -0700
Message-ID: <20130319200300.D4CC65A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:56609 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab3CSUDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:03:02 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so84852ghb.3
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:03:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: vmcore: modify vmcore clean-up function to free buffer on 2nd kernel
has been added to the -mm tree.  Its filename is
     vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: modify vmcore clean-up function to free buffer on 2nd kernel

If flag MEM_TYPE_CURRENT_KERNEL is set, the object is copied in some
buffer on the 2nd kernel, so clean-up funciton needs to free it.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/proc/vmcore.c~vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel
+++ a/fs/proc/vmcore.c
@@ -940,6 +940,10 @@ void vmcore_cleanup(void)
 		struct vmcore *m;
 
 		m = list_entry(pos, struct vmcore, list);
+
+		if (m->flag & MEM_TYPE_CURRENT_KERNEL)
+			free_pages((unsigned long)m->buf, get_order(m->size));
+
 		list_del(&m->list);
 		kfree(m);
 	}
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

vmcore-reference-e_phoff-member-explicitly-to-get-position-of-program-header-table.patch
vmcore-clean-up-by-removing-unnecessary-variable.patch
vmcore-rearrange-program-headers-without-assuming-consequtive-pt_note-entries.patch
vmcore-sysfs-export-elf-note-segment-size-instead-of-vmcoreinfo-data-size.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-round-up-buffer-size-of-elf-headers-by-page_size.patch
vmcore-procfs-introduce-a-flag-to-distinguish-objects-copied-in-2nd-kernel.patch
vmcore-copy-non-page-size-aligned-head-and-tail-pages-in-2nd-kernel.patch
vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel.patch
vmcore-clean-up-read_vmcore.patch
vmcore-read-buffers-for-vmcore-objects-copied-from-old-memory.patch
vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundary.patch
kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary.patch
kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch
elf-introduce-nt_vmcore_pad-type.patch
kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch
vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

