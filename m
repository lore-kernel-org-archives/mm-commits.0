Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74B81C84D0;
	Mon, 15 Jun 2026 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781555608; cv=none; b=cxw47OC268o1nvFySPJe7YDqG/MB2iBd/1yDui4PXExljAbX5aFU8Sm5lGgpKlFUm5r1fXdctlxm/jmmrXozH3APyV+QQ43DxIoPYVgwsGq5uzRT20PabNzn7dRHeGilb1liecoASjA9106TZI+QGsmBbUcEhlvAoh4np50Gucc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781555608; c=relaxed/simple;
	bh=jt500s7MUtArMPZ/k5LIAYQukTNw0+26fQiIROkmkl0=;
	h=Date:To:From:Subject:Message-Id; b=DG0n4o2rrWahnmVJSmbkoEhkhKmdkCShyuIEAAnnQb7HmokjrFiglTPDmdmPVvNq/wOYyGZUtiVdMD1q0vo825Tl7LXK3jOcSicJWetLB6jKxDa7oBauqhifdR6B5vgOs/jPEt7yq9/bhnkjjZamjmGms6CzWRfBDXOGJEeny/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SskUi4Ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SskUi4Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E0D1F000E9;
	Mon, 15 Jun 2026 20:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781555607;
	bh=x8CxbOFJKvFn7+t5U5BKpm3qVzT6qZUhy9t6Ay5wFC8=;
	h=Date:To:From:Subject;
	b=SskUi4CkslzRZtsW9v9fQAvd9VQcy78y2UF03J0VWQtbJX3B+/mUTkYbnayxr7Rk7
	 KEkGFPuE+vcjgBzoQvcSreHTXYK2X8EVaClFp1CbSBK0tNJdGf9XGs2cegxBs12+rW
	 0rWkDRnp8e+hFk5t4VJss/rAyL1Aow5YDCeoGPHQ=
Date: Mon, 15 Jun 2026 13:33:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,icb@fastmail.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-null-h_transaction-deref-in-ocfs2_assure_trans_credits.patch added to mm-nonmm-unstable branch
Message-Id: <20260615203327.55E0D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix NULL h_transaction deref in ocfs2_assure_trans_credits
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-null-h_transaction-deref-in-ocfs2_assure_trans_credits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-null-h_transaction-deref-in-ocfs2_assure_trans_credits.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ian Bridges <icb@fastmail.org>
Subject: ocfs2: fix NULL h_transaction deref in ocfs2_assure_trans_credits
Date: Thu, 11 Jun 2026 09:46:38 -0500

[BUG]
A direct write over unwritten extents can panic the kernel in
ocfs2_assure_trans_credits() when the journal aborts during DIO
completion. The crash is a general protection fault from a NULL pointer
dereference.

[CAUSE]
ocfs2_dio_end_io_write() loops over a direct write's unwritten extents,
marking each written under a single journal handle. If the journal
aborts (for example after an I/O error) while the extent tree is being
updated, the handle is left aborted with its transaction pointer
cleared. The extent merge treats that failure as not critical and
reports success, so the loop keeps using the handle.
ocfs2_assure_trans_credits() reads the handle's remaining credits
without first checking whether the handle is aborted, and that read
dereferences the cleared transaction pointer.

[FIX]
A journal abort is recorded in the handle itself, so callers are
expected to test the handle rather than rely on a returned error.
Make ocfs2_assure_trans_credits() do that, as the other ocfs2 journal
helpers already do, and return -EROFS when the handle is aborted.

Link: https://lore.kernel.org/airKTsM1fRVN-Wj7@dev
Fixes: be346c1a6eeb ("ocfs2: fix DIO failure due to insufficient transaction credits")
Signed-off-by: Ian Bridges <icb@fastmail.org>
Reported-by: syzbot+e9c15ff790cea6a0cfae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e9c15ff790cea6a0cfae
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/journal.c~ocfs2-fix-null-h_transaction-deref-in-ocfs2_assure_trans_credits
+++ a/fs/ocfs2/journal.c
@@ -473,8 +473,12 @@ bail:
  */
 int ocfs2_assure_trans_credits(handle_t *handle, int nblocks)
 {
-	int old_nblks = jbd2_handle_buffer_credits(handle);
+	int old_nblks;
 
+	if (is_handle_aborted(handle))
+		return -EROFS;
+
+	old_nblks = jbd2_handle_buffer_credits(handle);
 	trace_ocfs2_assure_trans_credits(old_nblks);
 	if (old_nblks >= nblocks)
 		return 0;
_

Patches currently in -mm which might be from icb@fastmail.org are

ocfs2-fix-ubsan-array-index-out-of-bounds-in-ocfs2_sum_rightmost_rec.patch
ocfs2-fix-null-h_transaction-deref-in-ocfs2_assure_trans_credits.patch

