Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793120137;
	b=k7JyMIhZ05+PjHtXocxJFt4z2FA3GJM7DAyzsLpJ6SOHAsh01uKcG/fGY7f22lDQivCJ
	 2tbvDVf6TLzTdfdgQKp9XSwZ5VZBwklwz8YhVm57ZB7ogrn8RejltaFp9rTasJkhpCray
	 7ZKPzNEBMzVRASKe09gdR6ereNtu8akPkdEQEbxNI8mBwk5z9scKSxpdszu8h0yBSNBog
	 CMhfTUYTg2DJqwJU7Tjzv0kjq1Oeh1uh6CgDnVpGJ+usZmQeDj2RqUqCi6nND1iZeKOm+
	 1b9+qx63U/6NpyO/3G9rC3hP1vzPvh1yTbTTZNx6USavmEqP6hCS3z5uJnHHOQjx0fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793120137;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mULTuQYjV8fHu8J0OltvywP34wCBXSOOaWJpBTq/DNs=;
	b=11Zx8JqX+WFD6lL0C3n3Cw9psguwwsi4QlT32N+ZD0rpbwJrQriPSyOeq+LUZ5DNK0RD
	 3dCLlb6zP2r+38U9my5PyTLueCAx+K0t5iprcB49mT4aXOHj9J6FUstRoGRu7AouWjtSw
	 i/dtczJOyDTYDAOxMjowSFbaJ1NHtS+JYokZQ1JqS16bR7DC6SNHzQ2ysMgY2g1E7RgkY
	 adqIYZuwY7LvsYAH7jIm1/KyXQwrEVs9LItnekgJYJVRX3ARraraLmo9VNCXkqcZLDhXe
	 fIp9SpV05XRK12ZuDXI7YNuLB1Kbc+68jijzTwscn3YMbTfD+IieggIdgo/fwNqXpQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xC1YlWn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CC2606A31E
	for <mm-commits@vger.kernel.org>; Tue, 27 Oct 2026 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xC1YlWn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7501F01825;
	Tue, 27 Oct 2026 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793120137;
	bh=mULTuQYjV8fHu8J0OltvywP34wCBXSOOaWJpBTq/DNs=;
	h=Date:To:From:Subject;
	b=xC1YlWn0jYAWqX46LX9xQA5xotn+sZryV+jjZhlH80vwM/0TX/SOfsusJVedWP/cN
	 WonpnfPsxdn7uJB2n75m4XUvnxgcxo7CMfEJI1ETlFEmiqvbTR05NOn4wY1xLKhY0Y
	 t1NhtcXBKfqWLQWvFI0whv9dwOlC8bdiMgNI+Vmw=
Date: Tue, 27 Oct 2026 09:55:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	kas@kernel.org,david@kernel.org,zenghui.yu@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-khugepaged_race-build-with-older-glibc.patch added to mm-unstable branch
Message-Id: <20261027165536.EF7501F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: fix khugepaged_race build with older glibc
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-khugepaged_race-build-with-older-glibc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-khugepaged_race-build-with-older-glibc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch
selftests-mm-fix-khugepaged_race-build-with-older-glibc.patch

