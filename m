Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B8D374E71;
	Wed, 17 Jun 2026 22:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735914; cv=none; b=jkMqIQi+YKwV2kTcthsHGIQDO61Vvq8xpo8dQZs2okWOKAu51euo1hKuCtyPfTAcqsx2dYg9okbhwbNpMtvzafprJjmUTs0ii+2yHP25yl/9GjReMJyBI62RLIRa4V4KH23z61Gp7gM+mChATEInnf3nPfZfLXxu5ng6FulAicI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735914; c=relaxed/simple;
	bh=miJMth9NyM2FROzcJJsAaeehqJACDVc+hdtB6GRIlWQ=;
	h=Date:To:From:Subject:Message-Id; b=RZP02ZFgXk+Gq3iDHDZ5+Y/ACv5HRvvLRuVqVhwn1L8kv8VaJb3Rt8bzZ2YXALjcY2T4/ATJdF07uA7x1G4R2ZcZ9hJ1GH9gTlxwTqBPDf4dwZEx5A9zqL8Iw51t5r/DLiDaK83wZ8rXgg264xgdh/IrNcQCMwBRUa+60CNcY5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sa1LncG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sa1LncG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0780B1F000E9;
	Wed, 17 Jun 2026 22:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781735913;
	bh=N5YX6geLgDWOznxn64/2ski9sMseXntQPNyd+iEC6QQ=;
	h=Date:To:From:Subject;
	b=Sa1LncG4FIsOKz+fXKPTx1rWVVsHm5CztgjDPth52A2oFmomLF6oi11MyJHyAtZ+6
	 yLNzZo53/Psk9Lpts1QZx8WCllAcAe3iFdKjd0RVJb3Q10dzKIB/FFEb1FR01jJrj6
	 o71fhUknaDew5AWdR7hu10vACvFO0mea0o06dGik=
Date: Wed, 17 Jun 2026 15:38:32 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,icb@fastmail.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-null-h_transaction-deref-in-ocfs2_assure_trans_credits.patch removed from -mm tree
Message-Id: <20260617223833.0780B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix NULL h_transaction deref in ocfs2_assure_trans_credits
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-h_transaction-deref-in-ocfs2_assure_trans_credits.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


