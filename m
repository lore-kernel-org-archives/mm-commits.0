Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F74337BB0
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671971; cv=none; b=tZVjA+E/CWGdyDaOkYIvkICi+zNiIRr2PRKtKZQrYgLBJPVxwWVubxAXP/NQ+Ri4cV4ZfTTq1zj++urYrQU2A4Vpd0XxORYPrs18v1xgXEPcKR7YO0TglN8GstXg59FYT12wEpZI0FfR4FmBruCckAuMWCsZtz3lE/NNjI459zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671971; c=relaxed/simple;
	bh=LmfqpyLlcUsojkuZmouvf+GO7KpxZRnkNpN2nbypKFM=;
	h=Date:To:From:Subject:Message-Id; b=bcNgPamwSQTAQ1Z3jmodwC/FuzJyZCJ1EL6E4Tpq4cnKucNpwVTsBQqMqBlz2nZYdzIsnrAvB/0tpDRHYZTlS1GMjuP0Qcir0cyFyXcf9V2wbA6N0FAIHBqX05fD4pmxiuciYmbCcFw8vm+Hk6QxS49faoadYNXGzjwVPyjnnXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uEECWVLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uEECWVLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF73C4CEF7;
	Sat, 28 Mar 2026 04:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671971;
	bh=LmfqpyLlcUsojkuZmouvf+GO7KpxZRnkNpN2nbypKFM=;
	h=Date:To:From:Subject:From;
	b=uEECWVLHtfbwHlbBykoPsOq0/CVAPyILalnH7CzeUZ1JxDZqNDKoxDFi1BBO2j4Qx
	 8Do+dbNOVvPFvW3gYUlg7I6dlqbKiovNgY9wV6GHM20zzciw9LCPBl9tWwJd4YbCmc
	 M830r3Qtqk6EdcFW3qYpIeRHmqBjXoq920EHHCbI=
Date: Fri, 27 Mar 2026 21:26:10 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,danisjiang@gmail.com,moonafterrain@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-dlm-validate-qr_numregions-in-dlm_match_regions.patch removed from -mm tree
Message-Id: <20260328042611.5DF73C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2/dlm: validate qr_numregions in dlm_match_regions()
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-validate-qr_numregions-in-dlm_match_regions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Junrui Luo <moonafterrain@outlook.com>
Subject: ocfs2/dlm: validate qr_numregions in dlm_match_regions()
Date: Sat, 07 Mar 2026 15:21:08 +0800

Patch series "ocfs2/dlm: fix two bugs in dlm_match_regions()".

In dlm_match_regions(), the qr_numregions field from a DLM_QUERY_REGION
network message is used to drive loops over the qr_regions buffer without
sufficient validation.  This series fixes two issues:

- Patch 1 adds a bounds check to reject messages where qr_numregions
  exceeds O2NM_MAX_REGIONS. The o2net layer only validates message
  byte length; it does not constrain field values, so a crafted message
  can set qr_numregions up to 255 and trigger out-of-bounds reads past
  the 1024-byte qr_regions buffer.

- Patch 2 fixes an off-by-one in the local-vs-remote comparison loop,
  which uses '<=' instead of '<', reading one entry past the valid range
  even when qr_numregions is within bounds.


This patch (of 2):

The qr_numregions field from a DLM_QUERY_REGION network message is used
directly as loop bounds in dlm_match_regions() without checking against
O2NM_MAX_REGIONS.  Since qr_regions is sized for at most O2NM_MAX_REGIONS
(32) entries, a crafted message with qr_numregions > 32 causes
out-of-bounds reads past the qr_regions buffer.

Add a bounds check for qr_numregions before entering the loops.

Link: https://lkml.kernel.org/r/SYBPR01MB7881A334D02ACEE5E0645801AF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com
Link: https://lkml.kernel.org/r/SYBPR01MB788166F524AD04E262E174BEAF7BA@SYBPR01MB7881.ausprd01.prod.outlook.com
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

 fs/ocfs2/dlm/dlmdomain.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-validate-qr_numregions-in-dlm_match_regions
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -980,6 +980,14 @@ static int dlm_match_regions(struct dlm_
 		goto bail;
 	}
 
+	if (qr->qr_numregions > O2NM_MAX_REGIONS) {
+		mlog(ML_ERROR, "Domain %s: Joining node %d has invalid "
+		     "number of heartbeat regions %u\n",
+		     qr->qr_domain, qr->qr_node, qr->qr_numregions);
+		status = -EINVAL;
+		goto bail;
+	}
+
 	r = remote;
 	for (i = 0; i < qr->qr_numregions; ++i) {
 		mlog(0, "Region %.*s\n", O2HB_MAX_REGION_NAME_LEN, r);
_

Patches currently in -mm which might be from moonafterrain@outlook.com are


