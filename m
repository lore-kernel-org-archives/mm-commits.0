Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EFF127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824920; cv=none; b=m7LFBweJIJ6WAe8a+4CDzf/ecNKHmQWEHg7CoDhJtP56cxAV/Ner/0kOlRdX5iKM8nMNgoIdaix9nrx9+uSOPXLCrVXwhFggOlvoslsow6Yghv8+yhg48w9M0F5i43xzEIsVYc4pTUlqYm0ctD3019EZq0NKQ/B6AGbXZyr5TrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824920; c=relaxed/simple;
	bh=yGS8PGbz4To07LdibWqv/t6QevwRNjHsY4PG76mjprQ=;
	h=Date:To:From:Subject:Message-Id; b=MsCtFEVL85PqWg+noC2z6tqmmDiNMZZ/HOxuqSNJg1Aa0tHeuqgcaf9gp0UldkVqYBFF6pmtD0eFf3vh7ZxjKz+QRxWpxedxRGAYwXLS7vrzebyDwTeyDBhWqSznjHTgUT236nK/nwTWBeaE/KAId7xduLY73qhUOw20hQelejw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sBz34v6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sBz34v6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17166C32782;
	Fri, 12 Jul 2024 22:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824920;
	bh=yGS8PGbz4To07LdibWqv/t6QevwRNjHsY4PG76mjprQ=;
	h=Date:To:From:Subject:From;
	b=sBz34v6vot8j/doSWPK0zm8RnRjgaYw5fXp4ABUSCFIdywh5uZie2t+FqD1bgw2tc
	 r+fmMm3NJxuOO5IHq41L9dDVTQnT99+419KAvYpLQTuMYWdNc0dpatx/yKGi5IMGvd
	 h8dKH/L1rS9rwSocWX9stXsbCYa+PS9RNpWCkKLk=
Date: Fri, 12 Jul 2024 15:55:19 -0700
To: mm-commits@vger.kernel.org,dan.carpenter@linaro.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-move-charge-migration-code-to-memcontrol-v1c-fix.patch removed from -mm tree
Message-Id: <20240712225520.17166C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg1: convert charge move flags to unsigned long long
has been removed from the -mm tree.  Its filename was
     mm-memcg-move-charge-migration-code-to-memcontrol-v1c-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: memcg1: convert charge move flags to unsigned long long
Date: Fri, 12 Jul 2024 18:35:14 +0000

Currently MOVE_ANON and MOVE_FILE flags are defined as integers
and it leads to the following Smatch static checker warning:
    mm/memcontrol-v1.c:609 mem_cgroup_move_charge_write()
    warn: was expecting a 64 bit value instead of '~(1 | 2)'

Fix this be redefining them as unsigned long long.

Even though the issue allows to set high 32 bits of mc.flags
to an arbitrary number, these bits are never used, so it doesn't
have any significant consequences.

Link: https://lkml.kernel.org/r/ZpF8Q9zBsIY7d2P9@google.com
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol-v1.c~mm-memcg-move-charge-migration-code-to-memcontrol-v1c-fix
+++ a/mm/memcontrol-v1.c
@@ -44,8 +44,8 @@ static struct mem_cgroup_tree soft_limit
 /*
  * Types of charges to be moved.
  */
-#define MOVE_ANON	0x1U
-#define MOVE_FILE	0x2U
+#define MOVE_ANON	0x1ULL
+#define MOVE_FILE	0x2ULL
 #define MOVE_MASK	(MOVE_ANON | MOVE_FILE)
 
 /* "mc" and its members are protected by cgroup_mutex */
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


