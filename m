From: akpm@linux-foundation.org
Subject: [nacked] vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:41 -0700
Message-ID: <20130320233241.8098D31C1D3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51344 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXcm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:42 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so220349qaj.3
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: modify vmcore clean-up function to free buffer on 2nd kernel
has been removed from the -mm tree.  Its filename was
     vmcore-modify-vmcore-clean-up-function-to-free-buffer-on-2nd-kernel.patch

This patch was dropped because it was nacked

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

