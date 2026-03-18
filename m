Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A973E2D249B
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 19:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773861570; cv=none; b=LD+SRJTVKP3tWxjh3diiNbc4dtTjjO7mDoXapMmYMo6RhlMrvPZjob98CfTCPZgHnBQZaJG0j7Dg0XMqdb+qKkAb+h9utl3CqkoMiip7BeIsmSdTwVF1BIDFrxU5rEZ9p4kL6iFphcRYI0IpVXt54gLZB6eBpExNkWYft6C9HWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773861570; c=relaxed/simple;
	bh=vVHIKZSrRhoeiNZ/Gx9+ejzu7bqPvmc5fRdFrg/JBfs=;
	h=Date:To:From:Subject:Message-Id; b=bLf6uTXRKs0zK8HySCmuPJvr0RiLWtSNb+ORhfR2sgelZRUPzgVgRHEMifO1vcD72wWCwIfC7OKN2pKhmDr2dhKFv54z9m1r+JFwSJSWrHv2XVOmviU02l3r9kdgl3y3Gqeo1rlwgBA/+ljsgugpviy2ihJfgC2LkCWXaRLCaQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k3ggZPh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k3ggZPh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E85C2BCAF;
	Wed, 18 Mar 2026 19:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773861570;
	bh=vVHIKZSrRhoeiNZ/Gx9+ejzu7bqPvmc5fRdFrg/JBfs=;
	h=Date:To:From:Subject:From;
	b=k3ggZPh7+IbFw5ICbPc9RHqsOziq9ZIXhc5PTwJvEiNB0lcLzDs3j3XsDIvQJE4H9
	 4ZQX9pKgjvZnQrHvooFGfWnxj+ijyS4vZoKtAMy1I8zPtk96wxJqMJ4C4xb8cjgGQ8
	 afm9AUYYsJpPYh/GVLm6eVPCQlQe/fvFlaYIQCKQ=
Date: Wed, 18 Mar 2026 12:19:29 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,danisjiang@gmail.com,moonafterrain@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-dlm-validate-qr_numregions-in-dlm_match_regions.patch added to mm-nonmm-unstable branch
Message-Id: <20260318191930.46E85C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2/dlm: validate qr_numregions in dlm_match_regions()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dlm-validate-qr_numregions-in-dlm_match_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dlm-validate-qr_numregions-in-dlm_match_regions.patch

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

ocfs2-dlm-validate-qr_numregions-in-dlm_match_regions.patch
ocfs2-dlm-fix-off-by-one-in-dlm_match_regions-region-comparison.patch

