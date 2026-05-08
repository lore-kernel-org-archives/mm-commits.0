Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165021F91F6
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 18:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778265114; cv=none; b=Tr6NgEIWxTpr8vDU5+D4ZzYg4j7vCpYaTSyR9UEswx6kkn4ZLgUVtCmon7xOTXpjrCC8kyDMqYrjvppIwt/7tzsvCYtLxOaGPhLeA0tusKrMxMDhIQ8jkbg4VYF3saY+Ma2rD8sAR3dRKVyELGitRzih4+YPwGr1/jIOaGxR3oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778265114; c=relaxed/simple;
	bh=5SmV5KN468LdSs6IMNW3szjf6t+TC+Hz1F+pCCdBmKg=;
	h=Date:To:From:Subject:Message-Id; b=Kjc9wPEXsteZg32c1J0VJVjSpuEDA7J9obEqrRcQp9VUXKr6dnqdJK+8GxyTjSUtXgUbqCkpr7/x7d6fxmYMeHt9atapncLYTxYeLHzIz3yUDz3Hj3FgmELYq1u4ZwgbiiHDX2q+X4alo7bYoAnl3rBAm9PPZIq50G2lE2AUlK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xh/dWwg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xh/dWwg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A535EC2BCB0;
	Fri,  8 May 2026 18:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778265113;
	bh=5SmV5KN468LdSs6IMNW3szjf6t+TC+Hz1F+pCCdBmKg=;
	h=Date:To:From:Subject:From;
	b=Xh/dWwg2wLWL0P2xkiSbmkTYPBAeRh2L233hjGA7SK829Fbeyx4AEMQhYMplrd8wq
	 T7smLEnPQyxsIMZj1W2ieIvUrxek09QjkqmLutXDYC33a4JrGyPKWk1BvbZ+9CDhnt
	 vbVu+NlsfREtduNKhH7i6b6Edn8UuBbZSrNaS2t8=
Date: Fri, 08 May 2026 11:31:53 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-balloon-expose-per-node-balloon-pages-in-node-meminfo.patch added to mm-new branch
Message-Id: <20260508183153.A535EC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc/meminfo: expose per-node balloon pages in node meminfo
has been added to the -mm mm-new branch.  Its filename is
     mm-balloon-expose-per-node-balloon-pages-in-node-meminfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-balloon-expose-per-node-balloon-pages-in-node-meminfo.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hao Ge <hao.ge@linux.dev>
Subject: proc/meminfo: expose per-node balloon pages in node meminfo
Date: Fri, 8 May 2026 17:47:36 +0800

Commit 835de37603ef ("meminfo: add a per node counter for balloon
drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
However, the per-node view at /sys/devices/system/node/nodeX/meminfo
was not updated, even though the counter is already tracked per-node.

Add it to node_read_meminfo() so users can see balloon usage per
NUMA node without having to parse the raw vmstat file.

Link: https://lore.kernel.org/20260508094736.142467-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/base/node.c~mm-balloon-expose-per-node-balloon-pages-in-node-meminfo
+++ a/drivers/base/node.c
@@ -525,6 +525,7 @@ static ssize_t node_read_meminfo(struct
 #endif
 			     "Node %d GPUActive:      %8lu kB\n"
 			     "Node %d GPUReclaim:     %8lu kB\n"
+			     "Node %d Balloon:        %8lu kB\n"
 			     ,
 			     nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK)),
@@ -560,7 +561,8 @@ static ssize_t node_read_meminfo(struct
 #endif
 			     ,
 			     nid, K(node_page_state(pgdat, NR_GPU_ACTIVE)),
-			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM))
+			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM)),
+			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
 			    );
 	len += hugetlb_report_node_meminfo(buf, len, nid);
 	return len;
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-balloon-expose-per-node-balloon-pages-in-node-meminfo.patch

