Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173B1EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119344; cv=none; b=j21LRt0pbgnezyg6eElIYFCKf6GjpnCzQ0eLVQpnfRD8DVYbHSiMv71H0JYL9QykWncSdlV0VLra/P+6tvw5LTOPWw7TstQufPecJA2KwVq6hGqwplNkLLq25eiCVyF9YnS9mMpB8q9sS+d9HRTiLmtypczYhtHqtUSG211dtrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119344; c=relaxed/simple;
	bh=UFI/XefXgKXfxPWaXa5ENGkMgR4dengSuiWMbk8rOI8=;
	h=Date:To:From:Subject:Message-Id; b=Cu4KNvPW1icZ4S88sLtROrPxHJJcLSDNZmMQWTplGbqng2zJmSKxq8jgIUfTXC2wOVZYnvk3nnfpgvDmlkR3WEOlKMFW7cEcZ2ilkMw19ca9W9MKa0fULZZYQUvD/UuSAZdl8hmRcM8jT1dcuUAxxNoWYfvGjObgq/f+fn2eAtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ln6wrsJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ln6wrsJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDA6C4CEE4;
	Tue, 13 May 2025 06:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119343;
	bh=UFI/XefXgKXfxPWaXa5ENGkMgR4dengSuiWMbk8rOI8=;
	h=Date:To:From:Subject:From;
	b=Ln6wrsJ2BV97ZtOQpsOLGvNl2rGuAJVnGHuExcf5tclQoM70p5BC5rRJ/7q9T41+S
	 H9nFYoXj9vDqLOphWazpDo+kBo1dBCYbPv3dZMW2YtHaHix3/sm0eL5ipN1mpuqLCg
	 CjhvTu7C2Osj3oFRzkOxYvPlxD9poNw+BLDLuvV0=
Date: Mon, 12 May 2025 23:55:43 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-add-ksm_stat-description-in-cgroup-v2rst.patch removed from -mm tree
Message-Id: <20250513065543.ADDA6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: add ksm_stat description in cgroup-v2.rst
has been removed from the -mm tree.  Its filename was
     documentation-add-ksm_stat-description-in-cgroup-v2rst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1739,6 +1739,18 @@ The following nested keys are defined.
 
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


