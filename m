Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A75D38DE2
	for <mm-commits@vger.kernel.org>; Sun, 21 Jan 2024 22:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705875227; cv=none; b=Ouw92yeh7V5EWvxtcZ5GepXZBe7cPqYUe3cxQEP9CIdWG9Bl3c/v3F/pUbC3nE3101kaFy4dkCAFKxH8Lf8VOZ8PZJOS9RFlEMmiFcEjOYC74nvL0sPq85rIl3i/7oc2UC+9PHDCbIp8Inh1e37g0O03MQZyWjWB8AFSk5h+Xv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705875227; c=relaxed/simple;
	bh=c+QxxvoOZYQXv7UAjkHqr0urEB6hCu1uDDCTRCexFX4=;
	h=Date:To:From:Subject:Message-Id; b=a/qkS92V726w0avDKYDOE5WHdT26kz/NDGe+Sr5lOmcdP0pArQAp0PhykvvrU1NOaAjYnx1tu7UlGOe8O8jmZ/yOWP15lzDhQTl9Pd5huSuHum4RR7eWAh05VNphyncr9vmMk9BF5qcE8PBmLhADnlZRTkpc9kjN0WpdjRoXygA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OIFq3Sjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OIFq3Sjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6042C433F1;
	Sun, 21 Jan 2024 22:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705875227;
	bh=c+QxxvoOZYQXv7UAjkHqr0urEB6hCu1uDDCTRCexFX4=;
	h=Date:To:From:Subject:From;
	b=OIFq3SjoIyzYpuxMpTBfc69Zu6IzVt1BvkSvg7Uof9xLMVR9fTWMJPN7WfHEsmgx2
	 NmXPhWOfGwyxd9eS9wqgB99d2t2svVZDxdcIPqvN6Jby0NlpTza1CxuAw2bFVzz62u
	 i4UmOADUoLCJMkJoTe8ADbDAbaPmX+JtMhGUmtKk=
Date: Sun, 21 Jan 2024 14:13:44 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-run_vmtestssh-add-missing-tests.patch removed from -mm tree
Message-Id: <20240121221346.E6042C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: add missing tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-add-missing-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: run_vmtests.sh: add missing tests
Date: Tue, 16 Jan 2024 14:06:40 +0500

Add missing tests to run_vmtests.sh. The mm kselftests are run through
run_vmtests.sh. If a test isn't present in this script, it'll not run
with run_tests or `make -C tools/testing/selftests/mm run_tests`.

Link: https://lkml.kernel.org/r/20240116090641.3411660-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-add-missing-tests
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -248,6 +248,9 @@ CATEGORY="hugetlb" run_test ./map_hugetl
 CATEGORY="hugetlb" run_test ./hugepage-mremap
 CATEGORY="hugetlb" run_test ./hugepage-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
+CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh
+CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh
+CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 
 nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
 # For this test, we need one and just one huge page
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-switch-to-bash-from-sh.patch

