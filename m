Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DAA37999D
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622967; cv=none; b=ldqO54aHkVNTqMlAlREBHnMGbu6NVLHjgl7Sej9JMwk94uZiisc8GomwJkRoIZPhee3Ppb1z5EWdw24Zssalmfb/eclQihKo8ldscZE1FoXXxq0D1kLc1/cdPyo8fIpCVdpcycmzgYw2Y/MY+YeqiBrtSlMe8nSU3Bsjk+tXOO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622967; c=relaxed/simple;
	bh=EUHwFH3pKIzma8JplyTssBtaH3YjaAtjRk0LMYjaNVQ=;
	h=Date:To:From:Subject:Message-Id; b=A+k6HdW1uNnpQEJyXKGNgVkgjrfpQQ4I5yK0EetOr8BQAbKkPkNCM7IduyAkL9I3dcn1Xr+LJMAsQu5EjoREha/XbTJtwdBn+L1yGGfTXzNb8ZdaMrtZ21TA/v/pJ/eqVz83ZZOGD9GunvArxuVYEST72L3Tt6keRP13r2fq1dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x2vAwKNA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x2vAwKNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476091F00A3A;
	Tue, 25 Aug 2026 01:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622966;
	bh=XSBp5bBM7+HQNT9oQXZovgNv0846udZZQjtvYkZdlMM=;
	h=Date:To:From:Subject;
	b=x2vAwKNAh69XaQl4og0yJzx29oM1NLY+4TH/7u/bVWSZ/WFB4+KjgLoxq4IYaKHBg
	 RI5VrvwZ3jAjSDWvuoxo8u3M68QKPKXQHpRwnGdU7ZA6qqeccsFjwDBWiY6pXVPOdq
	 TL8Gldy2Wixq9BPtIOycfu/Y/D9qrh8W0FevtiO0=
Date: Mon, 24 Aug 2026 18:56:05 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-documentation-fix.patch removed from -mm tree
Message-Id: <20260825015606.476091F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: documentation fix
has been removed from the -mm tree.  Its filename was
     maple_tree-documentation-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: documentation fix
Date: Fri, 21 Aug 2026 15:26:12 -0400

Don't include the word flag in the quotes with the actual flag.

Link: https://lore.kernel.org/20260821192627.4085470-5-liam@infradead.org
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/maple_tree.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-documentation-fix
+++ a/Documentation/core-api/maple_tree.rst
@@ -211,7 +211,7 @@ Advanced Locking
 
 The maple tree uses a spinlock by default, but external locks can be used for
 tree updates as well.  To use an external lock, the tree must be initialized
-with the ``MT_FLAGS_LOCK_EXTERN flag``, this is usually done with the
+with the ``MT_FLAGS_LOCK_EXTERN`` flag, this is usually done with the
 MTREE_INIT_EXT() #define, which takes an external lock as an argument.
 
 Functions and structures
_

Patches currently in -mm which might be from liam@infradead.org are


