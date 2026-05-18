Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699A93955ED
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141581; cv=none; b=UjvUQ+cUqy/AsfkGQcgIaW3dr1KWdYr9OnTIxvzDB4Jx8h+0EBLLifIPkVB4+6FLay/gttdwbzPBIgXRqt2N/muYbJ9Ecrfg+F6DbFEclGA8A3kdO7GJRk7Ul2HZjv7301SKuNex4DX4m9cajIJxx9O7nAXe0DaC/lUjefX67Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141581; c=relaxed/simple;
	bh=vwebCOASXyhi4NlisMBfzsCdOMXVUdc2SmwJyrXcD+w=;
	h=Date:To:From:Subject:Message-Id; b=IXpELMqRYldzt+AckeIe8xYRRCeBsjOk8bZIQHKtCiOqEJejRRHEcxaHGKOLUjqrPauXMrONr5PuQ6nc/Qga7C05L515N9aUVIl6Gq7d3pyGE2yEJ5UhFsjYuwF+WExQQzds01Jay3GZ4SbLXlBqSUIi/SX4kqYYVU1OPoxyBDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v98xMIQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v98xMIQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414FBC2BCB7;
	Mon, 18 May 2026 21:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141581;
	bh=vwebCOASXyhi4NlisMBfzsCdOMXVUdc2SmwJyrXcD+w=;
	h=Date:To:From:Subject:From;
	b=v98xMIQCaKydyCfwgomo79iUPlSc0eNT+Qf6AiJJA4ST5XTMIpmf40Y1oGHMVmxOe
	 MCkj7C7c0UUbOv69S9RsOkBMmEUOA6jYXQUUSuTeGjOf+TlQloW0mg8VHsUkGk3i9o
	 T6tnsto6Z2tRaTEVYnlFey94osKbCAxrahFtKO5c=
Date: Mon, 18 May 2026 14:59:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch removed from -mm tree
Message-Id: <20260518215941.414FBC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix run_vmtests.sh to only print SKIP when khugepaged is selected
has been removed from the -mm tree.  Its filename was
     selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fix run_vmtests.sh to only print SKIP when khugepaged is selected
Date: Thu, 7 May 2026 03:17:51 -0400

Link: https://lore.kernel.org/E44ED51F-D250-442D-A89F-B90A671D53ED@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -508,7 +508,7 @@ fi
 
 if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
 CATEGORY="thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
-else
+elif test_selected thp; then
 	count_total=$(( count_total + 1 ))
 	count_skip=$(( count_skip + 1 ))
 	echo "[SKIP] ./khugepaged all:file" | tap_prefix
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

