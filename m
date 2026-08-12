Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0E53603DB
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786505088; cv=none; b=fGSfoZ0USn/y9O9g+VA1ikxjWqE6vG9aPHCEBGXe77EdbH5tLcU1oA9My81fIqaQ5HeYDW3QAMO4wopYZoXsyC8LfPG4BX624AA3IS46GDbCNDbmj1hY1VMmwMP4JW1a5+NsiQG7IXFlrBShYYWXTh0rci9LuFR1Kd5/WvKc1X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786505088; c=relaxed/simple;
	bh=VjBVINX0g3evqdL7+oK5W9Q1Ra1sugcyhksTLkp0odY=;
	h=Date:To:From:Subject:Message-Id; b=CThwhel99ENt1tCXsUk7Bs6S8egrDax8ZE217174BTlS5eY12HIs86ZEWBlLPlE9Eb6kUMZNIPb31WNe1pl460aXdfd/KMeo3+yvNZrUQpYlhKlerUQcpMWqWUeFd1rkYwISVzmDmpSJxOk/PwPWQp5RU+OOyg2FCTwJ7tf+40Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jaHQeyhw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jaHQeyhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B8A1F000E9;
	Wed, 12 Aug 2026 03:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786505087;
	bh=amc1qMlorGb5pP6TgrpOnEbz3ti/jsxU3R9sYwtFs6c=;
	h=Date:To:From:Subject;
	b=jaHQeyhwx/CIMfhj5+IKI9ghJpsmwkYp0MyX6No8Wr6VlAvieMzm0Z1lKrrwiWN9J
	 so70rQp8XZabepsR/b9Sa/TOLGKsljHlaY2p3cWKTd79DedEp8deFssPZ6KeOoD6mT
	 h3k8/UYezYNuOLttPelO5PQg/N3txgoeAL+kSNS4=
Date: Tue, 11 Aug 2026 20:24:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shijianlin11@foxmail.com,mhocko@suse.com,joel.granados@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch removed from -mm tree
Message-Id: <20260812032446.E5B8A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch

This patch was dropped because it was folded into mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
Date: Thu Aug  6 02:14:15 PM PDT 2026

add comment, per hannes

Link: https://lore.kernel.org/anSRGASe5FIrqwlg@cmpxchg.org
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jianlin Shi <shijianlin11@foxmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
+++ a/mm/page_alloc.c
@@ -6870,6 +6870,10 @@ static int lowmem_reserve_ratio_sysctl_h
 	if (!write)
 		return proc_dointvec_minmax(table, write, buffer, length, ppos);
 
+	/*
+	 * proc_dointvec_max() works incrementally. Use a buffer and only set
+	 * the values if all of them parse cleanly.
+	 */
 	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
 	tmp.data = ratio;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

