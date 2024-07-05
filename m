Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2B9C15B
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 01:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720141635; cv=none; b=kGfYtwFMahtDXZttmrYitdGFw0jM0RtQY2EnRZXMt/1o4Uu3H87beVe9dUNKVJ5Q/QjGMzunfzIagrnF9K4B937CiVXHGv7KZ3UIRGZMEIKTrNZYHYqkohXTeqYzMgRg56ZR5iqpbTxPQVXI+jZ7G9F1Vu6TvNHlqS5Yjo65jFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720141635; c=relaxed/simple;
	bh=Q9W5Pj3t3mcFj9+qs9z7t0uQNbXTF5T6nayhtoVBxlE=;
	h=Date:To:From:Subject:Message-Id; b=KXs5Ax9btAsKufnPcuAMFHmAuKiJdMsmXwxQEWQkisCa9egG+Bt2X34JKvHGMV8+v/T7m50NloRnnpQog8KA3MKYl/cdxgqGG5zlhd64YFnrPxMZ5Xg6aZGshpVbKBRdOg3NZD3c1gnRNJknzOzo94n72HOKmXMIDwHpoWUndlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gsMLq+ZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gsMLq+ZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D8DC3277B;
	Fri,  5 Jul 2024 01:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720141635;
	bh=Q9W5Pj3t3mcFj9+qs9z7t0uQNbXTF5T6nayhtoVBxlE=;
	h=Date:To:From:Subject:From;
	b=gsMLq+ZOTJGGsn7tyNPodslAynO+BD601mkkOv1YctbNcsRj22JYBOQk8KpyvVGrC
	 ineKPLINlVksbNp1GRAElHt6s4wuDiXx40lJ8jL2WMr2I1OInkbRMz+AK/wCjMgUu+
	 Mt9zkZx90MwWXAJPn3uwpSOlyAOY0qf40RgTLnGI=
Date: Thu, 04 Jul 2024 18:07:14 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-remove-redundant-seq_buf_has_overflowed.patch removed from -mm tree
Message-Id: <20240705010715.70D8DC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: remove redundant seq_buf_has_overflowed()
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-redundant-seq_buf_has_overflowed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm: memcg: remove redundant seq_buf_has_overflowed()
Date: Wed, 26 Jun 2024 09:42:32 +0000

Both the end of memory_stat_format() and memcg_stat_format() will call
WARN_ON_ONCE(seq_buf_has_overflowed()).  However, memory_stat_format() is
the only caller of memcg_stat_format(), when memcg is on the default
hierarchy, seq_buf_has_overflowed() will be executed twice, so remove the
redundant one.

Link: https://lkml.kernel.org/r/20240626094232.2432891-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-remove-redundant-seq_buf_has_overflowed
+++ a/mm/memcontrol.c
@@ -1476,9 +1476,6 @@ static void memcg_stat_format(struct mem
 			       vm_event_name(memcg_vm_event_stat[i]),
 			       memcg_events(memcg, memcg_vm_event_stat[i]));
 	}
-
-	/* The above should easily fit into one page */
-	WARN_ON_ONCE(seq_buf_has_overflowed(s));
 }
 
 static void memory_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-hugetlb_cgroup-introduce-peak-and-rsvdpeak-to-v2.patch

