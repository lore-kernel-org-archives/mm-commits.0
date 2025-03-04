Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465BB1A83F9
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741055825; cv=none; b=pnx0ZBLlWVwZUC8d+vDqqeBsTAATAlDtzIUsactWjHMpdYeNh2HddoF5yMTyMBwCDhJUD1QV8LGO1e7h9/zVIWKJNkxDJoBfuknnUhvjUz6ivaw1suL22QoFwOj24wmQMUx9uV6L2eYeckI+wRGqSCuQrdTZHo01hsOAsAuLX58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741055825; c=relaxed/simple;
	bh=KyTpjcQp7fhyXXHbV4aV6rclGXksJhhyTK23M3lF/5A=;
	h=Date:To:From:Subject:Message-Id; b=pRoOytvJW1y73SJSvpvo+shVYKzvnJOdOKuB9MtYMa1N1jGlrdePxHwCNVGLGFN1LJRBtrQUzWU3/rqyL7wqEk6hqvAKOwHy62NAVBElanP8wrEQ0bbcLBrMW3ypvtAyXg34nCy2uxVF9nuayPszwQ/XYPhtOow62AN3XFVLWx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2VrC5h7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2VrC5h7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB40C4CEEA;
	Tue,  4 Mar 2025 02:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741055824;
	bh=KyTpjcQp7fhyXXHbV4aV6rclGXksJhhyTK23M3lF/5A=;
	h=Date:To:From:Subject:From;
	b=2VrC5h7t1PWOGPM23m6y4gaU2vj5N163+WLmuHlGlsU1LBmWN6M7sd1FwxdBBnC4u
	 vNGdkqTxUVek4HdqDLU1DI9KZpIStaJlHKXkNgKGDFZ6OOshMtYx5cwwoHbRhNzfUL
	 GNsw4aRDjEsb1W/9hRKHxtogis0daljKAURQ/F3g=
Date: Mon, 03 Mar 2025 18:37:04 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tytso@mit.edu,mjguzik@gmail.com,david@fromorbit.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-move-prefaulting-out-of-hot-write-path.patch added to mm-hotfixes-unstable branch
Message-Id: <20250304023704.8DB40C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: filemap: move prefaulting out of hot write path
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     filemap-move-prefaulting-out-of-hot-write-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-move-prefaulting-out-of-hot-write-path.patch

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
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: filemap: move prefaulting out of hot write path
Date: Fri, 28 Feb 2025 12:37:22 -0800

There is a generic anti-pattern that shows up in the VFS and several
filesystems where the hot write paths touch userspace twice when they
could get away with doing it once.

Dave Chinner suggested that they should all be fixed up[1].  I agree[2]. 
But, the series to do that fixup spans a bunch of filesystems and a lot of
people.  This patch fixes common code that absolutely everyone uses.  It
has measurable performance benefits[3].

I think this patch can go in and not be held up by the others.

I will post them separately to their separate maintainers for
consideration. But, honestly, I'm not going to lose any sleep if
the maintainers don't pick those up.

1. https://lore.kernel.org/all/Z5f-x278Z3wTIugL@dread.disaster.area/
2. https://lore.kernel.org/all/20250129181749.C229F6F3@davehans-spike.ostc.intel.com/
3. https://lore.kernel.org/all/202502121529.d62a409e-lkp@intel.com/


This patch:

There is a bit of a sordid history here. I originally wrote
998ef75ddb57 ("fs: do not prefault sys_write() user buffer pages")
to fix a performance issue that showed up on early SMAP hardware.
But that was reverted with 00a3d660cbac because it exposed an
underlying filesystem bug.

This is a reimplementation of the original commit along with some
simplification and comment improvements.

The basic problem is that the generic write path has two userspace
accesses: one to prefault the write source buffer and then another to
perform the actual write. On x86, this means an extra STAC/CLAC pair.
These are relatively expensive instructions because they function as
barriers.

Keep the prefaulting behavior but move it into the slow path that gets
run when the write did not make any progress. This avoids livelocks
that can happen when the write's source and destination target the
same folio. Contrary to the existing comments, the fault-in does not
prevent deadlocks. That's accomplished by using an "atomic" usercopy
that disables page faults.

The end result is that the generic write fast path now touches
userspace once instead of twice.

0day has shown some improvements on a couple of microbenchmarks:

	https://lore.kernel.org/all/202502121529.d62a409e-lkp@intel.com/

Link: https://lkml.kernel.org/r/20250228203722.CAEB63AC@davehans-spike.ostc.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/yxyuijjfd6yknryji2q64j3keq2ygw6ca6fs5jwyolklzvo45s@4u63qqqyosy2/
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/mm/filemap.c~filemap-move-prefaulting-out-of-hot-write-path
+++ a/mm/filemap.c
@@ -4170,17 +4170,6 @@ retry:
 		bytes = min(chunk - offset, bytes);
 		balance_dirty_pages_ratelimited(mapping);
 
-		/*
-		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 */
-		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
-			status = -EFAULT;
-			break;
-		}
-
 		if (fatal_signal_pending(current)) {
 			status = -EINTR;
 			break;
@@ -4198,6 +4187,12 @@ retry:
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_folio(folio);
 
+		/*
+		 * Faults here on mmap()s can recurse into arbitrary
+		 * filesystem code. Lots of locks are held that can
+		 * deadlock. Use an atomic copy to avoid deadlocking
+		 * in page fault handling.
+		 */
 		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
 		flush_dcache_folio(folio);
 
@@ -4223,6 +4218,16 @@ retry:
 				bytes = copied;
 				goto retry;
 			}
+
+			/*
+			 * 'folio' is now unlocked and faults on it can be
+			 * handled. Ensure forward progress by trying to
+			 * fault it in now.
+			 */
+			if (fault_in_iov_iter_readable(i, bytes) == bytes) {
+				status = -EFAULT;
+				break;
+			}
 		} else {
 			pos += status;
 			written += status;
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

filemap-move-prefaulting-out-of-hot-write-path.patch

