Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794534326;
	b=zf441tNVTWzZZaLKAgG/20CQwctF2LaGHUmUfJ9ArHmQ1qTHT3xIadU6MzteD8eT7538
	 rOZp1pV3T9eJu9y5otEgh3txXFZME3u8J6asjirWsTPhEz4fF86K3C7lK3UWdgIV2aqyz
	 C4A+AyLzVci72NsWUaXkArV6F7+O5X3Ihvx4OUaG2v+0NuviLKIgSUFlg7vlVa3FflWBb
	 tiHUNHAkqhepjE2ew9gGs8GAMT9+LFMb9Kq2dynFvQFbgaEvHF8ye2xZm8nk/HZ7ppVgW
	 YwsMj1Tl2U3ugZdaHqY43X1cSCNNoi2MrSw6wNzLno95q2iFu4HHhyuqr9q5KvVFhww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794534326;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gawzVXH4dzdEianOgImCiVHQ5Of7fpMeTBSAC24HQ44=;
	b=cyqnndc4NyZXLzFOK/ypj3+afhhhSJWrYP5n8QUPLJrYW2wypHBxvSrG7nQMR5jDaVhJ
	 UDziiQ5P9DFL3amRmX+QuOobQvab7q9NE1roENabp4V4FPHfuZN03hEu6cgEAEOVP8uXb
	 yT66lmO335ZRhsJYQKr3UH//X2zJVK4DoySYxsP0pwAT6/+qOa/WsvqbOuCfjMV3e83Lh
	 APexzOldyCo0HYOHXMXyJWhDyD5ZB6gpIwiWzWLzBt1R5oRdYp7/s7BuZ9qRdYSHLYvzH
	 vOVs0IEBjbbSklDA1ZXD+luX2FtTZjhoGNgKZ4cS9wKw+dS4jMXPE3hA/Cp5bFvnY6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L8omhzjN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86A2606A31C
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 01:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=L8omhzjN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736451F000C4;
	Fri, 13 Nov 2026 01:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794534325;
	bh=gawzVXH4dzdEianOgImCiVHQ5Of7fpMeTBSAC24HQ44=;
	h=Date:To:From:Subject;
	b=L8omhzjNaRnboSQanwZAqvuuowz7lD+Sy3l/LUxlv5HsCgsyL0iKRJaYNHen2iXQ9
	 Lg3Ed7cmoya6WKxaj22JG+m7cOO1zmmjRFPhxUTWFuTfUxxSiZbJzw7XWsV5AjG4MC
	 Ro0JuFc78GcGvy81xS7u6ced8TSNu6FZCyQhfszA=
Date: Thu, 12 Nov 2026 17:45:24 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,
	surenb@google.com,mhocko@suse.com,hannes@cmpxchg.org,
	brendan.jackman@linux.dev,aleszlucero@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_reporting-document-order-parameter-in-page_reporting_notify_free.patch added to mm-new branch
Message-Id: <20261113014525.736451F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/page_reporting: document @order parameter in page_reporting_notify_free()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_reporting-document-order-parameter-in-page_reporting_notify_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_reporting-document-order-parameter-in-page_reporting_notify_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
Subject: mm/page_reporting: document @order parameter in page_reporting_notify_free()
Date: Thu, 12 Nov 2026 10:18:19 -0600

Add missing kernel-doc description for @order to fix a kernel-doc warning.

Link: https://lore.kernel.org/20261112-page-reporting-doc-v1-1-593af69f3801@gmail.com
Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/page_reporting.h |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_reporting.h~mm-page_reporting-document-order-parameter-in-page_reporting_notify_free
+++ a/mm/page_reporting.h
@@ -23,6 +23,7 @@ static inline bool page_reported(struct
 
 /**
  * page_reporting_notify_free - Free page notification to start page processing
+ * @order: allocation order of the freed pages
  *
  * This function is meant to act as a screener for __page_reporting_notify
  * which will determine if a give zone has crossed over the high-water mark
_

Patches currently in -mm which might be from aleszlucero@gmail.com are

mm-page_reporting-document-order-parameter-in-page_reporting_notify_free.patch

