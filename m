Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B4021A434;
	Sat, 29 Aug 2026 18:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788027443; cv=none; b=sT/D5sXRcX07k9UMKz4aO0V5c4Pi6+q1W9RkATIW0/e5w0dGGQHpWgj9ZG5LVPPh+3oDbatwv+oLKUwVS6vQe0E7LxGeaBAWgrpKaTuYmZIW6+cjGZ0YIcEkQLJiDsy0IQgpZqebve2yRR9pg8EhpsqD/nd5+uqeQ/5rT7lI7Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788027443; c=relaxed/simple;
	bh=dQPI4iRZcursA7vKh1bm5JNK39zFatnVNXcNvhqSdwg=;
	h=Date:To:From:Subject:Message-Id; b=P/Ps+Yu8tV+us0EQZVYsKzCFjsX4WUWpRtesLge8KbrrHfD0GfXLe93GakdXtYoH+i7Vcd+NmChE/tYxTOtpp5eSWFAFrkju2ChuoooTY6Dq0/d+DwMfOicchkCmgK1sa0qRpVOc2ZN65uXcjrxXFi4leKhQrhRIwgH3NXa27lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oW7LVoD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oW7LVoD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5701F000E9;
	Sat, 29 Aug 2026 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788027442;
	bh=2XN1b9eO8GF93JBdqKYVKaa+En9P0gVjOIMyd0U+mE0=;
	h=Date:To:From:Subject;
	b=oW7LVoD4OtNyOKFCQLmd37MFIU3/q/Gre+3EJkrPAbhAyZ6p5i2byNH5/P+cmzJe7
	 tum+pktNq2kS9HbwMiOXYoVEljJm/VARUbLNYqFEHIvpNSRYr41+YuhVKrpIRGa1FD
	 erpDXjNDuvE+5oirvSiV3GV30LZRnfP7SVYslY+s=
Date: Sat, 29 Aug 2026 11:17:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tz2294@columbia.edu,trond.myklebust@hammerspace.com,stable@vger.kernel.org,jack@suse.cz,baohua@kernel.org,axboe@kernel.dk,qiwenjie@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-retain-mapped-dropbehind-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20260829181721.DD5701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: filemap: retain mapped dropbehind folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-filemap-retain-mapped-dropbehind-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-retain-mapped-dropbehind-folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wenjie Qi <qiwenjie@xiaomi.com>
Subject: mm: filemap: retain mapped dropbehind folios
Date: Sun, 30 Aug 2026 01:36:12 +0800

Fault-around can map ready dropbehind folios without going through the
normal page-cache lookup that clears dropbehind.  A mapping represents a
competing cached user, so retain the folio instead of forcibly unmapping
it when writeback completes.

For a mapped folio, folio_unmap_invalidate() can call
unmap_mapping_folio(), which takes i_mmap_rwsem and may sleep.  Retaining
mapped folios avoids this path when folio_end_dropbehind() runs in
non-preemptible task context.

Unmapped dropbehind folios continue through the existing invalidation path.

Link: https://lore.kernel.org/4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com
Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Cc: Barry Song <baohua@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-retain-mapped-dropbehind-folios
+++ a/mm/filemap.c
@@ -1616,7 +1616,7 @@ static void filemap_end_dropbehind(struc
 		return;
 	if (!folio_test_clear_dropbehind(folio))
 		return;
-	if (mapping)
+	if (mapping && !folio_mapped(folio))
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 
_

Patches currently in -mm which might be from qiwenjie@xiaomi.com are

mm-filemap-retain-mapped-dropbehind-folios.patch

