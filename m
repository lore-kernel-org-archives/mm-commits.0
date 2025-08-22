Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E739119E7E2
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 23:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755905839; cv=none; b=H3v6yfHd3laNQIHIDjcNFNpLLB+6EqsSGemv35gNyHFRPmU7RhIkSBuhHWdWkw1OSGZdaOBlR7bFCkt23uK2DW9c7fjBDLjuD5f+wVy14uWQEpccylE5/s6JDNSeBfjRIsQF0G4xOpOoAReFOMKZ9aeLq9+6AHPvo64ldzlpP0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755905839; c=relaxed/simple;
	bh=V6tG8QSwIqq3lcgAXVCO2zqDX9IQI2mlweVqiKmp9a4=;
	h=Date:To:From:Subject:Message-Id; b=ABHBVSfU/uOoCaOiEjdzpILNLFlnYHEMV0A85zJTxJGTJZbU66ZEDLnDqO5jtjyODbQKgMD136HDyH9qr5GdTTMquRedFcW0lyIbJASJwRQvZYHTdfIwuKn5DOltN0ixVmiAI/i2SE60CTAGz4kfK3z9Z4XGFEdGlLQwpzKEunQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cRr2gqcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cRr2gqcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB8BC4CEED;
	Fri, 22 Aug 2025 23:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755905838;
	bh=V6tG8QSwIqq3lcgAXVCO2zqDX9IQI2mlweVqiKmp9a4=;
	h=Date:To:From:Subject:From;
	b=cRr2gqcsQRoIPAjTux0vKPz1fmiBFTDFjIpvIbBQGsijEgkSsPmfZPmNVQiIivTsW
	 sxyf1cec/Y+YiamnXOOEP30FgzGSXUgXOOS59izCjJqwEOVi6gMCe7ldsHgbCC/Q+d
	 KMXp2OMD++AaEZOvdqhAXP1ROGrAYEEvaMJ0nR4w=
Date: Fri, 22 Aug 2025 16:37:18 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-addr_unit-file.patch added to mm-new branch
Message-Id: <20250822233718.BBB8BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document addr_unit file
has been added to the -mm mm-new branch.  Its filename is
     docs-abi-damon-document-addr_unit-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-addr_unit-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document addr_unit file
Date: Fri, 22 Aug 2025 17:34:18 +0800

Document addr_unit DAMON sysfs file on DAMON ABI document.

Link: https://lkml.kernel.org/r/20250822093420.2103803-11-yanquanmin1@huawei.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-addr_unit-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -77,6 +77,13 @@ Description:	Writing a keyword for a mon
 		Note that only the operations sets that listed in
 		'avail_operations' file are valid inputs.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/addr_unit
+Date:		Aug 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing an integer to this file sets the 'address unit'
+		parameter of the given operations set of the context.  Reading
+		the file returns the last-written 'address unit' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

