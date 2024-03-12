Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAEF1428ED
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274072; cv=none; b=EySBMTciM8hZkRkwkMRJ9qBiNvz/IeFSh0uJJAy52ByysBO5hai73kbE61bd+zm/hI9pnW42x4XHtnKkcmLI3iBJqT7NREKCId4ydZt3ftGnh6nJ+QZkNdMEbXBdF+kqZ+fb5fvQpjaeawmTabn/s8RfEIrdvDEhCvnSiy6QoSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274072; c=relaxed/simple;
	bh=sxgI/bgd+zlkZURYJX2pqo88ujr6wCKeUSSOww8zvlw=;
	h=Date:To:From:Subject:Message-Id; b=CVwUTP6NUBytdegYoHAbi1k8I7zSmwmLdDcHURyBjZX3KQrbbA62dOtmbzkPnCV7t3zu/Dy4ZzhAGW56ymj+v8oxwnX6wndqesM2/3SgzLiNHvQXyaNwtcQCSOL86WCNzRojoHZ7QMddkTIQxaZ2D6XxLUcd5U7ji06DRNiU/r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OgO6LIru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OgO6LIru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47719C433F1;
	Tue, 12 Mar 2024 20:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274072;
	bh=sxgI/bgd+zlkZURYJX2pqo88ujr6wCKeUSSOww8zvlw=;
	h=Date:To:From:Subject:From;
	b=OgO6LIruiS7c9x50vKMX4X7ysDJOvCMYmTITDWYNFu5vxHNqPhaqy2JvcDuwwFoX4
	 pMyTv7uGr7SDJNU85t8N2qMgSY2TBtUSqW957h9S34Yy5q9Sv9vHXilwY4ET9wWijE
	 XmTh2tEc2vLTM1/vmJQJMbPTVSHhDoSmXd+V0VGU=
Date: Tue, 12 Mar 2024 13:07:51 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,muchun.song@linux.dev,ben@decadent.org.uk,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages.patch removed from -mm tree
Message-Id: <20240312200752.47719C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip uffd hugetlb tests with insufficient hugepages
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: selftests/mm: skip uffd hugetlb tests with insufficient hugepages
Date: Wed, 6 Mar 2024 15:37:13 -0700

Now that run_vmtests.sh does not guarantee that the correct hugepage count
is available, add a check inside the userfaultfd hugetlb test to verify
the nr_hugepages count before continuing.

Link: https://lkml.kernel.org/r/20240306223714.320681-3-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-stress.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/uffd-stress.c~selftests-mm-skip-uffd-hugetlb-tests-with-insufficient-hugepages
+++ a/tools/testing/selftests/mm/uffd-stress.c
@@ -441,6 +441,12 @@ int main(int argc, char **argv)
 	parse_test_type_arg(argv[1]);
 	bytes = atol(argv[2]) * 1024 * 1024;
 
+	if (test_type == TEST_HUGETLB &&
+	   get_free_hugepages() < bytes / page_size) {
+		printf("skip: Skipping userfaultfd... not enough hugepages\n");
+		return KSFT_SKIP;
+	}
+
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 
 	nr_pages_per_cpu = bytes / page_size / nr_cpus;
_

Patches currently in -mm which might be from npache@redhat.com are


