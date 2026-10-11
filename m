Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6530136E478
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757196; cv=none; b=GwsF0Q16YCOSe5rj/6R1D+Tq9SPWyNGydIImCllOPoWxlwK7a9gjPpgEUk3DQioi5lUwjw72fZl2WOgj5gjth7/T7rxqh2nLhcBilEd782ZDIwEYw4b+m/YoLRmIP3Fqmu9/2Su0QIehAL5+i740IKCSqC4cILNUsmdg3MT39NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757196; c=relaxed/simple;
	bh=YnJGlNlChRHFAM0SJ7WA222Z6ksI2UBzBzA3xbz1y8w=;
	h=Date:To:From:Subject:Message-Id; b=S05xqg3iZ5WZcD65VEgk6IYWlko+jXDQCQA+DkV4f4OIdLZM3DQ/9QP748W19n1EKLoflKI4NuRQlFvRV5+vCYbSHP4zN5oqCcL0Qert7xvXCQEBzLY8WUTVhkSP0of1PWG8xvtK2KtEDUNY6tP9i6mW+Oys/bD7NkkLpIM4VLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2BBhELxc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2BBhELxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0A21F0089B;
	Sun, 11 Oct 2026 22:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757195;
	bh=wyRSdg2fCsgQqZ6HS5qgbCpToAIDSAHdLLTcpBUsPhI=;
	h=Date:To:From:Subject;
	b=2BBhELxcUsd2MlKcQYVJrajr+NtjAYO64j5xjrZeIillFg9lABOHYriTZ9Bv9CXcR
	 phOxZjqNEApCBv8u7NBi62MAb8lTxbsgrxbUXFGIzz4c+oqvT0R5wAaB0++P7W5Qnt
	 beKAdTTGN4YLus8IWogstxlvHESwR0AurPE8srRA=
Date: Sun, 11 Oct 2026 15:19:54 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch removed from -mm tree
Message-Id: <20261011221954.DC0A21F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/main.c: remove unreachable check in obsolete_checksetup()
has been removed from the -mm tree.  Its filename was
     init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: init/main.c: remove unreachable check in obsolete_checksetup()
Date: Tue, 22 Sep 2026 22:26:27 +0900

Since commit 1ecfea06386c ("init.h: remove long-dead
__setup_null_param() macro"), .init.setup entries cannot have a NULL
setup_func.

So remove the NULL check.

No functional change.

Link: https://lore.kernel.org/20260922132630.177941-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/init/main.c~init-mainc-remove-unreachable-check-in-obsolete_checksetup
+++ a/init/main.c
@@ -215,10 +215,6 @@ static bool __init obsolete_checksetup(c
 				 * params and __setups of same names 8( */
 				if (line[n] == '\0' || line[n] == '=')
 					had_early_param = true;
-			} else if (!p->setup_func) {
-				pr_warn("Parameter %s is obsolete, ignored\n",
-					p->str);
-				return true;
 			} else if (p->setup_func(line + n))
 				return true;
 		}
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-swapops-remove-unused-is_hwpoison_entry.patch

