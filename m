Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57232207A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957055; cv=none; b=qS/wNxQ4jTJg3fiRv+QbVFIgvvRuqJjzatcTJ/Q7kjdewHWbizicm/CBWgWOYD63HOWBMPDxIyo05vXno0FYFYSLsQhNoxu3HovwwFzBeEZn8a96d7Nz42os+e8+dG9wSgNfkpzjRn+w1zIcnS4iNu6ttqAq5wBMxV4Qm+pG3Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957055; c=relaxed/simple;
	bh=jCBlCYavEl8YF01xDnO+5cL/hwVqafYBrbb39sTQ6vo=;
	h=Date:To:From:Subject:Message-Id; b=QknBoGp+9dfcV0gsITKTyHstsDPBaOiv/aXoUzw+YEE8pYkmr+eXbGIYq4kG6yaSdcX4U9iHd3Mlm820A9Lt1Ao45SR8o5fPzA5DjktWntJREavIjd+7Fm0+A2JBj2uXpAho6QgunOJv+8dhQRPLXDJRiVVcFKedqZXDI3bk+Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zQ6WFzVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zQ6WFzVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23FFC113CC;
	Mon,  6 May 2024 00:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957054;
	bh=jCBlCYavEl8YF01xDnO+5cL/hwVqafYBrbb39sTQ6vo=;
	h=Date:To:From:Subject:From;
	b=zQ6WFzVIfcU8kcMDH72EqrF6wPcxJSoHcUliCA6w1MGcDHpTca/0zHwZVE8HDv52/
	 0RwRmWeyM2LwvTBvYWHKtkDEKpfVyTmNITRG8AXArDAmMfJe73Fu9BUZNB95ycaQ2t
	 7V0pVaWLmru5y32y0xdbe6oxO1YA7OxQDNwITZAk=
Date: Sun, 05 May 2024 17:57:34 -0700
To: mm-commits@vger.kernel.org,yi.zhang@huawei.com,yangerkun@huawei.com,willy@infradead.org,houtao1@huawei.com,leo.lilong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xarray-inline-xas_descend-to-improve-performance.patch removed from -mm tree
Message-Id: <20240506005734.B23FFC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xarray: inline xas_descend to improve performance
has been removed from the -mm tree.  Its filename was
     xarray-inline-xas_descend-to-improve-performance.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Long Li <leo.lilong@huawei.com>
Subject: xarray: inline xas_descend to improve performance
Date: Tue, 16 Apr 2024 14:16:28 +0800

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
 67108864     16384  2230080   3637689  6315197   5496027

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

Link: https://lkml.kernel.org/r/20240416061628.3768901-1-leo.lilong@huawei.com
Signed-off-by: Long Li <leo.lilong@huawei.com>
Cc: Hou Tao <houtao1@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: yangerkun <yangerkun@huawei.com>
Cc: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xarray.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/xarray.c~xarray-inline-xas_descend-to-improve-performance
+++ a/lib/xarray.c
@@ -200,7 +200,8 @@ static void *xas_start(struct xa_state *
 	return entry;
 }
 
-static void *xas_descend(struct xa_state *xas, struct xa_node *node)
+static __always_inline void *xas_descend(struct xa_state *xas,
+					struct xa_node *node)
 {
 	unsigned int offset = get_offset(xas->xa_index, node);
 	void *entry = xa_entry(xas->xa, node, offset);
_

Patches currently in -mm which might be from leo.lilong@huawei.com are


