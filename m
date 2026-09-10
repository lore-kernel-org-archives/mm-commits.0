Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2638941D223
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 21:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789074570; cv=none; b=ekWfEz9+pUCWiFpPzXzsIIpFJ5TEIil9Cg3+odatAclMepd7DS0Y7uMwI6LH66X2wBWBKHn3Y+xRuAx32bAac4NspXEIVXOtJlsDMwEoD1GGulTj54l0n6GbLmiaotE1PyJjGNBJv4nOirOd4nlD3uaabX/KlMM5Np2rEQvEr9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789074570; c=relaxed/simple;
	bh=0aBhERhKUsOHDNyw0cUppTC2sfY3w9KQa+0+7KJwDwo=;
	h=Date:To:From:Subject:Message-Id; b=aZ16e1NiFei4+CNp5qvonrMeGjrttFGRHrth3sSc+y8i5Z3gL2gOWLF0VwStn4GYA5o1eCqozOq2QyUEVXyRDd9q4gqpRNGHyWXrDmuM39L/WBWqW0lfnAvnHtVQnuLnpxHCJqYoDkWqMJ6kby4NQQiYbo5Hy2qNhwAFQIdesjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bF3fbPYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bF3fbPYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256441F000FF;
	Thu, 10 Sep 2026 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789074567;
	bh=fx2JEyJf6QKKKnSJB+3ktR007P66wJaD2R1AmMBtogY=;
	h=Date:To:From:Subject;
	b=bF3fbPYiRJadIC8WDcjiDNO8CdFVbbT9pEODZe8nTvExSC4GAcVbWBnNSsXNJ7+QI
	 KV9XYAu5a+UBHdDb10Nw8Aab3PBMu3zVoO+7HELpi8jDCxm2Y8j1q7PtfRbHEx4H5X
	 yxVDIf+0hUq3c3Acjn+taMBHh0MKchLwK+9bbzDE=
Date: Thu, 10 Sep 2026 14:09:26 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch added to mm-nonmm-unstable branch
Message-Id: <20260910210927.256441F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootconfig: remove redundant assignment in xbc_parse_array()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: bootconfig: remove redundant assignment in xbc_parse_array()
Date: Fri, 11 Sep 2026 01:30:48 +0900

After the loop, node is the last array value that xbc_add_child() added,
and xbc_parse_array() sets node->child to 0.

xbc_init_node() already set node->child to 0 when the value was
added, and node->child is not modified after that, so the assignment
is redundant.

So remove the assignment.

No functional change.

Link: https://lore.kernel.org/20260910163051.1973775-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/bootconfig.c~bootconfig-remove-redundant-assignment-in-xbc_parse_array
+++ a/lib/bootconfig.c
@@ -836,7 +836,6 @@ static int __init xbc_parse_array(char *
 			return -ENOMEM;
 		*__v = next;
 	} while (c == ',');
-	node->child = 0;
 
 	return c;
 }
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch
percpu-remove-redundant-assignments-to-bits.patch
percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch

