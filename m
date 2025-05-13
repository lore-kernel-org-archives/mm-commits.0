Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F3E1EDA1E
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119242; cv=none; b=IO4ZvD2kInCcz9nLTc128O29nyPpr3tGm1VkCgG6/fmZzzjSBxddfOjmsH5mlOdqZlM9ISY6hLm86WE7hdpp7dnl07Kt1vex14DAvzJR9b2Z7D7G6qW9EEi3vvs0DCZ8bpo/4zDjMO9QxpB+NJLqDaR9Csj+4NpjvBSkeFPWx/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119242; c=relaxed/simple;
	bh=g9bPUvTxWEBSOrKQHBTizrUBVpznJeOBoCopJoxxv8w=;
	h=Date:To:From:Subject:Message-Id; b=RbwyhcomuDu4xEPQNy1kc4sQGFOo6QHv5XEQz5dT9NqGMXmsYm8GSDcDwD1hThIZvrdopNs6+B8IuYo1jocH3dR/0N9y768ZnFIaDFL+D6mLaxwzdFHva0N3dxI1HMmGt3cTokC0Lqn4pQpP5oaikbRnssukCj7Vso+3bTaYYW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZW/yQ8wn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZW/yQ8wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D9CC4CEED;
	Tue, 13 May 2025 06:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119242;
	bh=g9bPUvTxWEBSOrKQHBTizrUBVpznJeOBoCopJoxxv8w=;
	h=Date:To:From:Subject:From;
	b=ZW/yQ8wn06WMQBwXzwemWvlfsyNaZdeLLvlhgt0vYySYxLNCr6W4rkhTGDxyFEhEc
	 MH7y4m4wUHGAVViS7AO6i+o+rEY0qqoJnJlz2QrJhdelVwXPzwholw7wUxPmaluSf3
	 6HwTAcgo3hk9jsyDkopwsOOTvODrCHaC02FY8vdc=
Date: Mon, 12 May 2025 23:54:01 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,siddarthsgml@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-use-long-for-dwregionsize.patch removed from -mm tree
Message-Id: <20250513065402.79D9CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: use long for dwRegionSize
has been removed from the -mm tree.  Its filename was
     selftests-mm-use-long-for-dwregionsize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Siddarth G <siddarthsgml@gmail.com>
Subject: selftests/mm: use long for dwRegionSize
Date: Sun, 27 Apr 2025 15:56:39 +0530

Change the type of 'dwRegionSize' in wp_init() and wp_free() from int to
long to match callers that pass long or unsigned long long values.

wp_addr_range function is left unchanged because it passes 'dwRegionSize'
parameter directly to pagemap_ioctl, which expects an int.

This patch does not fix any actual known issues.  It aligns parameter
types with their actual usage and avoids any potential future issues.

Link: https://lkml.kernel.org/r/20250427102639.39978-1-siddarthsgml@gmail.com
Signed-off-by: Siddarth G <siddarthsgml@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pagemap_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-use-long-for-dwregionsize
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -112,7 +112,7 @@ int init_uffd(void)
 	return 0;
 }
 
-int wp_init(void *lpBaseAddress, int dwRegionSize)
+int wp_init(void *lpBaseAddress, long dwRegionSize)
 {
 	struct uffdio_register uffdio_register;
 	struct uffdio_writeprotect wp;
@@ -136,7 +136,7 @@ int wp_init(void *lpBaseAddress, int dwR
 	return 0;
 }
 
-int wp_free(void *lpBaseAddress, int dwRegionSize)
+int wp_free(void *lpBaseAddress, long dwRegionSize)
 {
 	struct uffdio_register uffdio_register;
 
_

Patches currently in -mm which might be from siddarthsgml@gmail.com are


