Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5506734545
	for <mm-commits@vger.kernel.org>; Mon, 16 Jun 2025 23:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750116172; cv=none; b=Da74I1LaqDPHIEHJKAY9QMKYVrSgJ1iiuftHnBnDhokSZ0QxZ1OJkU6kuNPVe2NKibbAZonJmEgF8q164WBmZpxxW3nc8pwkyfMfOICXkumNF8kxBUr9Y2+lDrlJc4zhgJikR5fuPVapJEjkPCV7+92R40b63xaMQeIEEhSx8y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750116172; c=relaxed/simple;
	bh=0JEjIOl1cgJPNmGsNgX/paIkqX8jwdPWAKUCTTtSP94=;
	h=Date:To:From:Subject:Message-Id; b=lJdFrVDWWzymHAL82FNbofBXW57DvCkFMlilRZGgaq2Ejkto4XBhnWvLueu9hZelA8G4RbXES5DPOo1z8/EwB+plJYQsyU/+RcPk5uFY3kB326sFSff8/764gE9Ncf/wYNMMnKhKMP8S4CV6jAYM1ogJQGU3Ij9aBRkVQbK0U+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S4tqHSWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S4tqHSWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3653C4CEEA;
	Mon, 16 Jun 2025 23:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750116171;
	bh=0JEjIOl1cgJPNmGsNgX/paIkqX8jwdPWAKUCTTtSP94=;
	h=Date:To:From:Subject:From;
	b=S4tqHSWtj6bebyHqNiBD7Mhx3qo1fdalUEbsFn/bXodrhNuLQi3ubXsuk1yyVr3+n
	 41LZqy1O0baBEFKxQovSBuiOXm/ZLJhMbPLpEUFEXKzF2YvpTr5j4ystTc/QZUWYrH
	 fAbfiSOPvKzf7VhZXiYC0hrGCHQbz1wApDntUEOY=
Date: Mon, 16 Jun 2025 16:22:51 -0700
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,willy@infradead.org,surenb@google.com,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,hailong.liu@oppo.com,howlett@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + testing-raix-tree-maple-increase-readers-and-reduce-delay-for-faster-machines.patch added to mm-new branch
Message-Id: <20250616232251.C3653C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: testing/raix-tree/maple: increase readers and reduce delay for faster machines
has been added to the -mm mm-new branch.  Its filename is
     testing-raix-tree-maple-increase-readers-and-reduce-delay-for-faster-machines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/testing-raix-tree-maple-increase-readers-and-reduce-delay-for-faster-machines.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Liam R. Howlett" <howlett@gmail.com>
Subject: testing/raix-tree/maple: increase readers and reduce delay for faster machines
Date: Mon, 16 Jun 2025 14:45:19 -0400

Faster machines may not see the initial or updated value in the race
condition.  Reduce the delay so that faster machines are less likely to
fail testing of the race conditions.

Link: https://lkml.kernel.org/r/20250616184521.3382795-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <howlett@gmail.com>
Cc: Hailong Liu <hailong.liu@oppo.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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

testing-raix-tree-maple-increase-readers-and-reduce-delay-for-faster-machines.patch

