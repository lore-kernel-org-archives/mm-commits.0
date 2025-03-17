Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD21215771
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188263; cv=none; b=iq1YZkH5NRN2EcfScPsSSWpfm6pVeuYSNum1DbeyP27U31TqeEZNJtJBYukmGXQN5i/HzhjORa2rinl/9iXDZO5rauZqIAkFynpTNrjP7zOJWXx069U9Xc+GWnunvcza95sCzAc5dgyhwDXNuNW8AzCiTafJ0tpgUSIl8vq9BtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188263; c=relaxed/simple;
	bh=h1aEpKZ+hqiRwwN0ZpfY/YfXiCE8mtUlsBZzcDU//bg=;
	h=Date:To:From:Subject:Message-Id; b=hwRLXoqz/rQ0DkC9OI1BKLeDLfmSfSRCLVFoElwJi4xH0IUWvNpQBQ/u93Le3pO7dsnH8lTKcq8VQrGuVpWaa24X1p8jinIsZYmUEZmFsOpBFao3uPZj/bdKPJfhgC3biNGbZSiuca0cRkviuF3X/IVtIp0WSVR3G95JHAUge+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BVpQBRNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BVpQBRNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BA4C4CEEC;
	Mon, 17 Mar 2025 05:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188263;
	bh=h1aEpKZ+hqiRwwN0ZpfY/YfXiCE8mtUlsBZzcDU//bg=;
	h=Date:To:From:Subject:From;
	b=BVpQBRNrKP037poh+c+bc/FlLxvmrOwNeM6XhnIXwmOq1A7jbTr/8+FJmCCX5Ro5V
	 Sk8Ee1PULlqBEROXqxNuMQt5hJpHHJzKBzUYDKH5G94Fy7EUw61uNoRZ4PeH0c3SL8
	 ExEN4BujBg7WC5djS/9O7fAnHpgtitWD/fvD+8bo=
Date: Sun, 16 Mar 2025 22:11:02 -0700
To: mm-commits@vger.kernel.org,torvalds@linux-foundation.org,tglx@linutronix.de,peterz@infradead.org,peterx@redhat.com,mingo@redhat.com,luto@kernel.org,jhubbard@nvidia.com,jgg@nvidia.com,jack@suse.cz,david@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,david.laight.linux@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-the-access_ok-call-from-gup_fast_fallback.patch removed from -mm tree
Message-Id: <20250317051103.29BA4C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove the access_ok() call from gup_fast_fallback()
has been removed from the -mm tree.  Its filename was
     mm-remove-the-access_ok-call-from-gup_fast_fallback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Laight <david.laight.linux@gmail.com>
Subject: mm: remove the access_ok() call from gup_fast_fallback()
Date: Sun, 9 Feb 2025 17:47:11 +0000

Historiaclly the code relied on access_ok() to validate the address range.
Commit 26f4c328079d7 added an explicit wrap check before access_ok().
Commit c28b1fc70390d then changed the wrap test to use check_add_overflow().
Commit 6014bc27561f2 relaxed the checks in x86-64's access_ok() and added
  an explicit check for TASK_SIZE here to make up for it.
That left a pointless access_ok() call with its associated 'lfence' that
can never actually fail.

So just delete the test.

Link: https://lkml.kernel.org/r/20250209174711.60889-1-david.laight.linux@gmail.com
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/gup.c~mm-remove-the-access_ok-call-from-gup_fast_fallback
+++ a/mm/gup.c
@@ -2760,7 +2760,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  *
  *  *) ptes can be read atomically by the architecture.
  *
- *  *) access_ok is sufficient to validate userspace address ranges.
+ *  *) valid user addesses are below TASK_MAX_SIZE
  *
  * The last two assumptions can be relaxed by the addition of helper functions.
  *
@@ -3414,8 +3414,6 @@ static int gup_fast_fallback(unsigned lo
 		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;
-	if (unlikely(!access_ok((void __user *)start, len)))
-		return -EFAULT;
 
 	nr_pinned = gup_fast(start, end, gup_flags, pages);
 	if (nr_pinned == nr_pages || gup_flags & FOLL_FAST_ONLY)
_

Patches currently in -mm which might be from david.laight.linux@gmail.com are


