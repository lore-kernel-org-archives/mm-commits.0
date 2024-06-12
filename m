Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAD5181300
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718208111; cv=none; b=E2hGajPBtcvcIWkvjJjLiXHKKZcgLO9bpRpCecbg6r8F18KEhZn//6WvwpS69q8BnGyMHVuLk6NuFl95BmZSYh24sSyO+tx/6/UIE8RxCKK0aCnhVlowpD0k5Gl0/MoHPaPXsNt8HvV756m4HyKDYw4Vbm1xAdzmMykjZC+kXo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718208111; c=relaxed/simple;
	bh=R3zq6QExaKfoKvUwj3kWxlljUPI+uUL9gHSMzmPeu/Q=;
	h=Date:To:From:Subject:Message-Id; b=r9sQ2fTvdSNpJ58LgbyWDiPU2u8lhBfhIbuNh9qp2T7m986o+asSxUZqfvQMYY0dGNJ9WsnEIAOHKn0OFuwD0aCDi74cuxjpaWF+JBICAzTf46Lp0VJug0OdosDl7+tzDMDar03tWZni1Od/24cT31AojZwaIst4q3w5xDopshI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=02IBaO6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="02IBaO6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AF5C116B1;
	Wed, 12 Jun 2024 16:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718208110;
	bh=R3zq6QExaKfoKvUwj3kWxlljUPI+uUL9gHSMzmPeu/Q=;
	h=Date:To:From:Subject:From;
	b=02IBaO6ARjJM+nWAlL6iWIcCofcTyzVpsc1zRvFLgswaVArWKi4P5o4FGHpgQc/jj
	 eXMtcSVRvWxvovfedpGwD/9eNGUbOmSky0dOezXU0yLiRr7SF/mDRSJXPKwSZTt2iu
	 E7qyTlGAoChM7ErL4iDm/ldkWfxYotbQq1JIO228=
Date: Wed, 12 Jun 2024 09:01:50 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,david@redhat.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix.patch added to mm-unstable branch
Message-Id: <20240612160150.C0AF5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rmap: abstract updating per-node and per-memcg stats fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: rmap: abstract updating per-node and per-memcg stats fix
Date: Tue, 11 Jun 2024 22:10:43 -0700 (PDT)

/proc/meminfo is showing ridiculously large numbers on some lines:
__folio_remove_rmap()'s __folio_mod_stat() should be subtracting!

Link: https://lkml.kernel.org/r/49914517-dfc7-e784-fde0-0e08fafbecc2@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix
+++ a/mm/rmap.c
@@ -1567,7 +1567,7 @@ static __always_inline void __folio_remo
 		    list_empty(&folio->_deferred_list))
 			deferred_split_folio(folio);
 	}
-	__folio_mod_stat(folio, nr, nr_pmdmapped);
+	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
 
 	/*
 	 * It would be tidy to reset folio_test_anon mapping when fully
_

Patches currently in -mm which might be from hughd@google.com are

mm-migrate-fix-kernel-bug-at-mm-compactionc-2761.patch
mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix.patch

