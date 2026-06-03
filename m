Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743503932FA
	for <mm-commits@vger.kernel.org>; Wed,  3 Jun 2026 23:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780529186; cv=none; b=HGGfJfqvQGum5Y24ICd1dBmkizYrIwuLKo+9FfEVDPq/NwyjzlGScpKpWpmLnUi8zKAZR35d/tWoLwby80NRs6y+3O0rjBXbnx2pj8PeViE03a+Ru5ubwmHIhXpVRv+700n+oc28iQBcjzdxX2jwIvL6gGzTbMJilLlufGZ5Ip8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780529186; c=relaxed/simple;
	bh=+/Q10ybIky3cc8KVuwm4x32BX0oC1uRnmL4jFGAgX3s=;
	h=Date:To:From:Subject:Message-Id; b=KurZeVChOYt9EYM2MBnplNXaxtvSAtawDYFOn+hzqLHOK3eF1rPU689VsSjxIReXeNHVsT7B8RORIgXANtKxVQPwgKio2j94+Jto1i1uMybl8217ir/0wyQVqaTKEEl5b/4vtNqdI5M4Cb40EDB/4EKXbkinFrs3foWgF4z11aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wv9Bvs5m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wv9Bvs5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4809E1F00898;
	Wed,  3 Jun 2026 23:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780529185;
	bh=jzE0H02M7DMS05juV0e+zN1z6wtjOMXNVyzI3db6wPI=;
	h=Date:To:From:Subject;
	b=Wv9Bvs5mX6nqBFVCS9rvrCVCmAII17iSPQw1hNrF2m5hSLPh7zHqYHif99sY4wn5+
	 DGtU3ai0/z1KhbFxjaHxMMgj7NcYHX909B+gAh1XdiEs7Zcdyf3wF7fdDpnKjr8TaU
	 BD6iqmcoDPDy+t8Z1TWkK10+BuB86G0odbS54VCk=
Date: Wed, 03 Jun 2026 16:26:24 -0700
To: mm-commits@vger.kernel.org,baoquan.he@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-baoquan-hes-email-address.patch removed from -mm tree
Message-Id: <20260603232625.4809E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Baoquan He's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-baoquan-hes-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <baoquan.he@linux.dev>
Subject: MAINTAINERS: update Baoquan He's email address
Date: Thu, 28 May 2026 21:14:54 +0800

I will switch to use @linux.dev mailbox, update all entries in
MAINTAINERS.  And map the address in .mailmap.

Link: https://lore.kernel.org/20260528131454.1996752-1-baoquan.he@linux.dev
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/.mailmap~maintainers-update-baoquan-hes-email-address
+++ a/.mailmap
@@ -126,6 +126,7 @@ Baolin Wang <baolin.wang@linux.alibaba.c
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang@spreadtrum.com>
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang@unisoc.com>
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang7@gmail.com>
+Baoquan He <baoquan.he@linux.dev> <bhe@redhat.com>
 Barry Song <baohua@kernel.org> <21cnbao@gmail.com>
 Barry Song <baohua@kernel.org> <v-songbaohua@oppo.com>
 Barry Song <baohua@kernel.org> <song.bao.hua@hisilicon.com>
--- a/MAINTAINERS~maintainers-update-baoquan-hes-email-address
+++ a/MAINTAINERS
@@ -13864,7 +13864,7 @@ F:	scripts/Makefile.kcsan
 
 KDUMP
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Baoquan He <bhe@redhat.com>
+M:	Baoquan He <baoquan.he@linux.dev>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Pratyush Yadav <pratyush@kernel.org>
@@ -14183,7 +14183,7 @@ F:	include/linux/kernfs.h
 
 KEXEC
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Baoquan He <bhe@redhat.com>
+M:	Baoquan He <baoquan.he@linux.dev>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Pratyush Yadav <pratyush@kernel.org>
@@ -17036,7 +17036,7 @@ M:	Chris Li <chrisl@kernel.org>
 M:	Kairui Song <kasong@tencent.com>
 R:	Kemeng Shi <shikemeng@huaweicloud.com>
 R:	Nhat Pham <nphamcs@gmail.com>
-R:	Baoquan He <bhe@redhat.com>
+R:	Baoquan He <baoquan.he@linux.dev>
 R:	Barry Song <baohua@kernel.org>
 R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from baoquan.he@linux.dev are


