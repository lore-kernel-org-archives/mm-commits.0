Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305983FEB27
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774634361; cv=none; b=Lxkqm3zlV/yJH74nv1+wh87HWyJqQOFSSZLVxv9LH0GX2CqfpW/C0n8cE7wm96Qbh4ygMCtjP5TGMYW3SYEeGJUTnH+vgFB1y/hieIx9tj5OehxeaNywtZEtrMg1s87/MUDuNblv/9TqqGf2dDnFWRdepAd5OuJWd3WqmZ/yy4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774634361; c=relaxed/simple;
	bh=ewqGx6rJV+AUgCwum18XG1K3lmXizfnVT+QYdnglhDE=;
	h=Date:To:From:Subject:Message-Id; b=eROcgLiUDxPaI9p1bs/HoXJAjZvJtMvc2SFZxrYFNqSKAOeIOsixrssiRnUAN7Rpx7tm4VgBedVYr/fLm/GQ0tfwgcYKGx3QBikV3SUlmQglA5nb1kXFH5B/q00wz4hLbD1MBAMeOTjVohp6+EM2o91GQrxrX0/PPl/NYWZUj3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fn5DV0Jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fn5DV0Jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021E5C19423;
	Fri, 27 Mar 2026 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774634361;
	bh=ewqGx6rJV+AUgCwum18XG1K3lmXizfnVT+QYdnglhDE=;
	h=Date:To:From:Subject:From;
	b=Fn5DV0Jo4S+s7Q446zoqTa4V8y0drGOM3y4spEbv/qILnxvn62jNMQPEWyij4npBv
	 b1EhEq3fbSsAcIdN1apSJd4ZEEGbizKGzdQ/HZTbc+D4I4AKVaEWM+xHFije0LuKPm
	 hM9VgrQJNJi012FeF6Mow8WBFe37sm+DlGiugOt4=
Date: Fri, 27 Mar 2026 10:59:20 -0700
To: mm-commits@vger.kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch removed from -mm tree
Message-Id: <20260327175921.021E5C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix double increment in linked list cleanup in compaction_test
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: fix double increment in linked list cleanup in compaction_test
Date: Thu, 12 Mar 2026 17:55:38 +0530

The cleanup loop of allocated memory currently uses:

    for (entry = list; entry != NULL; entry = entry->next) {
        munmap(entry->map, MAP_SIZE);
        if (!entry->next)
            break;
        entry = entry->next;
    }

The inner entry = entry->next causes the loop to skip every other node,
resulting in only half of the mapped regions being unmapped.

Remove the redundant increment to ensure every entry is visited and
unmapped during cleanup.

Link: https://lkml.kernel.org/r/27390ade4251d1f7f6b846bd5836fa79dbf285df.1773305678.git.sayalip@linux.ibm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-fix-double-increment-in-linked-list-cleanup-in-compaction_test
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -263,9 +263,6 @@ int main(int argc, char **argv)
 
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
-		if (!entry->next)
-			break;
-		entry = entry->next;
 	}
 
 	if (check_compaction(mem_free, hugepage_size,
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are

a.patch
selftests-mm-move-hwpoison-setup-into-run_test-and-silence-modprobe-output-for-memory-failure-category.patch
selftests-cgroup-extend-test_hugetlb_memcgc-to-support-all-huge-page-sizes.patch

