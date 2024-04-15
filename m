Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028F2155A59
	for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2024 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713211860; cv=none; b=JCMB89Iwdc0ttUoyTUWvm7KiGMG/XV77CVgZCFf+ePpJlaQxgcabeZiF7QQwWrtD6HvI1EBIKMhEQxlvg1fp/HmA9S1PhpLE0IXYtWpFteiPlyz1JRI9W5oMxPSsySR+vFdxL2mQoSO3+7TC9OIFllafXwIVcXJ20mVUJkHCWh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713211860; c=relaxed/simple;
	bh=5LdpzQRRO7/PO+B98CzvURk7gjZR8G7GI3gH7vA7EoE=;
	h=Date:To:From:Subject:Message-Id; b=O3/WwJwB7mdof1dSTOOBVrwNV8Qz24W5LCGAEi0Vi+vi5q9C8m/aiywIcSvFmu6CblxaDdVOPfzFg+n1adb+QXiMIFcRo0Tkj8tjhU7WCwNuj9N/E2/4sft8fDhVWtLkw9EW8grctgtz1sShUvxpR5dcaYIDZo8BwjnVpf82LfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H3ZLxaVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H3ZLxaVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5966BC113CC;
	Mon, 15 Apr 2024 20:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713211859;
	bh=5LdpzQRRO7/PO+B98CzvURk7gjZR8G7GI3gH7vA7EoE=;
	h=Date:To:From:Subject:From;
	b=H3ZLxaVNs2u2S7Mo5kit7xFhM+E+dBnHwscderU/cpwMjDHiq0kze83mgOkN+Ux1z
	 YS2fpLSac1SGQR0UyOVJqhjgpsR8jmCm+LR+c2UDBexpQyE03yul+a/4pUR+oLDd8J
	 BUmMqYG7obWa+TcefT2NLTtcG5yDd84UyB06KTMk=
Date: Mon, 15 Apr 2024 13:10:58 -0700
To: mm-commits@vger.kernel.org,yi.zhang@huawei.com,yangerkun@huawei.com,willy@infradead.org,houtao1@huawei.com,leo.lilong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-inline-xas_descend-to-improve-performance.patch added to mm-unstable branch
Message-Id: <20240415201059.5966BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: inline xas_descend to improve performance
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-inline-xas_descend-to-improve-performance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-inline-xas_descend-to-improve-performance.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Long Li <leo.lilong@huawei.com>
Subject: xarray: inline xas_descend to improve performance
Date: Mon, 15 Apr 2024 09:21:36 +0800

The commit 63b1898fffcd ("XArray: Disallow sibling entries of nodes")
modified the xas_descend function in such a way that it was no longer
being compiled as an inline function, because it increased the size of
xas_descend(), and the compiler no longer optimizes it as inline.  This
had a negative impact on performance, xas_descend is called frequently to
traverse downwards in the xarray tree, making it a hot function.

Inlining xas_descend has been shown to significantly improve performance
by approximately 4.95% in the iozone write test.

  Machine: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz
  #iozone i 0 -i 1 -s 64g -r 16m -f /test/tmptest

Before this patch:

       kB    reclen    write   rewrite     read    reread
 67108864     16384  2230080   3637689 6 315197   5496027

After this patch:

       kB    reclen    write   rewrite     read    reread
 67108864     16384  2340360   3666175  6272401   5460782

Percentage change:
                       4.95%     0.78%   -0.68%    -0.64%

This patch introduces inlining to the xas_descend function. While this
change increases the size of lib/xarray.o, the performance gains in
critical workloads make this an acceptable trade-off.

Size comparison before and after patch:
.text		.data		.bss		file
0x3502		    0		   0		lib/xarray.o.before
0x3602		    0		   0		lib/xarray.o.after

Link: https://lkml.kernel.org/r/20240415012136.3636671-1-leo.lilong@huawei.com
Signed-off-by: Long Li <leo.lilong@huawei.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: yangerkun <yangerkun@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-inline-xas_descend-to-improve-performance
+++ a/lib/xarray.c
@@ -200,7 +200,7 @@ static void *xas_start(struct xa_state *
 	return entry;
 }
 
-static void *xas_descend(struct xa_state *xas, struct xa_node *node)
+static inline void *xas_descend(struct xa_state *xas, struct xa_node *node)
 {
 	unsigned int offset = get_offset(xas->xa_index, node);
 	void *entry = xa_entry(xas->xa, node, offset);
_

Patches currently in -mm which might be from leo.lilong@huawei.com are

xarray-inline-xas_descend-to-improve-performance.patch

