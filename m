Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E710328DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489824; cv=none; b=TGrZXJr7G4cy8MEhwfQp2XYVuNJNXj6KL+bfZh5GcYNt0WMJu1FGdT8lX1FG9DN76MbPQx48az9fvkY4Y40LPLiBrgfhGSZ3XXT1yI9p6itnqe7UhxSUB4BhVoR/oN67lhhqPVAi/9/l0jsXtPHRSkc0jnpW9qoiGTjoF7lG5Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489824; c=relaxed/simple;
	bh=eccFHCTrHpREqXHTZwBHez2DAFA+eghWEEM0H28DQN4=;
	h=Date:To:From:Subject:Message-Id; b=jfiF0xFO9ERYHg7HwC7Yivj7/HKfSRB+5mbiRvtDXuPBfZi7SVpKpbvsQHyHi+ptpnziAK0cQStOQGxI3xKKy2p/zl474g8AJnA3oghBFIGXcwF791mFixeSGEoqaoh3s4K19hdA+yS2UEGs7/lp5WdJudOCGuzhzlwRTGmOuaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bTG84WwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bTG84WwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC957C4CEE7;
	Sun, 21 Sep 2025 21:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489823;
	bh=eccFHCTrHpREqXHTZwBHez2DAFA+eghWEEM0H28DQN4=;
	h=Date:To:From:Subject:From;
	b=bTG84WwFYp6ScmJFEU6FeHjftBIcejEywxLbvKRsnqNkG92sT152pv7EJnU9x3HCF
	 GQ6ltiWZvI7NrpC78x6bQExdyZHg2XvYIhrH894JvSd3/+YHcAFPfmOzIO1gQIHZeg
	 H0UnM+9boPAN8qsaEIhdPF6bFvwjheQtS9KvVNR8=
Date: Sun, 21 Sep 2025 14:23:43 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm-percpu-km-drop-nth_page-usage-within-single-allocation.patch removed from -mm tree
Message-Id: <20250921212343.BC957C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm/percpu-km: drop nth_page() usage within single allocation
has been removed from the -mm tree.  Its filename was
     mm-mm-percpu-km-drop-nth_page-usage-within-single-allocation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/mm/percpu-km: drop nth_page() usage within single allocation
Date: Mon, 1 Sep 2025 17:03:35 +0200

We're allocating a higher-order page from the buddy.  For these pages
(that are guaranteed to not exceed a single memory section) there is no
need to use nth_page().

Link: https://lkml.kernel.org/r/20250901150359.867252-15-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-km.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu-km.c~mm-mm-percpu-km-drop-nth_page-usage-within-single-allocation
+++ a/mm/percpu-km.c
@@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_ch
 	}
 
 	for (i = 0; i < nr_pages; i++)
-		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+		pcpu_set_page_chunk(pages + i, chunk);
 
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages);
_

Patches currently in -mm which might be from david@redhat.com are


