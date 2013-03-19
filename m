From: akpm@linux-foundation.org
Subject: + elf-introduce-nt_vmcore_pad-type.patch added to -mm tree
Date: Tue, 19 Mar 2013 13:03:12 -0700
Message-ID: <20130319200312.D3B075A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:59426 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3CSUDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Mar 2013 16:03:14 -0400
Received: by mail-qa0-f73.google.com with SMTP id g10so93890qah.2
        for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2013 13:03:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: elf: introduce NT_VMCORE_PAD type
has been added to the -mm tree.  Its filename is
     elf-introduce-nt_vmcore_pad-type.patch

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
Subject: elf: introduce NT_VMCORE_PAD type

The NT_VMCORE_PAD type is introduced to make both crash_notes buffer and
vmcoreinfo_note buffer satisfy mmap()'s page-size boundary requirement by
filling them with this note type.

The purpose of this type is just to align the buffer in page-size
boundary; it has no meaning in contents, which are fully filled with zero.

This note type belongs to "VMCOREINFO" name space and the type in this
name space is 7.  The reason why the numbers from 1 to 5 is not chosen is
that for the ones from 1 to 4, there are the corresponding note types
using the same number in "CORE" name space, and crash utility and
makedumpfile don't distinguish note types by name space at all; for the
remaining 5, this has somehow not been used since v2.4.0 kernel despite
the fact that NT_AUXV is defined as 6.  It looks that it avoids some
dependency to 5.  Here simply 5 is not chosen for conservative viewpoint.

By this change, gdb and binutils work well without any change, but
makedumpfile and crash utility need their changes to distinguish two note
types in "VMCOREINFO" name space.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/elf.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/uapi/linux/elf.h~elf-introduce-nt_vmcore_pad-type include/uapi/linux/elf.h
--- a/include/uapi/linux/elf.h~elf-introduce-nt_vmcore_pad-type
+++ a/include/uapi/linux/elf.h
@@ -402,6 +402,7 @@ typedef struct elf64_shdr {
  * Notes exported from /proc/vmcore, belonging to "VMCOREINFO" name.
  */
 #define NT_VMCORE_DEBUGINFO	0	/* vmcore system kernel's debuginfo */
+#define NT_VMCORE_PAD		7	/* vmcore padding of note segments */
 
 /* Note header in a PT_NOTE section */
 typedef struct elf32_note {
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

