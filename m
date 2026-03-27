Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4721A74BE1
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 05:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774589674; cv=none; b=QVpAwSCY989haTgMv8m2TywXGGY9HkTLXvTYfHaDWiExpqJ56Ua4Zbqo0tls+7q2nmm7c2DBsez/69PCLkKtet8i+E6SRvkdMdcO2sG1iAVab/LPBmIzQ6xuurMgHb7V9HPJrlQ/Z3ibmxY6T0Xjg8kQ00/D++yp/bqStfFD4Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774589674; c=relaxed/simple;
	bh=+9fDCZPV5nnmdqpM7qgLK+aC8bXJR9xTvEOMFt0IgFk=;
	h=Date:To:From:Subject:Message-Id; b=fL7fzuPPeGGvj4VRUm+q368N8SW0qi86144+VHir7GrNgSuJYuGvyKd1T7icOboRZ93J2nAlivqbUDmBZMa5xXJWEv4Nd06bDi0CtWzXOdceG85qgZUTHWl9dr4lF2hVsK37awYnmLTe7PdA1X+6Js9h3KBAu+ex909BxEFcOOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gmdpG9Hy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gmdpG9Hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A61C19423;
	Fri, 27 Mar 2026 05:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774589674;
	bh=+9fDCZPV5nnmdqpM7qgLK+aC8bXJR9xTvEOMFt0IgFk=;
	h=Date:To:From:Subject:From;
	b=gmdpG9Hy2ggtX7HBsngGXz/sD9zPLaFeY7GBuuHX9rbdNvK6QzlivbOGt9NymAoCj
	 ftg/3+bcDacie5ijOMkVJvNsZmqr8axJUebNjxQ6SwDjOfKIuz+XJPENj29gHkM252
	 rHSCUR0/Gqd5oExeMYPOn+6Nmmzz/LDwGWiPKCHg=
Date: Thu, 26 Mar 2026 22:34:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,justinstitt@google.com,david.laight.linux@gmail.com,david@kernel.org,qq570070308@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-optimize-the-implementation-of-warn_on_once_gfp.patch removed from -mm tree
Message-Id: <20260327053433.E8A61C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimize the implementation of WARN_ON_ONCE_GFP()
has been removed from the -mm tree.  Its filename was
     mm-optimize-the-implementation-of-warn_on_once_gfp.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Xie Yuanbin <qq570070308@gmail.com>
Subject: mm: optimize the implementation of WARN_ON_ONCE_GFP()
Date: Mon, 9 Mar 2026 23:38:11 +0800

As shown in the commit message of commit 242b872239f6a7deacbc
("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"), the
code "unlikely(a && b)" may generate poor assembly code if it is actually
"unlikely(a) && unlikely(b)" or "unlikely(a) && b".

WARN_ON_ONCE_GFP() may be used in the hot path code:
1. The argument cond should be unlikely.
2. When "1." is true, !(gfp & __GFP_NOWARN) is unlikely, otherwise, a
   WARN may be triggered, which is a very unlikely case.
3. When "1. && 2." is true, just like the implementation of WARN_ONCE(),
   !__warned can be unlikely.

Reorder __ret_warn_once judgement to first and split out the unlikely() in
WARN_ON_ONCE_GFP() to optimize performance.

Link: https://lkml.kernel.org/r/20260309153811.40958-1-qq570070308@gmail.com
Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/internal.h~mm-optimize-the-implementation-of-warn_on_once_gfp
+++ a/mm/internal.h
@@ -94,7 +94,8 @@ struct pagetable_move_control {
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(!(gfp & __GFP_NOWARN) && __ret_warn_once && !__warned)) { \
+	if (unlikely(__ret_warn_once) &&				\
+	    unlikely(!(gfp & __GFP_NOWARN)) && unlikely(!__warned)) {	\
 		__warned = true;					\
 		WARN_ON(1);						\
 	}								\
_

Patches currently in -mm which might be from qq570070308@gmail.com are


