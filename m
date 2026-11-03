Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672150;
	b=Njl7+K+YiY5XtzvfMGvnT+IDvELWKBRHc8rV9eBDeLncm2M6gjcXeGS3mOII3IcHAA1/
	 rGo0DiT4lrukaAysFifB6dSe+uSmFqCLRKTlRagCiWWkTDNpFT+zVz4VZCIn7l7LtKoD9
	 I23IakRm0B13LaGwgSEzIQJNvvEyyUwvr+LjhngIMS12jZpTNUO0n1lR3BlLmvS3gE7ho
	 MlbnC2W09vbk7vb1MPOZOBLl2yGdA7urz4K9oofausBi25SElb7G7IFCXdI4BlcEpSKTu
	 BGqNlPRD3JTPjSbGPoOrtrkGbIArvIN4Wx0hxCtWELP/MpFz5Jv2WcqRpTkaDudnA2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672150;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=SMwOVdcyEhwVdRsmiGe5SnDIrCqEo/zvuSYZoMvFTHw=;
	b=lvzI55j5bNAlBUcYAKxgEyLwHXZ0AOqIwICez45qu0IANTaDszjI67jW4pI96YY8IpWM
	 Pj4dSrmc+ZIQanmx6YPLKmvcu3klEMCX5OnmvQDWfkJgDulxRBSYQYcGLDOc1E3CAgYrS
	 yrW5SxXdvEPiiBOYWoSYw55TktXVa3Wn2n+et5H/Hvk99ourrz4U0ddW3LAqujrZlNNH5
	 58Zt3kIADGWK2RK9dFWfLdPMODeKrGsR1nrAVu8iH/Q0cYzu6mAXZBpAr7QIHdWW3EQzt
	 Jf+er07a9+gkRY6ZepaaagCZkgYxcmG7lIxAteZdSAxTcDezsFH8zdI6hqr9k9XODmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mZ78XZBz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5B7606A338
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mZ78XZBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76731F000C1;
	Tue,  3 Nov 2026 02:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672149;
	bh=SMwOVdcyEhwVdRsmiGe5SnDIrCqEo/zvuSYZoMvFTHw=;
	h=Date:To:From:Subject;
	b=mZ78XZBzd/1zN/J4LXwl0fS9vZ6pCa0EHXaKiuYHiD60WkagKRIX3mFNS23ldtBOC
	 vUEdmnGQYzoCHovRjrCmJLST3WOgz1wWWvoZ49jfBGAHJ6TKAnJy6GDAP68BY8CM5d
	 oilRYH3kYTk1PERw+z8ItrY/eQijIIYzMC0ZuyIw=
Date: Mon, 02 Nov 2026 18:15:49 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	kas@kernel.org,david@kernel.org,zenghui.yu@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-khugepaged_race-build-with-older-glibc.patch removed from -mm tree
Message-Id: <20261103021549.A76731F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: fix khugepaged_race build with older glibc
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-khugepaged_race-build-with-older-glibc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: fix khugepaged_race build with older glibc
Date: Tue, 27 Oct 2026 20:20:13 +0800

glibc versions before 2.37 do not define MADV_COLLAPSE in <sys/mman.h>, so
khugepaged_race fails to build against them (e.g. glibc 2.34):

[root@localhost mm]# make
  CC       khugepaged_race
khugepaged_race.c: In function 'main':
khugepaged_race.c:506:23: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
  506 |       hpage_pmd_size, MADV_COLLAPSE);
      |                       ^~~~~~~~~~~~~
      |                       MADV_COLD
khugepaged_race.c:506:23: note: each undeclared identifier is reported only once for each function it appears in
make: *** [../lib.mk:225: /data/code/mm/tools/testing/selftests/mm/khugepaged_race] Error 1

Include <linux/mman.h> to get the UAPI definition of MADV_COLLAPSE.

Link: https://lore.kernel.org/20261027122013.4286-1-zenghui.yu@linux.dev
Fixes: 66c374464438 ("selftests/mm: add khugepaged race harness")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 tools/testing/selftests/mm/khugepaged_race.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/khugepaged_race.c~selftests-mm-fix-khugepaged_race-build-with-older-glibc
+++ a/tools/testing/selftests/mm/khugepaged_race.c
@@ -8,6 +8,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
+#include <linux/mman.h>
 #include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-skip-collapse_compound_extreme-on-thp-allocation-failure.patch
mm-page_alloc-remove-unneeded-forward-declaration-of-__free_pages_ok.patch

