Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9022FBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645173; cv=none; b=jtd4eOG3x5J2NfnLFc57n+loO126n5IPE/fmMuBkXYMnl1jCEAlPkPJZW9mDIBjYvVePG63M4WfABE3/27YBK1F1/Wxk4qZGP+QlOlyQMM0sYhn2DZCQ4YL3bYjcxZo1VdHw8Xy41E6ZyDmywoUXUgqi7UKvyMWBUQMSfdpijDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645173; c=relaxed/simple;
	bh=LKbmxYlGPfY5S0eKluW3IN/6htSA6yCc4hn6X1Ni4kA=;
	h=Date:To:From:Subject:Message-Id; b=U+dgOjK8hPN/Nf21xhLTqu/crfHgi/VTe/XoEomOIOUBFQStDVFuC5e5Z0dZNNY6COnBuC0IP44clLBUDQBKFqLQbMq6jnN8wb4IRNP4g95Pct2PVymeuJDrRTNXxlYP4/SO14iG8lcBTspBdJDUDmnhWSB9U2RLxL0ao1yrdz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ocy5N0Xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ocy5N0Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BCE9C433F1;
	Thu, 22 Feb 2024 23:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645173;
	bh=LKbmxYlGPfY5S0eKluW3IN/6htSA6yCc4hn6X1Ni4kA=;
	h=Date:To:From:Subject:From;
	b=Ocy5N0XlC0bxSJgtw9tCOeEZt0YlHgGV8ltaCNeXXhnqKoJBknEKYOG3mBq3hRN7y
	 ayQc5xiGAe10gZuMf1rNV9N7Ae7g3m+taWNJetXfL+S97xUpDDMiL9C+qc+r+5dfDS
	 EsLrqkWyVJZP23LRG/SFHx8WQRkEOyqgLbb3RSUc=
Date: Thu, 22 Feb 2024 15:39:33 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-win_minmax-fix-header-comments.patch removed from -mm tree
Message-Id: <20240222233933.7BCE9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/win_minmax: fix header comments
has been removed from the -mm tree.  Its filename was
     lib-win_minmax-fix-header-comments.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/win_minmax: fix header comments
Date: Sun, 7 Jan 2024 14:01:55 -0800

Don't use "/**" kernel-doc comment marker for non-kernel-doc
comment.

Correct the filename but omit the path since we know where it is
and it could change (but not likely).

Link: https://lkml.kernel.org/r/20240107220155.29013-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/win_minmax.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/win_minmax.h~lib-win_minmax-fix-header-comments
+++ a/include/linux/win_minmax.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
- * lib/minmax.c: windowed min/max tracker by Kathleen Nichols.
+/*
+ * win_minmax.h: windowed min/max tracker by Kathleen Nichols.
  *
  */
 #ifndef MINMAX_H
_

Patches currently in -mm which might be from rdunlap@infradead.org are


