Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76DEBE52
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yg6o/8BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E39C433C7;
	Mon, 11 Dec 2023 01:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257858;
	bh=3ygsShdtfQiq6CBghBq+4dkXb1P6sZJeR7Rh2D4KPsM=;
	h=Date:To:From:Subject:From;
	b=yg6o/8BQeUy1qVG9P+AJdGV62WNhl6DDa0qwSA6cYNOURUwFjG2QHywd1YA85hwye
	 uKIRGS99YNcwtOgVVLSfuZxk0lT4SZz89WtgFOS056KNJ78KL6lB4IrsDkJoFHbvt3
	 WPgHQ1/yBcdrtNKmiZxTACVDkoFUwqhMCm+X1rVQ=
Date: Sun, 10 Dec 2023 17:24:18 -0800
To: mm-commits@vger.kernel.org,qun-wei.lin@mediatek.com,oleg@redhat.com,matthias.bgg@gmail.com,florian.fainelli@broadcom.com,chinwen.chang@mediatek.com,angelogioacchino.delregno@collabora.com,andreyknvl@google.com,Kuan-Ying.Lee@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-stackdepot-rename-pool_index-to-pools_num.patch removed from -mm tree
Message-Id: <20231211012418.B2E39C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb/stackdepot: rename pool_index to pools_num
has been removed from the -mm tree.  Its filename was
     scripts-gdb-stackdepot-rename-pool_index-to-pools_num.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/stackdepot: rename pool_index to pools_num
Date: Wed, 29 Nov 2023 14:51:39 +0800

After stackdepot evicting support patchset[1], we rename pool_index to
pools_num.

To avoid from the below issue, we rename consistently in
gdb scripts.

Python Exception <class 'gdb.error'>: No symbol "pool_index" in current
context.
Error occurred in Python: No symbol "pool_index" in current context.

[1] https://lore.kernel.org/linux-mm/cover.1700502145.git.andreyknvl@google.com/
Link: https://lkml.kernel.org/r/20231129065142.13375-3-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/stackdepot.py |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/gdb/linux/stackdepot.py~scripts-gdb-stackdepot-rename-pool_index-to-pools_num
+++ a/scripts/gdb/linux/stackdepot.py
@@ -25,10 +25,10 @@ def stack_depot_fetch(handle):
     handle_parts_t = gdb.lookup_type("union handle_parts")
     parts = handle.cast(handle_parts_t)
     offset = parts['offset'] << DEPOT_STACK_ALIGN
-    pool_index_cached = gdb.parse_and_eval('pool_index')
+    pools_num = gdb.parse_and_eval('pools_num')
 
-    if parts['pool_index'] > pool_index_cached:
-        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pool_index_cached, handle))
+    if parts['pool_index'] > pools_num:
+        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))
         return gdb.Value(0), 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are


