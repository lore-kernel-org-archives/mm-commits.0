Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD32200130
	for <mm-commits@vger.kernel.org>; Thu, 13 Feb 2025 22:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739484158; cv=none; b=UW1ApTgDMOXSBea3ZAv2ozMycZI4gfh8/Hux5VDh9GME+fIyZiPguzPCk3YCbPq34obwDpiAf3i5mVF7Y1FxW14QlmJzueTsXFNbXZZ2xxxeyJABDi6aSPXOBW5x/NkEcWTZvZoQPz3T46j5lMfDnvjb3GRkDWWLRrezpGfI7qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739484158; c=relaxed/simple;
	bh=cMYcIsLYnp3a0K9Kjp2xeXybgIE7WQu7EB06guKnOwM=;
	h=Date:To:From:Subject:Message-Id; b=gZOxpY4IBz+s9a5XIn9QHZmeuV+quaAHW29rstg0FKfniWjmIUKuMxvQtDq/WlOvDOkwCF4RRmjYVblpYlFJJJsSOItTF6cwV64k+wAmLrHKJhOZPs5Bar2q5OnpYjfI/YjqWc9Lv2Uq8aPWp8FIMf8C45IWj/CctaCByX0jjNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KbRiVCMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KbRiVCMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F380C4CED1;
	Thu, 13 Feb 2025 22:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739484157;
	bh=cMYcIsLYnp3a0K9Kjp2xeXybgIE7WQu7EB06guKnOwM=;
	h=Date:To:From:Subject:From;
	b=KbRiVCMAUrEAdCE87CZpHYfraxxYtpmMmKrC+F0905xrXi9NjyN7hHhW/tgN5Dksl
	 7zSKrpqHamKgZkLRJLCfQgPia1THIH42GpVLc50wzLMPJ/j0y1n4JPOHcjHP2ZqOPM
	 r0HzqSK4zKGzzhATIUBsdbtw88uylnMYBhePe8eI=
Date: Thu, 13 Feb 2025 14:02:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,geert@linux-m68k.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_xarray-fix-failure-in-check_pause-when-config_xarray_multi-is-not-defined.patch added to mm-hotfixes-unstable branch
Message-Id: <20250213220237.4F380C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_xarray: fix failure in check_pause when CONFIG_XARRAY_MULTI is not defined
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     test_xarray-fix-failure-in-check_pause-when-config_xarray_multi-is-not-defined.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_xarray-fix-failure-in-check_pause-when-config_xarray_multi-is-not-defined.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: test_xarray: fix failure in check_pause when CONFIG_XARRAY_MULTI is not defined
Date: Fri, 14 Feb 2025 00:36:59 +0800

In case CONFIG_XARRAY_MULTI is not defined, xa_store_order can store a
multi-index entry but xas_for_each can't tell sbiling entry from valid
entry.  So the check_pause failed when we store a multi-index entry and
wish xas_for_each can handle it normally.  Avoid to store multi-index
entry when CONFIG_XARRAY_MULTI is disabled to fix the failure.

Link: https://lkml.kernel.org/r/20250213163659.414309-1-shikemeng@huaweicloud.com
Fixes: c9ba5249ef8b080c ("Xarray: move forward index correctly in xas_pause()")
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

test_xarray-fix-failure-in-check_pause-when-config_xarray_multi-is-not-defined.patch

