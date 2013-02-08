From: akpm@linux-foundation.org
Subject: + fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch added to -mm tree
Date: Thu, 07 Feb 2013 16:09:08 -0800
Message-ID: <20130208000909.7153B1CA088@corp2gmr1-1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:37001 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3BHAJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 19:09:11 -0500
Received: by mail-ea0-f201.google.com with SMTP id l13so214466eaa.0
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 16:09:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: fs/proc/vmcore.c: put if tests in the top of the while loop to reduce duplication
has been added to the -mm tree.  Its filename is
     fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: fs/proc/vmcore.c: put if tests in the top of the while loop to reduce duplication

In read_vmcore() two `if' tests are duplicated.  Change the position of
them could reduce the duplication.  This change does not affect the
behaviour of the function.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication
+++ a/fs/proc/vmcore.c
@@ -176,15 +176,16 @@ static ssize_t read_vmcore(struct file *
 	start = map_offset_to_paddr(*fpos, &vmcore_list, &curr_m);
 	if (!curr_m)
         	return -EINVAL;
-	if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
-		tsz = buflen;
-
-	/* Calculate left bytes in current memory segment. */
-	nr_bytes = (curr_m->size - (start - curr_m->paddr));
-	if (tsz > nr_bytes)
-		tsz = nr_bytes;
 
 	while (buflen) {
+		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
+			tsz = buflen;
+
+		/* Calculate left bytes in current memory segment. */
+		nr_bytes = (curr_m->size - (start - curr_m->paddr));
+		if (tsz > nr_bytes)
+			tsz = nr_bytes;
+
 		tmp = read_from_oldmem(buffer, tsz, &start, 1);
 		if (tmp < 0)
 			return tmp;
@@ -199,12 +200,6 @@ static ssize_t read_vmcore(struct file *
 						struct vmcore, list);
 			start = curr_m->paddr;
 		}
-		if ((tsz = (PAGE_SIZE - (start & ~PAGE_MASK))) > buflen)
-			tsz = buflen;
-		/* Calculate left bytes in current memory segment. */
-		nr_bytes = (curr_m->size - (start - curr_m->paddr));
-		if (tsz > nr_bytes)
-			tsz = nr_bytes;
 	}
 	return acc;
 }
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

