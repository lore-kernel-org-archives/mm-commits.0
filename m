Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B76156C62;
	Tue, 17 Sep 2024 08:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560525; cv=none; b=LPJIVmlYXFmVFwe5OCP3oPK9YNebjm1uXp3o49KYBjey5gkXa3PBnhNtQsyHbd79uNInZoUjXk+5n0mVR7Xk04vDTzzylVrf0oxDYUUgmTuuUYujwtxlMuffs7IGlqdB2vu3ISOpD+MC1RXo2J2mfKP0Ufv2GAdOU50Knoj5EFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560525; c=relaxed/simple;
	bh=sh6ABWqGcsje+n2ZIJeDC3rHfUArvndyQmY2qM1izOs=;
	h=Date:To:From:Subject:Message-Id; b=uoL/WFi6qpb+2O8O7c8LMXNZqSX5G+CJ+rqrHzTXm6C3fyKpOfY9PnlDMRfyeu54GYb4wuJusp1pF/4NuWJ4YuGZwyVTNgRTYAHfB17miE8hHmOAgLQ6NyGBiGJpsNahQ2wgSY2+xZmGiefEWv3MmhnVTEAldLHb6xDkxcUyQPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n8KqBYfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n8KqBYfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C39EC4CECE;
	Tue, 17 Sep 2024 08:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560524;
	bh=sh6ABWqGcsje+n2ZIJeDC3rHfUArvndyQmY2qM1izOs=;
	h=Date:To:From:Subject:From;
	b=n8KqBYfRaSOE8MF8suTthtvoZrqw79Fh8PXz79mS5BmYtEjcxahHFCDyyXkVY9Cf3
	 AsJf7yCP61Jqu8tCGYuIvtSJaN+fbLRgaBLC0IiiqWI573O1tikiFlPwvD+tsLDnQ7
	 N9eaoZcXWTZ/F67y2Lf/r5q7rivSQuD42XTPTTUc=
Date: Tue, 17 Sep 2024 01:08:41 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,stable@vger.kernel.org,senozhatsky@chromium.org,npiggin@gmail.com,nphamcs@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linmiaohe@huawei.com,kernel@xen0n.name,hch@lst.de,hannes@cmpxchg.org,christophe.leroy@csgroup.eu,chris@chrisdown.name,chenhuacai@kernel.org,arnd@arndb.de,aneesh.kumar@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-deprecate-config_z3fold.patch removed from -mm tree
Message-Id: <20240917080844.4C39EC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: z3fold: deprecate CONFIG_Z3FOLD
has been removed from the -mm tree.  Its filename was
     mm-z3fold-deprecate-config_z3fold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: z3fold: deprecate CONFIG_Z3FOLD
Date: Wed, 4 Sep 2024 23:33:43 +0000

The z3fold compressed pages allocator is rarely used, most users use
zsmalloc.  The only disadvantage of zsmalloc in comparison is the
dependency on MMU, and zbud is a more common option for !MMU as it was the
default zswap allocator for a long time.

Historically, zsmalloc had worse latency than zbud and z3fold but offered
better memory savings.  This is no longer the case as shown by a simple
recent analysis [1].  That analysis showed that z3fold does not have any
advantage over zsmalloc or zbud considering both performance and memory
usage.  In a kernel build test on tmpfs in a limited cgroup, z3fold took
3% more time and used 1.8% more memory.  The latency of zswap_load() was
7% higher, and that of zswap_store() was 10% higher.  Zsmalloc is better
in all metrics.

Moreover, z3fold apparently has latent bugs, which was made noticeable by
a recent soft lockup bug report with z3fold [2].  Switching to zsmalloc
not only fixed the problem, but also reduced the swap usage from 6~8G to
1~2G.  Other users have also reported being bitten by mistakenly enabling
z3fold.

Other than hurting users, z3fold is repeatedly causing wasted engineering
effort.  Apart from investigating the above bug, it came up in multiple
development discussions (e.g.  [3]) as something we need to handle, when
there aren't any legit users (at least not intentionally).

The natural course of action is to deprecate z3fold, and remove in a few
cycles if no objections are raised from active users.  Next on the list
should be zbud, as it offers marginal latency gains at the cost of huge
memory waste when compared to zsmalloc.  That one will need to wait until
zsmalloc does not depend on MMU.

Rename the user-visible config option from CONFIG_Z3FOLD to
CONFIG_Z3FOLD_DEPRECATED so that users with CONFIG_Z3FOLD=y get a new
prompt with explanation during make oldconfig.  Also, remove
CONFIG_Z3FOLD=y from defconfigs.

[1]https://lore.kernel.org/lkml/CAJD7tkbRF6od-2x_L8-A1QL3=2Ww13sCj4S3i4bNndqF+3+_Vg@mail.gmail.com/
[2]https://lore.kernel.org/lkml/EF0ABD3E-A239-4111-A8AB-5C442E759CF3@gmail.com/
[3]https://lore.kernel.org/lkml/CAJD7tkbnmeVugfunffSovJf9FAgy9rhBVt_tx=nxUveLUfqVsA@mail.gmail.com/

[arnd@arndb.de: deprecate ZSWAP_ZPOOL_DEFAULT_Z3FOLD as well]
  Link: https://lkml.kernel.org/r/20240909202625.1054880-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20240904233343.933462-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vitaly Wool <vitaly.wool@konsulko.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/configs/loongson3_defconfig |    1 
 arch/powerpc/configs/ppc64_defconfig       |    1 
 mm/Kconfig                                 |   25 ++++++++++++++-----
 3 files changed, 19 insertions(+), 8 deletions(-)

--- a/arch/loongarch/configs/loongson3_defconfig~mm-z3fold-deprecate-config_z3fold
+++ a/arch/loongarch/configs/loongson3_defconfig
@@ -96,7 +96,6 @@ CONFIG_ZPOOL=y
 CONFIG_ZSWAP=y
 CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD=y
 CONFIG_ZBUD=y
-CONFIG_Z3FOLD=y
 CONFIG_ZSMALLOC=m
 # CONFIG_COMPAT_BRK is not set
 CONFIG_MEMORY_HOTPLUG=y
--- a/arch/powerpc/configs/ppc64_defconfig~mm-z3fold-deprecate-config_z3fold
+++ a/arch/powerpc/configs/ppc64_defconfig
@@ -81,7 +81,6 @@ CONFIG_MODULE_SIG_SHA512=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_BINFMT_MISC=m
 CONFIG_ZSWAP=y
-CONFIG_Z3FOLD=y
 CONFIG_ZSMALLOC=y
 # CONFIG_SLAB_MERGE_DEFAULT is not set
 CONFIG_SLAB_FREELIST_RANDOM=y
--- a/mm/Kconfig~mm-z3fold-deprecate-config_z3fold
+++ a/mm/Kconfig
@@ -146,12 +146,15 @@ config ZSWAP_ZPOOL_DEFAULT_ZBUD
 	help
 	  Use the zbud allocator as the default allocator.
 
-config ZSWAP_ZPOOL_DEFAULT_Z3FOLD
-	bool "z3fold"
-	select Z3FOLD
+config ZSWAP_ZPOOL_DEFAULT_Z3FOLD_DEPRECATED
+	bool "z3foldi (DEPRECATED)"
+	select Z3FOLD_DEPRECATED
 	help
 	  Use the z3fold allocator as the default allocator.
 
+	  Deprecated and scheduled for removal in a few cycles,
+	  see CONFIG_Z3FOLD_DEPRECATED.
+
 config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
 	bool "zsmalloc"
 	select ZSMALLOC
@@ -163,7 +166,7 @@ config ZSWAP_ZPOOL_DEFAULT
        string
        depends on ZSWAP
        default "zbud" if ZSWAP_ZPOOL_DEFAULT_ZBUD
-       default "z3fold" if ZSWAP_ZPOOL_DEFAULT_Z3FOLD
+       default "z3fold" if ZSWAP_ZPOOL_DEFAULT_Z3FOLD_DEPRECATED
        default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
        default ""
 
@@ -177,15 +180,25 @@ config ZBUD
 	  deterministic reclaim properties that make it preferable to a higher
 	  density approach when reclaim will be used.
 
-config Z3FOLD
-	tristate "3:1 compression allocator (z3fold)"
+config Z3FOLD_DEPRECATED
+	tristate "3:1 compression allocator (z3fold) (DEPRECATED)"
 	depends on ZSWAP
 	help
+	  Deprecated and scheduled for removal in a few cycles. If you have
+	  a good reason for using Z3FOLD over ZSMALLOC, please contact
+	  linux-mm@kvack.org and the zswap maintainers.
+
 	  A special purpose allocator for storing compressed pages.
 	  It is designed to store up to three compressed pages per physical
 	  page. It is a ZBUD derivative so the simplicity and determinism are
 	  still there.
 
+config Z3FOLD
+	tristate
+	default y if Z3FOLD_DEPRECATED=y
+	default m if Z3FOLD_DEPRECATED=m
+	depends on Z3FOLD_DEPRECATED
+
 config ZSMALLOC
 	tristate
 	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
_

Patches currently in -mm which might be from yosryahmed@google.com are


