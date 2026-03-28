Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AEF22B584
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671934; cv=none; b=K7c38pm6ZOJolvplKrwncbLj8BDI7UZvNeR8pAFlmB5S/oxILTtZxj784YOQFU80fE2M/mzW86dd8VXFyAAEKOIaNVrXFRUnBiOwqi9hfT+O9Ca/bOkeexwSFqUUdrONGtHJ+xn8hlVQl/076S0c/bGj+Ww8CaViyPNh3cFqpWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671934; c=relaxed/simple;
	bh=W1g1Df5nUyHz8avY/WJ4QVWvIqrIH1tM38CUo35jBXQ=;
	h=Date:To:From:Subject:Message-Id; b=HdswSyHYjTyvDsoOFbxgjeeb7d0hcwHW6sdif7aJO1Er4UTBktd1oYtPwBxAodXDF1ZOUVjHluYHHtBbwPTGcnwuKmdH129SLzty+Xybs2CS0XpUoKzdttN5MG7KpgasjW/2X+4zwSz6nNZu7y1KxEjGFya6hCSyp6dBLKO6ns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XnNh/uIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XnNh/uIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9663AC4CEF7;
	Sat, 28 Mar 2026 04:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671933;
	bh=W1g1Df5nUyHz8avY/WJ4QVWvIqrIH1tM38CUo35jBXQ=;
	h=Date:To:From:Subject:From;
	b=XnNh/uIyfWby0wlfI1ht/lHVcJRr9r28loa9U8havOjmMCXBWxdjVbR/VmspL1ss+
	 q3EYuv5gSepP+gcITw3XSXOZD+E3sxk/B7SuIWGVQDvqCVJyaxJPL2D4UIpkKenUcF
	 yoXK99G0wfkh7Ylkqk09Oq9IBEX33gbms2hxD3Vk=
Date: Fri, 27 Mar 2026 21:25:33 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,objecting@objecting.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-bug-fix-inconsistent-capitalization-in-bug-message.patch removed from -mm tree
Message-Id: <20260328042533.9663AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/bug: fix inconsistent capitalization in BUG message
has been removed from the -mm tree.  Its filename was
     lib-bug-fix-inconsistent-capitalization-in-bug-message.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Law <objecting@objecting.org>
Subject: lib/bug: fix inconsistent capitalization in BUG message
Date: Fri, 6 Mar 2026 16:23:27 +0000

Use lowercase "kernel BUG" consistently in pr_crit() messages.  The
verbose path already uses "kernel BUG at %s:%u!" but the non-verbose
fallback uses "Kernel BUG" with an uppercase 'K'.

Link: https://lkml.kernel.org/r/20260306162327.2815553-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bug.c~lib-bug-fix-inconsistent-capitalization-in-bug-message
+++ a/lib/bug.c
@@ -254,7 +254,7 @@ static enum bug_trap_type __report_bug(s
 	if (file)
 		pr_crit("kernel BUG at %s:%u!\n", file, line);
 	else
-		pr_crit("Kernel BUG at %pB [verbose debug info unavailable]\n",
+		pr_crit("kernel BUG at %pB [verbose debug info unavailable]\n",
 			(void *)bugaddr);
 
 	return BUG_TRAP_TYPE_BUG;
_

Patches currently in -mm which might be from objecting@objecting.org are

mm-damon-core-document-damos_commit_dests-failure-semantics.patch
lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.patch

