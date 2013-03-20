From: akpm@linux-foundation.org
Subject: [nacked] kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:53 -0700
Message-ID: <20130320233253.7C11831C1D3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:34135 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXcy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:54 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so211957qcr.2
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: allocate vmcoreinfo note buffer on page-size boundary
has been removed from the -mm tree.  Its filename was
     kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: kexec: allocate vmcoreinfo note buffer on page-size boundary

To satisfy mmap()'s page-size boundary requirement, specify aligned
attribute to vmcoreinfo_note objects to allocate it on page-size boundary.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    6 ++++--
 kernel/kexec.c        |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN include/linux/kexec.h~kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary include/linux/kexec.h
--- a/include/linux/kexec.h~kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary
+++ a/include/linux/kexec.h
@@ -185,8 +185,10 @@ extern struct kimage *kexec_crash_image;
 #define VMCOREINFO_BYTES           (4096)
 #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
 #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
-#define VMCOREINFO_NOTE_SIZE       (KEXEC_NOTE_HEAD_BYTES*2 + VMCOREINFO_BYTES \
-				    + VMCOREINFO_NOTE_NAME_BYTES)
+#define VMCOREINFO_NOTE_SIZE       ALIGN(KEXEC_NOTE_HEAD_BYTES*2	\
+					 +VMCOREINFO_BYTES		\
+					 +VMCOREINFO_NOTE_NAME_BYTES,	\
+					 PAGE_SIZE)
 
 /* Location of a reserved region to hold the crash kernel.
  */
diff -puN kernel/kexec.c~kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary kernel/kexec.c
--- a/kernel/kexec.c~kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary
+++ a/kernel/kexec.c
@@ -43,7 +43,7 @@ note_buf_t __percpu *crash_notes;
 
 /* vmcoreinfo stuff */
 static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
-u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4] __aligned(PAGE_SIZE);
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch
elf-introduce-nt_vmcore_pad-type.patch
kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch
vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

