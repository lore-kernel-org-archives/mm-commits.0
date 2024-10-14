Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6464B17BD3
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 23:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728948514; cv=none; b=Ir6KlcXAky8b254KkLr9WFbIeb708yKEPn2b0wMRPTcFP1/Dx1bYNP9g2MOTzVYDVtZEJWyo91ShPOaZsPoJuSthhBp3MkmrDdOqdX/whiWd95aRzXjDnaSoUIkQjHG7MG8JvQCCOL3bb9OXb/mKkvMy+j/1fMqUHMA/nPJvGZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728948514; c=relaxed/simple;
	bh=1ZdjRRmj8fOE2ESuiJ/qUmyfe691JzOCI2iYHG6CwqU=;
	h=Date:To:From:Subject:Message-Id; b=avvYUYqlbM1xtAGGVhGuITkWWzNaomBPxnDr4YUI4rW8KxhIKCw0/dHy2EOmKqIq/XKUQzFUS/lpuIFKFLZ4T6NvRPc8qnIgDloQcbe6MN5GOhB5WUPXDxEongvz4ee1otty4B/57WhS8yRlmn6OZo4UdW4tS4CRJv+4ElGyY7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jQFg9HoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jQFg9HoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D8AC4CEC6;
	Mon, 14 Oct 2024 23:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728948514;
	bh=1ZdjRRmj8fOE2ESuiJ/qUmyfe691JzOCI2iYHG6CwqU=;
	h=Date:To:From:Subject:From;
	b=jQFg9HoTZ5qLfHAJgHTgMI50jmGkXwe6UyHksCYno+rySUCkIEBSfPyUCuQkR8ci4
	 XcEYG91tXVtTdeWS7M3P9V3mDDo3L+MedbJGp4Z/JDyYofw0bCk+jUnbHhu11bFDdq
	 2xRn9K6OvKB5ArFtdECvQTh19JKGj9XHqLDA0t60=
Date: Mon, 14 Oct 2024 16:28:33 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-memory-mapping-vma-reviewer.patch added to mm-hotfixes-unstable branch
Message-Id: <20241014232834.35D8AC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Jann as memory mapping/VMA reviewer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-myself-as-memory-mapping-vma-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-memory-mapping-vma-reviewer.patch

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
From: Jann Horn <jannh@google.com>
Subject: MAINTAINERS: add Jann as memory mapping/VMA reviewer
Date: Mon, 14 Oct 2024 22:50:57 +0200

Add myself as a reviewer for memory mapping / VMA code.  I will probably
only reply to patches sporadically, but hopefully this will help me keep
up with changes that look interesting security-wise.

Link: https://lkml.kernel.org/r/20241014-maintainers-mmap-reviewer-v1-1-50dce0514752@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-myself-as-memory-mapping-vma-reviewer
+++ a/MAINTAINERS
@@ -14918,6 +14918,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
@@ -24733,6 +24734,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	https://www.linux-mm.org
_

Patches currently in -mm which might be from jannh@google.com are

mm-mremap-fix-move_normal_pmd-retract_page_tables-race.patch
maintainers-add-myself-as-memory-mapping-vma-reviewer.patch

