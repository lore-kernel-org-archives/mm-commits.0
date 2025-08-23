Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE9F11CA0
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 02:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755914428; cv=none; b=lmgc0KHjWcMYP2ukMSKxhwAgetKqLZEj+Ad02wc0BAyIz/wiu68P/r2g2j56jSy1CDzEq471/sbR72te7PgaBei3PUNx7uxVAQbRd8yd9rh1qXC1A8Dn4GyzeZTYJq+Q638KArV3t7h2zrLO2e99ue9g0AOiixyVpifrkhRQJhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755914428; c=relaxed/simple;
	bh=XM1NhLtEgFXerpBsu5CcO6N/lyKhxBaHZb+FgVq/nCI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=uoFpPDsK3TtvDy8rp3KALsD5B6mK4ZBbfw1GNaji4NM/swRZbqrifWPamQj/ACaze8VvUH1d9FKKS5rFGeRytc+G27IMwkPJv0KbZL2Gix8mq7NiOBRuXb+p8B3Yv325KkW3VHGghf6ybsoElDdbxQu1SguPFotyFViXqjVn/oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yIjKIF/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yIjKIF/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D26FC4CEED;
	Sat, 23 Aug 2025 02:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755914427;
	bh=XM1NhLtEgFXerpBsu5CcO6N/lyKhxBaHZb+FgVq/nCI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yIjKIF/Uz+WuaqltPp1QGut5VErMW5cBDk7Gpj2o3sVHBWl3Rq/nMeUkmBvv44z2t
	 zec40iPk0Z2cpQtlJx9ocdrX8Ndd9e7LhCtc2IXkoRMSglZsWgheOS0iIkcVYRgKqp
	 F2s2TN1h3KDdpOeY0VEXDOu7zlXSIzBdJ4jDPWLA=
Date: Fri, 22 Aug 2025 19:00:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: mm-commits@vger.kernel.org, vgupta@kernel.org,
 lorenzo.stoakes@oracle.com, lkp@intel.com, liuye@kylinos.cn,
 dev.jain@arm.com, david@redhat.com, chrisl@kernel.org
Subject: Re: +
 mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
 added to mm-unstable branch
Message-Id: <20250822190026.4eec067edb5ff674bf16b117@linux-foundation.org>
In-Reply-To: <2D142A2F-4D76-46C9-9E4F-760F9CFEA6CF@nvidia.com>
References: <20250822220159.7AB3BC4CEED@smtp.kernel.org>
	<2D142A2F-4D76-46C9-9E4F-760F9CFEA6CF@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 22 Aug 2025 18:37:45 -0400 Zi Yan <ziy@nvidia.com> wrote:

> > +#define PAGES_TO_KB(pages) ((pages) >> (10 - PAGE_SHIFT))
> > +#define KB_TO_PAGES(kb)    ((kb) << (10 - PAGE_SHIFT))
> 
> Left shift and right shift with a negative value. Aren't they undefined
> behaviors?

Actually I just misread the bug report.  I'll redo:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
Date: Fri Aug 22 02:54:15 PM PDT 2025

remove arc's private PAGES_TO_MB, remove its unused PAGES_TO_KB

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lkml.kernel.org/r/202508230539.pnO97SIj-lkp@intel.com
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/arcregs.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arc/include/asm/arcregs.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix
+++ a/arch/arc/include/asm/arcregs.h
@@ -146,14 +146,13 @@
 
 #ifndef __ASSEMBLER__
 
+#include <linux/mm.h>
+
 #include <soc/arc/arc_aux.h>
 
 /* Helpers */
 #define TO_KB(bytes)		((bytes) >> 10)
 #define TO_MB(bytes)		(TO_KB(bytes) >> 10)
-#define PAGES_TO_KB(n_pages)	((n_pages) << (PAGE_SHIFT - 10))
-#define PAGES_TO_MB(n_pages)	(PAGES_TO_KB(n_pages) >> 10)
-
 
 /*
  ***************************************************************
_

