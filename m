Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52438155393
	for <mm-commits@vger.kernel.org>; Sat, 17 May 2025 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747495009; cv=none; b=kUh0dS7evNvC6knlMJqxsugZ5T/LY/2T2bJAroD5qFT59oOaTUC9NuvC2zsQXhPtkckaQwHdYLO6xsUQYxRkvnfQYJTJq1ICQGZ8S5ix6boFwEI/mgzX75qfKTzSwfRBoBeHxsnGrBB3Zysr+qHEPraytSnO+i9DuDyYwZ4j/d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747495009; c=relaxed/simple;
	bh=pyFxTzNgNefQXg+vEMX/4apNWQOJEynCIgjAU48Teck=;
	h=Date:To:From:Subject:Message-Id; b=Py6i7hkjhEjiVB3/iwmAtkW51jHSluX0ijhobmrrhD1fwsFzN4VT/jsrDuZlro1jbZ80OkbWaNAHUY/40p/MFOq7SKcUKiHqF2uuZBTMEJFYkW2JMQiB0q2JBqM4PsM7gfWi9xPSajXyhfYFVcqAsDwoswsOPFVRHWsLFfuM6nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MjRzq2AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MjRzq2AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D439C4CEE3;
	Sat, 17 May 2025 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747495008;
	bh=pyFxTzNgNefQXg+vEMX/4apNWQOJEynCIgjAU48Teck=;
	h=Date:To:From:Subject:From;
	b=MjRzq2ABLMed5D9kQklYkgdFeresVKAJbj14AdJ3UqJF0yDJaBZr6mmSiyTbwO1Q6
	 QDt4r11VsyJy5lIX7SwxLbc9bU1Bk0LdgR1f4ZrsH4fNnxC0/VIb17/0JIXsO+K3WJ
	 rAjsFmA7P6HHT+993h5Xj3f++ctd6+qT1P+wKKKI=
Date: Sat, 17 May 2025 08:16:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch added to mm-new branch
Message-Id: <20250517151648.7D439C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix
has been added to the -mm mm-new branch.  Its filename is
     memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix
Date: Thu, 15 May 2025 13:43:46 +0100

fix build

Link: https://lkml.kernel.org/r/22f69e6e-7908-4e92-96ca-5c70d535c439@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix
+++ a/mm/memcontrol.c
@@ -3697,7 +3697,8 @@ static void mem_cgroup_free(struct mem_c
 
 static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 {
-	struct memcg_vmstats_percpu *statc, __percpu *pstatc_pcpu;
+	struct memcg_vmstats_percpu *statc;
+	struct memcg_vmstats_percpu __percpu *pstatc_pcpu;
 	struct mem_cgroup *memcg;
 	int node, cpu;
 	int __maybe_unused i;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch
maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

