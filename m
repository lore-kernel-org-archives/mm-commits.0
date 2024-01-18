Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEA431A73
	for <mm-commits@vger.kernel.org>; Thu, 18 Jan 2024 22:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616186; cv=none; b=FdYCpzsuTAzybOPBXFkhPFFk7iLkt1U9fREhhPVLRUQzBxBNnRv3rcHRFKox2dcLvrv6sDaCgrNlRqOy9sc5zPpjdpQzc35Sp1G8hAlRFdmPWfvF/Pn0zPx/zNW3FnOQinc6xosZTML0qoPMh96bFowuQprQVCdQ8lpEfJQQ0Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616186; c=relaxed/simple;
	bh=uCQHvTENU0YGjJE5naAp/C3DhzTwz5JlUT7Y6s88g+g=;
	h=Date:To:From:Subject:Message-Id; b=VUu7C4om0/2tJT5Anq3S6AoSDRlqboBk6P23FXCqcYHfMLUOp+m67+uzXOEBiRSk2Nndu+wJvGZS6Kg/GS+aQHenrPa2CPy1MX/9IQaNtn3wqLCXMc3uOgXQKfvwudFgowSVmmArTZ+eugxFkJsQU5a9m1g+psNGtIsgRs4yNn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z7GIuaIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z7GIuaIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521B3C433F1;
	Thu, 18 Jan 2024 22:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616185;
	bh=uCQHvTENU0YGjJE5naAp/C3DhzTwz5JlUT7Y6s88g+g=;
	h=Date:To:From:Subject:From;
	b=Z7GIuaIu1MaCJqQnPR4rxnXQ774/8Rn2ab1XwgUGJw0PvL4Exuy5NrS7+iXIOXuQG
	 wVJG3mYlw868FEH2FTsM7WsNVfME4cYFsfu60fxiT53CHgcqNf/cnv8a7LCAl78tkY
	 khI+PRe0dETpn6MQt6c7DT+4z/RXRq6DsX0Aei+0=
Date: Thu, 18 Jan 2024 14:16:23 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-perform-some-system-cleanup-before-using-hugepages.patch added to mm-unstable branch
Message-Id: <20240118221625.521B3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: perform some system cleanup before using hugepages
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-perform-some-system-cleanup-before-using-hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-perform-some-system-cleanup-before-using-hugepages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

selftests-mm-perform-some-system-cleanup-before-using-hugepages.patch

