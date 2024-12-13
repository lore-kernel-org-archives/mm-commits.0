Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9827A4A33
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 02:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734056677; cv=none; b=DK7LWwGMaQ75k+IExH5dDqHuE/m74FiAwuPjZ1YkMAs3q+tXhmBWqoqOUz7EBoj5wsnQGCnkOH3+UOrWVvVDJaB3f6k7eTlyZAgK1rg+TY6JnupkghrceeQQok9XcY5AR1mx9WVKgXNFbKcj1AG8mLH5s+wuSXaiH5v2SkwjcuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734056677; c=relaxed/simple;
	bh=EdH0fd9pxnAsWoCG1BynYmlbZRE6SdQ8N52uS6jHKEM=;
	h=Date:To:From:Subject:Message-Id; b=bGLhK5brCbd40StYkKqtp5UPkNAc7joYuLAvEJ3WogKQEZ0xMvqh4OL21NlxcQS7T/Ezea4KjtW/biy6P4pxYu0JasmtIy9sG1/6zsYrpBImg3CB7g9tB6dsPYSLHYRTzsycY8+NLYdm7NmCgzZb39F/5a1ve3VVAxymqQx0bhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QYsfDZxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QYsfDZxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CFFC4CECE;
	Fri, 13 Dec 2024 02:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734056677;
	bh=EdH0fd9pxnAsWoCG1BynYmlbZRE6SdQ8N52uS6jHKEM=;
	h=Date:To:From:Subject:From;
	b=QYsfDZxbMPWTdtvmw9h8uUUCs/yu4MHSoxRSqUNj7SH+MAZqkX0ZegHrnsJlRXVGx
	 aHoVV0ALyCTQomku8nUdz/WqsAKx83/JwYi7gYGzQ8zbD+wuRUBU2Dvdvkkb6mstDU
	 NPtQIElBBDaeBDKa+Z9fngMHHo1v9v+BQXSSG6Qk=
Date: Thu, 12 Dec 2024 18:24:36 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,koct9i@gmail.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-fix-a-w=1-clang-compiler-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20241213022437.15CFFC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: fix a W=1 clang compiler warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmstat-fix-a-w=1-clang-compiler-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-fix-a-w=1-clang-compiler-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Bart Van Assche <bvanassche@acm.org>
Subject: mm/vmstat: fix a W=1 clang compiler warning
Date: Thu, 12 Dec 2024 13:31:26 -0800

Fix the following clang compiler warning that is reported if the kernel is
built with W=1:

./include/linux/vmstat.h:518:36: error: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Werror,-Wenum-enum-conversion]
  518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
      |                               ~~~~~~~~~~~ ^ ~~~


Link: https://lkml.kernel.org/r/20241212213126.1269116-1-bvanassche@acm.org
Fixes: 9d7ea9a297e6 ("mm/vmstat: add helpers to get vmstat item names for each enum type")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/vmstat.h~mm-vmstat-fix-a-w=1-clang-compiler-warning
+++ a/include/linux/vmstat.h
@@ -515,7 +515,7 @@ static inline const char *node_stat_name
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
 }
 
 #if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
_

Patches currently in -mm which might be from bvanassche@acm.org are

mm-vmstat-fix-a-w=1-clang-compiler-warning.patch

