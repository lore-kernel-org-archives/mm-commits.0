Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB10156668
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 23:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723765286; cv=none; b=UOwgORo5VIBhksvOdQP5BJZaBQlI9hYEEkZR20nSk7mHL7KPu4z4xsJcbxyqO9DdDzjppRWXeLZgCPEJ7tINPyx94VFr4+17iymd+3++RMnvIlhPRihbOxXw2PwWZsI6hzVdrUp2ndd02dlHlYUEvLtwunlJ6Y/zv1O9cBWyfnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723765286; c=relaxed/simple;
	bh=iAqHGXTP7HI9s+Tm1hFdU/QtqOpJ3gumvPt52mREN+g=;
	h=Date:To:From:Subject:Message-Id; b=g7GG27oI38r9sduWxo/cKkWAyxJy23WLUgtlYiNJNsplW/sj9gClVtGleNgQ5oxHFOibxOUUmX+va5VoPA9vyFOjiHRszYaIhL9uZFbLgMg1vTqCRRQi8Ru6Zb1vq5BAUn1z9uyqYQ6u4NOKQUvIoevXcO9eg9/pmrzk4xht4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mLU22JX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mLU22JX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1709CC4AF0E;
	Thu, 15 Aug 2024 23:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723765286;
	bh=iAqHGXTP7HI9s+Tm1hFdU/QtqOpJ3gumvPt52mREN+g=;
	h=Date:To:From:Subject:From;
	b=mLU22JX5aACMJR2aHRXPf8+VpPkWrNhluA3bH0pzrobMG+Lfxs+IL6DD/TbysMstn
	 1VZnssOQ0IOLrxEHgYOBWqVhTXc8jkDZeq5h3v2etNrFAAecWrgNdInq5G9orKFBjn
	 brLT0A0oiBcmA4KL/tcRV1ssjT75I/vaACzv17fg=
Date: Thu, 15 Aug 2024 16:41:25 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-initiate-deprecation-of-v1-tcp-accounting.patch added to mm-unstable branch
Message-Id: <20240815234126.1709CC4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: initiate deprecation of v1 tcp accounting
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-initiate-deprecation-of-v1-tcp-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-initiate-deprecation-of-v1-tcp-accounting.patch

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
@@ -2531,6 +2531,9 @@ static ssize_t mem_cgroup_write(struct k
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

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch
memcg-initiate-deprecation-of-v1-tcp-accounting.patch
memcg-initiate-deprecation-of-v1-soft-limit.patch
memcg-initiate-deprecation-of-oom_control.patch
memcg-initiate-deprecation-of-pressure_level.patch

