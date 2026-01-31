Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72E338B7B4
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898353; cv=none; b=AcvTqEFduFQdKhuukhxphZ+rLWI4+itR7d+RKv8SHPMAcdtA7XoVYloW6JWD1xTZTSI7Mja+rJ7LYit5iwy69Si/yw11JpV/DZWICUVn4kPpEkywzc1QCf+6jmGN/xLV8p6m3WAaEDyMPUX+hQqbOsfN997/Rxui42mXf8YpSvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898353; c=relaxed/simple;
	bh=i+nHFH0lHRRUjplboLxgyBlRmOL3jauIWkRHz/ACvc8=;
	h=Date:To:From:Subject:Message-Id; b=Ipkzq3ezRzLUOpj6G7RVBuxJvwSMs3gJmqDaDjlfcuKQBCpVzBXytsSxjHg+c3K79cwQAcxmIXWGlKHBibMADPFD/pXQGsgS1iyKRj8HLY7pPsIfJBp216RzWepZ4HtO/AkunSANyIL2mQDoATsYrj4jL2Ehf8TopEn0nL1WxuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YWVMMCPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YWVMMCPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB3DC4CEF1;
	Sat, 31 Jan 2026 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898352;
	bh=i+nHFH0lHRRUjplboLxgyBlRmOL3jauIWkRHz/ACvc8=;
	h=Date:To:From:Subject:From;
	b=YWVMMCPk78gr/tP6fNQ37ZUOJxlacRgUQQ6emw+mrDfiAmTkYnIaKRbtcTd6TXs0O
	 d5VKto167cxNFmZC/cJmx89h9KFIfYIKSo7llpqzlF8pJfzhT8lk5E8oA/ou8fVr3M
	 XBboSRAt51PMKrRAT6gr0rhmzqwtZEejitYkkT60=
Date: Sat, 31 Jan 2026 14:25:52 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch removed from -mm tree
Message-Id: <20260131222552.BEB3DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: fix wrong MAITNAINERS section name
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: fix wrong MAITNAINERS section name
Date: Sun, 18 Jan 2026 10:02:58 -0800

Commit 9044cbe50a70 ("MAINTAINERS: rename DAMON section") renamed the
section for DAMON from "DATA ACCESS MONITOR" to "DAMON".  But the commit
forgot updating the name on the maintainer-profile document.  Update.

Link: https://lkml.kernel.org/r/20260118180305.70023-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -3,8 +3,8 @@
 DAMON Maintainer Entry Profile
 ==============================
 
-The DAMON subsystem covers the files that are listed in 'DATA ACCESS MONITOR'
-section of 'MAINTAINERS' file.
+The DAMON subsystem covers the files that are listed in 'DAMON' section of
+'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
 linux-mm@kvack.org.  Patches should be made against the `mm-new tree
_

Patches currently in -mm which might be from sj@kernel.org are


