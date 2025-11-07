Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17993148850
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 22:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762556161; cv=none; b=XQlkDfeCG85wMIC8OTx9pVmp8UAmx0CgDix+zno8YHsZ2VxV6JAnPRQ2Xl4DgibIMnXFcPKSyh4jMfZj9q9Ks9a3gvqre7ww0moDcMngtAEMR4lu9oRUclWFCH/HkVfCc9cOfuHJH4e82mSYIAd5Xt64gErndu6Etuk0/a1FnkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762556161; c=relaxed/simple;
	bh=/u6B0cM+HUj5NgbvYxznCBlWLxeXVG1Uuio3sCOoplM=;
	h=Date:To:From:Subject:Message-Id; b=T0gzi0KMS/buzF675FrTZ9zVdBqlRVRn0Ts4o7PK2UsYlG76PSPAsHOdrM9uJNRUqpGkqiuijzvN4DZbQWkf/h6JkuUSjsIKnE/D0YDYFTuZdbM7v5yJpovQjRFU5xy83gPdl+84QLpPLkpKg+1vKnpcN5izxabexqg0FaDzIf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T2LPYhPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T2LPYhPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756A7C4CEF7;
	Fri,  7 Nov 2025 22:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762556160;
	bh=/u6B0cM+HUj5NgbvYxznCBlWLxeXVG1Uuio3sCOoplM=;
	h=Date:To:From:Subject:From;
	b=T2LPYhPfmSebnkXUqhQnICJ7j9xUkN/tsoE5t+aAbl8U7VmAqg/Z3noks20TNf6KX
	 z/AnoElC+rQi3BwoRiMw4fCkZnK7TQyr7tE4UiWB1zc9Uic1Inz2blllKbsSJNuJCe
	 UNPbrpPEJlWe2j9SQVC9lDRpbRiy9kT3XJifijFE=
Date: Fri, 07 Nov 2025 14:55:59 -0800
To: mm-commits@vger.kernel.org,slava@dubeyko.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-nilfs2-entry.patch added to mm-nonmm-unstable branch
Message-Id: <20251107225600.756A7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update nilfs2 entry
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-update-nilfs2-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-nilfs2-entry.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: MAINTAINERS: update nilfs2 entry
Date: Sat, 8 Nov 2025 00:32:49 +0900

Viacheslav has kindly offered to help with the maintenance of nilfs2 by
upstreaming patches, similar to the HFS/HFS+ tree.  I've accepted his
offer, and will therefore add him as a co-maintainer and switch the
project's git tree for that role.

At the same time, change the outdated status field to Maintained to
reflect the current state.

Link: https://lkml.kernel.org/r/20251107153530.9023-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Acked-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-update-nilfs2-entry
+++ a/MAINTAINERS
@@ -18275,10 +18275,11 @@ F:	net/sunrpc/
 
 NILFS2 FILESYSTEM
 M:	Ryusuke Konishi <konishi.ryusuke@gmail.com>
+M:	Viacheslav Dubeyko <slava@dubeyko.com>
 L:	linux-nilfs@vger.kernel.org
-S:	Supported
+S:	Maintained
 W:	https://nilfs.sourceforge.io/
-T:	git https://github.com/konis/nilfs2.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
 F:	Documentation/filesystems/nilfs2.rst
 F:	fs/nilfs2/
 F:	include/trace/events/nilfs2.h
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

maintainers-update-nilfs2-entry.patch

