Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6D5B64E
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141615; cv=none; b=OkORnR/xI7wqNFiF5AdUYzSP6IQprmpVu4DKk1rVg9eGC5LCJ5LDXpotGQHbJYhBti2ZsD9aDvfzWO+rvhJ4v13zTTgIp2yF5RcZwGDHYIimVu7e8l5ylV2yU9S3OrnkdfB5pcJleSCg7uO+6zx4TGB7t7BmYJNU9hat0U3c7HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141615; c=relaxed/simple;
	bh=uH9LMQgwFxBfz3x3mE0wimEA1H9GK60JV4z7coiSoqY=;
	h=Date:To:From:Subject:Message-Id; b=QCXz0JUYCnAz6tZUWDK7vJjS/iJuPYZjbYgLlhz5dMDgFFpJWRH/DhqCnlpT/P0YA0gH6VECi8SZWgh1AJ58ofyas1nzp4yIIoWKGaDXssG039iI7aQR1uF+SdEt5eyGTkJ5QZ5pfmnoa655hy1aKh25wlau6+hMuItO2Y+NLEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Du/T29f1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Du/T29f1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66E1C3277B;
	Fri,  5 Jul 2024 01:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141614;
	bh=uH9LMQgwFxBfz3x3mE0wimEA1H9GK60JV4z7coiSoqY=;
	h=Date:To:From:Subject:From;
	b=Du/T29f1KFksBijVuFBeO5s2jV+nTR0m/Flp2sabaI1yMLJHtDpnKE0mv+m9DHoib
	 fQ8P9CN/qjAFI55st2OFEul83T7HP3rmgBLq/ixJtcpKtlOnt4+DMp4fVxVz7qkyzq
	 5HVlqha/TMSEzc3RfIpyYMuGgXtP9orEvTqOYjFI=
Date: Thu, 04 Jul 2024 18:06:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch removed from -mm tree
Message-Id: <20240705010654.D66E1C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mm/memcontrol-v1.c/h to the list of maintained files
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: MAINTAINERS: add mm/memcontrol-v1.c/h to the list of maintained files
Date: Mon, 24 Jun 2024 17:59:06 -0700

Link: https://lkml.kernel.org/r/20240625005906.106920-15-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files
+++ a/MAINTAINERS
@@ -5583,6 +5583,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/memcontrol.h
 F:	mm/memcontrol.c
+F:	mm/memcontrol-v1.c
+F:	mm/memcontrol-v1.h
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

