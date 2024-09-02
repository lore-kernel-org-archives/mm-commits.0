Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4BF82876
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247856; cv=none; b=SGYqLEi8ajB4t4/ogS7CdjNfdT2pNo4u9mwl/pVCno6vr6ANWVeAEB8pVsGGfkEhl99bUCoJKJSvVk9yj6fjdm0BJY3XiN1mMvLceCyfd9OuhXg1reBTMSaNEcS8Gm75jRdRZM/SBhxrarzXtJAiZKbzOMu87mVb/2c6wsFQMrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247856; c=relaxed/simple;
	bh=JW6W3dtprPWjPAROz0nTE/I82JDU0YYFrW5KhL2l9yU=;
	h=Date:To:From:Subject:Message-Id; b=KeQsn53vxLKYA0odPDXcxypbDmgZKz80bYIw1DCA4DUjOQNQ3TvT2xE9Bh0ZcHn2Xb9LIBUBS03qjblKM9roHnLt7rwD7cRAJKs2ChKUAmyuKJW5GGsM5FO9Xmi3BCLC6xWBP8ZE3fAn+R+5FQVhWM1x++XfcvJjUA/IgkSNKGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GVau0cvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GVau0cvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43102C4CEC2;
	Mon,  2 Sep 2024 03:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247856;
	bh=JW6W3dtprPWjPAROz0nTE/I82JDU0YYFrW5KhL2l9yU=;
	h=Date:To:From:Subject:From;
	b=GVau0cvGJvbUwdu6foFImmD/KxfvAvI6hKMRdHLUlIcYASoI6SAl9vPYmT1Ir9wuG
	 XuPlXkdkMeL8vIP6Sj8kCAJLutfXRRzwYxnW4q6XUzJUNnZFjxopvOn4lIPowG6sQq
	 kePLAlcFqNmf/ZsKAV6cjEV+50Ur62WMXp6VJuTI=
Date: Sun, 01 Sep 2024 20:30:55 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-make-pgpgin-and-pgpgout-v1-only.patch removed from -mm tree
Message-Id: <20240902033056.43102C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: make PGPGIN and PGPGOUT v1 only
has been removed from the -mm tree.  Its filename was
     memcg-make-pgpgin-and-pgpgout-v1-only.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: make PGPGIN and PGPGOUT v1 only
Date: Wed, 14 Aug 2024 22:04:53 -0700

Currently PGPGIN and PGPGOUT are used and exposed in the memcg v1 only
code.  So, let's put them under CONFIG_MEMCG_V1.

Link: https://lkml.kernel.org/r/20240815050453.1298138-8-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-make-pgpgin-and-pgpgout-v1-only
+++ a/mm/memcontrol.c
@@ -408,8 +408,10 @@ unsigned long lruvec_page_state_local(st
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
+#ifdef CONFIG_MEMCG_V1
 	PGPGIN,
 	PGPGOUT,
+#endif
 	PGSCAN_KSWAPD,
 	PGSCAN_DIRECT,
 	PGSCAN_KHUGEPAGED,
@@ -1429,10 +1431,11 @@ static void memcg_stat_format(struct mem
 		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
+#ifdef CONFIG_MEMCG_V1
 		if (memcg_vm_event_stat[i] == PGPGIN ||
 		    memcg_vm_event_stat[i] == PGPGOUT)
 			continue;
-
+#endif
 		seq_buf_printf(s, "%s %lu\n",
 			       vm_event_name(memcg_vm_event_stat[i]),
 			       memcg_events(memcg, memcg_vm_event_stat[i]));
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


