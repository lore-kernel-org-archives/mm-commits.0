Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B112F1EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119342; cv=none; b=NXR/26oG5iccUCXBqfEU00HBjF/fRO7yd0zZVxHLMPfDyJyz9Iw1MahrYiWDGafa/Vv8H1uiK/IKTWyGgV8meFRXadRModKWcaBuZw6dev+2z1aw40zUdk485pk7n4eTn7aMOCzY2aYtTW39iGdjw3X70cpWptjDY0DITRz5tcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119342; c=relaxed/simple;
	bh=c7Z7hQewZZfpVgC7A9pNGgKDgWDMpcHISgA9QJw1280=;
	h=Date:To:From:Subject:Message-Id; b=gjWnZWNXrDKwDiX/Z77vJKjm94VltFVyl2ooaAXfiRDkLW989l/T6q0x2oc8fdPjTa8QRabRs//5YLZkCllYoRtsU7uYmceGXVb8+5LeNxWLhrJHWJq8Qyxn/UpqbNAWUiTKgc8iFA+uONkQxlJZOjVZRHhb45ADZ50SaNjye18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fRHuN3mH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fRHuN3mH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFC3C4CEE4;
	Tue, 13 May 2025 06:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119342;
	bh=c7Z7hQewZZfpVgC7A9pNGgKDgWDMpcHISgA9QJw1280=;
	h=Date:To:From:Subject:From;
	b=fRHuN3mHY8/bak0g2WQFMjUmZnP9riipmcFXjf56BYx7uj/fmV02vNKm2cio64l96
	 rBk4L+ZyOuZHjKQLNKk76oYgO5y7T+bQbFG9Nrg8EGRf4wjHca6T4ykMwf3Intv7d4
	 8DmDs4maVvywvyo/ZJKvLcNCAwvaHcPexnSV0Ry0=
Date: Mon, 12 May 2025 23:55:41 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch removed from -mm tree
Message-Id: <20250513065542.7DFC3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: add ksm_stat description in cgroup-v1/memory.rst
has been removed from the -mm tree.  Its filename was
     documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: Documentation: add ksm_stat description in cgroup-v1/memory.rst
Date: Thu, 1 May 2025 04:17:13 +0000

This updates ksm_stat description in cgroup-v1/memory.rst.

Link: https://lkml.kernel.org/r/20250501041713.3324621-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |   36 +++++++++++++++
 1 file changed, 36 insertions(+)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~documentation-add-ksm_stat-description-in-cgroup-v1-memoryrst
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -97,6 +97,8 @@ Brief summary of control files.
                                      used.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
+ memory.ksm_stat                     show the statistic information about various ksm
+                                     counters
  memory.kmem.limit_in_bytes          Deprecated knob to set and read the kernel
                                      memory hard limit. Kernel hard limit is not
                                      supported since 5.16. Writing any value to
@@ -674,6 +676,40 @@ The output format of memory.numa_stat is
 
 The "total" count is sum of file + anon + unevictable.
 
+.. _memcg_ksm_stat:
+
+5.7 ksm_stat
+------------
+
+When CONFIG_KSM is enabled, the ksm_stat file can be used to observe the ksm
+merging status of the processes within an memory cgroup.
+
+The output format of memory.ksm_stat is::
+
+  ksm_rmap_items <number>
+  ksm_zero_pages <number>
+  ksm_merging_pages <number>
+  ksm_profit <number>
+
+The "ksm_rmap_items" count specifies the number of ksm_rmap_item structures in
+use. The structureksm_rmap_item stores the reverse mapping information for
+virtual addresses.  KSM will generate a ksm_rmap_item for each ksm-scanned page
+of the process.
+
+The "ksm_zero_pages" count specifies represent how many empty pages are merged
+with kernel zero pages by KSM, which is useful when /sys/kernel/mm/ksm/use_zero_pages
+is enabled.
+
+The "ksm_merging_pages" count specifies how many pages of this process are involved
+in KSM merging (not including ksm_zero_pages).
+
+The "ksm_process_profit" count specifies the profit that KSM brings (Saved bytes).
+KSM can save memory by merging identical pages, but also can consume additional
+memory, because it needs to generate a number of rmap_items to save each scanned
+page's brief rmap information. Some of these pages may be merged, but some may not
+be abled to be merged after being checked several times, which are unprofitable
+memory consumed.
+
 6. Hierarchy support
 ====================
 
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


