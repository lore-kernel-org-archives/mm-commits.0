Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A49811F7
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104452; cv=none; b=PfQItAzefuaB75yaogrp96RDDKlgszbTtile/C1vo7mExvF4FdjJ9L+5EIEIdttkuds0pj1Qpm1wZnRKoVo7RZKpI/DwWqTJUar5nP0daodthVSXn9TTRZpF0/pduPcC+ZCUAz86hPH1A3wqll7ZAb1CSL/D2Z9t3LxT/e37xG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104452; c=relaxed/simple;
	bh=fAu3I/xkFe6aEbhu7njzwrzuBhA7//ZUKCNUYJEXols=;
	h=Date:To:From:Subject:Message-Id; b=s9BZiWi/EN48jhwHRFLFbP6Z5LmzaSkCHj6f7xcK6puBTVWgBdtmxCJ+GcCtS6RpdPx9Z6gOPatizwUCfZrWIOXfdhW2WeNh/XkAdzzY7hBlpBJOvuB6ZQBEoVMA5YCd/0+Pze5qgEcV3yAhVw5RGeR7ctQVvNgt6ZIlZtwg84E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kNKa2cS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kNKa2cS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C958C113CD;
	Fri, 26 Apr 2024 04:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104452;
	bh=fAu3I/xkFe6aEbhu7njzwrzuBhA7//ZUKCNUYJEXols=;
	h=Date:To:From:Subject:From;
	b=kNKa2cS4YWLRFtDNnCAkQTxT8ahTgAHmhmSmeUbItl61mp02CFc4eDny2VSsOyAEF
	 ypNf+1kCVzPEMGtQ9NxLIyAB+8EqjEDhvYsKny6M4QfKa4GPlg8558TPeQmQAIVq6P
	 ysHX65octF4UTHiBfnwsFYdQovdgcWsX9ok1+1LY=
Date: Thu, 25 Apr 2024 21:07:31 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-correctly-use-ocfs2_find_next_zero_bit.patch removed from -mm tree
Message-Id: <20240426040732.1C958C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: correctly use ocfs2_find_next_zero_bit()
has been removed from the -mm tree.  Its filename was
     ocfs2-correctly-use-ocfs2_find_next_zero_bit.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: correctly use ocfs2_find_next_zero_bit()
Date: Thu, 14 Mar 2024 10:17:13 +0800

If no bits are zero, ocfs2_find_next_zero_bit() will return max size, so
check the return value with -1 is meaningless.  Correct this usage and
cleanup the code.

Link: https://lkml.kernel.org/r/20240314021713.240796-1-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c   |   19 ++++++-------------
 fs/ocfs2/reservations.c |    2 +-
 fs/ocfs2/suballoc.c     |    6 ++----
 3 files changed, 9 insertions(+), 18 deletions(-)

--- a/fs/ocfs2/localalloc.c~ocfs2-correctly-use-ocfs2_find_next_zero_bit
+++ a/fs/ocfs2/localalloc.c
@@ -863,14 +863,8 @@ static int ocfs2_local_alloc_find_clear_
 
 	numfound = bitoff = startoff = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
-	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) != -1) {
-		if (bitoff == left) {
-			/* mlog(0, "bitoff (%d) == left", bitoff); */
-			break;
-		}
-		/* mlog(0, "Found a zero: bitoff = %d, startoff = %d, "
-		   "numfound = %d\n", bitoff, startoff, numfound);*/
-
+	while ((bitoff = ocfs2_find_next_zero_bit(bitmap, left, startoff)) <
+	       left) {
 		/* Ok, we found a zero bit... is it contig. or do we
 		 * start over?*/
 		if (bitoff == startoff) {
@@ -976,9 +970,9 @@ static int ocfs2_sync_local_to_main(stru
 	start = count = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start))
-	       != -1) {
-		if ((bit_off < left) && (bit_off == start)) {
+	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
+	       left) {
+		if (bit_off == start) {
 			count++;
 			start++;
 			continue;
@@ -1002,8 +996,7 @@ static int ocfs2_sync_local_to_main(stru
 				goto bail;
 			}
 		}
-		if (bit_off >= left)
-			break;
+
 		count = 1;
 		start = bit_off + 1;
 	}
--- a/fs/ocfs2/reservations.c~ocfs2-correctly-use-ocfs2_find_next_zero_bit
+++ a/fs/ocfs2/reservations.c
@@ -414,7 +414,7 @@ static int ocfs2_resmap_find_free_bits(s
 
 	start = search_start;
 	while ((offset = ocfs2_find_next_zero_bit(bitmap, resmap->m_bitmap_len,
-						 start)) != -1) {
+					start)) < resmap->m_bitmap_len) {
 		/* Search reached end of the region */
 		if (offset >= (search_start + search_len))
 			break;
--- a/fs/ocfs2/suballoc.c~ocfs2-correctly-use-ocfs2_find_next_zero_bit
+++ a/fs/ocfs2/suballoc.c
@@ -1290,10 +1290,8 @@ static int ocfs2_block_group_find_clear_
 	found = start = best_offset = best_size = 0;
 	bitmap = bg->bg_bitmap;
 
-	while((offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start)) != -1) {
-		if (offset == total_bits)
-			break;
-
+	while ((offset = ocfs2_find_next_zero_bit(bitmap, total_bits, start)) <
+	       total_bits) {
 		if (!ocfs2_test_bg_bit_allocatable(bg_bh, offset)) {
 			/* We found a zero, but we can't use it as it
 			 * hasn't been put to disk yet! */
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


