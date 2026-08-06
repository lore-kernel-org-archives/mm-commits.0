Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E3A3B4E8F
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 19:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044531; cv=none; b=AKEMR3m6XKZfLl7KaSPZjmOgiAZ1C0TpS7a746Yozd7KwKkhxrfpPmgrhrCvDsQfNqiaBEI3yvrlNpyOu9bstGxpQtdsjc9JzKIxh124eKiyonVHhc2KdtAb2TZV8vNmTv7twrQiKHk0j5Gpi+jlIjsXWDZ4r9aObYl233XfVDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044531; c=relaxed/simple;
	bh=H2DrN8xDDkgvwcaTqxaX7fDDh2rrdN1b1zANIsroANI=;
	h=Date:To:From:Subject:Message-Id; b=uGWDens6GOxw9IFeWvXPwq6MLvNacKNmFHjB0LeizZsew7uu7Pkl/oDCH8zFSpfedAU93eSeuT2eRH/7A9mkD3o2I0+UoCFxoUrCS9SAeKuPbexQVHrtKy4185jiwlf/LuLuGwDJvn5jxKhAOa0kvFm1INByyMDOmWaQXB6tL74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzmuN5e9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzmuN5e9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D841F000E9;
	Thu,  6 Aug 2026 19:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786044530;
	bh=6G+tPeCE4bNJpqySGXWkav1dfJ+wkv/4qKdXAvfICjo=;
	h=Date:To:From:Subject;
	b=hzmuN5e9D6Key9lpxfxWkVdpCjEK7OqvCtDH/nm3pKBOU3CFNWryitlYgtlW6ZAOr
	 DZVP5BhGE4foO33s1mBLnxlReF74bMUI19vqfyuhkavKbvWlICfMbr9cvOVJ7YvKbK
	 8flklKOAJ16vSjz2/Td5EvE/6m9BzsITT+0rFfNs=
Date: Thu, 06 Aug 2026 12:28:49 -0700
To: mm-commits@vger.kernel.org,debarbos@redhat.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-git-url-for-squashfs.patch added to mm-hotfixes-unstable branch
Message-Id: <20260806192849.E9D841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove git URL for Squashfs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-git-url-for-squashfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-git-url-for-squashfs.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: MAINTAINERS: remove git URL for Squashfs
Date: Thu, 6 Aug 2026 19:19:15 +0100

The squashfs-next.git URL hasn't been updated for many years, and it now
doesn't exist.

So remove it from the MAINTAINERS entry.

Link: https://lore.kernel.org/20260806181916.617881-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Derek Barbosa <debarbos@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-git-url-for-squashfs
+++ a/MAINTAINERS
@@ -25553,7 +25553,6 @@ M:	Phillip Lougher <phillip@squashfs.org
 L:	squashfs-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 W:	http://squashfs.org.uk
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git
 F:	Documentation/filesystems/squashfs.rst
 F:	fs/squashfs/
 
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

maintainers-remove-git-url-for-squashfs.patch

