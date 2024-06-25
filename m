Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C3833C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293194; cv=none; b=bln1gSQfPkbwrG1jww3oYa9C1K0KxtIu798FdSEG/EfTVmY1Itp/cjqO3iQ0M53sF85/gW54x8/UxYPZKvbf+EcKNrMb2L1wnQt+JmqlZIWrNUmndohdv4DoLvNTLwLdmxnLOsP707CyPjS1jaamHWnV1kVxPZWoBqSOzUGJXeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293194; c=relaxed/simple;
	bh=djbOCiDU/6QSuBhfadpiODVsarBslr4MIQbMSYv6ENE=;
	h=Date:To:From:Subject:Message-Id; b=Z/z8nD5mCUJa7Io4sdeEHNcMap36dwOfVjoO93H3WjlYkqVfQXhuYArNCFgQ/WjGYqL/YgSmTKtd8P5R4TDJ5KJGbVDTuOntnEx8dkLBF32hmT4Xr7Cm+4gUr+m5I9k5IheRbXs2OSy5eU11cg373FQkGlorZyV4wy5fa7T75g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hyuXB+Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hyuXB+Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77395C32782;
	Tue, 25 Jun 2024 05:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293194;
	bh=djbOCiDU/6QSuBhfadpiODVsarBslr4MIQbMSYv6ENE=;
	h=Date:To:From:Subject:From;
	b=hyuXB+Vhe695Uq64wBf6VXunm5xbAEEdhh6cx2MOKJ2tP6CxG7njxY5vQxcV9kSbx
	 c17KPfqostd9lkIMX2zX6T4IZ67UYhN9f5kRLH0XSx9NOpUQZUXFxpG2mwx9bG7OWj
	 Bf1OkcimQER5LVio+me0HTBVbW4h3qSjp/deD6sw=
Date: Mon, 24 Jun 2024 22:26:33 -0700
To: mm-commits@vger.kernel.org,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-plistc-enforce-memory-ordering-in-plist_check_list.patch removed from -mm tree
Message-Id: <20240625052634.77395C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/plist.c: enforce memory ordering in plist_check_list
has been removed from the -mm tree.  Its filename was
     lib-plistc-enforce-memory-ordering-in-plist_check_list.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: I Hsin Cheng <richard120310@gmail.com>
Subject: lib/plist.c: enforce memory ordering in plist_check_list
Date: Sun, 26 May 2024 22:01:39 +0800

There exists an iteration over a plist in plist_check_list(), and memory
dependency exists between variables "prev", "next" and "prev->next".  As
plist is used in the scheduling subsystem, we should guarantee the memory
ordering between multiple processors.

Using macro "WRITE_ONCE()" can help us to ensure the memory ordering as
it was stated in "Documentation/memory-barriers.txt".

Link: https://lkml.kernel.org/r/20240526140139.17220-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/plist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/plist.c~lib-plistc-enforce-memory-ordering-in-plist_check_list
+++ a/lib/plist.c
@@ -47,8 +47,8 @@ static void plist_check_list(struct list
 
 	plist_check_prev_next(top, prev, next);
 	while (next != top) {
-		prev = next;
-		next = prev->next;
+		WRITE_ONCE(prev, next);
+		WRITE_ONCE(next, prev->next);
 		plist_check_prev_next(top, prev, next);
 	}
 }
_

Patches currently in -mm which might be from richard120310@gmail.com are


