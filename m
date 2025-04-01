Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19E321481B
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545878; cv=none; b=f9+ZtOwzPYSbUKOCtEzRBlzn8iGlW5yfB/8YUIKU5OFG2cTdsW4WW4ulfEm5BJbKoYOYifqXxXm4gTxt+BqxGvQZfkgZswwmLRHpll8QAFJ+KYHGnhBv3Bg45MIxuGEdbfahMv+aSjpGFAEYPe5Myxv4+SxQmI51XHvK7NPhKK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545878; c=relaxed/simple;
	bh=Wb9A5z56udBXZFvPtORnRx5pVeXThKCnZDxOPX2rh3A=;
	h=Date:To:From:Subject:Message-Id; b=bpwOK3gA/8DNZhWdMQ53o6alWmHuePd1NeeQ0TiF1DoSJwZPu2IV+wN/7tcV0Fdy+SuOfq/pLRrJafntrWAfGc74riGGwQf8pBkA7Ti/zkeeotGX7sh5qvL7J4cxFaSIzi9Hi+nMYKBiesLx1bqTUOWtQapjV5yXySSbNoZ8yd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wH7jGFF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wH7jGFF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F27C4CEE4;
	Tue,  1 Apr 2025 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545877;
	bh=Wb9A5z56udBXZFvPtORnRx5pVeXThKCnZDxOPX2rh3A=;
	h=Date:To:From:Subject:From;
	b=wH7jGFF4quHxc82tCVbJMtbP5utfheuJGxSQ+bnE4Equvb368+FeVES5aHZk88avf
	 x2SqhxENTCqZNuzjqbKZT3EdrUNGcu+W7HQJimxMRbqp+hEekpKq52FprGqsOtNf5r
	 k2uQtwPVVcsoqaF8bZ9RFvwu8ntl1qxU6UBlKLFA=
Date: Tue, 01 Apr 2025 15:17:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org,aarcange@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-myself-as-userfaultfd-reviewer.patch removed from -mm tree
Message-Id: <20250401221757.61F27C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add peterx as userfaultfd reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-userfaultfd-reviewer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: add include/linux/userfaultfd_k.h, per Mike]
[akpm@linux-foundation.org: fix misordering]
Link: https://lkml.kernel.org/r/20250322002124.131736-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/MAINTAINERS~maintainers-add-myself-as-userfaultfd-reviewer
+++ a/MAINTAINERS
@@ -15517,6 +15517,18 @@ F:	mm/vma.h
 F:	mm/vma_internal.h
 F:	tools/testing/vma/
 
+MEMORY USERFAULTFD
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Peter Xu <peterx@redhat.com>
+S:	Maintained
+F:	Documentation/admin-guide/mm/userfaultfd.rst
+F:	fs/userfaultfd.c
+F:	include/asm-generic/pgtable_uffd.h
+F:	include/linux/userfaultfd_k.h
+F:	include/uapi/linux/userfaultfd.h
+F:	mm/userfaultfd.c
+F:	tools/testing/selftests/mm/uffd-*.[ch]
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from peterx@redhat.com are


