From: akpm@linux-foundation.org
Subject: [nacked] kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:56 -0700
Message-ID: <20130320233256.7BC9D5A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:45789 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:57 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so211430ves.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec, elf: introduce NT_VMCORE_DEBUGINFO note type
has been removed from the -mm tree.  Its filename was
     kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: kexec, elf: introduce NT_VMCORE_DEBUGINFO note type

This patch introduces NT_VMCORE_DEBUGINFO to a unique note type in
VMCOREINFO name, which has had no name so far.  The name means that it's a
kind of note type in vmcoreinfo that contains system kernel's debug
information.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/elf.h |    4 ++++
 kernel/kexec.c           |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/elf.h~kexec-elf-introduce-nt_vmcore_debuginfo-note-type include/uapi/linux/elf.h
--- a/include/uapi/linux/elf.h~kexec-elf-introduce-nt_vmcore_debuginfo-note-type
+++ a/include/uapi/linux/elf.h
@@ -398,6 +398,10 @@ typedef struct elf64_shdr {
 #define NT_METAG_CBUF	0x500		/* Metag catch buffer registers */
 #define NT_METAG_RPIPE	0x501		/* Metag read pipeline state */
 
+/*
+ * Notes exported from /proc/vmcore, belonging to "VMCOREINFO" name.
+ */
+#define NT_VMCORE_DEBUGINFO	0	/* vmcore system kernel's debuginfo */
 
 /* Note header in a PT_NOTE section */
 typedef struct elf32_note {
diff -puN kernel/kexec.c~kexec-elf-introduce-nt_vmcore_debuginfo-note-type kernel/kexec.c
--- a/kernel/kexec.c~kexec-elf-introduce-nt_vmcore_debuginfo-note-type
+++ a/kernel/kexec.c
@@ -1427,8 +1427,8 @@ static void update_vmcoreinfo_note(void)
 
 	if (!vmcoreinfo_size)
 		return;
-	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
-			      vmcoreinfo_size);
+	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, NT_VMCORE_DEBUGINFO,
+			      vmcoreinfo_data, vmcoreinfo_size);
 	final_note(buf);
 }
 
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

elf-introduce-nt_vmcore_pad-type.patch
kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch
vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

