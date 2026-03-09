Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778CF3314C5
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773087215; cv=none; b=GuZFga3LYMklT+CnsrMmOKDDIFmK9E1fmLgzfhCRgvkRlgKo4Gg4igksjBRfDLLGXybRkC9yl0tALKBS879e+DufGHhaVoxcycDLnjaBBeVa0PiyMhD5RGenLwGv5x8mLJhf9ah5kgo8ymlrqmpUJu+utI0NWNwn9PFa2vUTiHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773087215; c=relaxed/simple;
	bh=chgoE7Yt/V0eEqbEI3KHT2heih83b2InuBEc7doOOSY=;
	h=Date:To:From:Subject:Message-Id; b=WZFmfAcMa43t38lsLBBAMQy499tyz9i+ypANTS2G5wUQVolpp2yNsRO9mIsxDIduEws129VMvnENZU16oeGFHgs1V+emshfj9WWZ79J3wPoMp9JNM8qwoxWxR0nHYVPUxTMwSg8u2blPww4QiBzzKhYBEUs3Wic4MDjoLf5Z+vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pNTR6qtc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pNTR6qtc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA714C2BC87;
	Mon,  9 Mar 2026 20:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773087215;
	bh=chgoE7Yt/V0eEqbEI3KHT2heih83b2InuBEc7doOOSY=;
	h=Date:To:From:Subject:From;
	b=pNTR6qtcUXOjqRzcP6iOodejsG9I6J2HeFkLA4dLF7aT/pTJ/Wmlzxe5INoUGC0TT
	 H/JDbj/fpEn3xazRqZu1I6JxD+vrGj/nqWwXLkRmm77tGqxolaNyqYCJCSpwmAs5rq
	 p/eACWqNKIdBz0dBDxNQ6DfboCdlgaqHepRzloUQ=
Date: Mon, 09 Mar 2026 13:13:34 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,rientjes@google.com,pratyush@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,jasonmiu@google.com,graf@amazon.com,dmatlack@google.com,changyuanl@google.com,bhe@redhat.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-adopt-radix-tree-for-preserved-memory-tracking-fix.patch added to mm-unstable branch
Message-Id: <20260309201334.DA714C2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix child node parsing for debugfs in/sub_fdts
has been added to the -mm mm-unstable branch.  Its filename is
     kho-adopt-radix-tree-for-preserved-memory-tracking-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-adopt-radix-tree-for-preserved-memory-tracking-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho: fix child node parsing for debugfs in/sub_fdts
Date: Mon, 9 Mar 2026 03:35:30 +0000

Commit e0c1731f5d57 ("kho: adopt radix tree for preserved memory
tracking") changed KHO_FDT_SUB_TREE_PROP_NAME from "fdt" to
"preserved-data".  However, kho debugfs code still hard-coded the "fdt"
string when parsing the device tree, causing the debugfs node
/debugfs/kho/in/sub_fdts/ fail to parse child nodes correctly.

Fix this by including the header file and using KHO_FDT_SUB_TREE_PROP_NAME
instead of the hard-coded string.

Link: https://lkml.kernel.org/r/20260309033530.244508-1-ranxiaokai627@163.com
Fixes: e0c1731f5d57 ("kho: adopt radix tree for preserved memory tracking")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Miu <jasonmiu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover_debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover_debugfs.c~kho-adopt-radix-tree-for-preserved-memory-tracking-fix
+++ a/kernel/liveupdate/kexec_handover_debugfs.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/libfdt.h>
 #include <linux/mm.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include "kexec_handover_internal.h"
 
 static struct dentry *debugfs_root;
@@ -139,7 +140,7 @@ __init void kho_in_debugfs_init(struct k
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *fdt_phys;
 
-		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
+		fdt_phys = fdt_getprop(fdt, child, KHO_FDT_SUB_TREE_PROP_NAME, &len);
 		if (!fdt_phys)
 			continue;
 		if (len != sizeof(*fdt_phys)) {
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-adopt-radix-tree-for-preserved-memory-tracking-fix.patch

