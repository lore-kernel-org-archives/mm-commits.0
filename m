Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D613F2451FD
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837172; cv=none; b=p2/iENNjGJVVhLlTapUU6gSBYZLnoeWXCnt3G3w5/MQBfuPiQVM+DcaOJeJB6JBB2ZrXW0i3oScNYNQTrlpkMMoBcluRtOH8+YMAv2yUr4sZyGmqo2JAs6SDohnStVSLXZBNNUVuoxaNLTNi8whgYIjJROUM99lmdV5waoqYV9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837172; c=relaxed/simple;
	bh=iqlMNM9OkmaLq+3XVSgMFeb6VKCbQOx0OZdWEgFANnI=;
	h=Date:To:From:Subject:Message-Id; b=ti5m6sU6G6gj1VXdEoA76i+D0F4vP/UpoNLdDRr4KoR9Syc3Xb3qiwohiDGUEakxbHYh5S82mcY+Vim1n1eIBO7x9Ja98N9wF12R2DILwKXPihKRVGV6GQ0fEyvPAOmxDm5bicukH+XhdYgcdpHvf6x+9TliqGjyhZE3nFIlhIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uTC+F13O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uTC+F13O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA82DC4CEDD;
	Tue, 14 Jan 2025 06:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837172;
	bh=iqlMNM9OkmaLq+3XVSgMFeb6VKCbQOx0OZdWEgFANnI=;
	h=Date:To:From:Subject:From;
	b=uTC+F13OymMWtgFO0z8JIy6mTjrLnVDytbhp98chyaEhqY201ToeNdVGxNmdzYC/8
	 uGP8Sk3oi8FX1ZXvyIInWDma3WM++D2DakCzl2OeSQzMB1rczoJc5MknxpJy5jkxhx
	 Ucyf1GspNws616R64l8iormZF09Xlk31FR9c6H4k=
Date: Mon, 13 Jan 2025 22:46:12 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch removed from -mm tree
Message-Id: <20250114064612.AA82DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document per-region DAMOS filter-passed bytes stat file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document per-region DAMOS filter-passed bytes stat file
Date: Mon, 6 Jan 2025 11:34:01 -0800

Document the new ABI for per-region operations set layer-handled DAMOS
filters passed bytes statistic.

Link: https://lkml.kernel.org/r/20250106193401.109161-17-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -430,3 +430,10 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the 'age' of a memory region that
 		corresponding DAMON-based Operation Scheme's action has tried
 		to be applied.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/sz_filter_passed
+Date:		Dec 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading this file returns the size of the memory in the region
+		that passed DAMON operations layer-handled filters of the
+		scheme in bytes.
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

