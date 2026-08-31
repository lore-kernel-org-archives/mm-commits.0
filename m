Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08C74CCDE2
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788220200; cv=none; b=CckJ+rPYekdv6FMCrWBW7BcwEo+y472d6WXIeQsDXuc6txXP9atgnyXq6USdBLSnmAYmb0q71oR2z+oe6IHzY5hIa8Ll4KN1pAhg1sXEYGKTMld2lcl+wTzWW4hiY7qX+KZzkhKxYyd4VEspaYvVX373v7VXVy01kCbLITm+WIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788220200; c=relaxed/simple;
	bh=kk6OI2k3aIAYxVJpnkVJms8q0ttWPlSS1Nlyir+iT+8=;
	h=Date:To:From:Subject:Message-Id; b=NvGAFLUW3TTXpUl3ecflpywYNx0E5aG+/gCzG2gZG+jCOUuNGFh3zNQjr3cp0txyOeDw+6vZJblMncPO4wRs1rWE2OmynF3IR0XTJCk3sJtSF9I+CFjPvyE4+Hdr7k/uklxSwLw9JkWfA3yKtjPq6SuAAQEjetQ9uowVBjp7Bnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gFovefu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gFovefu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF941F000E9;
	Mon, 31 Aug 2026 23:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788220199;
	bh=OiTmwHEhd3dojxSVCry1dYO8PqQRF4BeHQPJOmdJYOk=;
	h=Date:To:From:Subject;
	b=gFovefu75iph+lRx8ryI6SttIHGtK/6dEOzEfZ3QwiFB9ul3WOHQ9b2HU9vIv3aOe
	 BHyFchsgio1KmrPfGGqWXKGJ2S+ihUgUZR666L+jkDjTcdr3gwlB5Siy4psBaGimKh
	 pZAkIN2yLQpxrLu3Jj55QPuw/SREObwF1ceTEtag=
Date: Mon, 31 Aug 2026 16:49:59 -0700
To: mm-commits@vger.kernel.org,oberpar@linux.ibm.com,brads@mainlining.org,hrushirajg23@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-use-strscpy-instead-of-strcpy-in-init_node.patch added to mm-nonmm-unstable branch
Message-Id: <20260831234959.6DF941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gcov: use strscpy() instead of strcpy() in init_node()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     gcov-use-strscpy-instead-of-strcpy-in-init_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-use-strscpy-instead-of-strcpy-in-init_node.patch

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
From: Hrushiraj Gandhi <hrushirajg23@gmail.com>
Subject: gcov: use strscpy() instead of strcpy() in init_node()
Date: Mon, 31 Aug 2026 20:19:53 +0530

node->name is a flexible array member sized to exactly strlen(name) + 1
bytes at allocation time in new_node(), so this copy can never actually
overflow.  Still, prefer the bounded strscpy() over strcpy() on general
principle; pass the same strlen(name) + 1 bound the allocation used, since
sizeof() cannot be applied to a flexible array member.

No functional change.

Link: https://lore.kernel.org/20260831144953.324441-1-hrushirajg23@gmail.com
Signed-off-by: Hrushiraj Gandhi <hrushirajg23@gmail.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/gcov/fs.c~gcov-use-strscpy-instead-of-strcpy-in-init_node
+++ a/kernel/gcov/fs.c
@@ -529,7 +529,7 @@ static void init_node(struct gcov_node *
 	}
 	node->parent = parent;
 	if (name)
-		strcpy(node->name, name);
+		strscpy(node->name, name, strlen(name) + 1);
 }
 
 /*
_

Patches currently in -mm which might be from hrushirajg23@gmail.com are

gcov-use-strscpy-instead-of-strcpy-in-init_node.patch

