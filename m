Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1402D249B
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 19:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773861572; cv=none; b=AfVBbgvY5+nzvmO7o6i7F0urHPRIlN68RCB/NPYM/J7D7vVX+GOOYmJu7c6YD5aAUSC7XimYKr5FQi/H5M6k9CI32DMJdnQKuMeykCD3+zYWLXA292l4JqljtQOM1LkHKFy9hrqjJsTcsrcyKfp+d9WuOooCoyLSkw3B9FX2bGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773861572; c=relaxed/simple;
	bh=WVltqzLD9NSDxb4yW6GEEHyJHox+z3D6r16wDV60DU4=;
	h=Date:To:From:Subject:Message-Id; b=V/hkspJHtYuvHcaPSqb394zqoXCYvxSbuONYN7D8z+TTl3aiCYsi+/PV5xwuBRr1lGU2pA70CTS3hdXJDFt/49baYwRXEeMcdV+lgr2QNkSla1ss9gUVJdRjYTCimYW4r0wPXX+6ipVYuHXBS78XhGlzd75NTkhWFzyooJYCKEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vpzYyhAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vpzYyhAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB94C2BCB1;
	Wed, 18 Mar 2026 19:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773861572;
	bh=WVltqzLD9NSDxb4yW6GEEHyJHox+z3D6r16wDV60DU4=;
	h=Date:To:From:Subject:From;
	b=vpzYyhArf2h9z831KQxEoViwt2fZetTLITwwvu9XDZEq4RUHvjYARmLZCZkpFcKWe
	 zeyS/p3TL+SnmEwK6hwrMVU5H/leOMWtTESwLwmn/8jBEtkjpuvqCedQStXBxcZEIC
	 y2lCsurzgZE97dst+D9margA285LpeqYkQS2xrEA=
Date: Wed, 18 Mar 2026 12:19:31 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,danisjiang@gmail.com,moonafterrain@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-dlm-fix-off-by-one-in-dlm_match_regions-region-comparison.patch added to mm-nonmm-unstable branch
Message-Id: <20260318191932.7BB94C2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-dlm-fix-off-by-one-in-dlm_match_regions-region-comparison.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-dlm-fix-off-by-one-in-dlm_match_regions-region-comparison.patch

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

ocfs2-dlm-validate-qr_numregions-in-dlm_match_regions.patch
ocfs2-dlm-fix-off-by-one-in-dlm_match_regions-region-comparison.patch

