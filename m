Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B58612C1
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 07:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255731; cv=none; b=fAAjpwCgFOw0B2zzZj5h4YpuVauSe+ClkhGnAMYeUIT3IdC9JBu7akrbf9dFFXCt3RbCefmvBF8/tGAQu76EbTtQUSMmtOBXK//ondEDCN/+dH6DNexBQKRpu9tKKId7d0keHou3ASx0EbrE3/BiXDItPe76z+nfw+N8/7fSymI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255731; c=relaxed/simple;
	bh=ZLZYTn/B8vIFgIpb0UrXva4ulCZTvYkWePzryqYwlWU=;
	h=Date:To:From:Subject:Message-Id; b=kyZBUzHXbPKvcJJSjxMsQG7YZSV3UxpucvTHLj/Tup7/ChFEkgapvNA6B8ptgsPPBBGAeWXGhviMRUTG908i405c76Bl34hDYUKvuk2SgzLLTj+qlyqk6MQjCYBjvEvt1Dl/+52QwGFSj23M9TSHK7YC+Dh036kEqy4H4jkup5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hh8L2i7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hh8L2i7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D14C433F1;
	Fri, 26 Jan 2024 07:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255730;
	bh=ZLZYTn/B8vIFgIpb0UrXva4ulCZTvYkWePzryqYwlWU=;
	h=Date:To:From:Subject:From;
	b=hh8L2i7ppq6s0se9Uz0JZE6AUns0C3ZdE1PkbyzP5B1r2SUNc4p/fWzANN/vR6ZJm
	 1WLe8afyBVVUsXj8BMqKzaJa/hhbnp8yxJqdCClsSrTFnkFUppjWeUbGmXSc6Wz1ms
	 nOCcyA3/XYk5ltvFz9u+FIW/yEoKczbdfmMuonfs=
Date: Thu, 25 Jan 2024 23:55:27 -0800
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-supplement-of-zswap-maintainers-update.patch removed from -mm tree
Message-Id: <20240126075529.E2D14C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: supplement of zswap maintainers update
has been removed from the -mm tree.  Its filename was
     maintainers-supplement-of-zswap-maintainers-update.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: MAINTAINERS: supplement of zswap maintainers update
Date: Wed, 17 Jan 2024 18:21:52 +0000

As discussed on the mailing list [1], merge the zpool maintainers entry
into the zswap one.  Also, add CREDITS entries for previous zswap/zpool
maintainers.

[1] https://lore.kernel.org/linux-mm/CAJD7tkYx4YWhGoVwnSeGc8dY_1aRRxxg8PzWBV==A6iqG_OgFw@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240117182152.1439822-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Seth Jennings <sjenning@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |   13 +++++++++++++
 MAINTAINERS |    9 ++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/CREDITS~maintainers-supplement-of-zswap-maintainers-update
+++ a/CREDITS
@@ -2161,6 +2161,19 @@ N: Mike Kravetz
 E: mike.kravetz@oracle.com
 D: Maintenance and development of the hugetlb subsystem
 
+N: Seth Jennings
+E: sjenning@redhat.com
+D: Creation and maintenance of zswap
+
+N: Dan Streetman
+E: ddstreet@ieee.org
+D: Maintenance and development of zswap
+D: Creation and maintenance of the zpool API
+
+N: Vitaly Wool
+E: vitaly.wool@konsulko.com
+D: Maintenance and development of zswap
+
 N: Andreas S. Krebs
 E: akrebs@altavista.net
 D: CYPRESS CY82C693 chipset IDE, Digital's PC-Alpha 164SX boards
--- a/MAINTAINERS~maintainers-supplement-of-zswap-maintainers-update
+++ a/MAINTAINERS
@@ -24341,13 +24341,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	Documentation/filesystems/zonefs.rst
 F:	fs/zonefs/
 
-ZPOOL COMPRESSED PAGE STORAGE API
-M:	Dan Streetman <ddstreet@ieee.org>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	include/linux/zpool.h
-F:	mm/zpool.c
-
 ZR36067 VIDEO FOR LINUX DRIVER
 M:	Corentin Labbe <clabbe@baylibre.com>
 L:	mjpeg-users@lists.sourceforge.net
@@ -24399,7 +24392,9 @@ M:	Nhat Pham <nphamcs@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/zswap.rst
+F:	include/linux/zpool.h
 F:	include/linux/zswap.h
+F:	mm/zpool.c
 F:	mm/zswap.c
 
 THE REST
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch

