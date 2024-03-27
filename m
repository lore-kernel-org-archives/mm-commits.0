Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D020B14F9DD
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571034; cv=none; b=TE/oYecRgO0X05RuOJaD0dw1vMfQuuaub6FXPyoOlAKm9a43tplUcAx54vkt9djBMDUGOscBWFJKV7dZuqEYa5HaKD+AyEEuWQ6hg800GXq0dh6c2A3kSQs0IQP7m6tMJ3GyBPAY0ny1hV5iXUM2FzbCJ4BI7tXteXErjfnow6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571034; c=relaxed/simple;
	bh=bYFZmvoPHT/MjCst2L22Q0g7lunocybYVl67I6TFO/o=;
	h=Date:To:From:Subject:Message-Id; b=XMdUtOveSuyoEyNeUpNvZ8gjaaWGNgUED4UW6Qy+szLJUSVvJHR4+70ABVQqOlrbeE+rLDUIG5E7iwggMW2gOX7XXDdQ0MJq1izMmPlXxiiGFy5vho8uilCrPkME0pqsDJRFxlX+J7AakRtTDivmfllvNE6SPhcWGYHHQAoAZy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P1P97BtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P1P97BtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9D6C433F1;
	Wed, 27 Mar 2024 20:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711571034;
	bh=bYFZmvoPHT/MjCst2L22Q0g7lunocybYVl67I6TFO/o=;
	h=Date:To:From:Subject:From;
	b=P1P97BtHF4Sgn0SOS4O8kmd5SREkzQXFMwyF65whykI/xLhC2IADajv47K1XSxySk
	 rc5fQOkIzBF/JUiDysv5NWDFLqfUeutCl22ZfbJxVTBbDhlek7zGLOhPNRJn8tMx75
	 3BCdyuLqG45V8kVg0AenqGqRZLZPUV409TuTX8Qw=
Date: Wed, 27 Mar 2024 13:23:53 -0700
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,willy@infradead.org,v-songbaohua@oppo.com,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zswap-replace-rb-tree-with-xarray-v10.patch added to mm-unstable branch
Message-Id: <20240327202354.4D9D6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zswap: replace RB tree with xarray
has been added to the -mm mm-unstable branch.  Its filename is
     zswap-replace-rb-tree-with-xarray-v10.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zswap-replace-rb-tree-with-xarray-v10.patch

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
From: Chris Li <chrisl@kernel.org>
Subject: zswap: replace RB tree with xarray
Date: Tue, 26 Mar 2024 14:17:26 -0700

restore original comment "erase" to "invalidate"

Link: https://lkml.kernel.org/r/20240326-zswap-xarray-v10-1-bf698417c968@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~zswap-replace-rb-tree-with-xarray-v10
+++ a/mm/zswap.c
@@ -1569,7 +1569,7 @@ bool zswap_load(struct folio *folio)
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 
 	/*
-	 * When reading into the swapcache, erase our entry. The
+	 * When reading into the swapcache, invalidate our entry. The
 	 * swapcache can be the authoritative owner of the page and
 	 * its mappings, and the pressure that results from having two
 	 * in-memory copies outweighs any benefits of caching the
_

Patches currently in -mm which might be from chrisl@kernel.org are

zswap-replace-rb-tree-with-xarray.patch
zswap-replace-rb-tree-with-xarray-v10.patch

