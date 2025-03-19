Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511918F5B
	for <mm-commits@vger.kernel.org>; Wed, 19 Mar 2025 02:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742351138; cv=none; b=NwXu9boxAhzQQTL8yTm2ekBd1X6lgOWXHbVneg59o3t/PLD3pEYD9LDjehEm0AyvKzKlND0nSh8lCXc5dY4hKlQNCNJH3GUqB4CRP/VpbhMIj3xSU27ca3KYJVEA4qkEExd3DGvUOxCyt+nkaDRpiEooYhDAk3QckH8ll7hn2nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742351138; c=relaxed/simple;
	bh=zKjW/sEXwOxSMbOvaFOb8OR79V02LjW5ee7krj9vJN8=;
	h=Date:To:From:Subject:Message-Id; b=ORu4dqQqd070GQ3uLWeFf58RlDSs0angsn4xYu2l0ORYYxlKqigr0vAj8Q5Al4UbxLefhxnN02+mCQcIIIPMVVvrumzHEh/FsIp8J8dNkl1JaKh2rS0+7k4HfO3HqmxCvEAVN37N+YUpBpjmBpNj1ua3MnrOEq0Sfi/Z/NuaOi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tL2e8oa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tL2e8oa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF163C4CEDD;
	Wed, 19 Mar 2025 02:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742351137;
	bh=zKjW/sEXwOxSMbOvaFOb8OR79V02LjW5ee7krj9vJN8=;
	h=Date:To:From:Subject:From;
	b=tL2e8oa1wsbli+ueyE0v7L0HHHDq73gJbOmuJUwWasNkH4RXR85+ja0azpdaKVR4C
	 YdQjGn8heiWD4xZao6gppyO7iSjDr2XgQYQ38LPdm3fP81XlKYv1H103b9K2CO9QND
	 JQhkLtjJ8aiqHlHTmQ9U+keuIi40JcfOKLtyu5Ug=
Date: Tue, 18 Mar 2025 19:25:37 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,corbet@lwn.net,jiahao1@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cgroup-docs-add-pswpin-and-pswpout-items-in-cgroup-v2-doc.patch added to mm-unstable branch
Message-Id: <20250319022537.AF163C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cgroup: docs: add pswpin and pswpout items in cgroup v2 doc
has been added to the -mm mm-unstable branch.  Its filename is
     cgroup-docs-add-pswpin-and-pswpout-items-in-cgroup-v2-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cgroup-docs-add-pswpin-and-pswpout-items-in-cgroup-v2-doc.patch

This patch will later appear in the mm-unstable branch at
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
From: Hao Jia <jiahao1@lixiang.com>
Subject: cgroup: docs: add pswpin and pswpout items in cgroup v2 doc
Date: Tue, 18 Mar 2025 15:58:33 +0800

The commit 15ff4d409e1a ("mm/memcontrol: add per-memcg pgpgin/pswpin
counter") introduced the pswpin and pswpout items in the memory.stat of
cgroup v2.  Therefore, update them accordingly in the cgroup-v2
documentation.

Link: https://lkml.kernel.org/r/20250318075833.90615-3-jiahao.kernel@gmail.com
Fixes: 15ff4d409e1a ("mm/memcontrol: add per-memcg pgpgin/pswpin counter") 
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~cgroup-docs-add-pswpin-and-pswpout-items-in-cgroup-v2-doc
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1561,6 +1561,12 @@ The following nested keys are defined.
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
 
+	  pswpin (npn)
+		Number of pages swapped into memory
+
+	  pswpout (npn)
+		Number of pages swapped out of memory
+
 	  pgscan (npn)
 		Amount of scanned pages (in an inactive LRU list)
 
_

Patches currently in -mm which might be from jiahao1@lixiang.com are

mm-vmscan-split-proactive-reclaim-statistics-from-direct-reclaim-statistics.patch
cgroup-docs-add-pswpin-and-pswpout-items-in-cgroup-v2-doc.patch

