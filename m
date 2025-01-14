Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4AC230D05
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837167; cv=none; b=KsGM5M03AVMSPJPOFOEMCuj/kYhwsoJAU3zFuHRQlvB+598yh9MB8sFFOPGl1tEXK/eWLxHUcztTG8/lr97ii88uqdKoCMpM+8vIXhv630gUiPOZh09Xi/WxKV6GYDaouMKz3JHr2khMhWA8ShC19AJOW2Xx9bDExONb62vGztQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837167; c=relaxed/simple;
	bh=K0Jvhhb6mdcL6qwiQfQCpGCSp4MekPiqxojUbR3zhZ0=;
	h=Date:To:From:Subject:Message-Id; b=Gc3xIICu492BSQneWvyuoAAqWSsas34ZE0L9vG6+4j84Z4PfCTe7mu9qQQHpVudiSoJ/LLtJzGG/N0c6zC6SdWiEReiXcgBEBdc6uqgwnZV+vpepTbUsLxa7rflAxpQQKjYp2VC14k2KsV1UWV4cpT6oBMutnSia/asQZTCwRjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pY7RZpvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pY7RZpvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F46C4CEDF;
	Tue, 14 Jan 2025 06:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837167;
	bh=K0Jvhhb6mdcL6qwiQfQCpGCSp4MekPiqxojUbR3zhZ0=;
	h=Date:To:From:Subject:From;
	b=pY7RZpvYYlnUfDwuzaIDV6M8BnIkRATvNzDpIwQBAD1B/YntsTq23Nd0mQ4Oc1jlV
	 f4Px5xlCm8DZPT7Mm1T2FnvZCsWMBU8HheQGB+b12MNOclAdM40NaNv7aOsHFZpiqb
	 YtcTAFeRjwqzGydwLyYunIUiy/ZZQI7HuK+JeUcc=
Date: Mon, 13 Jan 2025 22:46:06 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch removed from -mm tree
Message-Id: <20250114064607.70F46C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document per-scheme filter-passed bytes stat file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document per-scheme filter-passed bytes stat file
Date: Mon, 6 Jan 2025 11:33:56 -0800

Document the new ABI for per-scheme operations set layer-handled DAMOS
filters passed bytes statistic on the ABI document.

Link: https://lkml.kernel.org/r/20250106193401.109161-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -384,6 +384,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the total size of regions that the
 		action of the scheme has successfully applied in bytes.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_ops_filter_passed
+Date:		Dec 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the total size of memory that passed
+		DAMON operations layer-handled filters of the scheme in bytes.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/qt_exceeds
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

