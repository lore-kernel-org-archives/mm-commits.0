Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7312180603
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423609; cv=none; b=YlCAQcVFXLkCT7HVNSdaN9yPxnm2OOzJ5CSSDwvwuQRFaq7syMf/SKYqQNoyvHyafoFL+G64aCP++X7WFAEskpcTTH/vzJlgtMuuDOctpBaBmqI0ODvivYTj4QrYWihXwDbEZ4gR/0k9EPSMTxLDS2Zvu8ssjh4H2YNrtPhNdY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423609; c=relaxed/simple;
	bh=/e/H3EYxod1m/WiTpjE/lk2Cg2S5S380rDK2TW3mqWo=;
	h=Date:To:From:Subject:Message-Id; b=RZtkCAJnmoKiSz3Uv0I8FaNI98p55pE+LD48nyrZYfXiEpf9Dz/1u3Beem9aTWUs0IkbyDI78Gh1DBFqOXnGB6JODpAPVw5O5S/B6hFGmTWT9AZs0dKedeng//rgBg1vW4tyvK2D9FA7+uTGfw8ttMNInydrVA0PePQrkcN1SOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X38Dx875; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X38Dx875"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F659C4CEC2;
	Wed,  4 Sep 2024 04:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423608;
	bh=/e/H3EYxod1m/WiTpjE/lk2Cg2S5S380rDK2TW3mqWo=;
	h=Date:To:From:Subject:From;
	b=X38Dx875so5qFYtA9IiMZk1RvkrZ8RR854pNuHWoOUyhuH9vgvadnpBRoIqjvLx1n
	 0EphQjroAmX71M6fZgq9bd76Vuq2fNqQugnGYJMfaLUJ25AsP+YfpbtOtQvPnunoRb
	 Fndo8FX+XjSiqTTiUcqv1VdJbu0mCfJFvdFCkpqA=
Date: Tue, 03 Sep 2024 21:20:07 -0700
To: mm-commits@vger.kernel.org,davidgow@google.com,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch removed from -mm tree
Message-Id: <20240904042008.1F659C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests: add .kunitconfig file for DAMON kunit tests
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-add-kunitconfig-file-for-damon-kunit-tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/tests: add .kunitconfig file for DAMON kunit tests
Date: Mon, 26 Aug 2024 20:03:36 -0700

'--kunitconfig' option of 'kunit.py run' supports '.kunitconfig' file name
convention.  Add the file for DAMON kunit tests for more convenient kunit
run.

Link: https://lkml.kernel.org/r/20240827030336.7930-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/.kunitconfig |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/tests/.kunitconfig a/mm/damon/tests/.kunitconfig
new file mode 100644
--- /dev/null
+++ a/mm/damon/tests/.kunitconfig
@@ -0,0 +1,22 @@
+# for DAMON core
+CONFIG_KUNIT=y
+CONFIG_DAMON=y
+CONFIG_DAMON_KUNIT_TEST=y
+
+# for DAMON vaddr ops
+CONFIG_MMU=y
+CONFIG_PAGE_IDLE_FLAG=y
+CONFIG_DAMON_VADDR=y
+CONFIG_DAMON_VADDR_KUNIT_TEST=y
+
+# for DAMON sysfs interface
+CONFIG_SYSFS=y
+CONFIG_DAMON_SYSFS=y
+CONFIG_DAMON_SYSFS_KUNIT_TEST=y
+
+# for DAMON debugfs interface
+CONFIG_DEBUG_FS=y
+CONFIG_DAMON_PADDR=y
+CONFIG_DAMON_DBGFS_DEPRECATED=y
+CONFIG_DAMON_DBGFS=y
+CONFIG_DAMON_DBGFS_KUNIT_TEST=y
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-intorduce-per-context-region-priorities-histogram-buffer.patch
mm-damon-core-replace-per-quota-regions-priority-histogram-buffer-usage-with-per-context-one.patch
mm-damon-core-remove-per-scheme-region-priority-histogram-buffer.patch
revert-mm-damon-lru_sort-adjust-local-variable-to-dynamic-allocation.patch
docs-damon-use-damonitor-github-organization-instead-of-awslabs.patch
docs-damon-maintainer-profile-add-links-in-place.patch
docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

