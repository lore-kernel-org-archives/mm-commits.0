From: akpm@linux-foundation.org
Subject: [merged] fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:46 -0800
Message-ID: <20130228201146.CA27B5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:51501 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:47 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so244618vea.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/vmcore.c: put if tests in the top of the while loop to reduce duplication
has been removed from the -mm tree.  Its filename was
     fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: fs/proc/vmcore.c: put if tests in the top of the while loop to reduce duplication

In read_vmcore() two `if' tests are duplicated.  Change the position of
them could reduce the duplication.  This change does not affect the
behaviour of the function.

[akpm@linux-foundation.org: avoid `if (foo = bar)' thing, use min_t()]
[akpm@linux-foundation.org: s/max_t/min_t/]
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication
+++ a/fs/proc/vmcore.c
@@ -176,15 +176,15 @@ static ssize_t read_vmcore(struct file *
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
+		tsz = min_t(size_t, buflen, PAGE_SIZE - (start & ~PAGE_MASK));
+
+		/* Calculate left bytes in current memory segment. */
+		nr_bytes = (curr_m->size - (start - curr_m->paddr));
+		if (tsz > nr_bytes)
+			tsz = nr_bytes;
+
 		tmp = read_from_oldmem(buffer, tsz, &start, 1);
 		if (tmp < 0)
 			return tmp;
@@ -199,12 +199,6 @@ static ssize_t read_vmcore(struct file *
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

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

