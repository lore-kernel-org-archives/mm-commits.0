From: akpm@linux-foundation.org
Subject: [nacked] vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundary.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:32:50 -0700
Message-ID: <20130320233250.806385A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50230 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3CTXcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:32:51 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so211903vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:32:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: allocate per-cpu crash_notes objects on page-size boundary
has been removed from the -mm tree.  Its filename was
     vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundary.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: allocate per-cpu crash_notes objects on page-size boundary

To satisfy mmap()'s page-size boundary requirement, allocate per-cpu
crash_notes objects on page-size boundary.

/proc/vmcore on the 2nd kernel checks if each note objects is allocated on
page-size boundary.  If there's some object not satisfying the page-size
boundary requirement, /proc/vmcore doesn't provide mmap() interface.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kexec.c~vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundary kernel/kexec.c
--- a/kernel/kexec.c~vmcore-allocate-per-cpu-crash_notes-objects-on-page-size-boundary
+++ a/kernel/kexec.c
@@ -1223,7 +1223,8 @@ void crash_save_cpu(struct pt_regs *regs
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
-	crash_notes = alloc_percpu(note_buf_t);
+	crash_notes = __alloc_percpu(roundup(sizeof(note_buf_t), PAGE_SIZE),
+				     PAGE_SIZE);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

kexec-allocate-vmcoreinfo-note-buffer-on-page-size-boundary.patch
kexec-elf-introduce-nt_vmcore_debuginfo-note-type.patch
elf-introduce-nt_vmcore_pad-type.patch
kexec-fill-note-buffers-by-nt_vmcore_pad-notes-in-page-size-boundary.patch
vmcore-check-nt_vmcore_pad-as-a-mark-indicating-the-end-of-elf-note-buffer.patch
vmcore-check-if-vmcore-objects-satify-mmaps-page-size-boundary-requirement.patch
vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch
vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

