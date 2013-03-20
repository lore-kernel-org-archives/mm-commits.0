From: akpm@linux-foundation.org
Subject: [nacked] elf-introduce-nt_vmcore_pad-type.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:59 -0700
Message-ID: <20130320233259.82CA131C1D3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:43522 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:33:00 -0400
Received: by mail-gg0-f202.google.com with SMTP id l4so211472ggi.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:33:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: elf: introduce NT_VMCORE_PAD type
has been removed from the -mm tree.  Its filename was
     elf-introduce-nt_vmcore_pad-type.patch

This patch was dropped because it was nacked

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

kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch
vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

