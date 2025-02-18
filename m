Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BB01AF0CB
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860866; cv=none; b=WTPGdJry5IddYuxRhRyBGAMC/NXJCufj5rnkg0mr9pFI0UwerKJkhj3wTkUBrvC0o9hRtBBkfn9fJZjqdwobCfyTJ+I7rM6Zc54BYIHXPihBVkQpjR48OzhjR0C7TZ8VBLLNLh6O2IekEjmTXx05HLwDT34WaMJuOy7okTsyQ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860866; c=relaxed/simple;
	bh=USKp2I3VY3WJhhvQrzWe1Tc3sy5BfWuXB+DGTu+I4OI=;
	h=Date:To:From:Subject:Message-Id; b=eizCBvQNKW9qrpqw2bCEcNkInbIj8YxZBXcfpgrXfg4YgpV/KdABO4AQ0nl8mIznNCX9R6C+5MgZzf9zgLy/fmffkODSOKZ0IY3EIWLubl3hzxsJWsFb3aK+ZsrWZGGThnOV0hDQo+yacHb2G5ni7tLlHQOhSv2Ht3cqzMKPWW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dSqwInFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dSqwInFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57C2C4CEE2;
	Tue, 18 Feb 2025 06:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860865;
	bh=USKp2I3VY3WJhhvQrzWe1Tc3sy5BfWuXB+DGTu+I4OI=;
	h=Date:To:From:Subject:From;
	b=dSqwInFYBWsV8sOanfbEMqwLBNff97PvaB13TZdty7dg57ixhdnARVLDtYEpAS/DR
	 vvtau2juSioEojL+fwQTh7qiA+ZREPDVjEPMxlC8AVHCGJAbTYG+6sDO4YdTFYdeVQ
	 e2+IBcssT/H0DGp9m4HGEzSLCRW6IloEvz75NNeE=
Date: Mon, 17 Feb 2025 22:41:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,geert@linux-m68k.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] test_xarray-fix-failure-in-check_pause-when-config_xarray_multi-is-not-defined.patch removed from -mm tree
Message-Id: <20250218064105.D57C2C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_xarray: fix failure in check_pause when CONFIG_XARRAY_MULTI is not defined
has been removed from the -mm tree.  Its filename was
     test_xarray-fix-failure-in-check_pause-when-config_xarray_multi-is-not-defined.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: test_xarray: fix failure in check_pause when CONFIG_XARRAY_MULTI is not defined
Date: Fri, 14 Feb 2025 00:36:59 +0800

In case CONFIG_XARRAY_MULTI is not defined, xa_store_order can store a
multi-index entry but xas_for_each can't tell sbiling entry from valid
entry.  So the check_pause failed when we store a multi-index entry and
wish xas_for_each can handle it normally.  Avoid to store multi-index
entry when CONFIG_XARRAY_MULTI is disabled to fix the failure.

Link: https://lkml.kernel.org/r/20250213163659.414309-1-shikemeng@huaweicloud.com
Fixes: c9ba5249ef8b ("Xarray: move forward index correctly in xas_pause()")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/r/CAMuHMdU_bfadUO=0OZ=AoQ9EAmQPA4wsLCBqohXR+QCeCKRn4A@mail.gmail.com
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/lib/test_xarray.c~test_xarray-fix-failure-in-check_pause-when-config_xarray_multi-is-not-defined
+++ a/lib/test_xarray.c
@@ -1418,7 +1418,7 @@ static noinline void check_pause(struct
 {
 	XA_STATE(xas, xa, 0);
 	void *entry;
-	unsigned int order;
+	int order;
 	unsigned long index = 1;
 	unsigned int count = 0;
 
@@ -1450,7 +1450,7 @@ static noinline void check_pause(struct
 	xa_destroy(xa);
 
 	index = 0;
-	for (order = XA_CHUNK_SHIFT; order > 0; order--) {
+	for (order = order_limit - 1; order >= 0; order--) {
 		XA_BUG_ON(xa, xa_store_order(xa, index, order,
 					xa_mk_index(index), GFP_KERNEL));
 		index += 1UL << order;
@@ -1462,24 +1462,25 @@ static noinline void check_pause(struct
 	rcu_read_lock();
 	xas_for_each(&xas, entry, ULONG_MAX) {
 		XA_BUG_ON(xa, entry != xa_mk_index(index));
-		index += 1UL << (XA_CHUNK_SHIFT - count);
+		index += 1UL << (order_limit - count - 1);
 		count++;
 	}
 	rcu_read_unlock();
-	XA_BUG_ON(xa, count != XA_CHUNK_SHIFT);
+	XA_BUG_ON(xa, count != order_limit);
 
 	index = 0;
 	count = 0;
-	xas_set(&xas, XA_CHUNK_SIZE / 2 + 1);
+	/* test unaligned index */
+	xas_set(&xas, 1 % (1UL << (order_limit - 1)));
 	rcu_read_lock();
 	xas_for_each(&xas, entry, ULONG_MAX) {
 		XA_BUG_ON(xa, entry != xa_mk_index(index));
-		index += 1UL << (XA_CHUNK_SHIFT - count);
+		index += 1UL << (order_limit - count - 1);
 		count++;
 		xas_pause(&xas);
 	}
 	rcu_read_unlock();
-	XA_BUG_ON(xa, count != XA_CHUNK_SHIFT);
+	XA_BUG_ON(xa, count != order_limit);
 
 	xa_destroy(xa);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


