Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832445;
	b=dV7/DmlDbsR0Wa7uJx7/kgh1H+4vYkPhbSHtrsq8/InH+vepegYlq3KCijZh4IqSiqTE
	 j5EiKkgysJhyK/gPa9ipCg/nixFqoTh9muDeIEq0LA2vdQL2UrC47Sm1UWNZ5wt2ToFmI
	 Gmla3wM58C+8SdLzA3pY+GKlhm/JpaY1sNpDUysgRCCSbrBL1+fMTzpSEm3XbltDcjZH/
	 4BanT+0Us9WHOPGfEQ9ZJ/oyrHVrqja17hrwkJ4mTLRtt+vgRmFbqkHWgts5pOjLUq4NE
	 VYw2c7bkJmYCnhhc84Gum4lHcw84mcVihw1WciODDmH7zjZsIJ10pMRTexz3lcsZzTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832445;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=p6tr4ecEFNQjuk/Ql4z1cf77auYsWGogLSm7EA8zy20=;
	b=SEbVd/ZA/JXXCnbggXkonqXIeiD9SrJjF2L+ib+0ReGTwakuxhn0g0B7k1o7hbjVK4SF
	 0YoS7yCrTCBCx0uz5b5AAtIH2t3rB3JpsaJs60DFlWIMmgP2AyrfurdK95q3ehBfdKyJe
	 IpGKU9Y6hC20zLeaOlX+SK9NWqB/GWqrufJvqelURDffXOpKRPerhqAyDvVHQoCl6vanM
	 a0JlfaJfRVXb/FDCmVESCBCIIsMRqHLtku9g4GmmAl3f0eyWshFOG/z7gTQptmXu8bcGT
	 DwIxzN/+se+j7D4WulYiyAktG285YIosW2FAYD6Yg51DestGJm/dzXwC/Y6Dcu6bRRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aMs8ELpW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C92606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aMs8ELpW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6DD1F01829;
	Sat, 24 Oct 2026 09:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832444;
	bh=p6tr4ecEFNQjuk/Ql4z1cf77auYsWGogLSm7EA8zy20=;
	h=Date:To:From:Subject;
	b=aMs8ELpWKzjE7k6wgb5K9GS1yO87YX44QO1wg7FchcW0tuEF7EWwKhTvDgtK/xlTJ
	 expndfMTGRsFdboaKq5Au6KJ7Kow8YeUfN9lzj0j6nRvIKy0zvPV91Zb0mGj0mmbLi
	 Yr7ItT0COlMldAfnC4Oy1bHX/2oUYRoA4LQQf2+k=
Date: Sat, 24 Oct 2026 02:00:44 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,joe@perches.com,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch removed from -mm tree
Message-Id: <20261024090044.AB6DD1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: cover all hugetlb headers under HUGETLB SUBSYSTEM
has been removed from the -mm tree.  Its filename was
     maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: MAINTAINERS: cover all hugetlb headers under HUGETLB SUBSYSTEM
Date: Sat,  3 Oct 2026 14:00:28 +0800

The HUGETLB SUBSYSTEM F: entries list include/linux/hugetlb.h explicitly,
but other hugetlb headers are not covered, so get_maintainer.pl does not
attribute them to the hugetlb maintainers.

Enumerating headers by hand is also fragile: any header not listed (such
as hugetlb_cgroup.h) falls outside the subsystem.  Joe Perches suggested
using a glob F: entry, which covers all current and future hugetlb headers
in one line and avoids the gap.

Link: https://lore.kernel.org/20261003060029.2152489-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem
+++ a/MAINTAINERS
@@ -12097,7 +12097,7 @@ F:	Documentation/admin-guide/mm/hugetlbp
 F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
-F:	include/linux/hugetlb.h
+F:	include/linux/hugetlb*
 F:	include/linux/vmemmap-optimization.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
_

Patches currently in -mm which might be from lienze@kylinos.cn are


