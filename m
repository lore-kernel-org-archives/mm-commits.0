Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB0B27CB35
	for <mm-commits@vger.kernel.org>; Thu, 16 Apr 2026 05:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776318585; cv=none; b=XGcnomDbz3HxHLkb62X+j1N4hgY0cjOmnpM4QCtxYIHkx9DPbkwzgs5WIKwjYpm8wHQ7VGUsy2g6nNxAk+B6R0J+XCYPfEAaoRBSU9wiDHCLzQWaEwwx+a2x2hmV9NSKb8FFGKDQJUEYeq6UChUH29dAb1eoFIs0QJZGFviBIT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776318585; c=relaxed/simple;
	bh=s71ZjFiPz3d/xNbkqcQoiCp0jWFWecy9rRTVSPdhhII=;
	h=Date:To:From:Subject:Message-Id; b=eiOeueZnZT7g0zNLUW0OBFHaQbr+tLrC+EP9tqofR1bmg0TO0OizwWYmqy5C6gbkPuaLLE6kLgb9Z0H0cHrS592LzGvsIB2zoJeG4gel5Vv9RwyYYebPeEPWbsiUNrlzfVBIAzjzxZ7cjl97lRy3xVuUGy+NWrJp74e7GuHaqVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hHXeHKd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hHXeHKd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBB7C2BCAF;
	Thu, 16 Apr 2026 05:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776318584;
	bh=s71ZjFiPz3d/xNbkqcQoiCp0jWFWecy9rRTVSPdhhII=;
	h=Date:To:From:Subject:From;
	b=hHXeHKd71PtSBwcmsX69hxjyy4f2ukXkT9w49Ws/qwgsZkzI443KklNFYaNXI5cj2
	 svXu5p6h7D+ovPx34sf5izBOEcueRIuZJGeyKsdTBsq0BaYIKd148ZrbXF6I73kHJN
	 IxtSprw0pDaKutB3gxBnblEHUUEZ0qA9RuSiuHAA=
Date: Wed, 15 Apr 2026 22:49:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-page-cache-reviewer-fix.patch added to mm-unstable branch
Message-Id: <20260416054943.EFBB7C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maintainers-add-page-cache-reviewer-fix
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-page-cache-reviewer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-page-cache-reviewer-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-add-page-cache-reviewer-fix
Date: Wed Apr 15 10:47:13 PM PDT 2026

add linux-mm@kvack.org

Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-page-cache-reviewer-fix
+++ a/MAINTAINERS
@@ -19966,6 +19966,7 @@ PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
 R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
+L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.infradead.org/users/willy/pagecache.git
 F:	Documentation/filesystems/locking.rst
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-document-protectionkey-in-smaps-fix.patch
docs-proc-document-protectionkey-in-smaps-fix-fix.patch
maintainers-add-page-cache-reviewer-fix.patch

