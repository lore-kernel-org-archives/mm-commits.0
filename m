Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24270171C9;
	Tue, 13 Jan 2026 05:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280999; cv=none; b=jyVNhgvGvl+cfifuwfXvkFFuuces6WeUUHuhz4YlBdY94PnEOVXMNeBz/23e6FZgpfCHbnFXOcud7654EZu7eHbudGPltqzdDqWy26rtHaxn5Ynzhuv8bIalK6mTVm0xHSHdjHWHS4S2cD8DOgA1BkVeFIkjS/pYs4jwuRzsd4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280999; c=relaxed/simple;
	bh=5J1IXvCxwoop91oWHNO57Xq9KPceUE5wxAxnV/aYir0=;
	h=Date:To:From:Subject:Message-Id; b=KcDszz1KWH6kjL31KttSn/Dt4Vb5fbp5wgX8Te4KouxI+2fh9hWvv2sytm7naIxppCYIh/JVrGm8DRsXJiw99dFkQ4SiBIdmkNsnLzV2/yKLxT2XBsM+gnkLeZ+xW5NdCW/KGqmhe8SvaGJiHkj6zgyXYvnWuePhBrxuZ4WPO/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y79S8Vhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y79S8Vhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB76CC116C6;
	Tue, 13 Jan 2026 05:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280998;
	bh=5J1IXvCxwoop91oWHNO57Xq9KPceUE5wxAxnV/aYir0=;
	h=Date:To:From:Subject:From;
	b=y79S8VhutJ7UvkL2txDxzzm9YPo5gJPheO3+lxkFPRYsajk5L1od1uAfXaKQSIMCe
	 nr/HaFs2Le5FZJwUM6xzE0EtvNIvSo5F1tTO06zssaFfygpTSlk+yoAsKCOQenNlZ5
	 IMOk5iyuJqDm/jG7vl5TIWvzDXbD1xg7ZEKKNbDA=
Date: Mon, 12 Jan 2026 21:09:58 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,ben.dooks@codethink.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-numamemblock-include-asm-numah-for-numa_nodes_parsed.patch removed from -mm tree
Message-Id: <20260113050958.BB76CC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: numa,memblock: include <asm/numa.h> for 'numa_nodes_parsed'
has been removed from the -mm tree.  Its filename was
     mm-numamemblock-include-asm-numah-for-numa_nodes_parsed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: mm: numa,memblock: include <asm/numa.h> for 'numa_nodes_parsed'
Date: Thu, 8 Jan 2026 10:15:39 +0000

The 'numa_nodes_parsed' is defined in <asm/numa.h> but this file
is not included in mm/numa_memblks.c (build x86_64) so add this
to the incldues to fix the following sparse warning:

mm/numa_memblks.c:13:12: warning: symbol 'numa_nodes_parsed' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20260108101539.229192-1-ben.dooks@codethink.co.uk
Fixes: 87482708210f ("mm: introduce numa_memblks")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/numa_memblks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/numa_memblks.c~mm-numamemblock-include-asm-numah-for-numa_nodes_parsed
+++ a/mm/numa_memblks.c
@@ -7,6 +7,8 @@
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
 
+#include <asm/numa.h>
+
 int numa_distance_cnt;
 static u8 *numa_distance;
 
_

Patches currently in -mm which might be from ben.dooks@codethink.co.uk are


