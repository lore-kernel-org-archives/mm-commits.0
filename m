Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491D7143738
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291693; cv=none; b=UHwWY/NacxL1PHc2mm6qV8ZG6S3TylVsvQWceaC6WL9l9iFqZEi7aReIPkWzgpVqy0c9OL1Ou1klX6DFm4IcyzB40D8WJ7vXSPQe64hGGu/zoomuwHpEvz/ZXLogJDyskaA3wtFoKUp1olLyyMdqZLOe2dNXstUOjwM0A8ujVNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291693; c=relaxed/simple;
	bh=JacaHmzoqObRavUV/Z4zXi8Oci9L4Q1gZ/ppT6IawiM=;
	h=Date:To:From:Subject:Message-Id; b=vFlH5mITJSbSDLPDK9pLGePo6D8HyaMd0aCXY/kF7lSKppcF8qePoxrLZxH4MyeCNjDMISxbzGdemhjvLmTrPMqsExDbCvMkUQ/nqd5ujIKssnjnwtdN9wss/XpiJ7q+UcEWiamy86OmDF3nYpyAZUAbT78Ldt6cCWNhOsRVawo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xhaMAf8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xhaMAf8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDE7C32782;
	Tue, 25 Jun 2024 05:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291693;
	bh=JacaHmzoqObRavUV/Z4zXi8Oci9L4Q1gZ/ppT6IawiM=;
	h=Date:To:From:Subject:From;
	b=xhaMAf8e2LhpxPacVRqiiUIBzc0n4FkzQ8o5BMGKwuFM3HuSq09AqNtdXF076ba3g
	 lX+nsYzv2jLSGdfNvAngj6YuY5xB+Gvcb57HdtY8RMZ8IO+LrgF2757aS7JE8y9fT5
	 UBl+bhoiJGqoT9PsTVLI6al+DFbeMoCp1IcJwTRY=
Date: Mon, 24 Jun 2024 22:01:32 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,david@redhat.com,abelova@astralinux.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-prevent-accessing-by-index=-1.patch removed from -mm tree
Message-Id: <20240625050133.1EDE7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: prevent accessing by index=-1
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-prevent-accessing-by-index=-1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anastasia Belova <abelova@astralinux.ru>
Subject: mm/memory_hotplug: prevent accessing by index=-1
Date: Thu, 6 Jun 2024 11:06:59 +0300

nid may be equal to NUMA_NO_NODE=-1.  Prevent accessing node_data array by
invalid index with check for nid.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20240606080659.18525-1-abelova@astralinux.ru
Fixes: e83a437faa62 ("mm/memory_hotplug: introduce "auto-movable" online policy")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-prevent-accessing-by-index=-1
+++ a/mm/memory_hotplug.c
@@ -846,7 +846,6 @@ static bool auto_movable_can_online_mova
 	unsigned long kernel_early_pages, movable_pages;
 	struct auto_movable_group_stats group_stats = {};
 	struct auto_movable_stats stats = {};
-	pg_data_t *pgdat = NODE_DATA(nid);
 	struct zone *zone;
 	int i;
 
@@ -857,6 +856,8 @@ static bool auto_movable_can_online_mova
 			auto_movable_stats_account_zone(&stats, zone);
 	} else {
 		for (i = 0; i < MAX_NR_ZONES; i++) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+
 			zone = pgdat->node_zones + i;
 			if (populated_zone(zone))
 				auto_movable_stats_account_zone(&stats, zone);
_

Patches currently in -mm which might be from abelova@astralinux.ru are


