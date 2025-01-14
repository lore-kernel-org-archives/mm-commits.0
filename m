Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AEE23D3D1
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837048; cv=none; b=o0adxnMKdhaM7KSJYr9qHZdEMQOlSLcfLEXBgFyY2PnDrWoj9rE/B85UZKvsXZm1cnZGOZvJTrPOEef0zWsL/Bx831f1rXcas2f8uoAzUY4CBRbBh5IDS61dhxAarGEBy6HJ0KNoxCg83OHY461/XwDxTbWBeIqr/XNKcNIUFEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837048; c=relaxed/simple;
	bh=ZIpyQ4oww0K9dHlCN0iZy0HzspZxTncUM06GO3s4pyw=;
	h=Date:To:From:Subject:Message-Id; b=Nhg8hpe72xf0k8Y8TCZnUbhP7wn3wVxagS7PGT0ANsZw9Irbj37LVEBy+dTynE02LG2UB5Cl8yk79mcDhNM5zplJ+ii3NBNNHdXxICEXaOgzflHpB/wOa35AogQmCWIZ45CfCUHsJdFg8DPVgnuP24VigW7qQknnWJRfayrXxB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PCcAGF6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PCcAGF6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D433C4CEDD;
	Tue, 14 Jan 2025 06:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837048;
	bh=ZIpyQ4oww0K9dHlCN0iZy0HzspZxTncUM06GO3s4pyw=;
	h=Date:To:From:Subject:From;
	b=PCcAGF6dNUyVtD0mXiulD0BAreBaykHzPlhzIdFKRTuKiCXuF/cB3nYLNkDh4mP4f
	 N0bNBsFMJkiRY6K8/++clbYwdKhEL/lgHwz2XJ1qzdr4DTfo8QLcvkaR3nEkZ5RKF9
	 OxptvWlQ6LDwuLc/uCUQoW3RLY7Qm1io3ERu9uKg=
Date: Mon, 13 Jan 2025 22:44:07 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch removed from -mm tree
Message-Id: <20250114064408.6D433C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: define types using typedef in pkey-helpers.h
has been removed from the -mm tree.  Its filename was
     selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: define types using typedef in pkey-helpers.h
Date: Mon, 9 Dec 2024 09:50:12 +0000

Using #define to define types should be avoided.  Use typedef instead. 
Also ensure that __u* types are actually defined by including
<linux/types.h>.

Link: https://lkml.kernel.org/r/20241209095019.1732120-8-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-helpers.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-define-types-using-typedef-in-pkey-helpersh
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -13,13 +13,15 @@
 #include <ucontext.h>
 #include <sys/mman.h>
 
+#include <linux/types.h>
+
 #include "../kselftest.h"
 
 /* Define some kernel-like types */
-#define  u8 __u8
-#define u16 __u16
-#define u32 __u32
-#define u64 __u64
+typedef __u8	u8;
+typedef __u16	u16;
+typedef __u32	u32;
+typedef __u64	u64;
 
 #define PTR_ERR_ENOTSUP ((void *)-ENOTSUP)
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


