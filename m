Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9F1684BE
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394175; cv=none; b=HKUYJSYyU1hBYra0Zdapo15yVigDumE+tZKJYajcPZVG0exr34exWCNen/AUHW4KwwuQYQOXhD376rojhi7c5w/n7TYtj2vRNJJGgRVDBrOwAK5wON23HwJmT2gU5g8Lt5M4JldnN0+VRBepGSjGTw/SGhvPjARyDqO7BFGjH0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394175; c=relaxed/simple;
	bh=CyUAj8Je+OuB5R929cXL+Gu8YeCwExp+lkxebrVT/x0=;
	h=Date:To:From:Subject:Message-Id; b=iRD9iwF+2rg2kg/FOhGqXXgI+vgj5ziVQdDblR0SgyXxYELVXTs9xKvFEqZp3BLvBaWUBHNEPdqX1TP0b+xD51CnB1ooB8A3QbsS/0PIeu60/aqYQnHmCtzbWQ3nU3F1GQjYlAaXzrbLOzfw738xARyiRz4/wOUNaPAtOfR+Ylw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aImU9Yo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aImU9Yo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAC3C19424;
	Tue, 24 Mar 2026 23:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394175;
	bh=CyUAj8Je+OuB5R929cXL+Gu8YeCwExp+lkxebrVT/x0=;
	h=Date:To:From:Subject:From;
	b=aImU9Yo6Gs9F1U/85u/4Muhlt77SPESnuVa1qIIQ0Wpv4Hv+RNKvP67IS3KbElR+B
	 IuuV5YxhvUDMu+OO1EkbzVOoNqaecgjT7al9Z7l0GmYGxTbyMnhJ/z4KnLHqgdDY8p
	 SyqXPCt2udIy78ZtGS80Xk8twF5GufoXhR4yZakI=
Date: Tue, 24 Mar 2026 16:16:14 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch removed from -mm tree
Message-Id: <20260324231614.EFAC3C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch

This patch was dropped because it was folded into mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch

------------------------------------------------------
From: David Carlier <devnexen@gmail.com>
Subject: mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
Date: Mon, 23 Mar 2026 06:30:06 +0000

add newline, per Qi Zheng

Link: https://lkml.kernel.org/r/20260323063007.7783-1-devnexen@gmail.com
Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
+++ a/mm/memcontrol.c
@@ -4058,6 +4058,7 @@ free_objcg:
 	for_each_node(nid) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
 		objcg = rcu_replace_pointer(pn->objcg, NULL, true);
+
 		if (objcg)
 			percpu_ref_kill(&objcg->refcnt);
 
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch
mm-page_io-fix-pswpin-undercount-for-large-folios-in-sio_read_complete.patch

