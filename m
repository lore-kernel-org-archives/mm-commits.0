Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED98348463
	for <mm-commits@vger.kernel.org>; Wed, 17 Jun 2026 22:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735786; cv=none; b=f4hvn3WM1YsqdsrkK8YzNSbIwqLAOIkAmILM1uVlp5RFWq2Tv4fYieNuGZj5+oOzEim85qpxfUEeK6+wHZWiBySJVAPhWAVaYEg8TG3VEyCYI5VpXrUGmotRTzaXD8n5gGdvJigrE1+ti3wDvxL8wKraz75lYpOTETxNW9c4+FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735786; c=relaxed/simple;
	bh=4XBEFPrHMjZFZZ0vlfvyrlVbFEYbTKs+P94eD/fVeuQ=;
	h=Date:To:From:Subject:Message-Id; b=U9r1ihUFyRuMwTqUtSzeSC2WLksUvauHtpnofjkTyCQkYAmgISBP6ajzlv2zuFc7ItgcVt0gCmWEOLaspdJ2TnaNfQTtatYVKBC/SSwsGc7GTocJe7zcYPosfyETtDPWP8dpY0I410VSX4UAeFLwRruS85FDEETy7V9dNsB+PDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SuQh2Cea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SuQh2Cea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC541F000E9;
	Wed, 17 Jun 2026 22:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781735784;
	bh=sak3NiaIQtRrtwHImKWKtXxWdhKM2AmRCS4OCZRIHK8=;
	h=Date:To:From:Subject;
	b=SuQh2CeaeCrBSE/+xlRzSFe8vtcjeWTLuXK6xr/28mOsbBFG3OXUP0/UlVN/cQeYq
	 9yAPmv5YSB14mpA+F/D0LkjBVrHVE5l7x84v2RTpL63Y7d0yi0yk5UOV5OvXx1nw90
	 qimjxpcgHH6sxZN6j63TvZmTrHkJ5lURgIYsRb3Y=
Date: Wed, 17 Jun 2026 15:36:24 -0700
To: mm-commits@vger.kernel.org,sam.moelius@trailofbits.com,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-interval_tree_test-validate-benchmark-parameters-fix.patch removed from -mm tree
Message-Id: <20260617223624.AEC541F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-interval_tree_test-validate-benchmark-parameters-fix
has been removed from the -mm tree.  Its filename was
     lib-interval_tree_test-validate-benchmark-parameters-fix.patch

This patch was dropped because it was folded into lib-interval_tree_test-validate-benchmark-parameters.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-interval_tree_test-validate-benchmark-parameters-fix
Date: Fri Jun 12 07:09:37 PM PDT 2026

include printk.h for pr_warn()

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202606122249.neYsYssG-lkp@intel.com/
Cc: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/interval_tree_test.c~lib-interval_tree_test-validate-benchmark-parameters-fix
+++ a/lib/interval_tree_test.c
@@ -4,6 +4,7 @@
 #include <linux/interval_tree.h>
 #include <linux/prandom.h>
 #include <linux/slab.h>
+#include <linux/printk.h>
 #include <asm/timex.h>
 #include <linux/bitmap.h>
 #include <linux/maple_tree.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-interval_tree_test-validate-benchmark-parameters.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

