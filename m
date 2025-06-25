Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE661EA7EC
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 22:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892151; cv=none; b=TBTySLM+4WsfO1ABpXWM+d4+h7NHgyAo5U5j8UsdP++d/V830KXLi+76Fr1xWJESF9DBU+A52s2Y9l/yHNZrr5aMFzFJS1LK2jfhl3gtnwbxNcDfXDxdf1t1tc37i3cLwtBGa48hX0UpOddbB0PuWC0SSVrhIbe+3Dii2fFB7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892151; c=relaxed/simple;
	bh=d5CKOJR1H2MbKYbZENg5CNYjO3wgElbjFFd3f1Y5r6w=;
	h=Date:To:From:Subject:Message-Id; b=cyX+NWzDDM3TTdVAcA5KJyI63gdtqmmO7q+6RGAdEqkIlTHuJC88b18yayLjIcUCnkRw9WNLamQ1ghevP/rvcfppIqnVNKmDeU6tiFzhEtHrq28VgpUZ4Tw0CEeiJLx9GrY7oFJL+gojJxKZTyIbL2XJbgJznUZ8lzO3369AJBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vTVuk97T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vTVuk97T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3A1C4CEEA;
	Wed, 25 Jun 2025 22:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750892151;
	bh=d5CKOJR1H2MbKYbZENg5CNYjO3wgElbjFFd3f1Y5r6w=;
	h=Date:To:From:Subject:From;
	b=vTVuk97TCTHmvDF+sMxgDvJ8GX8RhnYvKym95B1TSi/dyuyZtm3XBHwy7roBx2ZsY
	 NHFpofzIxMZ1QHzdxLYRU8Aljt1f0thbWGBiO4o8yZiXfJj8HAHEMI0DRyrGdXLN90
	 Mg2/bNOGsrguRrrdZDOWJPeepOy+jp7JxRreH864=
Date: Wed, 25 Jun 2025 15:55:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-add-oom-killer-maintainer-structure.patch removed from -mm tree
Message-Id: <20250625225551.1F3A1C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add OOM killer maintainer structure
has been removed from the -mm tree.  Its filename was
     mm-add-oom-killer-maintainer-structure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: add OOM killer maintainer structure
Date: Tue, 17 Jun 2025 10:58:19 +0200

Add MAINTAINERS info for the oom-killer.

[akpm@linux-foundation.org: fix mhocko email address (SeongJae), add files (Lorenzo)]
[akpm@linux-foundation.org: fix ordering]
Link: https://lkml.kernel.org/r/20250617085819.355838-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/MAINTAINERS~mm-add-oom-killer-maintainer-structure
+++ a/MAINTAINERS
@@ -15848,6 +15848,17 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - OOM KILLER
+M:	Michal Hocko <mhocko@suse.com>
+R:	David Rientjes <rientjes@google.com>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/oom.h
+F:	include/trace/events/oom.h
+F:	include/uapi/linux/oom.h
+F:	mm/oom_kill.c
+
 MEMORY MANAGEMENT - PAGE ALLOCATOR
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
_

Patches currently in -mm which might be from mhocko@suse.com are


