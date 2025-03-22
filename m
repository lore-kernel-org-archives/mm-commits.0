Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE6A944F
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 00:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742604868; cv=none; b=VOSdCFCL4olTd7P2Krdfx1huDvK10SSZyFphx18rj59cs6Ev5RIASv2VzUqyV98MSudZaFZqKGEn9591yOGvHSQ0nDuhkYJ0G/QmjW9B+iH+0MVO97+z3/1CyBhU8dlvUIV/dzljgvU5nUtAfFRLdeqRLDqXToQYs5zv9pxZ338=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742604868; c=relaxed/simple;
	bh=zTOy0mvnhsA9qoDMoq7ds8IpNafZLdoRpSSnAeNRy2M=;
	h=Date:To:From:Subject:Message-Id; b=k1PlWtihbjhm8NLkgEBmy7aCSfDg9O2HP3lN8jmPzaPBxtpaRrgMlL0NLxa5Ei1nijbERqk8Bjr/8x7ZIbfLz0DqgVB6xR9BO8hbKAre/qIIz2Q31TV8DzdibsB1STINbXSp9BCs7dct8DsEzmHalv49QWazLn6bxuEF+Dh4NMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QxLGTnNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QxLGTnNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8425EC4CEE3;
	Sat, 22 Mar 2025 00:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742604867;
	bh=zTOy0mvnhsA9qoDMoq7ds8IpNafZLdoRpSSnAeNRy2M=;
	h=Date:To:From:Subject:From;
	b=QxLGTnNvV6Dl1McwIoDE6Jq6eGsyt4hJfcPSU9TPswqoL6dZvYiATlIjItRVnIgMf
	 GKJDq0Y91vnpPR/E5Wvk6EKQJul20FgxptPwOvyXwf+gkYJwqW3NJ853xxtg5kEPT0
	 ePeU4FvlpDZliqIvNHeUW5rgotblhI/B9K8FviXw=
Date: Fri, 21 Mar 2025 17:54:26 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-myself-as-userfaultfd-reviewer.patch added to mm-unstable branch
Message-Id: <20250322005427.8425EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add peterx as userfaultfd reviewer
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-myself-as-userfaultfd-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-myself-as-userfaultfd-reviewer.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: MAINTAINERS: add peterx as userfaultfd reviewer
Date: Fri, 21 Mar 2025 20:21:24 -0400

Add an entry for userfaultfd and make myself a reviewer of it, just in
case it helps people manage the cc list.

I named it MEMORY USERFAULTFD, could be a bad name, but then it can be
together with the MEMORY* entries when everything is in alphabetic order,
which is definitely a benefit.

The line may not change much on how I'd work with userfaultfd; I think
I'll do the same as before..  But maybe it still, more or less, adds some
responsibility on top, indeed.

Link: https://lkml.kernel.org/r/20250322002124.131736-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/MAINTAINERS~maintainers-add-myself-as-userfaultfd-reviewer
+++ a/MAINTAINERS
@@ -15220,6 +15220,17 @@ F:	mm/vma.h
 F:	mm/vma_internal.h
 F:	tools/testing/vma/
 
+MEMORY USERFAULTFD
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Peter Xu <peterx@redhat.com>
+S:	Maintained
+F:	mm/userfaultfd.c
+F:	fs/userfaultfd.c
+F:	include/uapi/linux/userfaultfd.h
+F:	include/asm-generic/pgtable_uffd.h
+F:	Documentation/admin-guide/mm/userfaultfd.rst
+F:	tools/testing/selftests/mm/uffd-*.[ch]
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-fix-release-hang-over-concurrent-gup.patch
mm-arm64-drop-dead-code-for-pud-special-bit-handling.patch
maintainers-add-myself-as-userfaultfd-reviewer.patch

