Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177DC322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391154; cv=none; b=arubuZm0I6fC2Lr+C5TiXH4KO7Od/R71dX6mVMiisl1m1Pm1CSQbUsyG5urcY1hWGAjL6MwuVe+4ihUsFemGYE+/jmArl7438rSCe1s0bxCYH085Rxiqi9dbkrbgE62qOvjaqsXr/iBZ9VGQzsQd6qFrkGwWyGr3hgZHDSb2C+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391154; c=relaxed/simple;
	bh=+fQCog52H6xWYZnVTwdYh2JaUtuGwKLDiFmAHAXtbn0=;
	h=Date:To:From:Subject:Message-Id; b=eU9SSPvOnYMqQHL74JEN9G7RSvqeXDcSJ+0RUnye9Y4r/BUeXq0YqM7ge1xrb3tRMAvxYX+k9+iYUnbJoPPcPBgI3TL0b4ijtWp0uAmYs6TkN3N+QhNtzmjgE7qCcFk3hqCV19yHH6SWUdxKR4xg+mW2VC4G2bUZRNFIFQWdkE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sKkzuaK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sKkzuaK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A237C4CEE3;
	Fri, 20 Jun 2025 03:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391153;
	bh=+fQCog52H6xWYZnVTwdYh2JaUtuGwKLDiFmAHAXtbn0=;
	h=Date:To:From:Subject:From;
	b=sKkzuaK2xARtMpKR3LG9Yb0LyYENGGXMq6Z5EHle11GE9sqtf2Bq6GP1qmF4lNBYO
	 Uz++IfH5TvKTV/YYEcfFUX4SLUJCBhhe5EEwo3YqAkMCH+2duWh/kZHUaMoXFQtoVz
	 TS8MyEyfFUMeGDnxzz7X94EjdfWbaw30XNeme3iQ=
Date: Thu, 19 Jun 2025 20:45:52 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ptyadav@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-initialize-tail-pages-for-higher-order-folios-properly-v2.patch removed from -mm tree
Message-Id: <20250620034553.7A237C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-initialize-tail-pages-for-higher-order-folios-properly-v2
has been removed from the -mm tree.  Its filename was
     kho-initialize-tail-pages-for-higher-order-folios-properly-v2.patch

This patch was dropped because it was folded into kho-initialize-tail-pages-for-higher-order-folios-properly.patch

------------------------------------------------------
From: Pratyush Yadav <ptyadav@amazon.de>
Subject: kho-initialize-tail-pages-for-higher-order-folios-properly-v2
Date: Fri, 13 Jun 2025 14:59:06 +0200

declare i in the loop instead of at the top

Link: https://lkml.kernel.org/r/20250613125916.39272-1-pratyush@kernel.org
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/kexec_handover.c~kho-initialize-tail-pages-for-higher-order-folios-properly-v2
+++ a/kernel/kexec_handover.c
@@ -166,13 +166,13 @@ static int __kho_preserve_order(struct k
 /* almost as free_reserved_page(), just don't free the page */
 static void kho_restore_page(struct page *page, unsigned int order)
 {
-	unsigned int i, nr_pages = (1 << order);
+	unsigned int nr_pages = (1 << order);
 
 	/* Head page gets refcount of 1. */
 	set_page_count(page, 1);
 
 	/* For higher order folios, tail pages get a page count of zero. */
-	for (i = 1; i < nr_pages; i++)
+	for (unsigned int i = 1; i < nr_pages; i++)
 		set_page_count(page + i, 0);
 
 	if (order > 0)
_

Patches currently in -mm which might be from ptyadav@amazon.de are

maintainers-add-linux-mm-list-to-kexec-handover.patch
kho-initialize-tail-pages-for-higher-order-folios-properly.patch

