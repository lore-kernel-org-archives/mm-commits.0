Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9766028373
	for <mm-commits@vger.kernel.org>; Mon, 22 Jun 2026 17:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782148040; cv=none; b=bxKqLn/Rq+S6IDY9+HPo5kwMx2KUcl8zqoH5Ka1m31djdTYP+f8rfE4JUniY7GEdUYXHIHM38k2HzezxVaSs1V1uz3spovFgYCcLxygKI4XsNaqOLdcRYuO7YRQswLxTtGgf3LPARpY00ejjJE9p21vCL10NIFIAtQuRfB8EF5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782148040; c=relaxed/simple;
	bh=VGjzaJ2rn65YQkO5EThP6FCrP7YdHN/MHcxOLHyFFag=;
	h=Date:To:From:Subject:Message-Id; b=sEF0FwcXqmtp+9heGTfV9c/RNGvhIX2KqVJwFPRv5Nl8/UmWy1N7JjlD8WZ7/KXQnUjao5/LKdA01f0+1shK0kyaQPGMwaThWSAygDjCndal9KlmJT/YVumQeonjHDB+bnvrnc0lxHjsXmAABTDCxiJuzKvQkIrzSecXxi5GG3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Im6IQWBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Im6IQWBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCDF1F000E9;
	Mon, 22 Jun 2026 17:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782148039;
	bh=XD/M79IaTxrzufXiIzy//mrMj/PdWMIepxGcKuefRHk=;
	h=Date:To:From:Subject;
	b=Im6IQWBV/h3tnHze7HI/RedQWSVzfIMpsHwUIkYecpUa/l/KNMup4vF0VgGfhCOzp
	 IJQ2rtOPCw7ItpSCZLgw9HNjgjKVljEFvZIVIcA7CqMVqTnk7ytZTnlho7UFVuZmk8
	 N3FGbHrV2Lh78+W1Nu8yhAMRGJgrWjdvbo+P5p1w=
Date: Mon, 22 Jun 2026 10:07:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,riel@surriel.com,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-lance-as-an-rmap-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20260622170719.1DCDF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Lance as an rmap reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-lance-as-an-rmap-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-lance-as-an-rmap-reviewer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: MAINTAINERS: add Lance as an rmap reviewer
Date: Mon, 22 Jun 2026 16:59:13 +0100

Lance has been doing excellent work reviewing rmap series and has proven
himself to be a great member of the community in general, so add him as an
rmap reviewer.

Link: https://lore.kernel.org/20260622155913.280355-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-lance-as-an-rmap-reviewer
+++ a/MAINTAINERS
@@ -17015,6 +17015,7 @@ R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
+R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-add-lance-as-an-rmap-reviewer.patch

