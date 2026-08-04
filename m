Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AAD4252BE;
	Tue,  4 Aug 2026 04:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816358; cv=none; b=O+C8EwZxjxoGuN5jG4Z7q+tW4KreEozfj7Z2XKpIop9aV2UhEBJKAnFSLUNjUkQ8HoQrLgQNoqs7CaMjGiHqtFvm8kjnqSmd02tn4tfOIQqqrHeg5XDJpAdH59xQuflcetdf6vkBV6aIKdKT2gJSeZV7SXFirIisS+4VcC3fwhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816358; c=relaxed/simple;
	bh=Ue4eJ3vQgt4HX/FQRS4fco+iVlSTXlVNfu50x1nR1CU=;
	h=Date:To:From:Subject:Message-Id; b=e+XgfmzM81X/COwELlDHnIuv88KGEPcNLB0Sl+Ls8d/ue3mMyeMFPBAc6BZPeHoLAh5ihzGnL27a8WHjkNtG8xXg2TOzVZABREexFOyFLXtxsKtcPz1DGWHNEU3H3NW3oqhq5ttiJ+lNUqWJoZXxs1xnEUoz6tHMjylV9Iwv2fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uDEYlATC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uDEYlATC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D8E1F00A3A;
	Tue,  4 Aug 2026 04:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816357;
	bh=wQbK1uMEFY4D0K3bIaXXM6uAA9YafDtLQesw5ieK/KY=;
	h=Date:To:From:Subject;
	b=uDEYlATCkwnH0i1/DQqJa2O8RyjCRWzYsjHPxf5I5bPDlqSBTj5vm80PLqAoksqdS
	 iPc9krn9srwnKY/oZOMYI5Uw4qDBs/H9pgHnPMNYZwzoESPxTU9VrHu8+m+ZeLfAQ0
	 HzBVUnh1QANw8Fvjvj8H1Bu/8IZA6odQpBkwCLlc=
Date: Mon, 03 Aug 2026 21:05:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oleg.deomi@gmail.com,bsingharora@gmail.com,akpm@linux-foundation.org,include@grrlz.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-fix-cpumask-parsing-cutting-off-the-last-character.patch removed from -mm tree
Message-Id: <20260804040557.09D8E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: fix cpumask parsing cutting off the last character
has been removed from the -mm tree.  Its filename was
     taskstats-fix-cpumask-parsing-cutting-off-the-last-character.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <include@grrlz.net>
Subject: taskstats: fix cpumask parsing cutting off the last character
Date: Thu, 23 Jul 2026 21:09:22 +0000

parse() hands nla_strscpy() len as dstsize, and nla_strscpy() copies at
most dstsize - 1 bytes.  When the attr payload comes in without a trailing
NUL, srclen == len >= dstsize and the last character of the cpumask string
gets cut off.  Register "0-15" and you are silently listening on "0-1",
exit data for the rest never shows up.

The bug only bites when the sender doesn't NUL terminate the payload;
senders that include the NUL were always fine (srclen gets decremented for
the trailing NUL, so srclen < dstsize).  Thats probably why this survived
20 years.  And the policy is NLA_STRING, not NLA_NUL_STRING, so a payload
without the trailing NUL is legit input here.

Skip the kmalloc/nla_strscpy dance entirely and use nla_strdup(), which
already allocates srclen + 1 and terminates.  The nla_len() bounds checks
stay as they were.

Link: https://lore.kernel.org/EC49FE41-7F5F-41E0-A07A-ABEB8ECA514D@grrlz.net
Fixes: f9fd8914c1ac ("[PATCH] per-task delay accounting taskstats interface: control exit data through cpumasks")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Reported-by: Oleg Deomi <oleg.deomi@gmail.com>
Closes: https://lore.kernel.org/CAByWkfZ6b1=3H9pwkz-dDQOs9cZaF-HYQ6b9Yb0=Hq2r1Vv_Pw@mail.gmail.com
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/taskstats.c~taskstats-fix-cpumask-parsing-cutting-off-the-last-character
+++ a/kernel/taskstats.c
@@ -368,10 +368,9 @@ static int parse(struct nlattr *na, stru
 		return -E2BIG;
 	if (len < 1)
 		return -EINVAL;
-	data = kmalloc(len, GFP_KERNEL);
+	data = nla_strdup(na, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-	nla_strscpy(data, na, len);
 	ret = cpulist_parse(data, mask);
 	kfree(data);
 	return ret;
_

Patches currently in -mm which might be from include@grrlz.net are

taskstats-drop-the-dead-null-attribute-check-in-parse.patch
taskstats-fold-the-two-cpumask-handlers-into-one.patch

