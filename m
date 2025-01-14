Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7773D23A11B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836958; cv=none; b=oDR1BDi+FcNcEXP6ykkZyAmg9O+AMYaCZSNHdo8Od+xP0NRLwknWL1pYKjkVytkiDpgnuSoTY2AkpMiNvGl8mWVbNuO61dKmgAdmzRmd6Wc4g32t0aoTtAq+C2z3XtYm7q8TAN7TyGbCA6mUsWGmpc+fQPfP70cPYqxBvIl1IwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836958; c=relaxed/simple;
	bh=lzeSpXaKZ/YkqFVPYrgve/fCAn7K19SAs9hTr1jzsG0=;
	h=Date:To:From:Subject:Message-Id; b=aLziwyNue3+ouU2tIrxfWvi36he6YSv30L1vhTwoFqbhXoHvIeYTaXKJJGc6KsOqHr+rJ2o8wUqnwqipe69O1t3huQpbg7VAZ9FO0Me1P6S1PaWl4hnXg7JdA12spsbpt4XIOIGryZXStNeMUsBgOHdO22Wu/Pa+qOwGvTFN/nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UhWBucUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UhWBucUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA1DC4CEDD;
	Tue, 14 Jan 2025 06:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836958;
	bh=lzeSpXaKZ/YkqFVPYrgve/fCAn7K19SAs9hTr1jzsG0=;
	h=Date:To:From:Subject:From;
	b=UhWBucUPXpKMjeqgNPaie2FtZr1LljwgbsRM/8FRZDMDh8vmR+LQNXqiqL7LcPOPb
	 lSwXV1dMt3mX70pjDJ8yS9UfRtjDsxSQln9Y66m8JGTZvNzwxSBAQoay/65dBD8HWC
	 161cAmege742aH0TNxvnes3fp+EkS8AyY/SmEF3I=
Date: Mon, 13 Jan 2025 22:42:37 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kerensun@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prefer-unsigned-int-to-bare-use-of-unsigned.patch removed from -mm tree
Message-Id: <20250114064238.3BA1DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prefer 'unsigned int' to bare use of 'unsigned'
has been removed from the -mm tree.  Its filename was
     mm-prefer-unsigned-int-to-bare-use-of-unsigned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Keren Sun <kerensun@google.com>
Subject: mm: prefer 'unsigned int' to bare use of 'unsigned'
Date: Fri, 15 Nov 2024 15:57:42 -0800

Patch series "mm: fix format issues and param types"

Change the param 'mode' from type 'unsigned' to 'unsigned int' in
memcg_event_wake() and memcg_oom_wake_function(), and for the param 'nid'
in VM_BUG_ON().

Link: https://lkml.kernel.org/r/20241115235744.1419580-2-kerensun@google.com
Signed-off-by: Keren Sun <kerensun@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol-v1.c~mm-prefer-unsigned-int-to-bare-use-of-unsigned
+++ a/mm/memcontrol-v1.c
@@ -899,7 +899,7 @@ static void memcg_event_remove(struct wo
  *
  * Called with wqh->lock held and interrupts disabled.
  */
-static int memcg_event_wake(wait_queue_entry_t *wait, unsigned mode,
+static int memcg_event_wake(wait_queue_entry_t *wait, unsigned int mode,
 			    int sync, void *key)
 {
 	struct mem_cgroup_event *event =
@@ -1202,7 +1202,7 @@ struct oom_wait_info {
 };
 
 static int memcg_oom_wake_function(wait_queue_entry_t *wait,
-	unsigned mode, int sync, void *arg)
+	unsigned int mode, int sync, void *arg)
 {
 	struct mem_cgroup *wake_memcg = (struct mem_cgroup *)arg;
 	struct mem_cgroup *oom_wait_memcg;
@@ -1644,7 +1644,7 @@ static unsigned long mem_cgroup_node_nr_
 	unsigned long nr = 0;
 	enum lru_list lru;
 
-	VM_BUG_ON((unsigned)nid >= nr_node_ids);
+	VM_BUG_ON((unsigned int)nid >= nr_node_ids);
 
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
_

Patches currently in -mm which might be from kerensun@google.com are


