Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07736AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423600; cv=none; b=IBjNWPAYQVmz89y/Co7ChUJr+IpKzG5P4K8tepnAMEGpTrtFdlO2FDq/Ey43745JaKPe9chGCJ30RXMXskHRj2h0nEtbZkLSaiVNMSKSBBofehw1Wvxd0hhQvUnT87YskJ3Ufr2P3j3xvknKSWJxZwp6nzKVqSSsUzz4viSZvPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423600; c=relaxed/simple;
	bh=BD8XVO6zFqap81xrooho3mYnUNyWtEH3X1T/nAPt4uw=;
	h=Date:To:From:Subject:Message-Id; b=jA7731Fyw3jgtLOag9ixcUxvLSEpz0SparirJTucF3NoWgM7rTims8UaZdDkrpAnY/rw9yqr8mhssxfRBDKCLx1wflD/vZSmuqJFJab2TmHg/Bxkws/hgG85Vgu1RJA3fUPtgDlTY7eoq6KAZn37/eZy9CFYq3hAdy74m8H5GVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PgCRoNrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PgCRoNrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD9BC4CEC2;
	Wed,  4 Sep 2024 04:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423600;
	bh=BD8XVO6zFqap81xrooho3mYnUNyWtEH3X1T/nAPt4uw=;
	h=Date:To:From:Subject:From;
	b=PgCRoNrnQl24Be6TeqW9oLtqAMj7HQZPTr4A63sM2mnzXDE33mdsnc1/OJba45Llj
	 426DSD/v/YcLh6/bc0Pbn4D47/i5G18rwFM3F4Qy4J8QuWftx85K9jtfG878abI2Gh
	 yo+Ykoa4KKHLMK0VtIeHkUyaUoHrLfVWAb4zIpRQ=
Date: Tue, 03 Sep 2024 21:20:00 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-cleanup-__pycache__-with-make-clean.patch removed from -mm tree
Message-Id: <20240904042000.9BD9BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: cleanup __pycache__/ with 'make clean'
has been removed from the -mm tree.  Its filename was
     selftests-damon-cleanup-__pycache__-with-make-clean.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: cleanup __pycache__/ with 'make clean'
Date: Mon, 26 Aug 2024 20:03:29 -0700

Python-based tests creates __pycache__/ directory.  Remove it with 'make
clean' by defining it as EXTRA_CLEAN.

Link: https://lkml.kernel.org/r/20240827030336.7930-3-sj@kernel.org
Fixes: b5906f5f7359 ("selftests/damon: add a test for update_schemes_tried_regions sysfs command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/damon/Makefile~selftests-damon-cleanup-__pycache__-with-make-clean
+++ a/tools/testing/selftests/damon/Makefile
@@ -25,4 +25,6 @@ TEST_PROGS += debugfs_target_ids_pid_lea
 TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 
+EXTRA_CLEAN = __pycache__
+
 include ../lib.mk
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

