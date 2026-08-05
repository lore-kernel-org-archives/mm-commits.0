Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8625C248881
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896551; cv=none; b=omQA9JR1GOE8rkBP70cjDpzEAuR7Kq+ZlfzQ6K3fg+koFTxfK+kkl+3PES1ElXV0/S98eyZvz2nR1lU2WxKqQULC6MxYsS9ZVvqpKbP3MEybtQqvKjzNhiBztg/Wx9FXpy+ytUS2WfbKUCC4nHWafZEE+19d+yGi5/CHbk94r8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896551; c=relaxed/simple;
	bh=dP9nxiBrzHUO3SEB+eTptljrbLFjo/KtVrs6Ggi9qQs=;
	h=Date:To:From:Subject:Message-Id; b=ssY3fUkVYG15JE0GTwZD7QOcz7Vbut1lpnVg/rtXnOgWiT4zzrVPkT6WG28y+2QPGlc4L+F0+Gq/D7bHBxk7vCIWt+PonZBJVCRbor4kY3O0igui4dDl6eTOc4A1cRYHGyU4AZdu+EIy7gFy2qHAp5NkSOf4qOouVax1hyT0p8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YPqUQDe6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YPqUQDe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2ED1F00A3A;
	Wed,  5 Aug 2026 02:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896550;
	bh=86w7bGrE0iDKN6NYmVdWnGnrmyapfYlcfN4z1HMpn/0=;
	h=Date:To:From:Subject;
	b=YPqUQDe680GZgS9/FtxXLKRomCJ+7SjiwFbr6M56u98dlH97ix4aap9Z4upKIzXII
	 GP/4EryC7i0x2dwE+xndnPH79OqAwIOoGOSZK92w1sEu8W5hVnbV65evQRn0TzAAhi
	 wLKa8yElnLJEGBo6C96q5fXe57PUDXH4ZqDiI1UE=
Date: Tue, 04 Aug 2026 19:22:29 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,yingfu.zhou@shopee.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,jiayuan.chen@linux.dev,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-bail-out-memorymax-when-memcg-is-dying.patch removed from -mm tree
Message-Id: <20260805022230.3E2ED1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: bail out memory.max when memcg is dying
has been removed from the -mm tree.  Its filename was
     memcg-bail-out-memorymax-when-memcg-is-dying.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: memcg: bail out memory.max when memcg is dying
Date: Thu, 2 Jul 2026 20:02:28 +0800

memory.max has the same high-latency reclaim loop as memory.high, and may
additionally invoke the OOM killer on a cgroup that is already going away,
further delaying its removal.

Mitigate this by bailing out of the loop once memcg_is_dying().

Link: https://lore.kernel.org/20260702120235.376752-3-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memcontrol.c~memcg-bail-out-memorymax-when-memcg-is-dying
+++ a/mm/memcontrol.c
@@ -4854,6 +4854,10 @@ static ssize_t memory_max_write(struct k
 		if (signal_pending(current))
 			break;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are


