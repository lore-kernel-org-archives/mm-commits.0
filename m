Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745AD3F58EA
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525385; cv=none; b=Vq35cdoos5WMgdA875QiOK1BELkcFklF7ySqhlVqqbd3BsRmw1JfxP7OmLObUMKp9cdsd+TD4G61m1ezJ3ll9kIdz8dU1cdR0QUetksBxvDkJTXNQFCn1SRfBE6lL1In5jGd6F1rklNVRKmcnm08Uh8fuDrD+/5bEM18gX3I5+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525385; c=relaxed/simple;
	bh=PDu6bhgbPpWPTAP3hIZbOLO/cyjjJcc8VaktZ5NFI7k=;
	h=Date:To:From:Subject:Message-Id; b=Kv7bslFZRXTVN1CzJiIIao19k4IgKXw1GD0sKeepFkSmd5A0vVyNl35S5FJ42qbYX9TqUgrWCj6lryUtxo9hJHysa464uJ2vl3mEpVO6jdSdtBoPQDbiLNmpnhqIJuU7lILoCYWgBHzv9qVhuYzJPWaWduqa6VHZloPSKUnbZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vpdr88YW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vpdr88YW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5CD1F00893;
	Fri,  9 Oct 2026 05:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525384;
	bh=djSJHxkRk1sJ/1O2PL6NuafkYqHwa9mDqviisIywmtU=;
	h=Date:To:From:Subject;
	b=vpdr88YW481dyJuOzTXx5Avl54xNli0CBhiAdkgyWoXnDx+EL3ASSgTps56WsFRKd
	 /KqknRyJQIqfxEmh7EaroGCK5zk0jFM9uno0k8JKVU4ozcEqWYaMkb18bTNa0K7DnF
	 +kfsfc8LGIvuXIec58fnOJytc/Gr0GDlWnWynPmE=
Date: Thu, 08 Oct 2026 22:56:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch removed from -mm tree
Message-Id: <20261009055624.2F5CD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: preserve original free_pid/free_tgid during folio migration
has been removed from the -mm tree.  Its filename was
     mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/page_owner: preserve original free_pid/free_tgid during folio migration
Date: Thu, 3 Sep 2026 17:21:26 +0800

__update_page_owner_free_handle() accepts pid and tgid, but ignores them,
always storing current->pid and current->tgid.

__folio_copy_owner() forwards the original free pid/tgid during folio
migration, yet these values were overwritten by the migrating task.

Store the passed-in pid/tgid so the migrated folio keeps the original free
attribution.

Link: https://lore.kernel.org/20260903092126.24685-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/page_owner.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration
+++ a/mm/page_owner.c
@@ -307,8 +307,8 @@ static inline void __update_page_owner_f
 			page_owner->free_handle = handle;
 		}
 		page_owner->free_ts_nsec = free_ts_nsec;
-		page_owner->free_pid = current->pid;
-		page_owner->free_tgid = current->tgid;
+		page_owner->free_pid = pid;
+		page_owner->free_tgid = tgid;
 	}
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch
mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch

