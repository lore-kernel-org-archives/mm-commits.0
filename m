Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A02017D8A9
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 20:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725913864; cv=none; b=X2BsO2I/91Zqd4UIzp36PGPrkBLPNBhSFYvmOeNvvMk8+lsOKkmDdH1fxoOnvTk7b5FLyDN+n5r2INUeHQSFAyHMupzkn4uiQ9vK74XuNGBsxYipdwZmGM+qcWOC3w94aA2mCihvY2Sw6wWhhSsok3REil74KqJmRmtPqsfG2/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725913864; c=relaxed/simple;
	bh=Q26IjUKhSUJZoxbefUpBmozmSJZzzvI6wc5vihtKCYw=;
	h=Date:To:From:Subject:Message-Id; b=WnNSDebJaJRIZoDXusN89AxeSJzTwDuz7EuFYWIq1OJkJZ0kz7Upe1PtqgC5Hz0FZ9Y4zsxsg0EytPOrPmQFZNQdONEG57gQBpf/j/NPwKXYreP5GAfsiZgUBHBomD1aNoTy6Si5TLnOfYe8y+WNiiiSJ0hOIT7Wq+UVDDx9+JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JXA2h4ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JXA2h4ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE27C4CEC5;
	Mon,  9 Sep 2024 20:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725913863;
	bh=Q26IjUKhSUJZoxbefUpBmozmSJZzzvI6wc5vihtKCYw=;
	h=Date:To:From:Subject:From;
	b=JXA2h4irvR9Vg+VwQPwztvT6ZDrHkGhBiCWjmLcCCINcigxK9TvvNtGclUoYLnNfj
	 yKJARux1+QTRmp2Cc2kHdeDyVwFXKSGswWngmhaXkyAfiFoAz0FQQ4vOL/33V7Sf7c
	 TmJctjy4Cgpond4Pkdc6QCQ0MubpaMb1KsXlxUN4=
Date: Mon, 09 Sep 2024 13:31:02 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,willy@infradead.org,vitaly.wool@konsulko.com,vbabka@suse.cz,rppt@kernel.org,peterx@redhat.com,nphamcs@gmail.com,kees@kernel.org,hannes@cmpxchg.org,david@redhat.com,chris@chrisdown.name,anshuman.khandual@arm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-deprecate-config_z3fold-fix.patch added to mm-unstable branch
Message-Id: <20240909203103.CBE27C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: z3fold: deprecated ZSWAP_ZPOOL_DEFAULT_Z3FOLD as well
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-deprecate-config_z3fold-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-z3fold-deprecate-config_z3fold-fix.patch

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

mm-z3fold-deprecate-config_z3fold-fix.patch

