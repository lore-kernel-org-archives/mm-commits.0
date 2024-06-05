Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EF5136E1F
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717627096; cv=none; b=a5gyeTEGYUiRwrk5SxmBu83vo7U2PiX+Hs9TZmtl7ArR1YV6YjQKtpZV9tt7nwXPyf3KQ97j1oqwdr2fce/k8NBU52nwhpdGGizfk+kf4SkRIMmW61MIITr8t6OW4I7aZiEzrvHO9s5R0ff4uLw6IoGt1PvK5Dc+tGZL24iWiQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717627096; c=relaxed/simple;
	bh=PCaza9NC0OYoZ8iNZEHZensiV1ADotKPjyZWPcMR4OA=;
	h=Date:To:From:Subject:Message-Id; b=ATJoQA77/eXaCgUU8trUPgvPybrrQu/XxQzAEo9Dsdm1uj0MeD6MtFjgrRhE90jajk9GVILD5rva8eGJOK/dJR1QoIOG+a95CayNRusnK8Riq1jTZUY5OFIvcK4cBqTr6h/GgrF/l1eneEqGsEL68IuW5vYHL1HZS9dOBb8cL/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cvRJ7xZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cvRJ7xZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EB8C32782;
	Wed,  5 Jun 2024 22:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717627095;
	bh=PCaza9NC0OYoZ8iNZEHZensiV1ADotKPjyZWPcMR4OA=;
	h=Date:To:From:Subject:From;
	b=cvRJ7xZjzWZ69LneSmI+muXzgMumJvWFtlekRdtq740Rd0uuv6bb1mg5GB4Uk1Bq+
	 MQzN/n95HA/B4rDieNOSzJTLe8c3Fe3xrIP3WVV1fDICFpMjVniQk4CYagWqdu5Z3U
	 xVgK0G8Vnk6LZlZm1PkGn1E2rlTqb3mmuEOguBF4=
Date: Wed, 05 Jun 2024 15:38:14 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,bhe@redhat.com,lstoakes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-myself-as-vmalloc-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20240605223815.95EB8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove Lorenzo as vmalloc reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-myself-as-vmalloc-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-myself-as-vmalloc-reviewer.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: MAINTAINERS: remove Lorenzo as vmalloc reviewer
Date: Sun, 2 Jun 2024 21:55:10 +0100

I haven't had the bandwidth to review vmalloc patches recently and I
suspect I won't be able to do so consistently moving forwards, so I think
it's best if I remove myself as reviewer for the time being.

Link: https://lkml.kernel.org/r/20240602205510.108807-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-as-vmalloc-reviewer
+++ a/MAINTAINERS
@@ -23976,7 +23976,6 @@ VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
 R:	Christoph Hellwig <hch@infradead.org>
-R:	Lorenzo Stoakes <lstoakes@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lstoakes@gmail.com are

maintainers-remove-myself-as-vmalloc-reviewer.patch

