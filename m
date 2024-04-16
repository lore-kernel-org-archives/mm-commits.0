Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1739859158
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 21:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713301631; cv=none; b=A9qXJ7f6Rl4q+KVvi8NQSaVbnHvMR8NSRSEo4/KGZwJiOt+Xqxs+Dbbd2eJhNcBaFy1c3Pw/UAG7qx5DiNdAhqCfy4mOjIKFw35tAQ+MA8DQJhGVtup+uf4f/OejmgLzJcFe+9pXbQja1WGo5SN2jnbdIyZV0ubFqJ//nDR5ZS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713301631; c=relaxed/simple;
	bh=W9w5HAuKdgAlY4tAdSWUiQ5RVIShPkRRazjoxKUlsug=;
	h=Date:To:From:Subject:Message-Id; b=ZL2nwMogFvjvdootQQvDbo/uZKvRA2pOU9V4L2BBvbbBVnxEYZxqUAYH4EjNfledEzno5NYXu3aWe1OU06oeZWHI2mHh+ys0pwhCDk7Hs+A5Kah4oGn5X7TlGoXzO7EO6Pic4sthQtBG0S0WmEizmYKsKqBLyWuh60GlI/6bnco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qb4rLjSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qb4rLjSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A4DC113CE;
	Tue, 16 Apr 2024 21:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713301630;
	bh=W9w5HAuKdgAlY4tAdSWUiQ5RVIShPkRRazjoxKUlsug=;
	h=Date:To:From:Subject:From;
	b=qb4rLjSJmV1dOMBKQOfk6iydQWbEbBewwio4C7dAXAJqP5c2kc4RvVMvNitWY3xCf
	 HNnxNPrtUiwQb5BRJt487Vq6AiZXD9jb5q7QcgjoE0M094z9XOILTiP27W3h8jH0YI
	 wC4K2t7Y5j/X6YoxgYpuM2p+inWw2AYomNZY8F8k=
Date: Tue, 16 Apr 2024 14:07:10 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] fix-missing-vmalloch-includes-fix-3.patch removed from -mm tree
Message-Id: <20240416210710.98A4DC113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix-missing-vmalloch-includes-fix-3
has been removed from the -mm tree.  Its filename was
     fix-missing-vmalloch-includes-fix-3.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: fix-missing-vmalloch-includes-fix-3
Date: Wed, 3 Apr 2024 14:12:40 -0700

fix loongarch build

Link: https://lkml.kernel.org/r/20240403211240.GA307137@dev-arch.thelio-3990X
Signed-off-by: Nathan Chancellor <nathan@kernel.org> 
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/addrspace.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/include/asm/addrspace.h~fix-missing-vmalloch-includes-fix-3
+++ a/arch/loongarch/include/asm/addrspace.h
@@ -11,6 +11,7 @@
 #define _ASM_ADDRSPACE_H
 
 #include <linux/const.h>
+#include <linux/sizes.h>
 
 #include <asm/loongarch.h>
 
_

Patches currently in -mm which might be from nathan@kernel.org are


