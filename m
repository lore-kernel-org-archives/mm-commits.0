Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A6F2C0290
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 20:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769458052; cv=none; b=u5PDsR/UpkHaS1g/iJ0k9Jil46Wtezz4GbULHEX9m8MZncwIH6qH7bDH7rCkNOdmsNz05Aor/Yf5IRNsDlB4g3nT7SVGvZlgquCH/cpwV6k/rrlTB+DTgqwkrUR/M5OPM4YY7Vp57L8KOpzxW6uUhSfkNaDIiH/2UMfNntqGklk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769458052; c=relaxed/simple;
	bh=tu1Ub4MYheRHPWaOXalamqvk3gOvH5CzHvX4JfH4VJc=;
	h=Date:To:From:Subject:Message-Id; b=qqxRFbTC072rneyfJb8WlfCwJz4ovm/71x2p/YGVvjApUkW8wlPxK61ItUkYbpchwU+MKenJ4Z5v6sK7AWkiV11APLJexKGdIF6ZLeqh6zgGTnI7PeQ0r0nDC1KebNjHC2UG8v3OqPpmRsgZMkOQ+WkPoZkSGaaDyLt2JgfVifc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=taXYI3y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="taXYI3y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28AEC116C6;
	Mon, 26 Jan 2026 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769458052;
	bh=tu1Ub4MYheRHPWaOXalamqvk3gOvH5CzHvX4JfH4VJc=;
	h=Date:To:From:Subject:From;
	b=taXYI3y014q9lnL2W4jDSGVXiK/s2ecsXvPyknVphxb75nIRicfiOSn5w4mlcRoeN
	 QM59X/XatNs6pgo45yBN1vOER/vfddfYrR9AHoXAzKuJUvCbpdx2uiwr35yMbf4rjN
	 Byl/Z4tj2Nmpx4HT2JlfsKroot8p677mMb6EvzkE=
Date: Mon, 26 Jan 2026 12:07:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tujinjiang@huawei.com,dev.jain@arm.com,david@kernel.org,shardul.b@mpiricsoftware.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xarray-free-unused-spare-node-in-xas_create_range.patch added to mm-new branch
Message-Id: <20260126200731.E28AEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: xarray: free unused spare node in xas_create_range()
has been added to the -mm mm-new branch.  Its filename is
     lib-xarray-free-unused-spare-node-in-xas_create_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-xarray-free-unused-spare-node-in-xas_create_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
Subject: lib: xarray: free unused spare node in xas_create_range()
Date: Thu, 4 Dec 2025 19:56:25 +0530

xas_create_range() is typically called in a retry loop that uses
xas_nomem() to handle -ENOMEM errors.  xas_nomem() may allocate a spare
xa_node and store it in xas->xa_alloc for use in the retry.

When the lock is dropped after xas_create_range() another thread can
expand the xarray tree in the meantime.  On the next retry,
xas_create_range() can then succeed without consuming the spare node
stored in xas->xa_alloc.  If the function returns without freeing this
spare node, it leaks.

xas_create_range() calls xas_create() multiple times in a loop for
different index ranges.  A spare node that isn't needed for one range
iteration might be needed for the next, so we cannot free it after each
xas_create() call.  We can only safely free it after xas_create_range()
completes.

Fix this by calling xas_destroy() at the end of xas_create_range() to free
any unused spare node.  This makes the API safer by default and prevents
callers from needing to remember cleanup.

This fixes a memory leak in mm/khugepaged.c and potentially other callers
that use xas_nomem() with xas_create_range().

Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
Link: https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
Link: https://lkml.kernel.org/r/20251204142625.1763372-1-shardul.b@mpiricsoftware.com
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/xarray.c~lib-xarray-free-unused-spare-node-in-xas_create_range
+++ a/lib/xarray.c
@@ -744,11 +744,16 @@ restore:
 	xas->xa_shift = shift;
 	xas->xa_sibs = sibs;
 	xas->xa_index = index;
-	return;
+	goto cleanup;
+
 success:
 	xas->xa_index = index;
 	if (xas->xa_node)
 		xas_set_offset(xas);
+
+cleanup:
+	/* Free any unused spare node from xas_nomem() */
+	xas_destroy(xas);
 }
 EXPORT_SYMBOL_GPL(xas_create_range);
 
_

Patches currently in -mm which might be from shardul.b@mpiricsoftware.com are

lib-xarray-free-unused-spare-node-in-xas_create_range.patch

