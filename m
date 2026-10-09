Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944174052B7
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525497; cv=none; b=Y1zxjqqIWzavH9sxiqCM4AYxd6oL1fVhsmYZfWVk0UqtIOEdM7kLlTxYo+4f6Aj1DQf0GB9yq/Slw/yLFacsUhhuo/ac0Gzn/6sAKCqjiO4i8Szwz22HG+wB5uiznsW19nvn5PLDVfvMAev8VjqK0k6gWDkdmztVnCNGia0bB3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525497; c=relaxed/simple;
	bh=8j7pRGWrz/6EfVzF+4ROdoh8GNUPUwtI+02Fq0GkYEQ=;
	h=Date:To:From:Subject:Message-Id; b=r1jvQjhn14oaszcHC48SbtB5J4+e+ZPUTu3JN9GdlKvNPf127obgwysHV4C5jdONtTUiGAU9+3OLkmN8OwKBBcIVKNqC+d7dNuiMkeJAa1A8XpOMYm3sQGKJs+grXZu2E2DWK3J22IDSYF6QCgfyN4DGGMSEEKrGzH0G8C7sRxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UMKZqCtm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UMKZqCtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA251F000FF;
	Fri,  9 Oct 2026 05:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525495;
	bh=QuRfH+2ivGjKOOz4ph4yrW1m7ryn+8IT4zBIAUbOcd4=;
	h=Date:To:From:Subject;
	b=UMKZqCtmNk5f4yD/py48r/kbSmFm2shlizmLj9LTY8WyTwMUfsYY8+kPvgyOWnXQI
	 gDdCboVR9fbcTR2bu/Zx/WrdERNjGgVjpwUGPFobEsVFhzEn1huLjfzz3TzqlLRZWn
	 FLdNGJPeTRKQHscFAQhxEqnYbbczmXpfswO+ZDnY=
Date: Thu, 08 Oct 2026 22:58:15 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,james.bottomley@HansenPartnership.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch removed from -mm tree
Message-Id: <20261009055815.6AA251F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix ptrace PEEKDATA check in memfd_secret test
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix ptrace PEEKDATA check in memfd_secret test
Date: Thu, 10 Sep 2026 14:44:15 +0800

try_ptrace() treats PTRACE_PEEKDATA return value as a boolean check.  A
successful read returns non-zero data (memory filled with 0x55), causing
the test to incorrectly report PASS when secret memory protection is
broken.

Check the return value against -1 instead.  The test should only pass when
PTRACE_PEEKDATA fails, which means secret memory protection works.

Link: https://lore.kernel.org/20260910064415.71623-1-hongfu.li@linux.dev
Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/mm/memfd_secret.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -145,7 +145,8 @@ static void try_ptrace(int fd, int pipef
 		exit(KSFT_FAIL);
 	}
 
-	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
+	/* PEEKDATA on secret memory must fail, else protection is broken. */
+	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0) == -1)
 		exit(KSFT_PASS);
 
 	exit(KSFT_FAIL);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-hugetlb_cgroup-move-per-node-usage-on-cross-node-migration.patch
mm-hugetlb_cgroup-move-per-node-usage-on-cgroup-reparenting.patch
mm-hugetlb-account-migration-target-folio-in-per-node-nr_hugetlb-vmstat.patch
mm-memcg-migrate-per-node-hugetlb-lruvec-stat-together-with-hugetlb-folio.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch

