Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A1334C141
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388574; cv=none; b=SzKdOWEh4bdrCkfwBsjzkl4O1Gx6xraUxLqWkiY2aIC8zHV8d7A6J+XPh8fdmGCeA7+45LlYo0xJZYrWbEcmk6klO4q0Jc6R83YZtNs7dmXF4w2+64bpB83UsJnFmz+e75bVRRH1+BTs5WlFxV3R94/Wnp39XcxG/PWktSa75IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388574; c=relaxed/simple;
	bh=JET2U16T87SxfpufdduixXXSy0xwt9/BMZJoXtzATtM=;
	h=Date:To:From:Subject:Message-Id; b=mxjYyzmXoD6PutSDruZ8/u2be5wFHvIk7+UOgHwAvVyyYJ83hqtBs2eH8cLUkocI7eyR6q9H/KLL/3u1Gg0o5pGZbjQAJEfQxHUKSm5QQZCrg37of85GDQb6aSfeieowk5MMPc0EWFlMFFWOy3DO5X+4caMiPEQy1WzJpW17e4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c53MOE7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c53MOE7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E48C19424;
	Tue, 24 Mar 2026 21:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388574;
	bh=JET2U16T87SxfpufdduixXXSy0xwt9/BMZJoXtzATtM=;
	h=Date:To:From:Subject:From;
	b=c53MOE7qqEkTw0AzkpeRIuaT0WV6ruWM+kuy1w2/wExngIIgLRsYsidCXhLDHSfnp
	 asmDtDUDQv1cNvzF1oBT4z0E71mDndoMYRMbuKOE8R+B8iuvV0u00PWGJ9BtyrYOXf
	 t4qBcUBPWMmJx0wzhg+QpVLOl27mAS0jfzsE0RXQ=
Date: Tue, 24 Mar 2026 14:42:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,linmiaohe@huawei.com,Liam.Howlett@oracle.com,dev.jain@arm.com,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-remove-duplicate-include-of-unistdh.patch removed from -mm tree
Message-Id: <20260324214254.20E48C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: remove duplicate include of unistd.h
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-duplicate-include-of-unistdh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ni <nichen@iscas.ac.cn>
Subject: selftests/mm: remove duplicate include of unistd.h
Date: Wed, 11 Feb 2026 14:43:11 +0800

Remove duplicate inclusion of unistd.h in memory-failure.c to clean up
redundant code.

Link: https://lkml.kernel.org/r/20260211064311.2981726-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memory-failure.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-remove-duplicate-include-of-unistdh
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -13,7 +13,6 @@
 #include <unistd.h>
 #include <signal.h>
 #include <setjmp.h>
-#include <unistd.h>
 #include <fcntl.h>
 #include <sys/vfs.h>
 #include <linux/magic.h>
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are

mm-swapfile-remove-duplicate-include-of-swap_tableh.patch

