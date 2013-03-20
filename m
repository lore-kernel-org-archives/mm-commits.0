From: akpm@linux-foundation.org
Subject: [nacked] vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch removed from -mm tree
Date: Wed, 20 Mar 2013 16:33:11 -0700
Message-ID: <20130320233311.7E3D031C1D3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50703 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab3CTXdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:33:13 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so211934qcs.5
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:33:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.hatayama@jp.fujitsu.com, ebiederm@xmission.com, vgoyal@redhat.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmcore: round-up offset of vmcore object in page-size boundary
has been removed from the -mm tree.  Its filename was
     vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: vmcore: round-up offset of vmcore object in page-size boundary

To satisfy mmap()'s page-size bounary requirement, round-up offset of each
vmcore objects in page-size boundary; each offset is connected to
user-space virtual address through mapping of mmap().

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN fs/proc/vmcore.c~vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~vmcore-round-up-offset-of-vmcore-object-in-page-size-boundary
+++ a/fs/proc/vmcore.c
@@ -698,7 +698,7 @@ static int __init process_ptload_program
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf64(char *elfptr,
+static void __init set_vmcore_list_offsets_elf64(char *elfptr, size_t elfsz,
 						struct list_head *vc_list)
 {
 	loff_t vmcore_off;
@@ -708,17 +708,16 @@ static void __init set_vmcore_list_offse
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
 	/* Skip Elf header and program headers. */
-	vmcore_off = ehdr_ptr->e_phoff +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr);
+	vmcore_off = elfsz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
-		vmcore_off += m->size;
+		vmcore_off += roundup(m->size, PAGE_SIZE);
 	}
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf32(char *elfptr,
+static void __init set_vmcore_list_offsets_elf32(char *elfptr, size_t elfsz,
 						struct list_head *vc_list)
 {
 	loff_t vmcore_off;
@@ -728,12 +727,11 @@ static void __init set_vmcore_list_offse
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
 	/* Skip Elf header and program headers. */
-	vmcore_off = ehdr_ptr->e_phoff +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr);
+	vmcore_off = elfsz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
-		vmcore_off += m->size;
+		vmcore_off += roundup(m->size, PAGE_SIZE);
 	}
 }
 
@@ -801,7 +799,7 @@ static int __init parse_crash_elf64_head
 			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
-	set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets_elf64(elfcorebuf, elfcorebuf_sz, &vmcore_list);
 	return 0;
 }
 
@@ -869,7 +867,7 @@ static int __init parse_crash_elf32_head
 			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
-	set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets_elf32(elfcorebuf, elfcorebuf_sz, &vmcore_list);
 	return 0;
 }
 
_

Patches currently in -mm which might be from d.hatayama@jp.fujitsu.com are

vmcore-count-holes-generated-by-round-up-operation-for-vmcore-size.patch
vmcore-introduce-mmap_vmcore.patch

