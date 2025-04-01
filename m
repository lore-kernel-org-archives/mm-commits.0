Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0084215045
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545924; cv=none; b=NNz7frKFQMhXOWLg8P3T7SmGNN1LcYyLWj4/SNb0Re/MXsHbWB6VEcNaiVamMQOBdSITpSg00TmoaIaIfxrtcjF4f1eWbZo9Z4Gj2H+QZcGszkVFsSP2EZ4N+nUubyri8WtUIu1j1b87Mq78Fqxi2y5n3K/cEevYiPF4Yc77C14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545924; c=relaxed/simple;
	bh=7c2LHtbOPM8HYTfMAppuw/zZ7845H1IoTE9Y5Nw/L6Q=;
	h=Date:To:From:Subject:Message-Id; b=WE8kKY3yL4tHoi9DY3zCJ41GyRlrZWz7yAFyo++wnYVlzAGGhbsUbcXUBMZFsosebW3kG97VEPOPUfSp1Ot/eYbxcnl81/1myVGY22xy8DTxc2+PM1LhAlIctxMYZ75SSOPHm4GR/E/k5GC13/uGQ4gvp3KplNGrssM8Os7o/54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVl0FCed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVl0FCed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAA5C4CEE4;
	Tue,  1 Apr 2025 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545923;
	bh=7c2LHtbOPM8HYTfMAppuw/zZ7845H1IoTE9Y5Nw/L6Q=;
	h=Date:To:From:Subject:From;
	b=fVl0FCedT7cQsCTT7TGEjlbaoauOgZCAOuFr9NFUjNLifQVvnvKY2pWMKkt1GmK5T
	 iL2iHPUpgWySBoGKjd6Tet7avEWrtIi13yJw8GjN+N71Qjo81NKKg2Cac2N2vOWxAl
	 iQdGLDonEYfyn2hwbThutoOGFIQF5ZNnIDBCFExw=
Date: Tue, 01 Apr 2025 15:18:42 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,thomas.weissschuh@linutronix.de,svens@linux.ibm.com,m-malladi@ti.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,hca@linux.ibm.com,guoweikang.kernel@gmail.com,gor@linux.ibm.com,geert@linux-m68k.org,edumazet@google.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-sysmap-add-arch-support-txt.patch removed from -mm tree
Message-Id: <20250401221843.4BAA5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal sysmap: add arch-support txt
has been removed from the -mm tree.  Its filename was
     mseal-sysmap-add-arch-support-txt.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal sysmap: add arch-support txt
Date: Fri, 21 Mar 2025 03:26:27 +0000

Add Documentation/features/core/mseal_sys_mappings/arch-support.txt

N/A: the arch is 32bits only and mseal is not supported in 32 bits,
     therefore N/A (until mseal is available in 32 bits kernel).

[jeffxu@chromium.org: update to v3]
  Link: https://lkml.kernel.org/r/20250324151537.1106542-2-jeffxu@google.com
Link: https://lkml.kernel.org/r/20250321032627.4147562-2-jeffxu@google.com
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

 Documentation/features/core/mseal_sys_mappings/arch-support.txt |   30 ++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/features/core/mseal_sys_mappings/arch-support.txt a/Documentation/features/core/mseal_sys_mappings/arch-support.txt
new file mode 100644
--- /dev/null
+++ a/Documentation/features/core/mseal_sys_mappings/arch-support.txt
@@ -0,0 +1,30 @@
+#
+# Feature name:          mseal-system-mappings
+#         Kconfig:       ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+#         description:   arch supports mseal system mappings
+#
+    -----------------------
+    |         arch |status|
+    -----------------------
+    |       alpha: | TODO |
+    |         arc: |  N/A |
+    |         arm: |  N/A |
+    |       arm64: |  ok  |
+    |        csky: |  N/A |
+    |     hexagon: |  N/A |
+    |   loongarch: | TODO |
+    |        m68k: |  N/A |
+    |  microblaze: |  N/A |
+    |        mips: | TODO |
+    |       nios2: |  N/A |
+    |    openrisc: |  N/A |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |       riscv: | TODO |
+    |        s390: |  ok  |
+    |          sh: |  N/A |
+    |       sparc: | TODO |
+    |          um: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: |  N/A |
+    -----------------------
_

Patches currently in -mm which might be from jeffxu@chromium.org are


