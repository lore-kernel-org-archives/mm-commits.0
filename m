Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A3F213254
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343146; cv=none; b=XBzkJI2ovSp/yiTQ8N7wby1DVifXJycPOP/1RTtvoHwoBsUjr2n2P/HW4/tvK1C9kYAFKt+LaqVVXHdQPqnH0iZ8uzctuRaXlEePibpWWfgqGQLWh+zUH7yeNfHxLqUZITxgjAwm2pJ12KlBDZ56QCtClf7WvAk4oDSG+cXQTlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343146; c=relaxed/simple;
	bh=wbmP1ZWiJ75u3pXCp4wf/CGRVBA56q/RvukQnK0Hp1w=;
	h=Date:To:From:Subject:Message-Id; b=e/HEX1ca2nm5vLu7L2l2lckMs2Vob1hWAvr0MY3l0nCTxZdh/0U4uvfzE08OiwchMKPg7XL22KGAuzYm//VJRIJuEA/OGi5xYbPYoyta9bBIUrjR2959Wm8FJ53sVCWrhWBxS8b6HduMUYUaPj2ch5rkmISZ2tutZMQ8UyOvv7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BFbTHJVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BFbTHJVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36291C4CEF5;
	Mon, 17 Nov 2025 01:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343146;
	bh=wbmP1ZWiJ75u3pXCp4wf/CGRVBA56q/RvukQnK0Hp1w=;
	h=Date:To:From:Subject:From;
	b=BFbTHJVRoZgjVxv8RSGpdt+c24Tl/aWkL1Uk3Jg7cMG6oCzwaAwXvlJzj0NDHGwtK
	 x8sN8wpoMOW4LJ5IrbLoKKAYtspPy9GZApLdbhOqhDJqW51qh2zb84OahItOvFecgN
	 huw2D/ri/ftDoHdvNrnPPtkrecupLfOkkxuzFjPM=
Date: Sun, 16 Nov 2025 17:32:25 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,dev.jain@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-use-stdboolh-in-page_owner_sortc.patch removed from -mm tree
Message-Id: <20251117013226.36291C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: use <stdbool.h> in page_owner_sort.c
has been removed from the -mm tree.  Its filename was
     tools-mm-use-stdboolh-in-page_owner_sortc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm: use <stdbool.h> in page_owner_sort.c
Date: Wed, 15 Oct 2025 17:38:50 +0800

Use standard <stdbool.h> instead of manually defining bool, true and false.

Link: https://lkml.kernel.org/r/20251015093851.109663-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-use-stdboolh-in-page_owner_sortc
+++ a/tools/mm/page_owner_sort.c
@@ -13,6 +13,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdbool.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -23,9 +24,6 @@
 #include <linux/types.h>
 #include <getopt.h>
 
-#define bool int
-#define true 1
-#define false 0
 #define TASK_COMM_LEN 16
 
 struct block_list {
_

Patches currently in -mm which might be from liuye@kylinos.cn are


