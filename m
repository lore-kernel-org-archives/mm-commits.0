Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61512F855;
	Fri,  6 Dec 2024 01:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733448508; cv=none; b=I/gMreIpJ44AEkbajxbaSHzkMkreiFf3ERVNtHChdQmEMPEddh8ymYgXscwmGmb+VvmquUbIgsYvITfJPPc3WklZM4aGB7yCaReRX318bz9dzwluLnWfEV/1PvUcpEB9hMXcQRh+kzABJR5OgBhzzB1llzWR43xryTJzm9yDRvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733448508; c=relaxed/simple;
	bh=4GebgE312igrfJdU+68WgZze1ama2eem5kzWWBLxpgo=;
	h=Date:To:From:Subject:Message-Id; b=BI++XpSEtTMiiA15vw5O/6grAk+A/P5k3G+SnfeEghMmymDwgI/w1YJ+BAhAVrdmnrIVgjQWUNQLttfJ0+3huA4cYBIT4o/6pb9YfInF1Nx7sMDWLvTe+45fz9UK8hxl7ZFYVzlkuqKGeWykNeRs93yk17xbieWq7BDF09qoa8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hMe/4hkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hMe/4hkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A9EC4CED1;
	Fri,  6 Dec 2024 01:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733448508;
	bh=4GebgE312igrfJdU+68WgZze1ama2eem5kzWWBLxpgo=;
	h=Date:To:From:Subject:From;
	b=hMe/4hkXXCRdDU+of8mnKebsn4AabYOx0hQfcuXhipt39WIzXcV6LXS59b+KrLAzX
	 xE2f/cxyQKrDnAD01UjZzCMgRLmThc9DWbT2VPaapIrX7Myc7SBOR/BA+ZA578YW4d
	 wBlOR0YTNtT1KC+jGHnxIQxeR2ypB5jEQWBTvWvU=
Date: Thu, 05 Dec 2024 17:28:27 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-the-space-leak-in-la-when-releasing-la.patch added to mm-hotfixes-unstable branch
Message-Id: <20241206012828.20A9EC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix the space leak in LA when releasing LA
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-the-space-leak-in-la-when-releasing-la.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-the-space-leak-in-la-when-releasing-la.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix the space leak in LA when releasing LA
Date: Thu, 5 Dec 2024 18:48:33 +0800

Commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
introduced an issue, the ocfs2_sync_local_to_main() ignores the last
contiguous free bits, which causes an OCFS2 volume to lose the last free
clusters of LA window during the release routine.

Please note, because commit dfe6c5692fb5 ("ocfs2: fix the la space leak
when unmounting an ocfs2 volume") was reverted, this commit is a
replacement fix for commit dfe6c5692fb5.

Link: https://lkml.kernel.org/r/20241205104835.18223-3-heming.zhao@suse.com
Fixes: 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/localalloc.c~ocfs2-fix-the-space-leak-in-la-when-releasing-la
+++ a/fs/ocfs2/localalloc.c
@@ -971,9 +971,9 @@ static int ocfs2_sync_local_to_main(stru
 	start = count = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
-	       left) {
-		if (bit_off == start) {
+	while (1) {
+		bit_off = ocfs2_find_next_zero_bit(bitmap, left, start);
+		if ((bit_off < left) && (bit_off == start)) {
 			count++;
 			start++;
 			continue;
@@ -998,6 +998,8 @@ static int ocfs2_sync_local_to_main(stru
 			}
 		}
 
+		if (bit_off >= left)
+			break;
 		count = 1;
 		start = bit_off + 1;
 	}
_

Patches currently in -mm which might be from heming.zhao@suse.com are

ocfs2-revert-ocfs2-fix-the-la-space-leak-when-unmounting-an-ocfs2-volume.patch
ocfs2-fix-the-space-leak-in-la-when-releasing-la.patch

