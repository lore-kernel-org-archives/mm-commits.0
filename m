Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81271A7253
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 19:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534580; cv=none; b=t+BdZo9sa10zoFpEHIEQ+haCtCKLRWEhvopfmGvyOTkicWriGCoRcxObse7I7qmrFF2m5K+zGkqXKmMiRL7rFStolkR5QIWuEEzTBLFnzCfF6oftbXYD+NBJXZ1Goj0CwBnqR+LxrJLuReOUDH0EvHwHybwGAXY+tekcUgWwhh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534580; c=relaxed/simple;
	bh=OJIu/oxMIgDZtXyK3chLNnfyh9o5bUXOsCSWjZqsvmE=;
	h=Date:To:From:Subject:Message-Id; b=ZQD7vi4dBFUjR+WfOatoxsojlaZcYcs8EHGh/wPtBrEakibnZFgmAxK8CX/K+h4s3pTLm9utYUg2XhOM1CR3QPVG5g42lkCE4AYoP7syMsfdjnLmewLmogG+Bch/ZpQ4vn0A3YBt2hugH9e0ZrdMXBOz88YP/3nS/wrg+5XoXQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sD/8jmXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sD/8jmXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06829C4CEE4;
	Tue,  1 Apr 2025 19:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743534580;
	bh=OJIu/oxMIgDZtXyK3chLNnfyh9o5bUXOsCSWjZqsvmE=;
	h=Date:To:From:Subject:From;
	b=sD/8jmXelzkdWaBwwt3NbZR7tyMD0WlcOyU5pfnXJmpf+sHsC6cOJdSE9SaJ74Zmk
	 EvNDwwdXP/ib+0lqPwzBnMc2JMknInYWzw8+T4bmRuvmR56QgMpsJdZp3c2RVAr5Zs
	 ZYqSRGaYxKge180QZz2jN23gLQjbcFF/yid/mw88=
Date: Tue, 01 Apr 2025 12:09:39 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,thomas.weissschuh@linutronix.de,svens@linux.ibm.com,m-malladi@ti.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,hca@linux.ibm.com,guoweikang.kernel@gmail.com,gor@linux.ibm.com,geert@linux-m68k.org,edumazet@google.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mseal-sysmap-add-arch-support-txt-v3.patch removed from -mm tree
Message-Id: <20250401190940.06829C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: add arch-support txt
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-add-arch-support-txt-v3.patch

This patch was dropped because it was folded into mseal-sysmap-add-arch-support-txt.patch

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal sysmap: add arch-support txt
Date: Mon, 24 Mar 2025 15:15:37 +0000

update to v3

Link: https://lkml.kernel.org/r/20250324151537.1106542-2-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Meghana Malladi <m-malladi@ti.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/features/core/mseal_sys_mappings/arch-support.txt |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/features/core/mseal_sys_mappings/arch-support.txt~mseal-sysmap-add-arch-support-txt-v3
+++ a/Documentation/features/core/mseal_sys_mappings/arch-support.txt
@@ -7,16 +7,16 @@
     |         arch |status|
     -----------------------
     |       alpha: | TODO |
-    |         arc: | TODO |
+    |         arc: |  N/A |
     |         arm: |  N/A |
     |       arm64: |  ok  |
-    |        csky: | TODO |
+    |        csky: |  N/A |
     |     hexagon: |  N/A |
     |   loongarch: | TODO |
-    |        m68k: | TODO |
+    |        m68k: |  N/A |
     |  microblaze: |  N/A |
     |        mips: | TODO |
-    |       nios2: | TODO |
+    |       nios2: |  N/A |
     |    openrisc: |  N/A |
     |      parisc: | TODO |
     |     powerpc: | TODO |
@@ -26,5 +26,5 @@
     |       sparc: | TODO |
     |          um: | TODO |
     |         x86: |  ok  |
-    |      xtensa: | TODO |
+    |      xtensa: |  N/A |
     -----------------------
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mseal-sysmap-kernel-config-and-header-change.patch
selftests-x86-test_mremap_vdso-skip-if-vdso-is-msealed.patch
mseal-sysmap-enable-x86-64.patch
mseal-sysmap-enable-arm64.patch
mseal-sysmap-uprobe-mapping.patch
mseal-sysmap-update-msealrst.patch
selftest-test-system-mappings-are-sealed.patch
mseal-sysmap-add-arch-support-txt.patch

