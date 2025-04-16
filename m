Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BCA22F11
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 02:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744769788; cv=none; b=ejuKHec7pH7Lr9kiKyfwoSHtsa9Ona8rFV5fChU9T0igGdJ8QSQz/cy0Ewh2BKtfLawvFWekfDFHP8BhyZjYIabbxIQcKDYWuqTZws2Yc2GuYWfo56JpI/C+7cobCoMxRDK8g1b5NWoXHK4ygmNv6icVx6ZiMBHAQkKfMQu0lkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744769788; c=relaxed/simple;
	bh=cVDBXIuPHQ4FmnNBXYsNDvyJ60TFECQ2FnweQX5Cby8=;
	h=Date:To:From:Subject:Message-Id; b=KZWlyCg7PpS/YjOCHmEJM7CDwnQnB4te+Tqdun2UtpxViPSQFK8m7yFygzys2E8I6BuqRZNYtzzawLjAWqvJ+Xes2oKpYKrXDf/qf5il6thKjP6h/25ILQMO7EnuzDrcufpjTCclMTLW0zJH+YCYg0mkzlI+IQU/GX/S1nAk30M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gbXtxWl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gbXtxWl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB705C4CEE7;
	Wed, 16 Apr 2025 02:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744769787;
	bh=cVDBXIuPHQ4FmnNBXYsNDvyJ60TFECQ2FnweQX5Cby8=;
	h=Date:To:From:Subject:From;
	b=gbXtxWl8z0NWGcxNtV02MbKfcDRqQRPTaDJQzQW32tMmPdfjIWOLikjRSBFJGBzMf
	 cOOY0JmUTlyQFFTOLYxl9ISih61Z56lxl8+2HTHfewUj9z3F6sJS/Pc85aN8ZSjmqz
	 LJYDgzeNeS+pfZLRI7LyPdyk4GNsxycgIVaNabHQ=
Date: Tue, 15 Apr 2025 19:16:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch removed from -mm tree
Message-Id: <20250416021627.CB705C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix
has been removed from the -mm tree.  Its filename was
     memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix.patch

This patch was dropped because it was folded into memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix
Date: Thu Apr 10 10:02:52 PM PDT 2025

fix build: s/flag/flags/ in memcg_hotplug_cpu_dead

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock-fix
+++ a/mm/memcontrol.c
@@ -1964,10 +1964,10 @@ static int memcg_hotplug_cpu_dead(unsign
 
 	stock = &per_cpu(memcg_stock, cpu);
 
-	local_irq_save(flag);
+	local_irq_save(flags);
 	/* stock of a remote dead cpu, no need for stock_lock. */
 	__drain_obj_stock(stock);
-	local_irq_restore(flag);
+	local_irq_restore(flags);
 
 	drain_stock(stock);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
memcg-decouple-memcg_hotplug_cpu_dead-from-stock_lock.patch

