Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E056FBF
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987014; cv=none; b=NRjenu3R+cxuZAhi/M1JJJL14Ud577rTGxy3Z+edfi27sNzX20h7J/QE8r8k8X3RcdT8wUxM/4DQ7J+A093VGmaVuHTyO2zg5y8NsoW6l8Q1XpiA6EThNu+8hIwomsjRCmkk5xo+2KEMGJHgK7a8VsciBI3E60b4WIzU0pi9LHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987014; c=relaxed/simple;
	bh=YPiDo7J6FxZhfH/CR/PzOK4ng1OHQ6JrJyaFIUwuXQY=;
	h=Date:To:From:Subject:Message-Id; b=hPNUYs1XStZhzEjnogEb21c0d74c3RkfxGsphI4Ao6yXUIPg/6WSC1UuZTbeKGKOyLR+J8/2A3TltY7KMC3YdW3QMko1Kaa6BzdpY3BjBzf6yOSdAFuo1tRwQKUwm2tQFwVAy/exA0+32RkFEUbf4qw7FxYJc9EuO157KDC+eYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J3Wm9xq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J3Wm9xq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A58BC4CEE3;
	Mon,  7 Apr 2025 00:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987013;
	bh=YPiDo7J6FxZhfH/CR/PzOK4ng1OHQ6JrJyaFIUwuXQY=;
	h=Date:To:From:Subject:From;
	b=J3Wm9xq2Ns2+o5jpixEOkDU/EVzaY3cf+0PfuNcuF9FdSIcBsGAJReVep3ygUCykl
	 WUqpcPVd6j+WxJZrcUUk2Jh81E6EL4SgPyAMEyutlpaArqax/7FCzah1J11GcO8OQi
	 rdNf6CV+JCPAQNXgNW9kT2B1tNQxykfZ8Hx6bbMM=
Date: Sun, 06 Apr 2025 17:50:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-decouple-drain_obj_stock-from-local-stock.patch added to mm-new branch
Message-Id: <20250407005013.6A58BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: decouple drain_obj_stock from local stock
has been added to the -mm mm-new branch.  Its filename is
     memcg-decouple-drain_obj_stock-from-local-stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-decouple-drain_obj_stock-from-local-stock.patch

This patch will later appear in the mm-new branch at
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
Subject: memcg: decouple drain_obj_stock from local stock
Date: Thu, 3 Apr 2025 18:39:06 -0700

Currently drain_obj_stock() can potentially call __refill_stock which
accesses local cpu stock and thus requires memcg stock's local_lock. 
However if we look at the code paths leading to drain_obj_stock(), there
is never a good reason to refill the memcg stock at all from it.

At the moment, drain_obj_stock can be called from reclaim, hotplug cpu
teardown, mod_objcg_state() and refill_obj_stock().  For reclaim and
hotplug there is no need to refill.  For the other two paths, most
probably the newly switched objcg would be used in near future and thus no
need to refill stock with the older objcg.

In addition, __refill_stock() from drain_obj_stock() happens on rare
cases, so performance is not really an issue.  Let's just uncharge
directly instead of refill which will also decouple drain_obj_stock from
local cpu stock and local_lock requirements.

Link: https://lkml.kernel.org/r/20250404013913.1663035-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-decouple-drain_obj_stock-from-local-stock
+++ a/mm/memcontrol.c
@@ -2876,7 +2876,12 @@ static struct obj_cgroup *drain_obj_stoc
 
 			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
 			memcg1_account_kmem(memcg, -nr_pages);
-			__refill_stock(memcg, nr_pages);
+			if (!mem_cgroup_is_root(memcg)) {
+				page_counter_uncharge(&memcg->memory, nr_pages);
+				if (do_memsw_account())
+					page_counter_uncharge(&memcg->memsw,
+							      nr_pages);
+			}
 
 			css_put(&memcg->css);
 		}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch

