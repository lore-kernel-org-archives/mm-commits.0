Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04013E3F5
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560218; cv=none; b=CTSwEOPYRaUtnX+7gN03mt6LG+I01oXhAoa4shYhsftC/nnN1M8ed36YhbLmKtgoRTbJjUYjQpVG+91Og7tCIbhE6RHbAUGqn5g1UzwEmtwGW8K4qA9pkqmYQk0HZde+A4MN79U+Uj6Taf/k1yQ8yfgjmK4b2e/Q+4Y+SwVVni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560218; c=relaxed/simple;
	bh=SoGAzq1Pd80FrzuPGWHspm+WQ1FL1AsITyuXdtZAlIs=;
	h=Date:To:From:Subject:Message-Id; b=SWgj/NeOzOy0fFvVIpCU5hKsVEUXMsuVME7/zkiykJzrjlQfh25dGxnl9E+crtoz0iQIUhO5gi++P7rcl9yBAaIXxKoN9gxk2lETEwWTP6k7MMIHLSyTxPAHMnb1MVnZskPjTKc/pffs5QQMWCHOCOSPPh1sFk4aRVSwADouJDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KukogTc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KukogTc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91E9C4CEC6;
	Tue, 17 Sep 2024 08:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560218;
	bh=SoGAzq1Pd80FrzuPGWHspm+WQ1FL1AsITyuXdtZAlIs=;
	h=Date:To:From:Subject:From;
	b=KukogTc+rbKvk36AwgA6SP8esNlK3HObwoEqthBpVOuI90gabsxf2yOhZxbrSUACb
	 cOL0UefeeO3voDbrnuSJTTicwAwSAvH3azbT40ziPgHSH0rtLBIB3em4TIScQXicCE
	 ePjSS5zFRIxNqMhVINEROJXgWhMLb2MyGG38z8g4=
Date: Tue, 17 Sep 2024 01:03:35 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,willy@infradead.org,vitaly.wool@konsulko.com,vbabka@suse.cz,rppt@kernel.org,peterx@redhat.com,nphamcs@gmail.com,kees@kernel.org,hannes@cmpxchg.org,david@redhat.com,chris@chrisdown.name,anshuman.khandual@arm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-z3fold-deprecate-config_z3fold-fix.patch removed from -mm tree
Message-Id: <20240917080337.C91E9C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: z3fold: deprecated ZSWAP_ZPOOL_DEFAULT_Z3FOLD as well
has been removed from the -mm tree.  Its filename was
     mm-z3fold-deprecate-config_z3fold-fix.patch

This patch was dropped because it was folded into mm-z3fold-deprecate-config_z3fold.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm: z3fold: deprecated ZSWAP_ZPOOL_DEFAULT_Z3FOLD as well
Date: Mon, 9 Sep 2024 20:26:16 +0000

Randconfig builds that use ZSWAP_ZPOOL_DEFAULT_Z3FOLD now cause a harmless
warning:

WARNING: unmet direct dependencies detected for Z3FOLD
  Depends on [n]: Z3FOLD_DEPRECATED [=n]
  Selected by [y]:
  - ZSWAP_ZPOOL_DEFAULT_Z3FOLD [=y] && ZSWAP [=y]

Avoid the warning by selecting Z3FOLD_DEPRECATED instead,
but rename this symbol to ZSWAP_ZPOOL_DEFAULT_Z3FOLD_DEPRECATED
in the process so it no longer automatically gets used with
old defconfigs while still allowing users to select it
manually.

Link: https://lkml.kernel.org/r/20240909202625.1054880-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/Kconfig~mm-z3fold-deprecate-config_z3fold-fix
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
 
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-z3fold-deprecate-config_z3fold.patch

