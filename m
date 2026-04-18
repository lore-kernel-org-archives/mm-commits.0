Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAC4346A18
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 08:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499211; cv=none; b=fX/V8vyNvP+mqiS3NRcTO+3EZ1e+bJFMV48yVgWzRP2LRAmte9f7ZCq1chpVSZ0MLYQS6LsG2aEItKuHtR6MNSX6bIyueN2oilhuuI1RqiPKF6ZnR8cFFoD5fnOMvKSsPhLJ1Bu6EPIoItm9T5pZmqQPaHhWLHszI5eXRKPqFZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499211; c=relaxed/simple;
	bh=lLhU/5EZdTxrSKD5B3ZyfZ6PFnSV2TKiow+18XwqHKY=;
	h=Date:To:From:Subject:Message-Id; b=aa22WjAt5yTJzWgnTSZdeeVChOX68lC2dNDliyVVKeUeP5fxBOvGtsBzA6LIgEb639BsDQ2aQPuzmkTfvGPBetWnvJD++DATEXkUc7BQ+FGsmcqBaK1A1BAYC70kPSdQop+WwvMjfuGcXsklGl8T34B5tvcC29u1nkMGW+FnsAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G7O6YeTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G7O6YeTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73371C19424;
	Sat, 18 Apr 2026 08:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499211;
	bh=lLhU/5EZdTxrSKD5B3ZyfZ6PFnSV2TKiow+18XwqHKY=;
	h=Date:To:From:Subject:From;
	b=G7O6YeTYx6acoVUUCyXTF1ElDCMuYhms+iBFK39PhWMocHDmomJv11MiJrP/11+qV
	 lWvP0gGynjv+UHCVrynUu2wKmlpKqT5uaOu/4KwVnamiwfwaHu+E39Z4UT2XBc25Ot
	 1VeJRm4e1OvOWhLdPz+KY7CfRwuYdFec9gD8o/Gs=
Date: Sat, 18 Apr 2026 01:00:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-page-cache-reviewer.patch removed from -mm tree
Message-Id: <20260418080010.73371C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add page cache reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-page-cache-reviewer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: MAINTAINERS: add page cache reviewer
Date: Wed, 15 Apr 2026 19:40:40 +0200

Add myself as a page cache reviewer since I tend to review changes in
these areas anyway.

[akpm@linux-foundation.org: add linux-mm@kvack.org]
Link: https://lore.kernel.org/20260415174039.13016-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-page-cache-reviewer
+++ a/MAINTAINERS
@@ -19964,7 +19964,9 @@ F:	kernel/padata.c
 
 PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
+R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
+L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.infradead.org/users/willy/pagecache.git
 F:	Documentation/filesystems/locking.rst
_

Patches currently in -mm which might be from jack@suse.cz are


