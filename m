Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237DF38C406
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 03:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786505986; cv=none; b=UmJ+FhP77BLLzrtH2GcMVvRZey73ed1PMfs+K9UftuYxM9aRY7IiA0rFoTY+mvrKF+ulFu45zqCrp/8tSolzjHxYvI6jtrYrPGKEyBmJJ2/LE1sHzNNw9ChRxF8cQen16g0r44nK9a2GqutDrrG/2qcXwDC0rhXiAnBJZ55WApY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786505986; c=relaxed/simple;
	bh=cf80jp7pxYA3Dxj3LM3uMQdWJziJbHu+zblkMbaWP7A=;
	h=Date:To:From:Subject:Message-Id; b=CzXRdMjXkTm2jSZQTnkTHa6VUdd3UcFc+JwbPoiD0yvizR/N2+Gntpx8c1CKvA/emKXi/W8r31q/9Vk8uBZYsh9WPGCn82AhdlBG430k1WzZqzOWL129YVthEy1cyXiAotAGBnXyunh2LakvaG03oPAH2i6xueHP+Jc0XdvbdLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EbX8U5Dy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EbX8U5Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D701F000E9;
	Wed, 12 Aug 2026 03:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786505984;
	bh=JnJwJF16mzToUC72memxX72JCqUdOHF0O+4oKKvDSUE=;
	h=Date:To:From:Subject;
	b=EbX8U5DyFL8VdRnEy0cyrkncJO/4skkZh1s0Bbs+4mxoQYc2SDGDBsnF1csnSmV67
	 wPhWTkLXUEWYVqUSWEdkj8VIGJJvpyLfGIMbDRlwPR9SmLTTQ9fA5uVqb/2JTHfyAp
	 YRBDNljX28LgTkPQVQfAU/EOmRCKkhB1QbAkRTQg=
Date: Tue, 11 Aug 2026 20:39:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,audra@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch removed from -mm tree
Message-Id: <20260812033944.96D701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-fix-soft-dirty-kselftest-supported-check-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch

This patch was dropped because it was folded into selftests-mm-fix-soft-dirty-kselftest-supported-check.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-fix-soft-dirty-kselftest-supported-check-fix
Date: Thu Aug  6 11:43:11 AM PDT 2026

remove comment, per Sashiko

Link: https://sashiko.dev/#/patchset/20260806181843.1839943-2-audra@redhat.com
Cc: Audra Mitchell <audra@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-fix-soft-dirty-kselftest-supported-check-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -68,7 +68,6 @@ static uint64_t pagemap_scan_get_categor
 	return r.categories;
 }
 
-/* `start` is any valid address. */
 static bool pagemap_scan_supported(int fd)
 {
 	const size_t pagesize = getpagesize();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-mm-fix-soft-dirty-kselftest-supported-check.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning.patch
mm-hmmc-hmm_do_fault-suppress-sparse-warning-fix.patch
lib-kconfigdebug-make-debug_force_weak_per_cpu-depend-on-s390alpha.patch
selftests-cgroup-test_zswap-skip-test_no_kmem_bypass-if-debugfs-is-unavailable-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

