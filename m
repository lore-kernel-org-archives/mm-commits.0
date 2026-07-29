Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125A6255F2D
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298511; cv=none; b=T9r4RnNwR4HpMFxfW/1mHs87hUctCvaW9bKyBmEF0IBw5bJa6ux7ygqcqNgWFyO9b5+RFA8QRd5DOMKfmUKBshSstCbuTCzHkJ9MWnn+4h6tajLsUtnrKfB/nxwZ53AiHRypiGvPg8T7r7Vax7OwfYGwEHj/rVPkuMX3CrpX9CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298511; c=relaxed/simple;
	bh=de/LfNhCvFuhvXnT0jkrR8/j6YEEsV96AZiESZR/XFg=;
	h=Date:To:From:Subject:Message-Id; b=dzzrTnIiYe7t1D0F6AnxQYl6UVNoejXH4AQGnIPX0SDbJVOUTxboSAXrDJ6mXopIJv5D1YbK/lU2r52qSNqoGxh+TRBt29H5Jgjmvwqfxqhze3Ed8wHMOnr0TdYQKsRMI6qNUyWI3qST0WZ6ekOW1JNIwtK0nJt3l+a36ppN4gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Ba0Gh0G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Ba0Gh0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A15C1F00A3A;
	Wed, 29 Jul 2026 04:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298508;
	bh=xW5UQDeYJL6QTCKVscOpbMxdQlukZdDeQW+7RTdj8MY=;
	h=Date:To:From:Subject;
	b=2Ba0Gh0G6AfORLStMTrhlDmkDt1aYDz/LmHO3wuIwICfKXx47o8/UjoKLG7sYF1n0
	 cM/l7SLfUveCHSoBou+n0RtoBJLzk5p4ngmVGtGRUjaVfROrajlA9NAbB5rSmjF4hw
	 hFOhKuCTLsqotAupJokhXRI6ZSdCJLTvOzjKMkQk=
Date: Tue, 28 Jul 2026 21:15:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,david@kernel.org,imran.f.khan@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-avoid-taking-zone-lock-in-proc-buddyinfo-reads.patch removed from -mm tree
Message-Id: <20260729041508.4A15C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: avoid taking zone lock in /proc/buddyinfo reads
has been removed from the -mm tree.  Its filename was
     mm-vmstat-avoid-taking-zone-lock-in-proc-buddyinfo-reads.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Imran Khan <imran.f.khan@oracle.com>
Subject: mm/vmstat: avoid taking zone lock in /proc/buddyinfo reads
Date: Thu, 4 Jun 2026 21:42:45 +0800

frag_show_print() just reads zone->free_area[order].nr_free, so it can
safely do this without needing the zone->lock.

Pass nolock=true from frag_show(), so that walk_zones_in_node() can skip
the zone->lock acquisition.

Link: https://lore.kernel.org/20260604134245.1580287-1-imran.f.khan@oracle.com
Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-avoid-taking-zone-lock-in-proc-buddyinfo-reads
+++ a/mm/vmstat.c
@@ -1568,7 +1568,7 @@ static void frag_show_print(struct seq_f
 static int frag_show(struct seq_file *m, void *arg)
 {
 	pg_data_t *pgdat = (pg_data_t *)arg;
-	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
+	walk_zones_in_node(m, pgdat, true, true, frag_show_print);
 	return 0;
 }
 
_

Patches currently in -mm which might be from imran.f.khan@oracle.com are


