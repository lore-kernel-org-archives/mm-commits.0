Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9B33BF68E
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896699; cv=none; b=tZGkyX8uDiiONOMqV0Gm8AO5cnikAOcEq4FbKmEHKW0XNdYenBFA8oHKs2Ed1xh/lrJzEkWanc9XbUWBOafgA3b5TT4dEPaj6rwv14zVlxcC8b/bjjQQg6k79FqzmDxny+6Io9I2vP/lQpaGjflDwWTJc9IuzjtfmxA2Cr6NJfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896699; c=relaxed/simple;
	bh=e0HvEnVGdHX9yVpwKTyX1zp7I0S2X02JTCU91FTAG6U=;
	h=Date:To:From:Subject:Message-Id; b=lmHmTlE2G7ykZjB5UWTegba9Uq9oDvh/lQ7qMsLyP0uAF+4fyrdn9tqjDWmpvRZjWjHsg3o4QEt+IiNIBt+qynSGA28rdZd/tXt134xNPrazUBXplD6k1+DZvexPp45/ddHQww/h8VQz8EPfF9lk3MsF4jU/advA4PHuc+tNM6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DwFWJ9xl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DwFWJ9xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBEE1F00A3A;
	Wed,  5 Aug 2026 02:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896697;
	bh=A+/fcsq3seRz736CPEDWEN5IzjPuXmZNzzrhWnGbP7I=;
	h=Date:To:From:Subject;
	b=DwFWJ9xlhF+NGn/iV47nin9hpoiqYvxNe7P0H4gOYTozmwEIZqyXomuQn6o/2+uoB
	 PYTN7vzChzfLZ6PI5jdw+v6E5D+ljwidPVo7+aCAuqgLykkqQrpahSmO/dGIbuewI6
	 GDKNxYj7C4sbg0SAnnllMLMNf4ZIfzqQe4TaWDFQ=
Date: Tue, 04 Aug 2026 19:24:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam@infradead.org,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-ternary-operator-precedence-in-ksm_tests.patch removed from -mm tree
Message-Id: <20260805022457.8FBEE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix ternary operator precedence in ksm_tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-ternary-operator-precedence-in-ksm_tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: fix ternary operator precedence in ksm_tests
Date: Wed, 8 Jul 2026 12:29:07 +0530

The KSM selftest uses conditional expressions to skip accesses to
merge_across_nodes on systems without NUMA support.  However, the ternary
operator is combined with logical OR without parentheses:

a || numa_available() ? 0 : b || c

Due to operator precedence rules, this is parsed as:

(a || numa_available()) ? 0 : (b || c)

instead of the intended:

a || (numa_available() ? 0 : b) || c

Add parentheses around the conditional expressions to ensure the
correct evaluation order.

Link: https://lore.kernel.org/ce859430287ed2642848c933a90eb9a69da361f0.1783446924.git.sayalip@linux.ibm.com
Fixes: 9aa1af954db0 ("selftests: vm: check numa_available() before operating "merge_across_nodes" in ksm_tests")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-fix-ternary-operator-precedence-in-ksm_tests
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -288,8 +288,8 @@ static bool assert_ksm_pages_count(long
 static int ksm_save_def(struct ksm_sysfs *ksm_sysfs)
 {
 	if (ksm_read_sysfs(KSM_FP("max_page_sharing"), &ksm_sysfs->max_page_sharing) ||
-	    numa_available() ? 0 :
-		ksm_read_sysfs(KSM_FP("merge_across_nodes"), &ksm_sysfs->merge_across_nodes) ||
+	    (numa_available() ? 0 :
+		ksm_read_sysfs(KSM_FP("merge_across_nodes"), &ksm_sysfs->merge_across_nodes)) ||
 	    ksm_read_sysfs(KSM_FP("sleep_millisecs"), &ksm_sysfs->sleep_millisecs) ||
 	    ksm_read_sysfs(KSM_FP("pages_to_scan"), &ksm_sysfs->pages_to_scan) ||
 	    ksm_read_sysfs(KSM_FP("run"), &ksm_sysfs->run) ||
@@ -304,8 +304,8 @@ static int ksm_save_def(struct ksm_sysfs
 static int ksm_restore(struct ksm_sysfs *ksm_sysfs)
 {
 	if (ksm_write_sysfs(KSM_FP("max_page_sharing"), ksm_sysfs->max_page_sharing) ||
-	    numa_available() ? 0 :
-		ksm_write_sysfs(KSM_FP("merge_across_nodes"), ksm_sysfs->merge_across_nodes) ||
+	    (numa_available() ? 0 :
+		ksm_write_sysfs(KSM_FP("merge_across_nodes"), ksm_sysfs->merge_across_nodes)) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), ksm_sysfs->pages_to_scan) ||
 	    ksm_write_sysfs(KSM_FP("run"), ksm_sysfs->run) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), ksm_sysfs->sleep_millisecs) ||
@@ -846,8 +846,8 @@ int main(int argc, char *argv[])
 
 	if (ksm_write_sysfs(KSM_FP("run"), 2) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), 0) ||
-	    numa_available() ? 0 :
-		ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1) ||
+	    (numa_available() ? 0 :
+		ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1)) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), page_count))
 		ksft_exit_fail_msg("Cannot set up KSM tunables\n");
 
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


