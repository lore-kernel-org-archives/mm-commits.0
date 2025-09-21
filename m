Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E2B27281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490015; cv=none; b=CBS2sA1ZSV33V5udHye5gi8arEwB/Dhu+zZQrwPBCv98HHf0ZbMN0J+CNvIU5bccDMh970OVi3s8vqOGTgK8EOyQuK14H8+ovzYnrK6pr13VsIMMOkK6UJgOaaHwSq5PQqS++95Yse2uRaWscT5YmeNxzALDKqQeichVyZTYhJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490015; c=relaxed/simple;
	bh=/vTPEj9dg1QjQ7A6BOQRxONNNhLSBdeP5GysYWTBGtk=;
	h=Date:To:From:Subject:Message-Id; b=AHL6/5kj2oD3WMv2OWdkZcpsbUOo7R0yep5+VJ03SoUmuSXjygXj+S7Wcy8iuf8V1syN+WWf9c0Dt+43UuxqKoAzLfVJ+2ojnhaBYp7S+MBGPFiswCMYMuZZ8WI3CfAaVwQ54fO4Fm0os/HxS5l531iq24rRyZ0d5c3aovegMTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UANLc5Bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UANLc5Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29555C4CEE7;
	Sun, 21 Sep 2025 21:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490015;
	bh=/vTPEj9dg1QjQ7A6BOQRxONNNhLSBdeP5GysYWTBGtk=;
	h=Date:To:From:Subject:From;
	b=UANLc5Bul3YWma08hGRq2RI+uVSmDVQt5ufhuKLnraWC4QEeiSXkhtLDWdzcRda/l
	 seTwDU7NYu8PTqUfUIEAs2KICSV8jGIqHD1YlALkCyMUkLRRrrpnkMlISSPY9WqMZb
	 UrJJ2S+mfXCaUFnjD36nljIHc6bMbXaTeSGUEEKg=
Date: Sun, 21 Sep 2025 14:26:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-set-effective-quota-on-first-charge-window.patch removed from -mm tree
Message-Id: <20250921212655.29555C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: set effective quota on first charge window
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-effective-quota-on-first-charge-window.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: set effective quota on first charge window
Date: Mon, 15 Sep 2025 20:23:36 -0700

The effective quota of a scheme is initialized zero, which means there is
no quota.  It is set based on user-specified time/quota/quota goals.  But
the later value set is done only from the second charge window.  As a
result, a scheme having a user-specified quota can work as not having the
quota (unexpectedly fast) for the first charge window.  In practical and
common use cases the quota interval is not too long, and the scheme's
target access pattern is restrictive.  Hence the issue should be modest. 
That said, it is apparently an unintended misbehavior.  Fix the problem by
setting esz on the first charge window.

Link: https://lkml.kernel.org/r/20250916032339.115817-3-sj@kernel.org
Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota") # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-set-effective-quota-on-first-charge-window
+++ a/mm/damon/core.c
@@ -2142,8 +2142,10 @@ static void damos_adjust_quota(struct da
 		return;
 
 	/* First charge window */
-	if (!quota->total_charged_sz && !quota->charged_from)
+	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
+		damos_set_effective_quota(quota);
+	}
 
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

