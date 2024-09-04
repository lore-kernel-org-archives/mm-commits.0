Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D17711B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423532; cv=none; b=nDkHsYI09Ru8XDtdmZ+oP9P4ezy7FGMdgsAq8MCUjUByDSjP1FyiaVHo6Rb+Oslp2MpN4Z/o4J3YNvYTEe6V4BZBl3mkEKTBe7JSOmPK6K/HNvBiK9ufY7qb9bMeUbursraUpJ3orN5q6vweoSsqG30LRJ3N9DjHCkAN2Oxtt9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423532; c=relaxed/simple;
	bh=+JYr1F0pxPIB03PR0xbqnJUmwrmq6n2NL9+i+RJuIYI=;
	h=Date:To:From:Subject:Message-Id; b=TO6xQVOwMuKIYSehY2UMCD8hdZ+CU1Yt43ojmD5MwZsSbcsHcIs5VXHE5bzRjzAXJrfCe+c+6xp68A4SVuomJZSzuDs8WIL6nMlT46bkdVzbtjclvD6lwtXNbzMUMhia1xkXCWr5J2zBPBNPqIUfEsldtJD/Na1Xg2dmpX6ulHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+dMQoAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+dMQoAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86277C4CEC2;
	Wed,  4 Sep 2024 04:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423532;
	bh=+JYr1F0pxPIB03PR0xbqnJUmwrmq6n2NL9+i+RJuIYI=;
	h=Date:To:From:Subject:From;
	b=k+dMQoATyk319hJfLfb5i5R7tDurg/Uh3DrgjaP45hWD65oP9FK1Vm6UWpJ71cD8D
	 8/tocuSmU0+tbGhln5Gj6VU3yEpbi3NiOqDqP5AsiKcpwRa1ATwzmOjYLYoHLj8J4i
	 IVUee7M/+GnSFzv44VK+15jaNccdq6WDZrBYDKC8=
Date: Tue, 03 Sep 2024 21:18:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pageownerpriv1.patch removed from -mm tree
Message-Id: <20240904041852.86277C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageOwnerPriv1
has been removed from the -mm tree.  Its filename was
     mm-remove-pageownerpriv1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageOwnerPriv1
Date: Wed, 21 Aug 2024 20:34:40 +0100

While there are many aliases for this flag, nobody actually uses the
*PageOwnerPriv1() nor folio_*_owner_priv_1() accessors.  Remove them.

Link: https://lkml.kernel.org/r/20240821193445.2294269-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pageownerpriv1
+++ a/include/linux/page-flags.h
@@ -539,8 +539,6 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
  */
 PAGEFLAG(Private, private, PF_ANY)
 PAGEFLAG(Private2, private_2, PF_ANY) TESTSCFLAG(Private2, private_2, PF_ANY)
-PAGEFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
-	TESTCLEARFLAG(OwnerPriv1, owner_priv_1, PF_ANY)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
_

Patches currently in -mm which might be from willy@infradead.org are

swap-convert-swapon-to-use-a-folio.patch

