Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC4E156236
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713212532; cv=none; b=J2NkcT6jSHRpFGbvJzOkOPVGOLeE52DpHzyhfSFRikvu+hTq8P7OS0HeLyVTWpodfCqEJ/lTdap+LbsZczP/yTAqVTBXtAB2Obt0b4i9csiR5bKyVQlI3XkQtxWm3OyJYj6//F1Rc2i9/e6jfSdMnJ3EyNUsMqAJfmCj15m4B+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713212532; c=relaxed/simple;
	bh=jQ4tTV26pTNmCSGe/Goy3rvll33CWbg0Xm0sClrbeaU=;
	h=Date:To:From:Subject:Message-Id; b=j5IVyh3c2TuxQbJf3xe4d7tAOH79EW0LSckboz2fPUbfehkq28t/UMZD0vjeu2nBQwDN6frTb7CuVPcN6NHRt6a4cUJYPoKewhz3ktkCXgTdvNBil7fmjGOOLsOA3KvCtgM5Jb+iOXQSg8mlmojL7JBcwFNiL+0Jsd1MYgft8Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SRIrFrH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SRIrFrH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A56C32781;
	Mon, 15 Apr 2024 20:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713212532;
	bh=jQ4tTV26pTNmCSGe/Goy3rvll33CWbg0Xm0sClrbeaU=;
	h=Date:To:From:Subject:From;
	b=SRIrFrH2FIeZIN6CHnZmfvpLtAAtU7mERmK9zyuf8rYFaaGdT1uzkS/y2KItikGvT
	 o12Re6sZbjEYriCfIFC37Egh/XIitFJM8fcOBlsKc/IBtS5dy2K13JSRXcagtpj37l
	 VjFmkOR8RXW89vYykLzgsKEv1cVLbCm5a3W1SP2o=
Date: Mon, 15 Apr 2024 13:22:11 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,mail@maciej.szmigiero.name,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-same_filled-module-params-fix.patch added to mm-unstable branch
Message-Id: <20240415202212.69A56C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: remove same_filled_pages from docs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-remove-same_filled-module-params-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-same_filled-module-params-fix.patch

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
Subject: mm: zswap: remove same_filled_pages from docs
Date: Sun, 14 Apr 2024 21:03:43 +0000

The module parameters are now removed, remove all references from kernel
docs.

Link: https://lkml.kernel.org/r/ZhxFVggdyvCo79jc@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/zswap.rst             |   29 -----------
 Documentation/driver-api/crypto/iaa/iaa-crypto.rst |    2 
 2 files changed, 31 deletions(-)

--- a/Documentation/admin-guide/mm/zswap.rst~mm-zswap-remove-same_filled-module-params-fix
+++ a/Documentation/admin-guide/mm/zswap.rst
@@ -111,35 +111,6 @@ checked if it is a same-value filled pag
 compressed length of the page is set to zero and the pattern or same-filled
 value is stored.
 
-Same-value filled pages identification feature is enabled by default and can be
-disabled at boot time by setting the ``same_filled_pages_enabled`` attribute
-to 0, e.g. ``zswap.same_filled_pages_enabled=0``. It can also be enabled and
-disabled at runtime using the sysfs ``same_filled_pages_enabled``
-attribute, e.g.::
-
-	echo 1 > /sys/module/zswap/parameters/same_filled_pages_enabled
-
-When zswap same-filled page identification is disabled at runtime, it will stop
-checking for the same-value filled pages during store operation.
-In other words, every page will be then considered non-same-value filled.
-However, the existing pages which are marked as same-value filled pages remain
-stored unchanged in zswap until they are either loaded or invalidated.
-
-In some circumstances it might be advantageous to make use of just the zswap
-ability to efficiently store same-filled pages without enabling the whole
-compressed page storage.
-In this case the handling of non-same-value pages by zswap (enabled by default)
-can be disabled by setting the ``non_same_filled_pages_enabled`` attribute
-to 0, e.g. ``zswap.non_same_filled_pages_enabled=0``.
-It can also be enabled and disabled at runtime using the sysfs
-``non_same_filled_pages_enabled`` attribute, e.g.::
-
-	echo 1 > /sys/module/zswap/parameters/non_same_filled_pages_enabled
-
-Disabling both ``zswap.same_filled_pages_enabled`` and
-``zswap.non_same_filled_pages_enabled`` effectively disables accepting any new
-pages by zswap.
-
 To prevent zswap from shrinking pool when zswap is full and there's a high
 pressure on swap (this will result in flipping pages in and out zswap pool
 without any real benefit but with a performance drop for the system), a
--- a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst~mm-zswap-remove-same_filled-module-params-fix
+++ a/Documentation/driver-api/crypto/iaa/iaa-crypto.rst
@@ -457,7 +457,6 @@ Use the following commands to enable zsw
   # echo deflate-iaa > /sys/module/zswap/parameters/compressor
   # echo zsmalloc > /sys/module/zswap/parameters/zpool
   # echo 1 > /sys/module/zswap/parameters/enabled
-  # echo 0 > /sys/module/zswap/parameters/same_filled_pages_enabled
   # echo 100 > /proc/sys/vm/swappiness
   # echo never > /sys/kernel/mm/transparent_hugepage/enabled
   # echo 1 > /proc/sys/vm/overcommit_memory
@@ -599,7 +598,6 @@ the 'fixed' compression mode::
   echo deflate-iaa > /sys/module/zswap/parameters/compressor
   echo zsmalloc > /sys/module/zswap/parameters/zpool
   echo 1 > /sys/module/zswap/parameters/enabled
-  echo 0 > /sys/module/zswap/parameters/same_filled_pages_enabled
 
   echo 100 > /proc/sys/vm/swappiness
   echo never > /sys/kernel/mm/transparent_hugepage/enabled
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-add-null-check-to-obj_cgroup_put.patch
mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch
percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch
mm-zswap-remove-nr_zswap_stored-atomic.patch
mm-zswap-always-shrink-in-zswap_store-if-zswap_pool_reached_full.patch
mm-zswap-refactor-limit-checking-from-zswap_store.patch
mm-zswap-move-more-same-filled-pages-checks-outside-of-zswap_store.patch
mm-zswap-remove-same_filled-module-params.patch
mm-zswap-remove-same_filled-module-params-fix.patch

