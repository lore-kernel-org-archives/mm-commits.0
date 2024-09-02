Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1906A33B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247858; cv=none; b=OOFLRD1EhAdWt8fr86RbUQosop5AbLvb3GhjRvAKckqqmr3521oAooYup5xCYiedaFm/RI9rZnNDBS4W5eZ+6GNtCUuSxSa/VxuFcpHCUzDp/DdoeCskwQeYfBYlDSkQclB0EDO8ABUqgugt3DSHH+r+ufvMPKyo//hw8Cw+jNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247858; c=relaxed/simple;
	bh=Z0Q26R+pvUC+O2MncKZ8itx9AXLjUhp8xpOQJ+Jd7D4=;
	h=Date:To:From:Subject:Message-Id; b=Kt4FgY3ZC10DOJXMuNH0W/Sp254wLTSQAtEGI6Em6sB3C2GSCzYOUqX1NKJz8s98Jg4Ko0qImJUDYWsQTwEXAF9YvCQUc1UKDuKcj2U0g2YCpDY6eZgt3QM7l/A/8W7nYiqRGUFAEzXk46BxzPNIA8OrXkQlbBpka+0GHQp6WNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eFYDP0f+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eFYDP0f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB28CC4CEC2;
	Mon,  2 Sep 2024 03:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247857;
	bh=Z0Q26R+pvUC+O2MncKZ8itx9AXLjUhp8xpOQJ+Jd7D4=;
	h=Date:To:From:Subject:From;
	b=eFYDP0f+u3IHOWFFjSGHjPpVcMoSdmV3MM070JewDNy4+tXk0ZwzvnlpAtppUrWbb
	 oXc9ahVVAXfYRFibhPehvMecCFzdCNc+Lmni22LH5jr3phn4tz/Gf4lcyU/BjTbT9z
	 PfSEmaDts4U6zOYy/d6+a/9D/T6trNdCzXp5pE3Q=
Date: Sun, 01 Sep 2024 20:30:57 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-initiate-deprecation-of-v1-tcp-accounting.patch removed from -mm tree
Message-Id: <20240902033057.DB28CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: initiate deprecation of v1 tcp accounting
has been removed from the -mm tree.  Its filename was
     memcg-initiate-deprecation-of-v1-tcp-accounting.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: initiate deprecation of v1 tcp accounting
Date: Wed, 14 Aug 2024 15:00:18 -0700

Patch series "memcg: initiate deprecation of v1 features", v2.

Start the deprecation process of the memcg v1 features which we discussed
during LSFMMBPF 2024 [1].  For now add the warnings to collect the
information on how the current users are using these features.  Next we
will work on providing better alternatives in v2 (if needed) and fully
deprecate these features.

Link: https://lwn.net/Articles/974575 [1]


This patch (of 4):

Memcg v1 provides opt-in TCP memory accounting feature.  However it is
mostly unused due to its performance impact on the network traffic.  In
v2, the TCP memory is accounted in the regular memory usage and is
transparent to the users but they can observe the TCP memory usage through
memcg stats.

Let's initiate the deprecation process of memcg v1's tcp accounting
functionality and add warnings to gather if there are any users and if
there are, collect how they are using it and plan to provide them better
alternative in v2.

Link: https://lkml.kernel.org/r/20240814220021.3208384-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20240814220021.3208384-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |    8 ++++++++
 mm/memcontrol-v1.c                             |    3 +++
 2 files changed, 11 insertions(+)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~memcg-initiate-deprecation-of-v1-tcp-accounting
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -105,10 +105,18 @@ Brief summary of control files.
  memory.kmem.max_usage_in_bytes      show max kernel memory usage recorded
 
  memory.kmem.tcp.limit_in_bytes      set/show hard limit for tcp buf memory
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.kmem.tcp.usage_in_bytes      show current tcp buf memory allocation
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.kmem.tcp.failcnt             show the number of tcp buf memory usage
 				     hits limits
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.kmem.tcp.max_usage_in_bytes  show max tcp buf memory usage recorded
+                                     This knob is deprecated and shouldn't be
+                                     used.
 ==================================== ==========================================
 
 1. History
--- a/mm/memcontrol-v1.c~memcg-initiate-deprecation-of-v1-tcp-accounting
+++ a/mm/memcontrol-v1.c
@@ -2534,6 +2534,9 @@ static ssize_t mem_cgroup_write(struct k
 			ret = 0;
 			break;
 		case _TCP:
+			pr_warn_once("kmem.tcp.limit_in_bytes is deprecated and will be removed. "
+				     "Please report your usecase to linux-mm@kvack.org if you "
+				     "depend on this functionality.\n");
 			ret = memcg_update_tcp_max(memcg, nr_pages);
 			break;
 		}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


