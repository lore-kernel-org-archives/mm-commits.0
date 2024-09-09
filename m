Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E58D18A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925231; cv=none; b=Qr71rIL1/KU2cDCWF8LNWvMLudVgBIb0LHemPqsz/sK7G9Dv0Z6YFbPS4X23RVm3vWF4G0BEPEMapme0mLhorWct2TNDB4nufaRT+gtSsOwIB41iFxN9f1kfpeb2BVOcalmd5l/WDY1bitwzVICjOyA7oXvPl2c/FpT09c5cPtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925231; c=relaxed/simple;
	bh=Hjml2EK0OvHgTU4/XpEs5Sn49wo/69Svx8Vypi1cWFg=;
	h=Date:To:From:Subject:Message-Id; b=QgehplWo2TZe8TKrasrzeD+zrgXxHto6Dexgbr6M7eMmijezqtqaqtXHJVoaERsGaI+vi8wZOqHFU4UQFHSJS2iZ6ykkhKt5Ncx9X9d1nvHFWvL7BPppKqNYw2AekzvnbXnzxO+Nv7YstS+jbnYOTgN+1K2d1Ce7b69QvmfdMY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aXZwRhRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aXZwRhRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB43C4CEC5;
	Mon,  9 Sep 2024 23:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925230;
	bh=Hjml2EK0OvHgTU4/XpEs5Sn49wo/69Svx8Vypi1cWFg=;
	h=Date:To:From:Subject:From;
	b=aXZwRhRGXV1Hb726e5oR37ek8qHW/GGgCeeTUHLHSP40VK0Y6v7omDSjOU6yW3gmM
	 bUV61uH9j0zytsMEma+tJEuwVCSdaOtZsKcn6X61Mnt3gAvZ+WjP/GC6MqTz/MLd3N
	 TKWLVgCjXDDiEB1s6SQaHKt+TmxrJ1oj+lp1cvNQ=
Date: Mon, 09 Sep 2024 16:40:30 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-dump-error-message-based-on-format.patch removed from -mm tree
Message-Id: <20240909234030.CEB43C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: dump error message based on format
has been removed from the -mm tree.  Its filename was
     maple_tree-dump-error-message-based-on-format.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: dump error message based on format
Date: Mon, 26 Aug 2024 01:24:22 +0000

Just do what mt_dump_range64() does.

Dump the error message based on format.

Link: https://lkml.kernel.org/r/20240826012422.29935-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-dump-error-message-based-on-format
+++ a/lib/maple_tree.c
@@ -7243,9 +7243,15 @@ static void mt_dump_arange64(const struc
 		if (last == max)
 			break;
 		if (last > max) {
-			pr_err("node %p last (%lu) > max (%lu) at pivot %d!\n",
+			switch(format) {
+			case mt_dump_hex:
+				pr_err("node %p last (%lx) > max (%lx) at pivot %d!\n",
 					node, last, max, i);
-			break;
+				break;
+			case mt_dump_dec:
+				pr_err("node %p last (%lu) > max (%lu) at pivot %d!\n",
+					node, last, max, i);
+			}
 		}
 		first = last + 1;
 	}
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


