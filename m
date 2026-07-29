Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E84DC2EA
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298398; cv=none; b=fygjHmAobT27qzP4a4JSIIMU1XihqDoX/itF75Jt9/4DZKuXp8uSCF+Zd0nSz1/pSKhAt8GP02glQQpGJrfamiZ+ayiz8wyWWlkCLFPOwhZWtmpIKYbgRDMIB5iNY5ArULkciy4dGyYAZcv6iOZTby/wI71uR/XCpU/1/2jUVdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298398; c=relaxed/simple;
	bh=RjtyEYxvF6Qmi27m2EBhSpX/E+qjccX3lku9IO/423M=;
	h=Date:To:From:Subject:Message-Id; b=tqetI6tRKwTuNbVZQxmLGRX0dZG1sK2Ey2vZ44ddH6Pk6/Kq+ISmRvtiBc0JIzCQMUC3SFBoas+Pd5nnZgg8r6HbFcuu25uBqL8Z3B0c/CnQQvY8/uPMunCe3NZsMHzcqNR0di8fqslITsCz17e3ugSiaSC5nsoFlUpMt22t/BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H/UTuUN6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H/UTuUN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157201F000E9;
	Wed, 29 Jul 2026 04:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298397;
	bh=2CLvm+6G+QCD+LhsS9cTo9XQ7IbA3I0rfJsLkt4nN7w=;
	h=Date:To:From:Subject;
	b=H/UTuUN60NO7jxs+hl9lIVwKNGYe/O3o9I8wSN2ZH03A19jxCxhBsqsgHJpWId4XE
	 Y7DV6nQ2KWr188nj5C6Dv+4qY9Mc7ISufWV9SeK4Y7lLQAXSDdrI+ZQUE6mC6p9Sid
	 SniU3uc1esDJX/hPwwXM5bJB5jtXFaPbNs7/IEqk=
Date: Tue, 28 Jul 2026 21:13:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ben.dooks@codethink.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dont-build-vm_numa_stat_key-if-config_numa=n.patch removed from -mm tree
Message-Id: <20260729041317.157201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: don't build vm_numa_stat_key if CONFIG_NUMA=n
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-build-vm_numa_stat_key-if-config_numa=n.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: mm/page_alloc: don't build vm_numa_stat_key if CONFIG_NUMA=n
Date: Thu, 18 Jun 2026 11:06:14 +0100

vm_numa_stat_key is only exported if CONFIG_NUMA is set, so avoid the
following warning by guarding it in an #ifdef on CONFIG_NUMA:

mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?

Link: https://lore.kernel.org/20260618100614.1321950-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-dont-build-vm_numa_stat_key-if-config_numa=n
+++ a/mm/page_alloc.c
@@ -165,7 +165,9 @@ DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
 #endif
 
+#ifdef CONFIG_NUMA
 DEFINE_STATIC_KEY_TRUE(vm_numa_stat_key);
+#endif
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 /*
_

Patches currently in -mm which might be from ben.dooks@codethink.co.uk are


