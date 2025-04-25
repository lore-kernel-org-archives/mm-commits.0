Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A728BE5
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 00:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745542795; cv=none; b=U1lFMXEyakMh6HQTlcqU0k0qVvup9ZN+2c8ZLwnAF19oZjBj8/R60OTBFS5rvhwDRqEZc63WHdpjs/Gqk3+o4AdiF0mrJRw11/M5U8FehqfwVbEt6/ma3O3ypsOvNz7b2dli4UBjMVUCeZDBhsdqviNg5FY4OFss1yNbCm+vIgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745542795; c=relaxed/simple;
	bh=tKt1CG6Pm/UEuRasZet7T/6CDXcvkh6VQhilWIHMHso=;
	h=Date:To:From:Subject:Message-Id; b=awYR8lTFGfyMH61GvZfchWXbcr3G5Cp2dqreK4Sw8YBVupWL3jul+V9CTebs9sH8Fjv4W9AlfDh4G3TUh89Y7uYWkba83F1XTgW8lN+enNYJhNjuUUU+/W93TNLgT7NY0Wpqz9kVsU2AC32q0RwZ2zhZrzRCDn/n2RSZxhwxx90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vo54tsSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vo54tsSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EEAC4CEE3;
	Fri, 25 Apr 2025 00:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745542794;
	bh=tKt1CG6Pm/UEuRasZet7T/6CDXcvkh6VQhilWIHMHso=;
	h=Date:To:From:Subject:From;
	b=Vo54tsShcEuw+eE3SBRW1rPzTfcWoq6W9SE5e6eMBkzVRCY39zuYydT5JaDB/685Y
	 2xF7Whx53i0XnbSjEStpbdUMXlEISAMu1dnAeJHzFtK7ZZDwEmPEjB3Q48Zyjkqhp0
	 uKUI2EnPjXVOXGn4oDWpABwPUc86YoOFgPjBc6Bo=
Date: Thu, 24 Apr 2025 17:59:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-multi-memcg-percpu-charge-cache-fix.patch added to mm-unstable branch
Message-Id: <20250425005954.70EEAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: multi-memcg percpu charge cache - fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-multi-memcg-percpu-charge-cache-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-multi-memcg-percpu-charge-cache-fix.patch

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
Subject: memcg: multi-memcg percpu charge cache - fix
Date: Wed, 23 Apr 2025 15:41:18 -0700

Add BUILD_BUG_ON() for MEMCG_CHARGE_BATCH

Link: https://lkml.kernel.org/r/rlsgeosg3j7v5nihhbxxxbv3xfy4ejvigihj7lkkbt3n6imyne@2apxx2jm2e57
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache-fix
+++ a/mm/memcontrol.c
@@ -1909,6 +1909,13 @@ static void refill_stock(struct mem_cgro
 	bool evict = true;
 	int i;
 
+	/*
+	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
+	 * decide to increase it more than 127 then we will need more careful
+	 * handling of nr_pages[] in struct memcg_stock_pcp.
+	 */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
+
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
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
memcg-optimize-memcg_rstat_updated.patch
memcg-multi-memcg-percpu-charge-cache.patch
memcg-multi-memcg-percpu-charge-cache-fix.patch
memcg-introduce-non-blocking-limit-setting-option.patch

