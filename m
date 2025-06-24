Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE16219E0
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750807824; cv=none; b=bT/yeEdUy4nIONeD0dOYR+XECRMd7I1foHydH1hMo6OPCuOVDaMlZv0cLHllPAxtfYTmWYaiJay7Ah8wCkUmb8MvMzXUnbmGErHAHgcsR/MonRnr7DkG6YTxX8a/uvherzQO6lSIMCYwKW/Z801noh6il+0dHbeC19Bp37egxkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750807824; c=relaxed/simple;
	bh=qErQqOgxVHk/Sjjb2X1OdpRwBVJv4POtY4Zr8XrTfks=;
	h=Date:To:From:Subject:Message-Id; b=K35pn6BvS9mS/6V+xf6fl6k8NEk4rSO8d7viE6IWNYgSWmnD1M5U8M1gjcCqNERmxDf4FZ9nU9sf1oDfaCRMPrw02xtiA4yNCCrPEkOUilFwyUT5GFfaNAegdhNSte7UO4xuWt8uElAmrFjuRB2L79rzpcoNUG0tAnRfLkTAkzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zxf+fekl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zxf+fekl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DBCC4CEE3;
	Tue, 24 Jun 2025 23:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750807824;
	bh=qErQqOgxVHk/Sjjb2X1OdpRwBVJv4POtY4Zr8XrTfks=;
	h=Date:To:From:Subject:From;
	b=Zxf+feklfLHdKIz/g5O8mDI56dwr7VMbsq76s/h8vBi1NHhNSbhFNK+Yh/nJn7ewi
	 BnRpKpFCJXc95aHO/WkkcNViVgDPQC/4CxoyeUQZ+BjvXsrVXgGkjQs5Z0k0nXv8QS
	 YTFHWmj+9yBLwxbByJ55NFHQK/UwSDyQg0tp9bZs=
Date: Tue, 24 Jun 2025 16:30:23 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,liam.howlett@oracle.com,dev.jain@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-use-goto-label-to-simplify-code-fix.patch added to mm-unstable branch
Message-Id: <20250624233024.46DBCC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple-tree-use-goto-label-to-simplify-code-fix
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-use-goto-label-to-simplify-code-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-use-goto-label-to-simplify-code-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple-tree-use-goto-label-to-simplify-code-fix
Date: Tue Jun 24 04:28:16 PM PDT 2025

add newline, per Liam (and remove one, per akpm)

Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple-tree-use-goto-label-to-simplify-code-fix
+++ a/lib/maple_tree.c
@@ -4560,13 +4560,13 @@ again:
 	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 		goto retry;
 
-
 	if (likely(entry))
 		return entry;
 
 	if (!empty) {
 		if (mas->index <= min)
 			goto underflow;
+
 		goto again;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
filemap-add-__filemap_get_folio_mpol-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

