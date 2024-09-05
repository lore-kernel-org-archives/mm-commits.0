Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ABF197A9F
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 23:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725577734; cv=none; b=jWlatEVQUER7MSwI0R4wry3zg9g3j5xrH7PxLeuy3hpjvyqnQpvQjwOdh+AK/Bsl72lXb6tWsCJGiYNT0vzrpqpw4VXpcdhgOWGkUTz9KpiwnwarPxlYdOgOpmNtTHZ4vL7SdCGlPRsf+Fu7Cloe/n/o+CJ9sRROlnrVElMRZgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725577734; c=relaxed/simple;
	bh=d6+1759s0O4ECCFOGXzx331xvceVQC62l+e5k0WMM4E=;
	h=Date:To:From:Subject:Message-Id; b=vEmXQSWLSMfg6xidz9+Xt1ACbNzOXO5syU0SNgA9g4aQ8mFSGNycz4wTZMBLEgpfaio+kMJQdRonOhux/Ltul2Z5MD3C6wj0iYXGq8jKOOXI8H0vRH+J2cQsSRmHnfEQQzGn3Km72J9wW97PQOOdigW/1ti1CKCROgX7yqZcLQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y7ko5sMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y7ko5sMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC95BC4CEC4;
	Thu,  5 Sep 2024 23:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725577733;
	bh=d6+1759s0O4ECCFOGXzx331xvceVQC62l+e5k0WMM4E=;
	h=Date:To:From:Subject:From;
	b=y7ko5sMufhE1mTpP9t4eMGNy+F76j0su4K3cjx/dupevMrtv40y+AxKEIRU4z8sjv
	 fmEpUkLJPa2jIjfUUzcIxo9JFmdjmO6HI5w/oXd1OHAZEYHAg2+vORNxrGRiucZ23L
	 /fUNiUEJOZUdAAOO5pbdW0B8in1Y6t/f7sgxX0Y8=
Date: Thu, 05 Sep 2024 16:08:53 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,senozhatsky@chromium.org,npiggin@gmail.com,nphamcs@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linmiaohe@huawei.com,kernel@xen0n.name,hch@infradead.org,hannes@cmpxchg.org,christophe.leroy@csgroup.eu,chris@chrisdown.name,chenhuacai@kernel.org,aneesh.kumar@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-deprecate-config_z3fold.patch added to mm-unstable branch
Message-Id: <20240905230853.CC95BC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: z3fold: deprecate CONFIG_Z3FOLD
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-deprecate-config_z3fold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-z3fold-deprecate-config_z3fold.patch

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

Link: https://lkml.kernel.org/r/20240904233343.933462-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/configs/loongson3_defconfig |    1 -
 arch/powerpc/configs/ppc64_defconfig       |    1 -
 mm/Kconfig                                 |   14 ++++++++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

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
@@ -177,15 +177,25 @@ config ZBUD
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

mm-page_alloc-fix-missed-updates-of-pgfree-in-free_unref_page-folios.patch
mm-z3fold-deprecate-config_z3fold.patch

