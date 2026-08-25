Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A0637DAD0
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622971; cv=none; b=T0Kqu9RYk9/3oZd+WnHGhmYc+YHxCopNqjz/iCv7tq/R7ZCFdI+Cuvf2iDKDp8XOIEzLWRYPF4iYYMMViZcrl2xujtl80WT9ii1ZvHE3/HaffiFrJCvQQ9DoKJRcOERShOz6q2ZBh/runQwbojUzxDj7Ij+e3KPA8BiCcL6pmmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622971; c=relaxed/simple;
	bh=F20smMIfhpIcP2dR/9tYNdE8mhbXf3oHRHa+Myrr374=;
	h=Date:To:From:Subject:Message-Id; b=ZL3I6FO70B7VtkEtXYpKyhaRnup0bSJ4Ix53pDb4fRoBpx96CSkV9t1MjKaTW8RmHucogqRFAVUVZiCkVtjAXR/lGVhZ2icZot+Fg9o/ym44dGNHs/05oIEDHr95a1BWgse6mn+CXFRJz7UXtDEEoG3P92c90Jt2WDl3ImsP13U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zLHXt7X3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zLHXt7X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7270A1F00A3A;
	Tue, 25 Aug 2026 01:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622969;
	bh=b8DfpQcJjdNYBDZxpqyU0QVLcObq283b7TAObqgl3A8=;
	h=Date:To:From:Subject;
	b=zLHXt7X3CNrBih76V54qJkKAfQTWLdEGsp9SA69tD8Nb/K1WpiLbyjnFl1TROSXAU
	 Y2GlfAXLU+Sc1ySiwPWvS6Ee09VhGi0h7+Dj1CzClK8nixZa4FgRR4nmSFQYXELFzz
	 YGUYBLbDLWAAMvPIcn1eLwLoNs40MjXBz1lP7NAs=
Date: Mon, 24 Aug 2026 18:56:09 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-drop-maple_alloc_slots.patch removed from -mm tree
Message-Id: <20260825015609.7270A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: drop MAPLE_ALLOC_SLOTS
has been removed from the -mm tree.  Its filename was
     maple_tree-drop-maple_alloc_slots.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: drop MAPLE_ALLOC_SLOTS
Date: Fri, 21 Aug 2026 15:26:14 -0400

MAPLE_ALLOC_SLOTS is no longer used, so remove it.

Link: https://lore.kernel.org/20260821192627.4085470-7-liam@infradead.org
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

 include/linux/maple_tree.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-drop-maple_alloc_slots
+++ a/include/linux/maple_tree.h
@@ -28,13 +28,11 @@
 #define MAPLE_NODE_SLOTS	31	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	16	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	10	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 1)
 #else
 /* 32bit sizes */
 #define MAPLE_NODE_SLOTS	63	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	32	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	21	/* 240 bytes */
-#define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 2)
 #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
 
 #define MAPLE_NODE_MASK		255UL
_

Patches currently in -mm which might be from liam@infradead.org are


