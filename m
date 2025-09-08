Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7632F1FF7
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 23:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757374900; cv=none; b=JhahXtNmC2YBJ2KA+59P5XcVjLgMsM18a5lWuZOxUEsf152qkh/MWyJAZ2p/z2BrWrPJSDu3EZUnQKTI6DTfA+3rPPfTdrTzGTNmtUxsTL8K10wN+mNsh80AHl8Ftu24ZjKGLM8xImJ4bGKVFE5ZZg0Sr0nGv1DRbS7kKvKaj4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757374900; c=relaxed/simple;
	bh=vIJHTkMTnkyJSu24OwfKgepFtHGxd0IAWdP3bLUE2Zk=;
	h=Date:To:From:Subject:Message-Id; b=Qf8pPYKseIBPZ0+W+PyWWMkXdqsDgaUTT6vafmgai3a05hMy5w1ceUQyYnZK5bzOk0JyDDEj3e3K7XVEBkbJxwlyxfoXtXuhSOzAB4qgI/bzXbSdf+OxoE8B5cieeENYNGcKPmh0v4GOV4A8DDrv6ZSL1GN3WfTIp+0dnY/l8CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=huGmpN9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="huGmpN9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3E4C4CEF1;
	Mon,  8 Sep 2025 23:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757374900;
	bh=vIJHTkMTnkyJSu24OwfKgepFtHGxd0IAWdP3bLUE2Zk=;
	h=Date:To:From:Subject:From;
	b=huGmpN9ga7YzCqM9Hvy76Hls0/T+8FZi1BoGNpPMQOUmw/Dq0gqjKS4zNCn9GYypS
	 QC8aKbTRUt+W3ELjS0P7OxfXI9WBGSUuIFgDWmNYoElisyVxaxoxh+wZq1pWq4wbOU
	 0UGTV8z+LD+UWZZm4M0qsictSUb64/XUvxDp2wIM=
Date: Mon, 08 Sep 2025 16:41:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-lance-yang-as-a-thp-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20250908234140.2E3E4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Lance Yang as a THP reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-lance-yang-as-a-thp-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-lance-yang-as-a-thp-reviewer.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add Lance Yang as a THP reviewer
Date: Mon, 8 Sep 2025 18:48:57 +0800

I've been actively digging into the MM/THP subsystem for over a year now,
and there's a real interest in contributing more and getting further
involved.

Well, missing out on any more cool THP things is really a pain ;)

Link: https://lkml.kernel.org/r/20250908104857.35397-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-lance-yang-as-a-thp-reviewer
+++ a/MAINTAINERS
@@ -16240,6 +16240,7 @@ R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
 R:	Barry Song <baohua@kernel.org>
+R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lance.yang@linux.dev are

maintainers-add-lance-yang-as-a-thp-reviewer.patch

