Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E63C375F97;
	Mon, 24 Aug 2026 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787599197; cv=none; b=ho71sBQCLqH6upBs2+NEUEv8w26ncJrvGx8/SiO8Di5aEjGojZzzmCmq6/ji2EUurIUtzbHmPYka5tVA6samilMYkYrptmhux5NgdiuPMkxwwlAmSQ7jIi6DSUGHZ4jZNfhEx3VlJUkj+EdEvTDvSMChFimARM3J7bUgF4ulfIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787599197; c=relaxed/simple;
	bh=adz2C8mivmTPLOozPvSpXJc8jJqx6RsiL13ffXdi7Yg=;
	h=Date:To:From:Subject:Message-Id; b=sW9i1voc3HyXgoPh0OLXDfc2Br8WeoSu53qAzv5OfzsGrs/st3A3Fvlh0zUGbKCIqVJ4kcr2dZeIXmqu31emc/5o52I0TMOdbPLQh0vlCI+zgVR8FUkjP3msyUvc5fUnWm6Gc8NU2xUzDgBxKkhWiFEzBUQf9YSaJtdKjNOm5nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIR8N2eu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIR8N2eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4331F000E9;
	Mon, 24 Aug 2026 19:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787599195;
	bh=eyailxTAjiTRXQv2zUj0R04x+iF5DADQ6D+8OAMveEQ=;
	h=Date:To:From:Subject;
	b=SIR8N2eux/MIJ37qFWuuxzfJ0YqhM7sH+W0HVFal6I33YkjZ/T6m1m+UGjhzbDD6+
	 wJOqzqKXZMiQaUcHQjMATGbe4Tm2pQzCPl4/2W60GPF+NNDLPPXKN6GWR/y+nYriXv
	 ZVCc51yTojCqNX2KvFpnfx/a2PigNc3OlYBU5xnk=
Date: Mon, 24 Aug 2026 12:19:54 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-lru-size-accounting-on-reparenting-instead-of-copying-it.patch added to mm-unstable branch
Message-Id: <20260824191955.2B4331F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move LRU size accounting on reparenting instead of copying it
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-move-lru-size-accounting-on-reparenting-instead-of-copying-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-lru-size-accounting-on-reparenting-instead-of-copying-it.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: move LRU size accounting on reparenting instead of copying it
Date: Fri, 21 Aug 2026 19:47:07 -0700

When a memory cgroup is offlined its LRU folios are reparented to the
parent.  lruvec_reparent_lru() splices the child's lists into the
parent's and credits the parent with the child's per-zone
lru_zone_size[], but never clears the child's copy, so the size is
copied rather than moved.  lru_gen_reparent_memcg() does the same for
MGLRU.

The parent is left correct, credited with exactly the folios it took
over.  The stale value sits on the child and nothing will correct it:
folio->memcg_data now resolves to the parent, so every later
update_lru_size() for those folios goes there.

Dying cgroups are not freed immediately and mem_cgroup_iter() still
walks them, so shrink_lruvec() keeps being called on them.
get_scan_count() reads the phantom counter through lruvec_lru_size() and
the scan loop then grinds through nr[] in SWAP_CLUSTER_MAX steps against
an empty list, for as long as the dead cgroup lives.  Under MGLRU the
MGLRU scanner runs instead, but count_shadow_nodes() sums all of
NR_LRU_LISTS through lruvec_lru_size() and over-budgets the shadow node
limit just the same.

On one 251 GiB host a sweep of every mz->lru_zone_size[] found 380
counters describing folios on no list at all: 124777314 pages, 476 GiB,
1.89x the machine's RAM, across 57 cgroups.  All were on memcgs with
CSS_DYING set and CSS_ONLINE clear, and parent/child pairs reported
byte-identical sizes.

LRU_UNEVICTABLE needs its size moved too.  Its list is deliberately not
spliced because lruvec_init() poisons the head - the unevictable LRU is
imaginary and folios are never threaded on it - but the size is kept by
lruvec_add_folio()/lruvec_del_folio() and those folios account to the
parent from here on.

This depends on commit bf4ade7dbd76 ("memcg: keep folio's objcg same as
its node") and must not be backported ahead of it.  Without that
invariant a folio's objcg can belong to another node, so a folio already
spliced onto the parent's list can still resolve to the child's lruvec
until the objcg's node is reparented in a later iteration of
memcg_reparent_objcgs(); clearing the child's counter early then lets
lruvec_del_folio() underflow it and trip the WARN_ONCE()/VM_BUG_ON() in
mem_cgroup_update_lru_size().

Link: https://lore.kernel.org/20260822024707.77192-1-shakeel.butt@linux.dev
Fixes: 07a6e9a2c199 ("mm: vmscan: prepare for reparenting traditional LRU folios")
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org> # After: bf4ade7dbd76: memcg: keep folio's objcg same as its node
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/folio.c  |    9 +++++++++
 mm/vmscan.c |    5 +++++
 2 files changed, 14 insertions(+)

--- a/mm/folio.c~memcg-move-lru-size-accounting-on-reparenting-instead-of-copying-it
+++ a/mm/folio.c
@@ -1130,7 +1130,16 @@ static void lruvec_reparent_lru(struct l
 	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
 		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
 
+		if (!size)
+			continue;
+
+		/*
+		 * The folios are accounted to the parent from now on, so the
+		 * size has to be moved, not just copied. Leaving it behind
+		 * makes the dying child describe folios it no longer owns.
+		 */
 		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+		mem_cgroup_update_lru_size(child_lruvec, lru, zid, -(long)size);
 	}
 }
 
--- a/mm/vmscan.c~memcg-move-lru-size-accounting-on-reparenting-instead-of-copying-it
+++ a/mm/vmscan.c
@@ -4635,7 +4635,12 @@ void lru_gen_reparent_memcg(struct mem_c
 		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
 			unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
 
+			if (!size)
+				continue;
+
+			/* Move the accounting, do not duplicate it. */
 			mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+			mem_cgroup_update_lru_size(child_lruvec, lru, zid, -(long)size);
 		}
 	}
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-make-the-v1-soft-limit-knob-inert.patch
memcg-bypass-the-reclaim-and-oom-killer-for-dying-tasks-once-oom_reaper-is-done.patch
memcg-move-lru-size-accounting-on-reparenting-instead-of-copying-it.patch

