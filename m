Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C26218D6F;
	Thu,  7 Nov 2024 22:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017733; cv=none; b=lgCOt3VDle1kCIcHvRu9bLw0wG5DAW6AjetUgNpWzy7C+mXjwSDmLMdBy3q2CDWuiJGy/fze+kOAWZQhHliFPKVXIsBKJSp6Hx3b/yhKLSwsiXsyyCwZJDn3QFFKewN8nxQ0aGgRvwW9KKau773kN0N9IRNfvO/HhF4TztLFIS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017733; c=relaxed/simple;
	bh=B6wDQeQ9NUtq/ASwyAwKY/iEJa/RPkJHBzyhrs6t/ZQ=;
	h=Date:To:From:Subject:Message-Id; b=WPFLvceHbXbDI1a85/3OXYVLFevPF5WHuUzaMDu0Gtbhk/wDA9a7hPvtAb8wLgUShMojrHl8koRvusF4shUocYFjOR2KsbA7Q7bnQ8MiE57gNG5WSc1FzaXlPTb1Zox2WSnJGyr3zmfS4rV8sIzmSzALnkz0TwWGAFSDL7DJjCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cnLqVMdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cnLqVMdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FCBC4CED4;
	Thu,  7 Nov 2024 22:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017732;
	bh=B6wDQeQ9NUtq/ASwyAwKY/iEJa/RPkJHBzyhrs6t/ZQ=;
	h=Date:To:From:Subject:From;
	b=cnLqVMdYWX5uhZYQHKRwOaMyXLTmc7mfZ4A116l2qo8fmXJDKG6mXrpiVtHKDv3B5
	 zseqw3YWi1+g1XuFVf3BuDiYLw/6l0CIKcrR7ZS0s+4o9XOcTEMDBt1oaW3Y69/y8i
	 N00mkrl0oCZRpVyHe/aujobXfVmZ4Sqm6TPr7vJY=
Date: Thu, 07 Nov 2024 14:15:32 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,oleg@redhat.com,legion@kernel.org,kees@kernel.org,ebiederm@xmission.com,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ucounts-fix-counter-leak-in-inc_rlimit_get_ucounts.patch removed from -mm tree
Message-Id: <20241107221532.D3FCBC4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucounts: fix counter leak in inc_rlimit_get_ucounts()
has been removed from the -mm tree.  Its filename was
     ucounts-fix-counter-leak-in-inc_rlimit_get_ucounts.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrei Vagin <avagin@google.com>
Subject: ucounts: fix counter leak in inc_rlimit_get_ucounts()
Date: Fri, 1 Nov 2024 19:19:40 +0000

The inc_rlimit_get_ucounts() increments the specified rlimit counter and
then checks its limit.  If the value exceeds the limit, the function
returns an error without decrementing the counter.

Link: https://lkml.kernel.org/r/20241101191940.3211128-1-roman.gushchin@linux.dev
Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Andrei Vagin <avagin@google.com>
Co-developed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Tested-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/ucount.c~ucounts-fix-counter-leak-in-inc_rlimit_get_ucounts
+++ a/kernel/ucount.c
@@ -317,7 +317,7 @@ long inc_rlimit_get_ucounts(struct ucoun
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
 		long new = atomic_long_add_return(1, &iter->rlimit[type]);
 		if (new < 0 || new > max)
-			goto unwind;
+			goto dec_unwind;
 		if (iter == ucounts)
 			ret = new;
 		max = get_userns_rlimit_max(iter->ns, type);
@@ -334,7 +334,6 @@ long inc_rlimit_get_ucounts(struct ucoun
 dec_unwind:
 	dec = atomic_long_sub_return(1, &iter->rlimit[type]);
 	WARN_ON_ONCE(dec < 0);
-unwind:
 	do_dec_rlimit_put_ucounts(ucounts, iter, type);
 	return 0;
 }
_

Patches currently in -mm which might be from avagin@google.com are


