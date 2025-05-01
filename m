Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734F1216392
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131265; cv=none; b=fxjmGwFsaZ+LM0IDeJCxJuzXqoxUSoiPlNAEzH1/rt/dBOdWf7KiQpBzLjyRN15c8v+LfkF8J0HkguPwgboyNkeU49mnftKF8KkkduqM0SwakgeELg3HbFKnRe97sv9RyZfh97FeGVVKboPMW+sruMLH2IN3xevpHb9XgwvoWhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131265; c=relaxed/simple;
	bh=sfB9b7mpETNqtYAXcUC7FVIIMPtJlxIO9jNoWJtOGdw=;
	h=Date:To:From:Subject:Message-Id; b=L1jKPsMetTB9hck4N2SDlHkIfxtWF3If2vFfMl+pdRONQ8j2ta4qWzhWrLqMePCyrUVu5VlZfPTAX6hT1+X+wTo6iB1GOCEAEsNCKrxjagZxJ5NSa5g/npBldjzdoBhu3eBevX7wT9pvl0mnZZoxTKawr2kri128CcWlOs6oXsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sqlCWcd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sqlCWcd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CE7C4CEE4;
	Thu,  1 May 2025 20:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746131265;
	bh=sfB9b7mpETNqtYAXcUC7FVIIMPtJlxIO9jNoWJtOGdw=;
	h=Date:To:From:Subject:From;
	b=sqlCWcd9ncleHOl6ajH4HYu1TbWGYdGAWpOjawYMMXCNT5oWBq7MeqwB55nDIWRTk
	 Q75fJQw0ZfzvEqS4Y/EnTHgdGK330b4J757jJLvmuae0bP1X6O4m0LtPOT5sPzD88s
	 9jko0Jk6/FnIZRZm4rcjc1Nxl80OQslJNqPbYywI=
Date: Thu, 01 May 2025 13:27:44 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-add-ksm_stat-description-in-cgroup-v2rst.patch added to mm-new branch
Message-Id: <20250501202745.43CE7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: add ksm_stat description in cgroup-v2.rst
has been added to the -mm mm-new branch.  Its filename is
     documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: xu xin <xu.xin16@zte.com.cn>
Subject: Documentation: add ksm_stat description in cgroup-v2.rst
Date: Thu, 1 May 2025 04:17:39 +0000

This updates ksm_stat description in cgroup-v2.rst.

Link: https://lkml.kernel.org/r/20250501041739.3324672-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~documentation-add-ksm_stat-description-in-cgroup-v2rst
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1735,6 +1735,18 @@ The following nested keys are defined.
 
 	The entries can refer to the memory.stat.
 
+  memory.ksm_stat
+        A read-only nested-keyed file.
+
+        The file can be used to observe the ksm merging status of the
+        processes within an memory cgroup. There are four items
+        including "ksm_rmap_items", "ksm_zero_pages", "ksm_merging_pages"
+        and "ksm_profit".
+
+        See
+        :ref:`Documentation/admin-guide/cgroup-v1/memory.rst ksm_stat <memcg_ksm_stat>`
+        for details.
+
   memory.swap.current
 	A read-only single value file which exists on non-root
 	cgroups.
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

memcontrol-rename-mem_cgroup_scan_tasks.patch
memcontrol-introduce-the-new-mem_cgroup_scan_tasks.patch
memcontrol-introduce-ksm_stat-at-memcg-v2.patch
memcontrol-add-ksm_zero_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_merging_pages-in-cgroup-memoryksm_stat.patch
memcontrol-add-ksm_profit-in-cgroup-memoryksm_stat.patch
memcontrol-v1-add-ksm_stat-at-memcg-v1.patch
documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch
documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

