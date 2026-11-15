Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712652;
	b=fldf8RhmNhIsbOJjLkYFLo6QZk3knUkcCdWhVZM0HkVlMA1j+9pRT6BeaW1zhkUTSK46
	 7BnFHPuMTwPcuVRZmFfMKPGG/dSEr/TMtXM85uGzs4RtnjDmNPFMhu5WhWlV7N/2jhcZy
	 glYO3sBGliUoH5EN1a7OLfjvn5Z8QnrHLZV5/0n5QmxurJKKWIkRPbDfzDodAS6TmaVoN
	 h5yGWoR+nFl25bRgumiucPTdW+q7uOMS0d1NJrlRV/okF1esYTOHlINXhpQaKeiJak48t
	 v3G0o/kok9JzHAt7Y7zEDrQ+eBBt0Pw49emY561VRFwHqKDry83zMsEGRw5cKSiH/VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712652;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pKgiMRhc0jkYmr/7+BMWHOOl/NccrVcjN9Qo1bIeFvk=;
	b=lTQbPs3VzIpRbV0HfAsOKdq+pi+J1TTMBtrH3k2otV5Ch9hFr/40eO8F2jYDx8RCsa87
	 cdqZzThrpO7tQgd+l2mPhObN7x3lXhS9kgMPqKkTPmhdXoR70c1kR2G23UwCHEQtaGE4M
	 RxLEMNmAEocRq5aR8VpmFg5Q6tMzjjc+Kzuna4mgl+VT99mznqXW1LquGmLlx26kmgpVu
	 y4+mfGzdoLzcSC8lJnMkEe1Pl1UA/771W0iryhGFK4fVZGKuydxj+a4vYgWsE2K1z5BjM
	 XsuPubCMy79g9ERTpKfrqpwPDjUluF35A+1hQ5jFANuiVvq54rNsHFSJXS64zDskvFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LVgmlNRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77991606A323
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 03:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LVgmlNRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE641F000C4;
	Sun, 15 Nov 2026 03:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794712651;
	bh=pKgiMRhc0jkYmr/7+BMWHOOl/NccrVcjN9Qo1bIeFvk=;
	h=Date:To:From:Subject;
	b=LVgmlNRoX8hPSAHYNUoJZJhftoplhp4DDa+wzOqGduSSK+mRPL7rFj0BDFdq4fyN8
	 4uGZ1K1kP8C4LcBefWrULcsVmmxVKaZqazSUXXdkfxgkGl9tTFjRwwTnS8Ol8Ldrje
	 XfTcxASzlCrUgDTfObbPplyxyv+XolUM3OO7BmCw=
Date: Sat, 14 Nov 2026 19:17:31 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tujinjiang@huawei.com,
	janak@mpiricsoftware.com,dev.jain@arm.com,david@kernel.org,
	akpm@linux-foundation.org,shardul.b@mpiricsoftware.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-xarray-free-unused-spare-node-in-xas_create_range.patch added to mm-new branch
Message-Id: <20261115031731.CCE641F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


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

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Date: Thu, 04 Dec 2025 19:56:25 +0530

Patch series "xarray: free unused spare node after range creation".

xas_nomem() can leave a spare xa_node in an XA state when another user
populates the tree before xas_create_range() retries.  Free an unused
spare at the end of range creation, and add a deterministic lib/test_xarray
check for that path.  The fix is first and the test is second.

The test patch was held on both sides of a kernel A/B run while only the
fix was removed and restored.  Without the fix, its spare-node assertion
failed (158825705 of 158825706 checks passed).  With the fix, all
158825706 checks passed.  Both runs used the same verified guest test
script.


This patch (of 2):

xas_create_range() is typically called in a retry loop that uses
xas_nomem() to handle -ENOMEM errors.  xas_nomem() may allocate a spare
xa_node and store it in xas->xa_alloc for use in the retry.

If the lock is dropped after xas_nomem(), another thread can expand the
xarray tree in the meantime.  On the next retry, xas_create_range() can
then succeed without consuming the spare node stored in xas->xa_alloc.  If
the function returns without freeing this spare node, it leaks.

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

Link: https://lore.kernel.org/20251204142625.1763372-1-shardul.b@mpiricsoftware.com
Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
Link: https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (ARM) <david@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: <janak@mpiricsoftware.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>

 lib/xarray.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/xarray.c~lib-xarray-free-unused-spare-node-in-xas_create_range
+++ a/lib/xarray.c
@@ -745,11 +745,16 @@ restore:
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

