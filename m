Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72C31C5F2F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274614; cv=none; b=KHJOZnHlB2cww4ElvmbglnSYuNLNys5inPCh6eDS4lcTUBVopbOw6lT80H9Q2z5HAcMxilawtq6+lhponJ0QA6G77Dqwe///OFAPmANQAvX1veUisREWFwh79uWxhYhIaD3K/fZJdkhL9rBj0RPFkZhT4C17t/3XmkOmJyo+/Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274614; c=relaxed/simple;
	bh=r8Eapo0MH10hFKlcNubgEuKJnfmJSL6TRH0Os/38CMk=;
	h=Date:To:From:Subject:Message-Id; b=XkJnUbxL0+CYnXOYb5c5vWIJG+rSnSPJPIcXjEMnhy7zM39eQSIP61c2Un/zo4IEEkLxRbN0xyzRFSA1wvFycj3Ap6leDWbkyKVMb3bR6ubWLIvY34eIBR8aoNlrmrOMkgZ5q6PxOSlwY2PZfoXOEWWCkD8SukNvVfDKI1R/8tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1Gy5vvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1Gy5vvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A14BC4CEDD;
	Tue, 18 Mar 2025 05:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274614;
	bh=r8Eapo0MH10hFKlcNubgEuKJnfmJSL6TRH0Os/38CMk=;
	h=Date:To:From:Subject:From;
	b=t1Gy5vvlUSMPTEjoK8YuuKfrZtKIkPwH4KD1l0ztVdPszbbfeLDvJrDvu8DzMqHbb
	 e5jyl8lwcaZxX0iHtKrKAlWpmuBeqSyorMeO3U/12UPaET2vE1Ilh37UFsAfusw+VJ
	 vHVI5JDFeQ9u7oKECIE9z/1RBxQI1A6JkhwnOIGQ=
Date: Mon, 17 Mar 2025 22:10:14 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kasong@tencent.com,chrisl@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap_cgroup-remove-double-initialization-of-locals.patch removed from -mm tree
Message-Id: <20250318051014.9A14BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap_cgroup: remove double initialization of locals
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-remove-double-initialization-of-locals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: swap_cgroup: remove double initialization of locals
Date: Thu, 6 Mar 2025 09:31:42 -0500

Fixes: 6769183166b3 ("mm/swap_cgroup: decouple swap cgroup recording and clearing")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap_cgroup.c~mm-swap_cgroup-remove-double-initialization-of-locals
+++ a/mm/swap_cgroup.c
@@ -92,8 +92,7 @@ void swap_cgroup_record(struct folio *fo
  */
 unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
 {
-	pgoff_t offset = swp_offset(ent);
-	pgoff_t end = offset + nr_ents;
+	pgoff_t offset, end;
 	struct swap_cgroup *map;
 	unsigned short old, iter = 0;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


