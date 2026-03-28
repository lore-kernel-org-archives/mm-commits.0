Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46FD337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671972; cv=none; b=QFqBamwlnrp1FhjOWY3y5FZ+a9P9BAv+QFa5SQ9fvVziLXIwTzp0Mp00CO23t9GS7ubwYV7D4o9yrDDtHCNJBzTdB1M9zvZTFD489ExDoigTHXIJdiVPzJ5MD6HRSFTiVxOsJlYCRSZARszoxAMiCHcSyjLVz3G9Dpp/Pqoj+tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671972; c=relaxed/simple;
	bh=tWW7XZkX+zuWkVDY++HXoLaMtwoSQH9IZhJBzy7nJL0=;
	h=Date:To:From:Subject:Message-Id; b=iK1lhzWFk7HgI8dXpIRuqroBBXgqwARk8Z9r2BvWJL7hQ0CGe0xYRicItR0hs9iNHTlZHVvtDCzeRPl/geP4cfM1VFIxe33GJjpWDwN4lNuZVRBpIDPNQqO0sfsm2Bvq0MJ9iizcTGVuOkzlSeVSnuXrla0P9/XAq6dYuuEuyWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZBoR7WgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZBoR7WgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4D8C4CEF7;
	Sat, 28 Mar 2026 04:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671972;
	bh=tWW7XZkX+zuWkVDY++HXoLaMtwoSQH9IZhJBzy7nJL0=;
	h=Date:To:From:Subject:From;
	b=ZBoR7WgP7GiQ5FHtOd1+FWgmrPWsd2qiz+/PaoZ3XYIaPiIW7LcYjs705Vjp7TFcv
	 3MnFsix8P/IkoJMouZ1MB4G/4C6pvVf52SbwGLagDhQuXCt0skgWX8qSuMxp4GKaZN
	 l0NAZ+abqNM3fPBjCejyd7ledScVqpn3jmZBQHA0=
Date: Fri, 27 Mar 2026 21:26:12 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,danisjiang@gmail.com,moonafterrain@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-dlm-fix-off-by-one-in-dlm_match_regions-region-comparison.patch removed from -mm tree
Message-Id: <20260328042612.8D4D8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-fix-off-by-one-in-dlm_match_regions-region-comparison.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Junrui Luo <moonafterrain@outlook.com>
Subject: ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison
Date: Sat, 07 Mar 2026 15:21:09 +0800

The local-vs-remote region comparison loop uses '<=' instead of '<',
causing it to read one entry past the valid range of qr_regions.  The
other loops in the same function correctly use '<'.

Fix the loop condition to use '<' for consistency and correctness.

Link: https://lkml.kernel.org/r/SYBPR01MB78813DA26B50EC5E01F00566AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com
Fixes: ea2034416b54 ("ocfs2/dlm: Add message DLM_QUERY_REGION")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-fix-off-by-one-in-dlm_match_regions-region-comparison
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1002,7 +1002,7 @@ static int dlm_match_regions(struct dlm_
 	for (i = 0; i < localnr; ++i) {
 		foundit = 0;
 		r = remote;
-		for (j = 0; j <= qr->qr_numregions; ++j) {
+		for (j = 0; j < qr->qr_numregions; ++j) {
 			if (!memcmp(l, r, O2HB_MAX_REGION_NAME_LEN)) {
 				foundit = 1;
 				break;
_

Patches currently in -mm which might be from moonafterrain@outlook.com are


