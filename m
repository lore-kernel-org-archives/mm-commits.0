Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82016158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945881; cv=none; b=YA1mftbW4+yjF4MmF0REIiz0UMUOiOHSyRDmQ/8O4GcbfH9Vri5aFXpYHi77k/RI4YWm+rPcLC2IvlYy+H7xZ8tEah9nI+V2MDOe8Mhtmom/pArw47PzWRpLhx002mT+vekBSQIVDbc8iiOt2AeLWCVyDQ93syGjN/4bPCu3APc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945881; c=relaxed/simple;
	bh=YNQljJVrLzdO4JXjWy5EgkY0WLH6XQaNf/CdHxMWvKM=;
	h=Date:To:From:Subject:Message-Id; b=ADpSJ3v7UeqokfU/Xs60n+XmTrtPStcAOu6R4Bbx7gRIOTUz/wCp921pI0JkIPVVGX/5v86dfAfX8R0TYgxl7SwlUx3ySmBt0m14DDqvWobkUxJBtWu11JVLOinNfqnphOyaPAkglHV8ou+ElYU+tycT+mXIpk1WmuEsj86J7UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tqp5LHxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tqp5LHxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E69C4CEEA;
	Fri, 18 Apr 2025 03:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945881;
	bh=YNQljJVrLzdO4JXjWy5EgkY0WLH6XQaNf/CdHxMWvKM=;
	h=Date:To:From:Subject:From;
	b=tqp5LHxgtDDKO75x3BAFZzbi5hvkXbYB5D1XEPn/tD4FAW5cBXN9KYJAMPAamWkfV
	 BZhanfGdOahq61/FdGVJQIJoyaNN24saAbY+lOwH17JiJtQmfsJBFiazVVL+R4nbpM
	 t9GR3eC+OpOY8DVj9Fnpm6Wei+bPhLCRTCjqk72U=
Date: Thu, 17 Apr 2025 20:11:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section.patch removed from -mm tree
Message-Id: <20250418031121.05E69C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Pedro as reviewer to the MEMORY MAPPING section
has been removed from the -mm tree.  Its filename was
     maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-pedro-as-reviewer-to-the-memory-mapping-section
+++ a/MAINTAINERS
@@ -15558,6 +15558,7 @@ M:	Liam R. Howlett <Liam.Howlett@oracle.
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
 R:	Jann Horn <jannh@google.com>
+R:	Pedro Falcato <pfalcato@suse.de>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-incorrectly-disallowed-anonymous-vma-merges.patch
tools-testing-add-procmap_query-helper-functions-in-mm-self-tests.patch
tools-testing-selftests-assert-that-anon-merge-cases-behave-as-expected.patch
mm-move-mmap-vma-locking-logic-into-specific-files.patch

