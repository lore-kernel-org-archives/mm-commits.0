Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654CD15ECD7;
	Tue, 17 Dec 2024 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734461212; cv=none; b=GEHpQo3ZFZjSb+b3ZuELRKYHFrciSeTooarrQKhxjXAILWuPP8eO973vnoupSLH0xmO94r9+lx1lqCH6IitggwCx+bWNLWWtpCFmqo1O3vWI0BZxUPIKQYe+PKZlA36V4UL7wywMZEDgstB+NvjiMsrHD0l59hm4/Rl3G5doRLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734461212; c=relaxed/simple;
	bh=WTVfIQXZws5D4KadG+JVsDOzzuaD+KWt7CZf3Ns48Jc=;
	h=Date:To:From:Subject:Message-Id; b=XKIhcSH1Rvx9cbAZnX6l/E7Wwbq/Zy+WcwTKd508Z9ziSh2qw8KAx/CBtTln+WE74azLO4mQ6eJv5Ytgms+ERe9aJdpKed+mSASdAyNjwgvIHc1IE0+YH3mWyi/MdaAaLijRphTNgVAEdJzMmiBHJUJRemaP1hG2qROVYMDX/hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AqRho86J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AqRho86J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2E6C4CED7;
	Tue, 17 Dec 2024 18:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734461212;
	bh=WTVfIQXZws5D4KadG+JVsDOzzuaD+KWt7CZf3Ns48Jc=;
	h=Date:To:From:Subject:From;
	b=AqRho86JczTytfNYPdTeILxYjvTZg0NbwKGtZ2Rz3umwlhxYaC4xzN+TI2oO+DNt8
	 wPX/kvKsHh0TMGT6OrEHgiNI8Q0x6gFGCTlN2S6D5OJyA61HvJNRfU0AuZHT3UndWJ
	 6XzX7T1lyhKjr6mz3CaAsRPMjV1IG6zoZFD05Kz4=
Date: Tue, 17 Dec 2024 10:46:51 -0800
To: mm-commits@vger.kernel.org,yangerkun@huawei.com,stable@vger.kernel.org,chuck.lever@oracle.com,brauner@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-mas_alloc_cyclic-second-search.patch added to mm-hotfixes-unstable branch
Message-Id: <20241217184651.DE2E6C4CED7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix mas_alloc_cyclic() second search
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-fix-mas_alloc_cyclic-second-search.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-mas_alloc_cyclic-second-search.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: fix mas_alloc_cyclic() second search
Date: Mon, 16 Dec 2024 14:01:12 -0500

The first search may leave the maple state in an error state.  Reset the
maple state before the second search so that the search has a chance of
executing correctly after an exhausted first search.

Link: https://lore.kernel.org/all/20241216060600.287B4C4CED0@smtp.kernel.org/
Link: https://lkml.kernel.org/r/20241216190113.1226145-2-Liam.Howlett@oracle.com
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com> says:
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-mas_alloc_cyclic-second-search
+++ a/lib/maple_tree.c
@@ -4346,7 +4346,6 @@ int mas_alloc_cyclic(struct ma_state *ma
 {
 	unsigned long min = range_lo;
 	int ret = 0;
-	struct ma_state m = *mas;
 
 	range_lo = max(min, *next);
 	ret = mas_empty_area(mas, range_lo, range_hi, 1);
@@ -4355,7 +4354,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 		ret = 1;
 	}
 	if (ret < 0 && range_lo > min) {
-		*mas = m;
+		mas_reset(mas);
 		ret = mas_empty_area(mas, min, range_hi, 1);
 		if (ret == 0)
 			ret = 1;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-fix-mas_alloc_cyclic-second-search.patch
test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch

