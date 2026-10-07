Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931972C17A3
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334291; cv=none; b=AVgVsTAML4SyHrVX5WoYQRVJOIh6y8GT1dXIkUooK8vas5SF484R/y+2hITFZUv8ZH1owcvej8RJsqIBsunj6wBtikK0+cXgHglDMI5dlayz+17TAX6Gs0KyxRaG/1X8KRQEMVY4EY58fuL1TrbC9S7Hk7a7RabRIDkeXSn3oV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334291; c=relaxed/simple;
	bh=fDjp6+Ju4w8rEUB5HyiqcfryxTez/gMCV4cJnn/G57Q=;
	h=Date:To:From:Subject:Message-Id; b=sIreGi+Orv3/17JAdTMBsvEmWyrgiZKmT64weeI57AzuYbgZ7GkJIkNSxMmwQ/uT4oa5KTNqNWfxlW7340voCQBaW9sbRNwnsTtb2hMXBm1IU28ALnHD5098U6lby3BKONbCIQWhID9tLOvoAgHgwTKUhAWRP47NbrIsLlVssU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=emf9D/wt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="emf9D/wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6541F0089C;
	Wed,  7 Oct 2026 00:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334290;
	bh=Znlyt9JvTin0hrXPAUAntFZr3kjX10k2yMEKvo8L26s=;
	h=Date:To:From:Subject;
	b=emf9D/wth4GpdnAEBPRBPFRiO86SZEBxpzkF/+X4rZILbQN11Mzq7c914ZQZkwzM5
	 hsRs2kPJe8Y3xjj2CY2bLky6N+y5WoeylQauHjCnIy0fy7DKESCQLpApaHGlaCX2aA
	 iXZgyklfmTN+5fbPJ76EiIlp2xe014EOSQ1Ksm84=
Date: Tue, 06 Oct 2026 17:51:30 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-mtier-add-comment-for-struct-region_range.patch removed from -mm tree
Message-Id: <20261007005130.6A6541F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: add comment for struct region_range
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-add-comment-for-struct-region_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: samples/damon/mtier: add comment for struct region_range
Date: Mon, 31 Aug 2026 07:26:09 -0700

The mtier sample defines a local struct region_range using phys_addr_t
instead of damon_addr_range which uses unsigned long.  Add a comment
explaining the rationale: on 32-bit systems with more than 4GiB memory,
phys_addr_t will be 64-bit while unsigned long is 32-bit.

Link: https://lore.kernel.org/20260831142611.77572-8-sj@kernel.org
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---

 samples/damon/mtier.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/samples/damon/mtier.c~samples-damon-mtier-add-comment-for-struct-region_range
+++ a/samples/damon/mtier.c
@@ -52,6 +52,11 @@ module_param(detect_node_addresses, bool
 
 static struct damon_ctx *ctxs[2];
 
+/*
+ * Use phys_addr_t instead of damon_addr_range (unsigned long) for physical
+ * addresses.  On 32-bit systems with more than 4GB memory, phys_addr_t will
+ * be 64-bit while unsigned long is 32-bit.
+ */
 struct region_range {
 	phys_addr_t start;
 	phys_addr_t end;
_

Patches currently in -mm which might be from lienze@kylinos.cn are

maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch
mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch
docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch

