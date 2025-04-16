Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606B02DFA42
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 22:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744841967; cv=none; b=ss+dB1wkBZgHJz4z1TcNpjUqdiczPmtcQmNr/uDe3UCQeIABp4x0s4guZ8bq4kyLbVY06FtCejc0ef+ff3UyKRmhDjAGeiHmZNEwYv4BpE8wozaTTAUOdxrDbsdGPrauzAHr4mbEjCm+TjoFngHZnp/t3+X9ZU+tVUFEpJRl7Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744841967; c=relaxed/simple;
	bh=TDBBfVR+qAa4zu3u5QMqyArmZzDkTPTfrNKaFY+iu/k=;
	h=Date:To:From:Subject:Message-Id; b=FKfeMolEFXfEy/pFFzqsoopuCGTcDiOYKb/6xrWYnVDihhDEju7g0TPkkneYkdvs6Z3auDgvsHECxs86+OlRNrYVNXksmJcjXK9/GdnT8CXeXLXgpSttxVFYvBjvQJ6AOYcxIVf4xoltxetPRN1drIBIPB5//SrUGuRd6y7ouUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o40Kk153; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o40Kk153"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C31CC4CEE2;
	Wed, 16 Apr 2025 22:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744841966;
	bh=TDBBfVR+qAa4zu3u5QMqyArmZzDkTPTfrNKaFY+iu/k=;
	h=Date:To:From:Subject:From;
	b=o40Kk153OHohhFiqdvo4Xw4xcsU6Bmpfclm8x7lbUeWFAm41N9jRaoeIS542ql5f9
	 /TO/NLJVEz/qc2AYJm+FDKR4wj/hFqpznCBMP7ncGU7pxOMPqOmyiPawgDLcq67Dnm
	 ECCnUE8x8Yx2fCBOQ2Int8Aw45Mt2EbTkijjRU2c=
Date: Wed, 16 Apr 2025 15:19:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,liam.howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250416221926.8C31CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Pedro as reviewer to the MEMORY MAPPING section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add Pedro as reviewer to the MEMORY MAPPING section
Date: Wed, 16 Apr 2025 14:53:01 +0100

Pedro has offered to review memory mapping code.  He has good experience
in this area and has provided excellent feedback on memory mapping series
in the past so I feel he'll be a great addition.

Link: https://lkml.kernel.org/r/20250416135301.43513-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section
+++ a/MAINTAINERS
@@ -15554,6 +15554,7 @@ M:	Liam R. Howlett <Liam.Howlett@oracle.
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
 R:	Jann Horn <jannh@google.com>
+R:	Pedro Falcato <pfalcato@suse.de>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-memory-advice-section.patch
maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section.patch
mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch

