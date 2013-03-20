From: akpm@linux-foundation.org
Subject: [nacked] vmcore-sysfs-export-elf-note-segment-size-instead-of-vmcoreinfo-data-size.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:26 -0700
Message-ID: <20130320233226.850105A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:60686 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3CTXc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:28 -0400
Received: by mail-gh0-f202.google.com with SMTP id z10so211297ghb.3
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore, sysfs: export ELF note segment size instead of vmcoreinfo data size
has been removed from the -mm tree.  Its filename was
     vmcore-sysfs-export-elf-note-segment-size-instead-of-vmcoreinfo-data-size.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore, sysfs: export ELF note segment size instead of vmcoreinfo data size

Currently, vmcoreinfo exports data part only, but kexec-tool sets it in
p_memsz member as a whole ELF note segment size.  Due to this, it would be
no problem on the current ELF note segment size, but if it grows in the
future, then read possibly doesn't reach ELF note header in larger p_memsz
position, failing to read a whole ELF segment.

Note: kexec-tools assigns PAGE_SIZE to p_memsz for other ELF note types. 
Due to the above reason, the same issue occurs if actual ELF note data
exceeds (PAGE_SIZE - 2 * KEXEC_NOTE_HEAD_BYTES).

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ksysfs.c~vmcore-sysfs-export-elf-note-segment-size-instead-of-vmcoreinfo-data-size kernel/ksysfs.c
--- a/kernel/ksysfs.c~vmcore-sysfs-export-elf-note-segment-size-instead-of-vmcoreinfo-data-size
+++ a/kernel/ksysfs.c
@@ -126,7 +126,7 @@ static ssize_t vmcoreinfo_show(struct ko
 {
 	return sprintf(buf, "%lx %x\n",
 		       paddr_vmcoreinfo_note(),
-		       (unsigned int)vmcoreinfo_max_size);
+		       (unsigned int)sizeof(vmcoreinfo_note));
 }
 KERNEL_ATTR_RO(vmcoreinfo);
 
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

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

