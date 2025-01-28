Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007FB1CD2B
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 01:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738026239; cv=none; b=ptkglQNmEou8xy5xGrecBdjtf2jjBBZBgVLEZv8rM6F1vRXekQsgcdWqY4sB1hxlNX05/NGruIAO3mv58QTAY4lef31NPGnLxyvHHyad79U88+q61V3BYVHlaw0QEirvv/F2EUdOL5E4d6vWaeLIa+NGhkDjt1RTrFgof0oeBGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738026239; c=relaxed/simple;
	bh=O7wvims7MlXgO/4GRgwbvmXr+KHpEIKuUxV3tl7cPNk=;
	h=Date:To:From:Subject:Message-Id; b=kfX3JwiyPVkqbHGkuv3fZDwR9xQ5xRlkVZdW1TOKPCr6LV4HnOy6CWHA81ctrs9Zsni9pcL2XDRMeF0FhwrHJcBhozuHrccVEMTzK33McIAlMajmb0t75FCl7RC1Cu91j0hmmqWhQZC2OQuw2s3tngge+0VtqARlQ8LxG95Ewc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=irebRZVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="irebRZVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325AFC4CED2;
	Tue, 28 Jan 2025 01:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738026238;
	bh=O7wvims7MlXgO/4GRgwbvmXr+KHpEIKuUxV3tl7cPNk=;
	h=Date:To:From:Subject:From;
	b=irebRZVC+NvmBYKskvTX6zDhfOBuoE6u9AZIu9PRSRhPKVdldd6IQnRckswjJ5gJE
	 xFqQ/iFMJ0w3uPPNY/z4Uvdkj26J228nkscDLM3M8YxinTIK63jhV79br5ZgusuNVD
	 hM++DpD/g9wM93OWR/2DQJ9WZASKdexvV1mNIwx4=
Date: Mon, 27 Jan 2025 17:03:57 -0800
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,nphamcs@gmail.com,linmiaohe@huawei.com,kernel@xen0n.name,hannes@cmpxchg.org,chenhuacai@kernel.org,chengming.zhou@linux.dev,yosry.ahmed@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zbud-deprecate-config_zbud.patch added to mm-unstable branch
Message-Id: <20250128010358.325AFC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zbud: deprecate CONFIG_ZBUD
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zbud-deprecate-config_zbud.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zbud-deprecate-config_zbud.patch

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
From: Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: mm: zbud: deprecate CONFIG_ZBUD
Date: Mon, 27 Jan 2025 23:58:21 +0000

Patch series "mm: zswap: deprecate zbud and remove z3fold".

After 2 cycles of deprecating z3fold, remove it and mark zbud as
deprecated for removal next.  It was initially thought that zbud cannot be
removed because it has no dependency on CONFIG_MMU while zsmalloc does,
but CONFIG_SWAP depends on CONFIG_MMU anyway.


This patch (of 2):

The zbud compressed pages allocator is rarely used, most users use
zsmalloc.  zbud consumes much more memory (only stores 1 or 2 compressed
pages per physical page).  The only advantage of zbud is a marginal
performance improvement that by no means justify the memory overhead.

Historically, zsmalloc had significantly worse latency than zbud and
z3fold but offered better memory savings.  This is no longer the case as
shown by a simple recent analysis [1].  In a kernel build test on tmpfs in
a limited cgroup, zbud 2-3% less time than zsmalloc, but at the cost of
using ~32% more memory (1.5G vs 1.13G).  The tradeoff does not make sense
for zbud in any practical scenario.

The only alleged advantage of zbud is not having the dependency on
CONFIG_MMU, but CONFIG_SWAP already depends on CONFIG_MMU anyway, and zbud
is only used by zswap.

Following in the footsteps of [2], which deprecated z3fold, deprecated
zbud as planned and remove it in a few cycles if no objections are raised
from active users.

Rename the user-visible config options so that users with CONFIG_ZBUD=y
get a new prompt with explanation during make oldconfig.  Also, remove
CONFIG_ZBUD from defconfig.

[1]https://lore.kernel.org/lkml/CAJD7tkbRF6od-2x_L8-A1QL3=2Ww13sCj4S3i4bNndqF+3+_Vg@mail.gmail.com/
[2]https://lore.kernel.org/lkml/20240904233343.933462-1-yosryahmed@google.com/

Link: https://lkml.kernel.org/r/Z5gdlO5pOu9XeGce@google.com
Link: https://lkml.kernel.org/r/Z5gdnSX5Lv-nfjQL@google.com
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/configs/loongson3_defconfig |    3 --
 mm/Kconfig                                 |   26 +++++++++++++------
 2 files changed, 20 insertions(+), 9 deletions(-)

--- a/arch/loongarch/configs/loongson3_defconfig~mm-zbud-deprecate-config_zbud
+++ a/arch/loongarch/configs/loongson3_defconfig
@@ -109,8 +109,7 @@ CONFIG_BINFMT_MISC=m
 CONFIG_ZPOOL=y
 CONFIG_ZSWAP=y
 CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD=y
-CONFIG_ZBUD=y
-CONFIG_ZSMALLOC=m
+CONFIG_ZSMALLOC=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MEMORY_HOTPLUG=y
 # CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE is not set
--- a/mm/Kconfig~mm-zbud-deprecate-config_zbud
+++ a/mm/Kconfig
@@ -129,7 +129,6 @@ choice
 	prompt "Default allocator"
 	depends on ZSWAP
 	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
-	default ZSWAP_ZPOOL_DEFAULT_ZBUD
 	help
 	  Selects the default allocator for the compressed cache for
 	  swap pages.
@@ -140,12 +139,15 @@ choice
 	  The selection made here can be overridden by using the kernel
 	  command line 'zswap.zpool=' option.
 
-config ZSWAP_ZPOOL_DEFAULT_ZBUD
-	bool "zbud"
-	select ZBUD
+config ZSWAP_ZPOOL_DEFAULT_ZBUD_DEPRECATED
+	bool "zbud (DEPRECATED)"
+	select ZBUD_DEPRECATED
 	help
 	  Use the zbud allocator as the default allocator.
 
+	  Deprecated and scheduled for removal in a few cycles,
+	  see CONFIG_ZBUD_DEPRECATED.
+
 config ZSWAP_ZPOOL_DEFAULT_Z3FOLD_DEPRECATED
 	bool "z3foldi (DEPRECATED)"
 	select Z3FOLD_DEPRECATED
@@ -165,21 +167,31 @@ endchoice
 config ZSWAP_ZPOOL_DEFAULT
        string
        depends on ZSWAP
-       default "zbud" if ZSWAP_ZPOOL_DEFAULT_ZBUD
+       default "zbud" if ZSWAP_ZPOOL_DEFAULT_ZBUD_DEPRECATED
        default "z3fold" if ZSWAP_ZPOOL_DEFAULT_Z3FOLD_DEPRECATED
        default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
        default ""
 
-config ZBUD
-	tristate "2:1 compression allocator (zbud)"
+config ZBUD_DEPRECATED
+	tristate "2:1 compression allocator (zbud) (DEPRECATED)"
 	depends on ZSWAP
 	help
+	  Deprecated and scheduled for removal in a few cycles. If you have
+	  a good reason for using ZBUD over ZSMALLOC, please contact
+	  linux-mm@kvack.org and the zswap maintainers.
+
 	  A special purpose allocator for storing compressed pages.
 	  It is designed to store up to two compressed pages per physical
 	  page.  While this design limits storage density, it has simple and
 	  deterministic reclaim properties that make it preferable to a higher
 	  density approach when reclaim will be used.
 
+config ZBUD
+	tristate
+	default y if ZBUD_DEPRECATED=y
+	default m if ZBUD_DEPRECATED=m
+	depends on ZBUD_DEPRECATED
+
 config Z3FOLD_DEPRECATED
 	tristate "3:1 compression allocator (z3fold) (DEPRECATED)"
 	depends on ZSWAP
_

Patches currently in -mm which might be from yosry.ahmed@linux.dev are

maintainers-mailmap-update-yosry-ahmeds-email-address.patch
mm-zbud-deprecate-config_zbud.patch
mm-z3fold-remove-z3fold.patch

