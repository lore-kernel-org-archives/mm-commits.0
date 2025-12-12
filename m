Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E6A301498
	for <mm-commits@vger.kernel.org>; Fri, 12 Dec 2025 18:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765563675; cv=none; b=oXKTuFfm0pwNpkYhQpZT31JJoCCW+o4R8wV8zVjoGOs8ejYzv67U7FSelWgXWW3QkY5f9DSVsV0KGS3roPyyZoDB7GpsaIDfqJaiD2Ps0p399IO41A0X3OBCG3/2l21IdjOfZI0vp4knGFlwctkMUPADaKGZQqmM3wYGE18BXYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765563675; c=relaxed/simple;
	bh=ql5XOaXZ5hRzJ3wRL1caSaIphaoyoPbQZSAJH5/XVdM=;
	h=Date:To:From:Subject:Message-Id; b=Q/IQh250KC1Gxg0Aynm7FM02JFwcrqEVK23TJJmTWkWCat6XcXLPNjMIC04uM/iIxCcwLL8krF8HAW2vQf2flFjaasC2MzxSF+bfgRlcgk7bkcwqO6zAZGMirpMgUnXpkzUYmKotUu70SK0EyZLoFDIrkME/o7xShqQIebQw5ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VZdede1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VZdede1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B87C4CEF1;
	Fri, 12 Dec 2025 18:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765563674;
	bh=ql5XOaXZ5hRzJ3wRL1caSaIphaoyoPbQZSAJH5/XVdM=;
	h=Date:To:From:Subject:From;
	b=VZdede1y8Ntt1O630zAZH/+3J+sBjFHtTG2M3zRwO+pGGhyrLDSx2YsLhsyUZCUMQ
	 xll/96vWw8O+5L79uFyajG+r+XrSgk9jIiWevbc/B38j4pwhkxKgdXn1GJP0+b5gqo
	 9Em5i4ynx5Vi/Nwy88mTGboQAew2k0kYAQpbFV4I=
Date: Fri, 12 Dec 2025 10:21:13 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,oliver.sang@intel.com,mjguzik@gmail.com,mhocko@suse.com,liam.howlett@oracle.com,jhubbard@nvidia.com,david.laight.linux@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch removed from -mm tree
Message-Id: <20251212182114.33B87C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid use of BIT() macro for initialising VMA flags
has been removed from the -mm tree.  Its filename was
     mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: avoid use of BIT() macro for initialising VMA flags
Date: Fri, 5 Dec 2025 17:50:37 +0000

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
how VMA flags are declared, utilising an enum of VMA bit values and
ifdef-fery VM_xxx flag declarations via macro.

As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
the newly introduced VMA bit numbers.

However, use of this macro results in apparently unfortunate macro
expansion and resulted in a performance degradation.This appears to be due
to the (__force int), which is required for the sparse typechecking to
work.

Avoid macro expansion issues by simply using 1UL << bitnum.

Link: https://lkml.kernel.org/r/20251205175037.1287366-1-lorenzo.stoakes@oracle.com
Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202512041634.150c7e4f-lkp@intel.com
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-avoid-use-of-bit-macro-for-initialising-vma-flags
+++ a/include/linux/mm.h
@@ -395,7 +395,8 @@ enum {
 #undef DECLARE_VMA_BIT
 #undef DECLARE_VMA_BIT_ALIAS
 
-#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
+#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
+
 #define VM_READ		INIT_VM_FLAG(READ)
 #define VM_WRITE	INIT_VM_FLAG(WRITE)
 #define VM_EXEC		INIT_VM_FLAG(EXEC)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


