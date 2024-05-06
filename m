Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA791A28D
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957938; cv=none; b=qCm9HGVOVktmwDyBIpvdkHilX7MNVkev3zJx8zJCIm7xRPRkKZJnSw4wGA+5najtFpPuvKfF8pTHsiq30f98sCvcJBTDtpwnfdDXebHyjSiHoLhKnEuj8/egg+7jtqqgqMpgg1GhLUnZ8veXxNpIh4X5+LzRcKiJusVAIRdXkNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957938; c=relaxed/simple;
	bh=jrOSMzKFfACy+tatX/VuGrL8cKipixujDvChQK3dnJk=;
	h=Date:To:From:Subject:Message-Id; b=fYujwB2MnHLmkBVJPOFmeCS5vFKR9vlIYIbhgBrR1PuNawTKiUOM/oHO4Jescu0x4bW+y6cHhmLqwlh6P1vLzy6rlIq0UdzrxT+dOUMdFp1QU6slaZ1mJM1k/MrOPxAYNyjEhflFQl/fn15LxRyzbGCxy0Wz5063rAXCKb0cgfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fAE+v0JR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fAE+v0JR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534D2C113CC;
	Mon,  6 May 2024 01:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957937;
	bh=jrOSMzKFfACy+tatX/VuGrL8cKipixujDvChQK3dnJk=;
	h=Date:To:From:Subject:From;
	b=fAE+v0JRa005geMlVwuPPoXioWkEZppoyGRaNXbbqlDpuMowPBKIvoS/c52Wplr4b
	 i6pKJsHsG7R8v8GGFoe2z54R1JNP3vSgrpshhXlGLF89w2nC3xmS2VjNkJwBfvSvcU
	 Q7qpJsRdTg1aV/LOrCSbIXcFzTSHk6Kh9vPVTF1U=
Date: Sun, 05 May 2024 18:12:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,song@kernel.org,peterz@infradead.org,lkp@intel.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch removed from -mm tree
Message-Id: <20240506011217.534D2C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix
has been removed from the -mm tree.  Its filename was
     watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix.patch

This patch was dropped because it was folded into watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix
Date: Sat May  4 03:39:48 PM PDT 2024

fix kerneldoc

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202405040851.2EgypmL1-lkp@intel.com/ 
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/watchdog_perf.c~watchdog-allow-nmi-watchdog-to-use-raw-perf-event-fix
+++ a/kernel/watchdog_perf.c
@@ -277,6 +277,8 @@ int __init watchdog_hardlockup_probe(voi
 
 /**
  * hardlockup_config_perf_event - Overwrite config of wd_hw_attr.
+ *
+ * @str: number which identifies the raw perf event to use
  */
 void __init hardlockup_config_perf_event(const char *str)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
watchdog-allow-nmi-watchdog-to-use-raw-perf-event.patch
kernel-watchdog_perfc-tidy-up-kerneldoc.patch

