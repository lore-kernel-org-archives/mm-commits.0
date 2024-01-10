Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B2348CC1
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uyn0FUzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3343C43390;
	Wed, 10 Jan 2024 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704902996;
	bh=hW8ejaTorxUrUq/twHYhqDgWR0tJkXkrfUig2ewb0RU=;
	h=Date:To:From:Subject:From;
	b=Uyn0FUzw2oBorRHwmlbWvqXR/U1d+4ilggYNu9+3dO6rSYZ9/zYbJCisnLMvbQH3p
	 uILodXMNnVv8ccYz4JXnuJMA5+w9HPoW+mzzCvv5nSl+bMsvJWfk2wYLfVSLOKD7mn
	 EhXOnYtrAufED5gOT4u3PgBjmIcAsrbTcX/p6yrU=
Date: Wed, 10 Jan 2024 08:09:56 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,haifeng.xu@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-list_lru-remove-unused-macro-list_lru_init_key.patch added to mm-unstable branch
Message-Id: <20240110160956.C3343C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: list_lru: remove unused macro list_lru_init_key()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-list_lru-remove-unused-macro-list_lru_init_key.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-list_lru-remove-unused-macro-list_lru_init_key.patch

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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm: list_lru: remove unused macro list_lru_init_key()
Date: Thu, 28 Dec 2023 06:27:15 +0000

list_lru_init_key() isn't used by anyone, remove it to clean up.

Link: https://lkml.kernel.org/r/20231228062715.338672-2-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-remove-unused-macro-list_lru_init_key
+++ a/include/linux/list_lru.h
@@ -62,8 +62,6 @@ int __list_lru_init(struct list_lru *lru
 
 #define list_lru_init(lru)				\
 	__list_lru_init((lru), false, NULL, NULL)
-#define list_lru_init_key(lru, key)			\
-	__list_lru_init((lru), false, (key), NULL)
 #define list_lru_init_memcg(lru, shrinker)		\
 	__list_lru_init((lru), true, NULL, shrinker)
 
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-list_lru-disable-memcg_aware-when-cgroupmemory-is-set-to-nokmem.patch
mm-list_lru-remove-unused-macro-list_lru_init_key.patch

