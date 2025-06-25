Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FDC2877FE
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891812; cv=none; b=ekQSLSyiURlgWnmTFotplvcSome93klAgC+PemVT4f9x7cl2knFZj8Y7cr9lY7u36+6p5qageKycDdiREkgMPCf9bTtKP4EXYGqe8MeVxuGenr3udGGFHY8mxZ+MCCtG0tu0qiJx8Zp4jyVIzoFogAcVoWDhBvnkbCMOlK4hVf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891812; c=relaxed/simple;
	bh=uw+8Gzk71NhJrHgFPuIDCkZbjPsV9u1bZxpF6TSyxww=;
	h=Date:To:From:Subject:Message-Id; b=Ts6Fckw3nh0p/ox87g91W0gIyqTWJh6LfcOSaiiUcoJYvFqop9vgY3itsq+KDYLVWwMgpOiIXSCBlXacIaSm0BwWod4Fp7eo35lAMtkF/kf3cjyi7cZueFs1f+m87U/XKrREj1ZPX2VxSzhkPoK3jASxDLfO3nLtooZDswupWBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RIkQFah4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RIkQFah4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FC1C4CEEA;
	Wed, 25 Jun 2025 22:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750891811;
	bh=uw+8Gzk71NhJrHgFPuIDCkZbjPsV9u1bZxpF6TSyxww=;
	h=Date:To:From:Subject:From;
	b=RIkQFah40ejj8OvQwBDuBYsyP2e5eBna0q73FryaxvFWlIMxIeDg876AHEOXJzsFS
	 RfVHQcbJj1xlPUc+NpbKCehUfv6CP+h/Isgu+WOi6msjiz8DwmuZ1tvO/rnEDb0FU8
	 y1nGWtVZoE+KsfQHYci7QE5HkL6TmfIAEKO/0/pg=
Date: Wed, 25 Jun 2025 15:50:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-oom-killer-maintainer-structure-fix.patch removed from -mm tree
Message-Id: <20250625225011.78FC1C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-oom-killer-maintainer-structure-fix
has been removed from the -mm tree.  Its filename was
     mm-add-oom-killer-maintainer-structure-fix.patch

This patch was dropped because it was folded into mm-add-oom-killer-maintainer-structure.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-oom-killer-maintainer-structure-fix
Date: Tue Jun 17 05:26:51 PM PDT 2025

fix mhocko email address (SeongJae), add files (Lorenzo)

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~mm-add-oom-killer-maintainer-structure-fix
+++ a/MAINTAINERS
@@ -15849,12 +15849,15 @@ F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
 MEMORY MANAGEMENT - OOM KILLER
-M:	Michal Hocko <mhocko@suse.com
+M:	Michal Hocko <mhocko@suse.com>
 R:	David Rientjes <rientjes@google.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/oom_kill.c
+F:	include/linux/oom.h
+F:	include/trace/events/oom.h
+F:	include/uapi/linux/oom.h
 
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
fix-do_pages_stat-to-use-compat_uptr_t-fix.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

