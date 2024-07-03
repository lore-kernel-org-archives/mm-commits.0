Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FF51849C6
	for <mm-commits@vger.kernel.org>; Wed,  3 Jul 2024 18:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720031633; cv=none; b=Nn9UNm8GZnJTlTvmWnjX+6FUPx+ZaOF4cEjRiF3rXjLYtGYeXMMTh+Lepmp1sm99PkyZAhHdRAMYVmW7eZImtNcfms7kh/b2sOyEI2Juf91rhftGhEpf345n/DfWaH4zNgNxxLbFHBABUnYLFO2aaiEwFc4ajzDgyAaTc81rYi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720031633; c=relaxed/simple;
	bh=74/sohx31JRQ7DrvAJgSAZ9jDCi4hiLhRNFs6ClLEYY=;
	h=Date:To:From:Subject:Message-Id; b=ol6sIDR3iFgrCYjn7a07AjRan9M7d034cSInx/+jcH9Z7fMZY4QDbJlVZNpU3Wg4+Lv+helhrD/Hzm+drKopZ9OOaCaN1vQ9tqmPLumke8c7wHIEFVATJpBT+SZT4pdpfVv/53T8kWezW7pD9jSYvpxrhnAJWTv1xVFBPZY51M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0SmzsWMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0SmzsWMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BFAC2BD10;
	Wed,  3 Jul 2024 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720031632;
	bh=74/sohx31JRQ7DrvAJgSAZ9jDCi4hiLhRNFs6ClLEYY=;
	h=Date:To:From:Subject:From;
	b=0SmzsWMlf5XQEQMp1A2uLeD8isIFnWTq6DkjVw3vaJlizFWZGpX+B8s4qNYMBbBoa
	 h9YhpNuCxklkxZF9ZthP6hD5nZlLjVVaist6E7sHfNEs016iNSj6FTPR7OQyma8KcP
	 nzf17IKuhC7fs4SMDEFgGDEmYm+LdMMks/8V0WH0=
Date: Wed, 03 Jul 2024 11:33:51 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,nicolas@fjasle.eu,nathan@kernel.org,masahiroy@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-use-zonelist_zone-to-get-zone.patch removed from -mm tree
Message-Id: <20240703183352.91BFAC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use zonelist_zone() to get zone
has been removed from the -mm tree.  Its filename was
     mm-use-zonelist_zone-to-get-zone.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm: use zonelist_zone() to get zone
Date: Tue, 2 Jul 2024 23:40:06 +0000

Instead of accessing zoneref->zone directly, use zonelist_zone() like
other places for consistency.

No functional change.

Link: https://lkml.kernel.org/r/20240702234008.19101-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-use-zonelist_zone-to-get-zone
+++ a/include/linux/mmzone.h
@@ -1690,7 +1690,7 @@ static inline struct zoneref *first_zone
 			zone = zonelist_zone(z))
 
 #define for_next_zone_zonelist_nodemask(zone, z, highidx, nodemask) \
-	for (zone = z->zone;	\
+	for (zone = zonelist_zone(z);	\
 		zone;							\
 		z = next_zones_zonelist(++z, highidx, nodemask),	\
 			zone = zonelist_zone(z))
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch
modpost-meminit-is-not-in-init-section-when-config_memory_hotplug-set.patch
mm-page_alloc-put-__free_pages_core-in-__meminit-section.patch

