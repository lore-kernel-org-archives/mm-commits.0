Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8603770C
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724808913; cv=none; b=OYPMuHZJOObciT6FLT/NL2rfCOcW2sS3fZ9uj7c4ycKeNT/LidcjsC+0fsr/X6l0kw5MU0OEKmgqQApLDz9Tjm8AorIkLd8AY0oW5xAtQgfRivc/yy2l/H4wbxazEC6Z9Ai4HTjQo0j8GfKtJGaZuG0p0KvM24VxEPeNBxyPsks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724808913; c=relaxed/simple;
	bh=9yc7Q5eCwnJdaPsI+kpC8Eax5GG9XLPAp4Vs4FSBcA8=;
	h=Date:To:From:Subject:Message-Id; b=CirT9aOvy4Zqz8zCtmfc0oN388PNhzIZX428SEJXVN7WYLrDhzym9+U0Sr+9JWvfvgaTCG3lmrpB1sgUTur2v5xuBHbItUI2phRQ8jvgQorV0HtMSNVS81U85XtPfmwEEosC37pf4GZ9ae5kcjNZTurqpBaKhkMtZSKzfY8Eg3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQoIldMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQoIldMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3260C32782;
	Wed, 28 Aug 2024 01:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724808912;
	bh=9yc7Q5eCwnJdaPsI+kpC8Eax5GG9XLPAp4Vs4FSBcA8=;
	h=Date:To:From:Subject:From;
	b=aQoIldMAY/Kwwqcif/0boHnE+Oev7Q5dJN0OXwXPs63bhigYq33a9PBk91NidPyaS
	 YZnL99xZSGAZ73qRkElq6qEING/iNG4ZSja3OnYeh42kbHedYwpTPa6g2GSU8hAS5R
	 WI0Viy/rkegYtgA5f5SfB7BtVaq6Q8xLlwoi7GgY=
Date: Tue, 27 Aug 2024 18:35:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-dump-error-message-based-on-format.patch added to mm-unstable branch
Message-Id: <20240828013512.D3260C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: dump error message based on format
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-dump-error-message-based-on-format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-dump-error-message-based-on-format.patch

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

mm-improve-code-consistency-with-zonelist_-helper-functions.patch
mm-memory_hotplug-get-rid-of-__ref.patch
maple_tree-fix-comment-typo-of-ma_root.patch
maple_tree-fix-comment-typo-with-corresponding-maple_status.patch
maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch

