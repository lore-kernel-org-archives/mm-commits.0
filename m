Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFC4139E
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891814; cv=none; b=AT7ZrItwa+LK8d0PSH3M8QiApvx51c08k7FYYhT+9NyhervfU69PoGQl9KKxgm7KDEvnmLUYKpZV8auePk3n/gADT6Y7/nDVSPjtdx7JWBaI4FyLuoAj9eXscJUdPtqN8rqiBq2YlR5/Hagx3mJi9U6qs6synhL9QioW8Khl9Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891814; c=relaxed/simple;
	bh=KjK5EAVV78oAOw1tBcpCIqGrM3pH+v5FU+BvSQ1Ta5s=;
	h=Date:To:From:Subject:Message-Id; b=LTdVhV/lDRezdafTQz76Gmk6VFQcPBZz8GNFR84ltKdhIsNFtyK1mNRAmlu8IfYO/WQHMRRYVtzXaStpCoAONAufbRB/IczlS1o4c1MszJeW+uGTA9mdfccTCiHV583rqw3bIrxzl2veAwpV+B/DlMSCKFPW0zbimo9CaFYJRyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hW9C4R6l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hW9C4R6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ED9C4CEEA;
	Wed, 25 Jun 2025 22:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750891814;
	bh=KjK5EAVV78oAOw1tBcpCIqGrM3pH+v5FU+BvSQ1Ta5s=;
	h=Date:To:From:Subject:From;
	b=hW9C4R6l87VoaH+oJw/sGltNFmoYE16zE271c3Ahcxt2jHVCl7o37ohT05zwHIWi8
	 NzilhWc59Rx8UzT1bvtubVVIZxATzylYDe36Idv/l5IC3D9JRM6yDOL9Sl2GnP6/H0
	 0jKsX5iNEiGyvs32JxeC7FcnpBiYb1EgzybZwyU0=
Date: Wed, 25 Jun 2025 15:50:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20250625225014.16ED9C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-add-oom-killer-maintainer-structure.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes
Date: Tue Jun 17 06:15:31 PM PDT 2025

WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#32: FILE: MAINTAINERS:15860:
 F:	mm/oom_kill.c
+F:	include/linux/oom.h

Cc: David Rientjes <rientjes@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes
+++ a/MAINTAINERS
@@ -15854,10 +15854,10 @@ R:	David Rientjes <rientjes@google.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
-F:	mm/oom_kill.c
 F:	include/linux/oom.h
 F:	include/trace/events/oom.h
 F:	include/uapi/linux/oom.h
+F:	mm/oom_kill.c
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure.patch
fix-do_pages_stat-to-use-compat_uptr_t-fix.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

