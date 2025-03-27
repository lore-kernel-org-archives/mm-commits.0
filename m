Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D4274BE1
	for <mm-commits@vger.kernel.org>; Thu, 27 Mar 2025 19:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743103655; cv=none; b=iVCg+6m8hz+Hz38MNDLQUQzUVN2+gqJXQKyIB7Pvx769RS2ZefKlcHNhwcMbFrarMQaFcVkWJ8iBigVo0X71wFePL6vKOQBuP7M4XxDxNLfLAUv3E40qQlaH1Wt/eOrafVnYf7l29C8vBdKSoPyQI2kUebZiDRODuVw4nNTECr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743103655; c=relaxed/simple;
	bh=V5dlNMWB5ynl9CHIrakEISHwS7Oc64rVftNGo8Qf9Js=;
	h=Date:To:From:Subject:Message-Id; b=gfYB8J2MOSMVSc1zS2yFNUeuNghpKilr7Sf16yEx3iEcTxTh+6sZrNo58RbnptQ5xxtrbsoD78BkfpHcUibucBqXvr7IyMeyXMHt/JpgdT4bnc1LQkEUj6jJ55WAgoDV+0A/Ztq0jVE0hvtFOYx3AgIxEfPL20DAwL/UM/Jp2dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LcU9QAEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LcU9QAEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517ACC4CEDD;
	Thu, 27 Mar 2025 19:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743103655;
	bh=V5dlNMWB5ynl9CHIrakEISHwS7Oc64rVftNGo8Qf9Js=;
	h=Date:To:From:Subject:From;
	b=LcU9QAEvVpK6prOMzg40LOoK7pWZXEyYYHUARdr0Eey+B/QPTX/ogvQqH/AoXAJbo
	 HNzAoJF4pyx047rK0RTGvzvbnJSWHL08Pr9P9h5SKK0BcYzawqLUZ9EPVTSyL0mpb3
	 Fs+2mAAuzq3PAKJePY7+EHHmZbKEXq8tv68TVg94=
Date: Thu, 27 Mar 2025 12:27:34 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,thomas.weissschuh@linutronix.de,svens@linux.ibm.com,m-malladi@ti.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,hca@linux.ibm.com,guoweikang.kernel@gmail.com,gor@linux.ibm.com,geert@linux-m68k.org,edumazet@google.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mseal-sysmap-add-arch-support-txt-v3.patch added to mm-unstable branch
Message-Id: <20250327192735.517ACC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mseal sysmap: add arch-support txt
has been added to the -mm mm-unstable branch.  Its filename is
     mseal-sysmap-add-arch-support-txt-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mseal-sysmap-add-arch-support-txt-v3.patch

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
mseal-sysmap-add-arch-support-txt-v3.patch

