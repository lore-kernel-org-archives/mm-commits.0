Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5EB3815DF
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896777; cv=none; b=DM/jVmn9Q4g+vsOAn+Enp/XqWGqyhpXmDAMvTc/PbcbdHGLp49NueZS1L7lLqD3mJt/wBNPhkX/67p7XEu9HeItx0dWzq2H3ALHUE+Gv45Qee0tef0MNPllt2JGSwVZUONhFaR4usKod2gmvFhpCYR7m7Nfv2Gt5A16JFHKRt3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896777; c=relaxed/simple;
	bh=Jg4PNU288rL8i7WkJ4rsBfqyjSWuvaq+EhCKDuNCsX0=;
	h=Date:To:From:Subject:Message-Id; b=a+4P+5q/ixFwgPebGf1zUwNimf4WgGjDiiz70wPSjMasrG478HLzxKNrxrkaQO2l1lcVHbfH3VW3Ash8B1lh6Kl8cjyxaLQ4bgVU+SFJsdMWFvXFU+qVuTBDv+emDqCR5/2Ykcq7h8aAGANiCVxHjwgLTFFyM4XQWHAeFGHSqcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xcJxYe3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xcJxYe3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896CEC4CEF1;
	Sat, 31 Jan 2026 21:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896776;
	bh=Jg4PNU288rL8i7WkJ4rsBfqyjSWuvaq+EhCKDuNCsX0=;
	h=Date:To:From:Subject:From;
	b=xcJxYe3wtoc21gDeNeZkqmafqe7vk6R6WDqUHJlb0ua+MWOIi8P5+rKD9yf0sNRYT
	 JzQWUs7Yt5zz5Gw5xuk2px4jt028CCAyoYCO4CK/4BiMWVegapgKsMj6RpBKvUTkKJ
	 GR2V6N3McbL94c2PvCZ88egOmkolO0YTVK0PV+lI=
Date: Sat, 31 Jan 2026 13:59:35 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,Liam.Howlett@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch removed from -mm tree
Message-Id: <20260131215936.896CEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-relocate-the-page-table-ceiling-and-floor-definitions-fix
has been removed from the -mm tree.  Its filename was
     mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch

This patch was dropped because it was folded into mm-relocate-the-page-table-ceiling-and-floor-definitions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-relocate-the-page-table-ceiling-and-floor-definitions-fix
Date: Wed Jan 21 10:58:00 AM PST 2026

remove stray newline, per SeongJae

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/pgtable.h~mm-relocate-the-page-table-ceiling-and-floor-definitions-fix
+++ a/include/linux/pgtable.h
@@ -1629,7 +1629,6 @@ void arch_sync_kernel_mappings(unsigned
 #define FIRST_USER_ADDRESS	0UL
 #endif
 
-
 /*
  * No-op macros that just return the current protection value. Defined here
  * because these macros can be used even if CONFIG_MMU is not defined.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

