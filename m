Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BE0800
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 00:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742604468; cv=none; b=dXbQAv5SM9BZqhgbdyekPYa+rjOIVNJZx1k4Y9Re7ydlF2i0Op0ANeVF4lTLIVPDa4rACe1UdCzbCgypIJ3+/TZ4fYWJjJ8o3yPH5EQskUk7EuSosGpnZ1bBQ+JqH1SWbC/I+K394vaorTcX/biZK5Biu6OigHOXhsI7Pu90d5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742604468; c=relaxed/simple;
	bh=oy13YCbx31nNSpguH/fkd1sKnY48p6j5KUYEqQExI8c=;
	h=Date:To:From:Subject:Message-Id; b=GLkM+uRTcT0LTxAUxwHkpuBb+RTjosi3XCrL/scCQjc3y84MwTmUJXnaej8n77SYPxvcan2byKfP7uIjEMIOt4k9pRq4dMDa+pSGpOE66R/f8aSM2dJvxGuTAyoce0m+cIwyc1U+dhQH9zWS4Gx6MfIe9t9brSo3xuzEvQotzwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mvrRGpqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mvrRGpqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3670C4CEE3;
	Sat, 22 Mar 2025 00:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742604467;
	bh=oy13YCbx31nNSpguH/fkd1sKnY48p6j5KUYEqQExI8c=;
	h=Date:To:From:Subject:From;
	b=mvrRGpqFyIGwcbLzQnpJMK1utFxquE4faLj5tYHIl5SAJtcyPlAfQN1VmR2vFmdt6
	 HadoRw9a3s7QHKmCXYLbn2QCtNTcrxRRUO+XCA4ZPYVbL3M9fhcMSoKaBh2nmre9kc
	 B73rxR9AUSDWwgRby7DAhsnxps7nNT9XbZQ/r6ys=
Date: Fri, 21 Mar 2025 17:47:47 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,thomas.weissschuh@linutronix.de,svens@linux.ibm.com,m-malladi@ti.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,hca@linux.ibm.com,guoweikang.kernel@gmail.com,gor@linux.ibm.com,geert@linux-m68k.org,edumazet@google.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-sysmap-add-arch-support-txt.patch added to mm-unstable branch
Message-Id: <20250322004747.D3670C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal sysmap: add arch-support txt
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-sysmap-add-arch-support-txt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-sysmap-add-arch-support-txt.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: jeffxu@chromium.org
Subject: mseal sysmap: add arch-support txt
Date: Fri, 21 Mar 2025 03:26:27 +0000


Add Documentation/features/core/mseal_sys_mappings/arch-support.txt

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
+    |         arc: | TODO |
+    |         arm: |  N/A |
+    |       arm64: |  ok  |
+    |        csky: | TODO |
+    |     hexagon: |  N/A |
+    |   loongarch: | TODO |
+    |        m68k: | TODO |
+    |  microblaze: |  N/A |
+    |        mips: | TODO |
+    |       nios2: | TODO |
+    |    openrisc: |  N/A |
+    |      parisc: | TODO |
+    |     powerpc: | TODO |
+    |       riscv: | TODO |
+    |        s390: |  ok  |
+    |          sh: |  N/A |
+    |       sparc: | TODO |
+    |          um: | TODO |
+    |         x86: |  ok  |
+    |      xtensa: | TODO |
+    -----------------------
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

