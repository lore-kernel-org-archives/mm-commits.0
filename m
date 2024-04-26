Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9487604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103970; cv=none; b=UDMXOwOikGBEYPJKqONkyKIO8iY2yste3TG/z/1UbM9zIYx5MU6Nx/bWsU91myGoDl0XSAcjSfTHIK6c9gX/hIap4C6D/xYJYMApCpiHOYdzLVOuYFAQ0dEOXRBfd2Z6qvpbOVU/Wxbnq64/CNt7aasjuLWXv7dYblcEyjAEifQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103970; c=relaxed/simple;
	bh=fKymid9KxDg0V1y7umBy6apkxTQLk2GKWUMSjP8T/8s=;
	h=Date:To:From:Subject:Message-Id; b=k2hNmyN9xEz988iz0FVDXNIZgMiUol72rRs/akgdZw09OXEaWJganXQE6DwBXPrRwfqi70DQ9pLO/xqkRKLCIw7tviBEhPV6Btrw+URT1UiwSOcMzgBuI4E/8pVJ33Cme66Z3f2IViL5utTJZaKTsOjqVQ24eGdSWCUITHc5CFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dc3SodIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dc3SodIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2408C113CD;
	Fri, 26 Apr 2024 03:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103969;
	bh=fKymid9KxDg0V1y7umBy6apkxTQLk2GKWUMSjP8T/8s=;
	h=Date:To:From:Subject:From;
	b=dc3SodIoj3q1YaKrg9xYm1479oBKbXudwmmz0lHUvS131iWWGkn4FSevnlOy0pZpz
	 gcgfmj9LzYEqKgWT7haGLXVVhDlXCDqiiWJtyjep6EN6qB4Vlh/L2WzNVQjLQoesig
	 l/fyEoP9fGaUqRkO7N1fA0t1lfuqgcd0RqNKoaLo=
Date: Thu, 25 Apr 2024 20:59:29 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-compact-kmemleak_object-further.patch removed from -mm tree
Message-Id: <20240426035929.C2408C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: compact kmemleak_object further
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-compact-kmemleak_object-further.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: compact kmemleak_object further
Date: Thu, 7 Mar 2024 14:05:47 -0500

Patch series "mm/kmemleak: Minor cleanup & performance tuning".

This series contains 2 simple cleanup patches to slightly reduce memory
and performance overhead.


This patch (of 2):

With commit 56a61617dd22 ("mm: use stack_depot for recording kmemleak's
backtrace"), the size of kmemleak_object has been reduced by 128 bytes for
64-bit arches.  The replacement "depot_stack_handle_t trace_handle" is
actually just 4 bytes long leaving a hole of 4 bytes.  By moving up
trace_handle to another existing 4-byte hold, we can save 8 more bytes
from kmemleak_object reducing its overall size from 248 to 240 bytes.

Link: https://lkml.kernel.org/r/20240307190548.963626-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20240307190548.963626-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-compact-kmemleak_object-further
+++ a/mm/kmemleak.c
@@ -158,9 +158,9 @@ struct kmemleak_object {
 	int count;
 	/* checksum for detecting modified objects */
 	u32 checksum;
+	depot_stack_handle_t trace_handle;
 	/* memory ranges to be scanned inside an object (empty for all) */
 	struct hlist_head area_list;
-	depot_stack_handle_t trace_handle;
 	unsigned long jiffies;		/* creation timestamp */
 	pid_t pid;			/* pid of the current task */
 	char comm[TASK_COMM_LEN];	/* executable name */
_

Patches currently in -mm which might be from longman@redhat.com are


