Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980510;
	b=dReAxH/8X5Z0LIl3GOOEo7zXEArwAgj/4y2jQVWS8VBko9+z6MzZR7KgWezGDXIkqI3b
	 1Rmp6KovlmDxtEQItqYnVpIw9655Sso23H2EoeEAJEM/fHaSo/RHdeO+DjMV+ZFOAJxq1
	 DJFxuuUEL9jzw7mxqDRT5q6/PDAwp/ouX5fSRq2PCnRf2PkGgwJJXnGKWbaVR8Z2+/WQu
	 O73EgGyrigp9ryocOjn+lD/gt/0QcbH6g8PRb2GBy3lT1tQJc/74b3LMtTb/MetX2G0c6
	 +M3EgubwAHB/LrV6SbUUx1XpKdRmdtxTKwJbzI2W3C9bDM+QkY0n0IWTluYmfh+W/GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980510;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=591PQwi7SBP9atpIDvAWnsE5kg8HDauLEb6t9wX/kRQ=;
	b=VK5jPdiuyT+sp4oYkHrt8+pHhuZsw9Zfgw3Pbg2HHfhHQaLJrtr72H3vn2RudVtwD3DB
	 qpCSwKCsNnBoECpOE68fnE2ioCdyuYjRz8O63dEY/rAMPtbxaKsZf62GFsV4Qy05eRQvR
	 M5BU7F40A/ajUyIsxM+SsCCxyPrRIhKm200XeS8Vr9TiP1KDzmpm8FrsIVNIaloOLVJhX
	 Ak/hxy0AS1/J/jfrAe396CoONSpVJFrBldtIdJJElYiQgSq5i78sQ7fp5gHKFtSLMG5e1
	 4GMdto1iuaHobSUo87qllPtWJD6brxIZF99jJRsPrWioOFav72v9K6UGwsPHzw6V2IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MT2YODan;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3D7606A31C;
	Wed, 18 Nov 2026 05:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MT2YODan
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434361F000C4;
	Wed, 18 Nov 2026 05:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980510;
	bh=591PQwi7SBP9atpIDvAWnsE5kg8HDauLEb6t9wX/kRQ=;
	h=Date:To:From:Subject;
	b=MT2YODanXFDCn7mLUoJ2jTPigdY5b6fW/5Cs03tF53X5d/HKTOUt+SkehXnseWJQU
	 r29u6x5muDpFrOtqRbvLcWE+stZotv1kyD23iyjuuPNNtqY/LtDh/NSGv5VdJA+D8/
	 asbimjJwTQdPece8NXA4nrkErbnwuwIGWRaf7zcA=
Date: Tue, 17 Nov 2026 21:41:49 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,akinobu.mita@gmail.com,
	ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] fault-inject-fix-boot-failure-with-fault-injection-boot-parameters.patch removed from -mm tree
Message-Id: <20261118054150.434361F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fault-inject: fix boot failure with fault injection boot parameters
has been removed from the -mm tree.  Its filename was
     fault-inject-fix-boot-failure-with-fault-injection-boot-parameters.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: fault-inject: fix boot failure with fault injection boot parameters
Date: Fri,  6 Nov 2026 01:01:58 +0900

Since commit e9bc360b105c ("fault-inject: use prandom where
cryptographically secure randomness is not needed"), setup_fault_attr()
calls prandom_init_once(), which calls kmalloc() and schedule_work().

But setup_fault_attr() can be called from __setup handlers before slab and
workqueues are initialized, so any fault injection boot parameter leads to
boot failure.

So use DO_ONCE_LITE() instead.

Link: https://lore.kernel.org/20261105160209.1504867-1-ekffu200098@gmail.com
Fixes: e9bc360b105c ("fault-inject: use prandom where cryptographically secure randomness is not needed")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <stable@vger.kernel.org>

 lib/fault-inject.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/lib/fault-inject.c~fault-inject-fix-boot-failure-with-fault-injection-boot-parameters
+++ a/lib/fault-inject.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/once_lite.h>
 #include <linux/prandom.h>
 #include <linux/debugfs.h>
 #include <linux/sched.h>
@@ -50,7 +51,12 @@ int setup_fault_attr(struct fault_attr *
 		return 0;
 	}
 
-	prandom_init_once(&fault_rnd_state);
+	/*
+	 * __setup handlers run before slab and workqueues are initialized,
+	 * but prandom_init_once() calls kmalloc() and schedule_work(). So use
+	 * DO_ONCE_LITE() instead.
+	 */
+	DO_ONCE_LITE(prandom_seed_full_state, &fault_rnd_state);
 
 	attr->probability = probability;
 	attr->interval = interval;
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-memory-remove-unused-vmf_insert_mixed_mkwrite.patch
mm-memory-remove-the-mkwrite-argument-from-__vm_insert_mixed.patch
mm-memory-merge-__vm_insert_mixed-into-vmf_insert_mixed.patch
fault-inject-use-a-shared-initialization-helper-for-the-random-state.patch
fault-inject-fix-wrong-unit-of-verbose_ratelimit_interval_ms.patch

