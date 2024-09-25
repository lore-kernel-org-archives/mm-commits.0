Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEAD158557
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 10:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727259136; cv=none; b=LUNSID7m7LT+SOLPZ2Agwdmfs/iSm1/AG1fg0S1qOMEkAdQt6PUDrMQ8CKYub880GS5zohG+ex2V4x1GfqLiMuXM0yMT+G6TGheQwBP4FXOD6aOyjJR2Bhp+bBMpxLfwCpNCf7BBz3WkxNIRbsGrocZHhAPeUiiVWAPlYvt8JN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727259136; c=relaxed/simple;
	bh=WHAF+ZrvZVKmLCUKbLkNlv9ELrdw8TeZR21G2DCnfhw=;
	h=Date:To:From:Subject:Message-Id; b=SiIoJDUnw3r77Kqpvoh8ELLYxmMkMU2RB0c+ehnOHwkkEHHbXNX09i0xT2+pgDjd2tQrKiSeeBTSquZbwSlWToXCJZG4/q198M5Sytx7N8wEyXGvIrse5rJkEqyLPGjT/q6rs6dhF8xqmJJdBwm/71uZXhw/MCquneSgGR0uwvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E/ZEhO16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E/ZEhO16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318FAC4CEC3;
	Wed, 25 Sep 2024 10:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727259136;
	bh=WHAF+ZrvZVKmLCUKbLkNlv9ELrdw8TeZR21G2DCnfhw=;
	h=Date:To:From:Subject:From;
	b=E/ZEhO16yh6jtzDb71tws1Ta/wFXLJ/R3nCKC6KO9wnD9/lx5mjCAEBTHsfVE7hQD
	 /7neLiw+PnMg1hPU0aL61mvbBEmtR/hpmwhgYvIbTRe5eKU//sp6rqdAERZ5AWX2J0
	 eIWx52rT+6hBiqUGsOxHu7ethJvq7GKDUofwdJhU=
Date: Wed, 25 Sep 2024 03:12:15 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-maple_big_nodeparent.patch added to mm-unstable branch
Message-Id: <20240925101216.318FAC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove maple_big_node.parent
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-maple_big_nodeparent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-maple_big_nodeparent.patch

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
Subject: maple_tree: remove maple_big_node.parent
Date: Sun, 8 Sep 2024 14:05:53 +0000

Patch series "Reduce the space to be cleared for maple_big_node", v2.

Found current code may clear maple_big_node redundantly.

First we define a field parent, which is never used.  After removing this,
we reduce the size of memory to be cleared by memset.

Then mast_fill_bnode() clears part of the structure twice, since slot and
gap share some space.  By clearing the whole structure, we can avoid this.


This patch (of 2):

The member parent of maple_big_node is never used.

Let's remove it which could reduce the number of space to be cleared on
memset.

Link: https://lkml.kernel.org/r/20240908140554.20378-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20240908140554.20378-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-remove-maple_big_nodeparent
+++ a/lib/maple_tree.c
@@ -120,7 +120,6 @@ static const unsigned char mt_min_slots[
 #define MAPLE_BIG_NODE_GAPS	(MAPLE_ARANGE64_SLOTS * 2 + 1)
 
 struct maple_big_node {
-	struct maple_pnode *parent;
 	unsigned long pivot[MAPLE_BIG_NODE_SLOTS - 1];
 	union {
 		struct maple_enode *slot[MAPLE_BIG_NODE_SLOTS];
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch

