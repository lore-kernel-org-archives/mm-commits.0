From: akpm@linux-foundation.org
Subject: [nacked] vmcore-procfs-introduce-a-flag-to-distinguish-objects-copied-in-2nd-kernel.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:35 -0700
Message-ID: <20130320233235.811B75A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:45816 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3CTXcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:36 -0400
Received: by mail-qe0-f74.google.com with SMTP id 9so211831qea.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore, procfs: introduce a flag to distinguish objects copied in 2nd kernel
has been removed from the -mm tree.  Its filename was
     vmcore-procfs-introduce-a-flag-to-distinguish-objects-copied-in-2nd-kernel.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore, procfs: introduce a flag to distinguish objects copied in 2nd kernel

The part of dump target memory is copied into the 2nd kernel if it doesn't
satisfy mmap()'s page-size boundary requirement.  To distinguish such
copied object from usual old memory, a flag MEM_TYPE_CURRENT_KERNEL is
introduced.  If this flag is set, the object is considered to have been
copied into a buffer on the 2nd kernel.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proc_fs.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/proc_fs.h~vmcore-procfs-introduce-a-flag-to-distinguish-objects-copied-in-2nd-kernel include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~vmcore-procfs-introduce-a-flag-to-distinguish-objects-copied-in-2nd-kernel
+++ a/include/linux/proc_fs.h
@@ -97,11 +97,17 @@ struct kcore_list {
 	int type;
 };
 
+#define MEM_TYPE_CURRENT_KERNEL 0x1
+
 struct vmcore {
 	struct list_head list;
-	unsigned long long paddr;
+	union {
+		unsigned long long paddr;
+		char *buf;
+	};
 	unsigned long long size;
 	loff_t offset;
+	unsigned int flag;
 };
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

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

