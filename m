Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B15B637
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560091; cv=none; b=MAxdPvUZ2zybQPPcFjiHCfVvQuXMVJTWQw3+5yWeQKQPURTo1C4W1iD/wkAoAiCkWrnn+XsSse3RAKcVGTJ1A1AY2Lhe0T2pVyPIZuhur/F9O5ilFyImPnTG3Q/6HmAioZeQecMM/aQvbH07Dre1akyW9lt02/Dutz5GIHyp9qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560091; c=relaxed/simple;
	bh=cZ6X+ecsW+Fz9IUQXld+Sar20HTQHj0/pUAD85Ey9iA=;
	h=Date:To:From:Subject:Message-Id; b=ktfIN5fwTDtr7f4Ryr5nrd9o8I3ADAo968xD6vu6e364vYGnHuTxRQ9tgXNPNL/Wb3gY/pAjQlKN7bOujXR7YE1UQl4hqJM1KdjrHX7brQ1NdY5Sjgoh6ZscQFBaGt5X7VDF6VNWtlldxX+OhqKa+BIRVe64RylozQH7EtwS4MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qVCBu/rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qVCBu/rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5EDC433C7;
	Thu, 22 Feb 2024 00:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560091;
	bh=cZ6X+ecsW+Fz9IUQXld+Sar20HTQHj0/pUAD85Ey9iA=;
	h=Date:To:From:Subject:From;
	b=qVCBu/rfsulvgxQ57R+VsreB37FLmegbaD2mxOlcZFeRcw+lY0Te9pDWuhcmQtfgc
	 E6swPJoduKhejv7fpAsRg6+FaPDmmYXxSeD1dlTIvgAD57SonMn6OQ+PblQDLOIJW6
	 acac6dPalZBsuMA3MzBreRJEiuSLXqUQ4peWADqs=
Date: Wed, 21 Feb 2024 16:01:30 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-perform-some-system-cleanup-before-using-hugepages.patch removed from -mm tree
Message-Id: <20240222000131.1D5EDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: perform some system cleanup before using hugepages
has been removed from the -mm tree.  Its filename was
     selftests-mm-perform-some-system-cleanup-before-using-hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: selftests: mm: perform some system cleanup before using hugepages
Date: Wed, 17 Jan 2024 11:00:37 -0700

When running with CATEGORY= (thp | hugetlb) we see a large numbers of
tests failing.  These failures are due to not being able to allocate a
hugepage and normally occur on memory contrainted systems or when using
large page sizes.

drop_cache and compact_memory before the tests for a higher chance at a
successful hugepage allocation.

Link: https://lkml.kernel.org/r/20240117180037.15734-1-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-perform-some-system-cleanup-before-using-hugepages
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -206,6 +206,15 @@ pretty_name() {
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
+		# On memory constrainted systems some tests can fail to allocate hugepages.
+		# perform some cleanup before the test for a higher success rate.
+		if [ ${CATEGORY} == "thp" ] | [ ${CATEGORY} == "hugetlb" ]; then
+			echo 3 > /proc/sys/vm/drop_caches
+			sleep 2
+			echo 1 > /proc/sys/vm/compact_memory
+			sleep 2
+		fi
+
 		local test=$(pretty_name "$*")
 		local title="running $*"
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
_

Patches currently in -mm which might be from npache@redhat.com are


