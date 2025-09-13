Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF29283FD3
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801145; cv=none; b=mPhvlJWOBEf4uwyN5dAkQ8DSKYx08SyDT6Wr0K9DiAHXQWRFa6QAffTKylKN7PDcoVHCpVJ7blxO37eV6//gJNrTMq6i5SsKfDjN23ZKJu7I3XLc9ouTxBggWQnb0O+w0lxpCVZUtQ89gewtUusJ6yAbI/nguS8ZHdkmhCgzze4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801145; c=relaxed/simple;
	bh=jX0xaXbY3rjyy54Ph5O3ES+aVPFYjI65iE5/wMT5oys=;
	h=Date:To:From:Subject:Message-Id; b=GAMsv07EDetnnUJNOXsB3FyXqcwXE/8xiVBHMuRBWcLhbOof1SkXyB5BpD8+3rSiIq1ik40uYaS6aLmP5kZN8Rj+WMLBGEuYscBVPpwijUkywSRQsguy2HJ0zBBU833dnquT7g+B2SKjDN7W7AtFzNjB3A8Cn8VgSK8OVSff7u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H046WCnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H046WCnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433FDC4CEEB;
	Sat, 13 Sep 2025 22:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801145;
	bh=jX0xaXbY3rjyy54Ph5O3ES+aVPFYjI65iE5/wMT5oys=;
	h=Date:To:From:Subject:From;
	b=H046WCnvehLqgQwucFCc/FxbKIPqaVHTbFOqHcUQqg40lytgP3OCuBtlgjDfv6xKL
	 slrb53qm5OZnoa0rEVwn0onlBjj31/t14gBMz/zoQNr/QdB0igzHhAXfusL8D0xViP
	 Wu6zslHUgpZ3lNeB/k7LzZ+JeDpzM+lGGYHw8a2s=
Date: Sat, 13 Sep 2025 15:05:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,sj@kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mempolicy-clarify-what-zone-reclaim-means-fix.patch removed from -mm tree
Message-Id: <20250913220545.433FDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mempolicy-clarify-what-zone-reclaim-means-fix
has been removed from the -mm tree.  Its filename was
     mempolicy-clarify-what-zone-reclaim-means-fix.patch

This patch was dropped because it was folded into mempolicy-clarify-what-zone-reclaim-means.patch

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mempolicy-clarify-what-zone-reclaim-means-fix
Date: Wed, 6 Aug 2025 06:43:52 -0700

remove the reference to the vm.zone_reclaim_mode sysctl as an ABI

Link: https://lkml.kernel.org/r/20250806134404.2000234-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/mempolicy.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/mempolicy.h~mempolicy-clarify-what-zone-reclaim-means-fix
+++ a/include/uapi/linux/mempolicy.h
@@ -72,8 +72,8 @@ enum {
  * Fallback allocations on the next candidates in the zonelist are considered
  * when reclaim fails to free up enough memory in the current node/zone.
  *
- * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
- * ABI.  New bits are OK, but existing bits should not be changed.
+ * These bit locations are exposed in the vm.zone_reclaim_mode sysctl.
+ * New bits are OK, but existing bits should not be changed.
  */
 #define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
 #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mempolicy-clarify-what-zone-reclaim-means.patch

