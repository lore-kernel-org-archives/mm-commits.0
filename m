Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66BD81ACA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104466; cv=none; b=UrAatm6rL60/zxwej8BkxW+i/XPPWCF8LZzm5Vpur+h0en8dg+HHwditTJgiBRvTQFlunTGiUj7EEu49i/TRuDwju5ZxOdeDWAT7hCXcedwr91XD9lkqZv0RYpr4On+Qd7i/3uRqMSXDcyAm63vYs1dKs4SBB7KPzucAjpzl+p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104466; c=relaxed/simple;
	bh=yaGu55wobQ3dv1JM5O1mkfD5YTyUQctIDD4piEcX1pY=;
	h=Date:To:From:Subject:Message-Id; b=rOWJ8BYpRVAlTLZ+Q8vmQJ5801BI0/wd2j8XTQZtTudf7FeaY2rEjXPhgq7sfSkStqtpXRVGIVl6E0S1Ckgpe+tYgB3Dz9V8kwqUggMQgynXGAPLKfXGpNKlTicjOkLlBIgSdfW/x/2T7OeQCJckS7DuBKX3nxpceZU+Ak85CTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ii72Xwf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ii72Xwf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4505DC113CD;
	Fri, 26 Apr 2024 04:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104466;
	bh=yaGu55wobQ3dv1JM5O1mkfD5YTyUQctIDD4piEcX1pY=;
	h=Date:To:From:Subject:From;
	b=Ii72Xwf4Jpb2jDSfVQmdORn5q01Bn0Evw+JgjH2+hMghwJxq+yJBnSwuLQywivjXt
	 cxKim/skdlOfZguORd7nXBMT9Ph/HDyuDIN3JghgVT+ZBDjW4T91ac7Bud3i99dy/E
	 XfPljtmnpSLUJ08KlGQ2Ilcj1yHi6tkvl5dVKUYA=
Date: Thu, 25 Apr 2024 21:07:45 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-speed-up-chain-list-searching.patch removed from -mm tree
Message-Id: <20240426040746.4505DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: speed up chain-list searching
has been removed from the -mm tree.  Its filename was
     ocfs2-speed-up-chain-list-searching.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: speed up chain-list searching
Date: Thu, 28 Mar 2024 20:52:02 +0800

Add short-circuit code to speed up searching

Link: https://lkml.kernel.org/r/20240328125203.20892-4-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-speed-up-chain-list-searching
+++ a/fs/ocfs2/suballoc.c
@@ -2006,7 +2006,7 @@ static int ocfs2_claim_suballoc_bits(str
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
 		if (i == victim)
 			continue;
-		if (!cl->cl_recs[i].c_free)
+		if (le32_to_cpu(cl->cl_recs[i].c_free) < bits_wanted)
 			continue;
 
 		ac->ac_chain = i;
_

Patches currently in -mm which might be from heming.zhao@suse.com are


