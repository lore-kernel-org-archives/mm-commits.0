Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25CB24E4A1
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744843; cv=none; b=YqjmLIwdXFXy0fEEsVjrKb4jbt0NcEH3P6iegUclkMY6WM+R+yKBto3Pb96EjH6nGH23zYr8dBY0FAF45DWm3C7vkJwwe+SNwI414PsCNbZvHmaCfpEzx+A6JH2q4nmkfb/9cQn3WR5uq0IYQrCEWktMqB9dAHdZ+RXNrpUPWYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744843; c=relaxed/simple;
	bh=K5DmkAR0eRkeKFUG7Rwo57SGE1sbQFA/rGpMfThe/9E=;
	h=Date:To:From:Subject:Message-Id; b=s2D9Y6innd4wsGGbRkNwdAfp99Ysp9ow2fQiFD5fu6aOHBS6lsuuM9vzBeTy1xXxqW/oLqd9EXbfuDKmf1o4mWuP3Lz4+bHyP+Tyl+ZTV3GeWvEeLf8SQlQ8+vYfY9Nvhcm4hvc8yu2ifO3k/8Yt92gnGK9x9nv5X98Lt9mh2p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pn8cBP9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pn8cBP9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0E8C4CEF7;
	Sun, 29 Mar 2026 00:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744842;
	bh=K5DmkAR0eRkeKFUG7Rwo57SGE1sbQFA/rGpMfThe/9E=;
	h=Date:To:From:Subject:From;
	b=Pn8cBP9jhDAgiKMz4+dPdvBKLO1uLJgykHyGodtWhwK9DChhvht8XvJFPe8mXo8z9
	 N0drRK7/L0dzFg1twGJECJrzwbMZDrPXXS7JSnxU5ira4hNpCD1w03J2FWtCUBvPKD
	 Gcp1OXGLGvEEV27HaMGTZ28L6xqyioWnpwZ4x7x8=
Date: Sat, 28 Mar 2026 17:40:42 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-index-fix-typo-autoamted-automated.patch removed from -mm tree
Message-Id: <20260329004042.BC0E8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/index: fix typo: autoamted -> automated
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-index-fix-typo-autoamted-automated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/index: fix typo: autoamted -> automated
Date: Sat, 7 Mar 2026 11:53:55 -0800

There is an obvious typo.  Fix it (s/autoamted/automated/).

Link: https://lkml.kernel.org/r/20260307195356.203753-8-sj@kernel.org
Fixes: 32d11b320897 ("Docs/mm/damon/index: simplify the intro")
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/index.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-fix-typo-autoamted-automated
+++ a/Documentation/mm/damon/index.rst
@@ -12,7 +12,7 @@ DAMON is a Linux kernel subsystem for ef
  - *light-weight* (for production online usages),
  - *scalable* (in terms of memory size),
  - *tunable* (for flexible usages), and
- - *autoamted* (for production operation without manual tunings).
+ - *automated* (for production operation without manual tunings).
 
 .. toctree::
    :maxdepth: 2
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

