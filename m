Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90341547C0
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 21:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723758213; cv=none; b=de/V8omdK/NXDhZ95MXuwFKYwACzE9dn5LYgcg47bRvIsYcMr1xnnIayFHOUvFcs0DlRT++nudPXAB/l3o5gTxeUGYhMy3P9aQu0sUku0wlQWQhusNhsDLB3jlaP07IEa5oBenIR0yyU0yrfHWy4PBMeXLfCEBM3uDPoMcJ46lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723758213; c=relaxed/simple;
	bh=AOmA2Ij1gtNkwPO6hqhxw201PS+kaGJXi+WztGTibAo=;
	h=Date:To:From:Subject:Message-Id; b=pXCkBtw3AS5/BE2/c0yChPL3I0iT8GZQP1kP6UZDTL4QucvrCNctD4gcqg8Q96H2QSBbuCIgnfv/QrS+wQl8IcihIjyTD/F6S9MSqcn5EAPZzmLvLqsBa6rS4ih30O4en00jtLg5ylhpoNL6g2PmzsM/MCS3m8aGb2wz9Wrp5MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I6uSrQmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I6uSrQmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6503DC32786;
	Thu, 15 Aug 2024 21:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723758212;
	bh=AOmA2Ij1gtNkwPO6hqhxw201PS+kaGJXi+WztGTibAo=;
	h=Date:To:From:Subject:From;
	b=I6uSrQmK3c5VNgFjlSrsreKOwVoux3j4ZSeLW80yA/s7fIk58T7ydwRFz01BvgOuz
	 kRoNDGjk6kJIXDD5w18KRy8xj1ZGwIPxmuH0rW4hyiOR9458PtU83CkX3X5MJ7D9mq
	 OqIJ4SzDVJq8vCoFztRIOQKC8NAvOPno48gcKMls=
Date: Thu, 15 Aug 2024 14:43:31 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,jani.nikula@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch added to mm-nonmm-unstable branch
Message-Id: <20240815214332.6503DC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fault-inject-improve-build-for-config_fault_injection=n-fix-2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fault-inject-improve-build-for-config_fault_injection=n-fix-2
Date: Thu Aug 15 02:41:21 PM PDT 2024

fix drivers/misc/xilinx_tmr_inject.c

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408160254.7w492KEu-lkp@intel.com/
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/xilinx_tmr_inject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/xilinx_tmr_inject.c~fault-inject-improve-build-for-config_fault_injection=n-fix-2
+++ a/drivers/misc/xilinx_tmr_inject.c
@@ -12,6 +12,7 @@
 #include <asm/xilinx_mb_manager.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/debugfs.h>
 #include <linux/platform_device.h>
 #include <linux/fault-inject.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-support-large-folios-swap-in-for-zram-like-devices-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch

