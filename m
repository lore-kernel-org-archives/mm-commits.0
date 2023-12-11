Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AE15246
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vofaMw1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E745FC433C7;
	Mon, 11 Dec 2023 00:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256141;
	bh=98omT6Fofnjd1EnXacAMBQBf8bnIsh4fJqkz/KNuPnY=;
	h=Date:To:From:Subject:From;
	b=vofaMw1xAH20TE+CqYlnurp3xCkpoLs8Eae3fB61C7upMUCL5dxiVQYai3b9gmvR5
	 4/x5zbYvojqEIHAWu/XGMhhh+eR9AaDHzoUtjIM9PTPFMKm3dSMWi0xJzoHRs31B9K
	 g6NYCmYFakjgXPz+0PVaEwbwfUQVJnQNPD/x+xhU=
Date: Sun, 10 Dec 2023 16:55:40 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ddrokosov@salutedevices.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch removed from -mm tree
Message-Id: <20231211005540.E745FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: add reminder comment for the memcg v2 events
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-reminder-comment-for-the-memcg-v2-events.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Rokosov <ddrokosov@salutedevices.com>
Subject: mm: memcg: add reminder comment for the memcg v2 events
Date: Thu, 23 Nov 2023 10:19:45 +0300

To maintain the correct state, it is important to ensure that events for
the memory cgroup v2 are aligned with the sample cgroup codes.

Link: https://lkml.kernel.org/r/20231123071945.25811-4-ddrokosov@salutedevices.com
Signed-off-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memcontrol.c~mm-memcg-add-reminder-comment-for-the-memcg-v2-events
+++ a/mm/memcontrol.c
@@ -6783,6 +6783,10 @@ static ssize_t memory_max_write(struct k
 	return nbytes;
 }
 
+/*
+ * Note: don't forget to update the 'samples/cgroup/memcg_event_listener'
+ * if any new events become available.
+ */
 static void __memory_events_show(struct seq_file *m, atomic_long_t *events)
 {
 	seq_printf(m, "low %lu\n", atomic_long_read(&events[MEMCG_LOW]));
_

Patches currently in -mm which might be from ddrokosov@salutedevices.com are


