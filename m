Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED34E38E8B8;
	Fri,  7 Aug 2026 02:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068095; cv=none; b=lAO7890r1rHYS0BXRq6qCV8+JIOybVKB4GtPcj77JQy/V31YdXz+DuMYn+MM/IJe9Ru7//gimgeSIZsjxFSTTPEhouoCqAlNcrutejBoaPWeLXNChokehtXEcTwXkW3zOkc3Kavfjtssx0OcxSZoTbWFNYtHOgi2UDzJdB7mzWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068095; c=relaxed/simple;
	bh=nphmidJDXxVgBGgWwdZKYNbIh8jbU6ov7HFkWBOXf4s=;
	h=Date:To:From:Subject:Message-Id; b=FVmstRRlnmevKe8fOu3znem4sJ90v4iFA9eA/qm91ouswcgvsO57C+sWs/5FjFJ1oKacJiXTEYiQCQks8NXww/YegZxZ+IZBPqZU8nsjHOnhRXxri0fmW3xCM7kZJbNYnw/cnNbuLR90e9rUFKvUaXAQgT6PN3/owCX2bRb++xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPha8rFt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPha8rFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C411F1F000E9;
	Fri,  7 Aug 2026 02:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068086;
	bh=4v8vRAw4x8AwT/fz6p44tTbg73ENQvgCJro7Rlt6JeU=;
	h=Date:To:From:Subject;
	b=QPha8rFtoH6MPMUI4Cd3CnkaBAT//BuV/LdA9asiR+VRHwW8TzpGPq/qNSgQi2JD2
	 kDWReUVHWckPapLTYpp9VY81Bqm/EaA8eEgza+yjwkFz8n5hYaP09zE53XvW7UJ81L
	 KO3G/STowk2HZIP280pviZlRuNAlNRozvpJJ3d+M=
Date: Thu, 06 Aug 2026 19:01:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,brendan.jackman@linux.dev,bigeasy@linutronix.de,ast@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch removed from -mm tree
Message-Id: <20260807020126.C411F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: don't spin_trylock() when disallowed in free_one_page()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: don't spin_trylock() when disallowed in free_one_page()
Date: Wed, 15 Jul 2026 09:03:59 +0000

__free_frozen_pages() checks can_spin_trylock() before entering into the
main free_frozen_page_commit()/free_one_page() path, but before this it
can get to free_one_page() via the !pcp_allowed_order() and
MIGRATE_ISOLATE paths.

The !pcp_allowed_order() path depends on usage by callers so might not be
possible in practice.  The MIGRATE_ISOLATE path probably means kernel
crashes and privilege escalation if anyone ever did memory hotplug and BPF
tracing on a PREEMPT_RT or !SMP build.

Link: https://lore.kernel.org/20260715-alloc-nolock-fixes-v1-2-fadc49952dda@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-affb5fe5ed00%40google.com?part=2
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page
+++ a/mm/page_alloc.c
@@ -1559,7 +1559,7 @@ static void free_one_page(struct zone *z
 	unsigned long flags;
 
 	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
-		if (!spin_trylock_irqsave(&zone->lock, flags)) {
+		if (!can_spin_trylock() || !spin_trylock_irqsave(&zone->lock, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
 		}
_

Patches currently in -mm which might be from jackmanb@google.com are


