Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AED518EAB
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118744; cv=none; b=P3WIBtoArLhpOYf0PaExFWK+1Th79FqirFEfttLREvElpK/ef+hzym+TK5oTLVgP2JCGR4+iWiqs/dvHSVsVi8OLX2sFhIiyqmzLTN2BSTcaM/rsI45tbSX10SaKlpS9T68V8IyUFthBRT5EBvByiWq3cSoLkqpKvhYPCZGeCjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118744; c=relaxed/simple;
	bh=ZDlpZXVMFJth+MWzBs9yB+xXO9OJfYnK6gZEqyr+1zI=;
	h=Date:To:From:Subject:Message-Id; b=eQOux+cSo6Vk9P9Iz7i0nYcIiTAqIXTypYxCZ1MFmFcISNfJBePDjIcLwmuWWXXuuB6T5q7M7lJimOrul2+64aJTolDsrhZtlZySngMgTvPX2v33Ww9giUeu1kkASkkGrqxdLW/o+8dHAsRt0BSQsT4cmcFe4Qlduc/adGHRaJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=swW2mfON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="swW2mfON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B54C4CEEF;
	Tue, 13 May 2025 06:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118743;
	bh=ZDlpZXVMFJth+MWzBs9yB+xXO9OJfYnK6gZEqyr+1zI=;
	h=Date:To:From:Subject:From;
	b=swW2mfONMd7HThZVqEjGP9c4ULeX6R5SatbJrAevEn/eL1v4yH2Y2iJFv1D65jxW7
	 3oVpLdqbLYBGDLb5vnPx85imnMa0gkN1G79wHhvgyW3Fn1mAxibolRsJcw97+GGsSA
	 tZGlyc43dTYaXTD2KNNU10wcNZGE5p8xqEnkeHuM=
Date: Mon, 12 May 2025 23:45:43 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,lenb@kernel.org,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,dave.jiang@intel.com,dan.j.williams@intel.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mempolicy-weighted-interleave-auto-tuning-fix-2.patch removed from -mm tree
Message-Id: <20250513064543.99B54C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mempolicy-weighted-interleave-auto-tuning-fix-2
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-weighted-interleave-auto-tuning-fix-2.patch

This patch was dropped because it was folded into mm-mempolicy-weighted-interleave-auto-tuning.patch

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm-mempolicy-weighted-interleave-auto-tuning-fix-2
Date: Mon, 12 May 2025 07:25:10 -0700

remove auto_kobj_attr field from struct sysfs_wi_group

Link: https://lkml.kernel.org/r/20250512142511.3959833-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-weighted-interleave-auto-tuning-fix-2
+++ a/mm/mempolicy.c
@@ -3543,7 +3543,6 @@ struct iw_node_attr {
 struct sysfs_wi_group {
 	struct kobject wi_kobj;
 	struct mutex kobj_lock;
-	struct kobj_attribute auto_kobj_attr;
 	struct iw_node_attr *nattrs[];
 };
 
@@ -3833,7 +3832,6 @@ static int __init add_weighted_interleav
 	err = sysfs_create_file(&wi_group->wi_kobj, &wi_auto_attr.attr);
 	if (err)
 		goto err_put_kobj;
-	wi_group->auto_kobj_attr = wi_auto_attr;
 
 	for_each_online_node(nid) {
 		if (!node_state(nid, N_MEMORY))
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-mempolicy-weighted-interleave-auto-tuning.patch

