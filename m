Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6402374C
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 20:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710795099; cv=none; b=ZDiWQ5wUKCChnQ1dVBKLANV5SN9wDuwI8qjfNiU3nvOYPtufYFe8Nx6HfvDx0o408JJAZXn3vD/8wna/xZN/onMR8o3ZQSdqQ43FPQGPwJYkri5nPx3mjbQi5bxLYXn/r4XJJ0uM52BoGuJwKzWF4fW61Vk8D4gLOy2ColTx0o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710795099; c=relaxed/simple;
	bh=EF0vd3Onoe796TwB0XCV7JyfKdvXx7hzsMWd5U0HyOg=;
	h=Date:To:From:Subject:Message-Id; b=a5/AEymAz8NCEHxcyaskjpvBPYl38xxxUc9BLIfQc7QSbqb0MC7MsgIVdDdOhjlHD+pwT6/Ke9atbl9xM5x5DmtEyR6weBnpgaE0utJuOnIk7fRjBwCFbX0Lf1wm6G1hc3WLITxEIq57BNWd2TflxAMvCLFVtcGT7oIUov3gTjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dySBLN+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dySBLN+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB479C433C7;
	Mon, 18 Mar 2024 20:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710795098;
	bh=EF0vd3Onoe796TwB0XCV7JyfKdvXx7hzsMWd5U0HyOg=;
	h=Date:To:From:Subject:From;
	b=dySBLN+3QPGY3TvDFTeVAtD/u8U9jkf+6O+ancYirsaxuLY28E7H+ieCjbL9OGN3n
	 EfT1XX8tjGJWg7NIuD9AsydyI91Y1ksa0YmnfYG0gP9WikAsE2qP0NFxcaKZF5+T3y
	 YJJV03vtYeNCY4kjR0yhZcyjdF4IHLl7Tw4b+esM=
Date: Mon, 18 Mar 2024 13:51:38 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,ghe@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-correctly-use-ocfs2_find_next_zero_bit.patch added to mm-nonmm-unstable branch
Message-Id: <20240318205138.DB479C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: correctly use ocfs2_find_next_zero_bit()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-correctly-use-ocfs2_find_next_zero_bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-correctly-use-ocfs2_find_next_zero_bit.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

ocfs2-correctly-use-ocfs2_find_next_zero_bit.patch

