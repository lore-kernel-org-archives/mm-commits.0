Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB57283FE4
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126312; cv=none; b=XZwkUbKuTxV0GMLYLGjhCoOkzdWE/hRkXGSK/W0DqhMJueorQTvbMrRNypeMrHRqja0nA7qBZfbsVGBMWwqA4EyekquYU4gy3A2r/3tm50MvnVXPZ4i6VPfaxaI8uzwRxltY0PCeM5QuvXmhmuYUJTjqFwAnF7NkeAgk9TRo44s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126312; c=relaxed/simple;
	bh=Kr10c7+RU6/9sQ9o12YUggRc4zh7ZA1M+H85r4NBdNI=;
	h=Date:To:From:Subject:Message-Id; b=ulnqPu/pD6kDDeL2aSUAJt/yP5TTy7d77IWxsEWFb8XuhqS6JgvPkV2MjsAz8vsgEq87zA6h1Xm1ZL9hrPWIsSVTfwTmsx2umn0ztEF8uln2sFw8xCxaI8kA6UzecVTLblpVUtlwTghDZCiSCHopjoucwKGUnys7JoSzKc4mXXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qxyNkBGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qxyNkBGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C5AC4CEE3;
	Thu, 10 Jul 2025 05:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126312;
	bh=Kr10c7+RU6/9sQ9o12YUggRc4zh7ZA1M+H85r4NBdNI=;
	h=Date:To:From:Subject:From;
	b=qxyNkBGiq5sKkcpdFNb7qlqKI6W6OhefCpRNG2uY4XDTeNd2QVOeHBG4NfL28HW42
	 U3U3DsH5u/DBf2yoHq7AhLkUEjCQnZn6ogFAWNecKZdopXjUS5dtkqwcoun9caQJLu
	 p7F/pa4xuS+iDblHOvrMqYg79fVf1UYMK8Pl5zM8=
Date: Wed, 09 Jul 2025 22:45:11 -0700
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,surenb@google.com,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,hailong.liu@oppo.com,howlett@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] testing-raix-tree-maple-increase-readers-and-reduce-delay-for-faster-machines.patch removed from -mm tree
Message-Id: <20250710054512.53C5AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: testing/radix-tree/maple: increase readers and reduce delay for faster machines
has been removed from the -mm tree.  Its filename was
     testing-raix-tree-maple-increase-readers-and-reduce-delay-for-faster-machines.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <howlett@gmail.com>
Subject: testing/radix-tree/maple: increase readers and reduce delay for faster machines
Date: Mon, 16 Jun 2025 14:45:19 -0400

Faster machines may not see the initial or updated value in the race
condition.  Reduce the delay so that faster machines are less likely to
fail testing of the race conditions.

Link: https://lkml.kernel.org/r/20250616184521.3382795-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <howlett@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Hailong Liu <hailong.liu@oppo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/radix-tree/maple.c~testing-raix-tree-maple-increase-readers-and-reduce-delay-for-faster-machines
+++ a/tools/testing/radix-tree/maple.c
@@ -35062,7 +35062,7 @@ void run_check_rcu_slowread(struct maple
 
 	int i;
 	void *(*function)(void *);
-	pthread_t readers[20];
+	pthread_t readers[30];
 	unsigned int index = vals->index;
 
 	mt_set_in_rcu(mt);
@@ -35080,14 +35080,14 @@ void run_check_rcu_slowread(struct maple
 		}
 	}
 
-	usleep(5); /* small yield to ensure all threads are at least started. */
+	usleep(3); /* small yield to ensure all threads are at least started. */
 
 	while (index <= vals->last) {
 		mtree_store(mt, index,
 			    (index % 2 ? vals->entry2 : vals->entry3),
 			    GFP_KERNEL);
 		index++;
-		usleep(5);
+		usleep(2);
 	}
 
 	while (i--)
@@ -35098,6 +35098,7 @@ void run_check_rcu_slowread(struct maple
 	MT_BUG_ON(mt, !vals->seen_entry3);
 	MT_BUG_ON(mt, !vals->seen_both);
 }
+
 static noinline void __init check_rcu_simulated(struct maple_tree *mt)
 {
 	unsigned long i, nr_entries = 1000;
_

Patches currently in -mm which might be from howlett@gmail.com are


