Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD53522A
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 00:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745799096; cv=none; b=esdJV8tasAZuhd9bRvhbmmC184RwCH3Twqqc6mlvDm2rVwqEom9o5hGgrWvsb2Ir5NzmJovZXuN29RZOTrPY2otki41X18b7KOPcsyRzJN4aPn4efI7aC6hwTjeCPu0N/bPli8wvxtJ7/U/a9893kHUl8NCCmhGy9BUALMO0if0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745799096; c=relaxed/simple;
	bh=ktMlH3sO4m49XJFBQo5Q85VmTnhzYS88UQQyANA9Zlg=;
	h=Date:To:From:Subject:Message-Id; b=F3Nm06LVgmJRK62VjOVKH49ARQrhxXvaX3qILSkgZL+12g93yN8XcFn9H0lRt8c/9SVCjFyuCpF+lVL4f4dD3zInAoObpKUkwVwEe7JuXjHk3OxOdSJF67p9rdj0BR3vs9WSPVeEhLrFtYPsfahNKh7Q7FXUFZd5en6tMlfziUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YoT2Cma8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YoT2Cma8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07274C4CEEF;
	Mon, 28 Apr 2025 00:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745799094;
	bh=ktMlH3sO4m49XJFBQo5Q85VmTnhzYS88UQQyANA9Zlg=;
	h=Date:To:From:Subject:From;
	b=YoT2Cma80ADjrKB5+j30V7C7D7D5eviT/FDTGfbFLliAJ6AeMMMfqVIhZ6N5xfrT1
	 P8fsMcAf3pZaF1PIxr+P1ytkdvNDnm6PLbx+x74pJGEDgG7jRgul0IW1wBTvkCZ2el
	 /p81qmkabJwQaYCqtxHvj3AvtebEYXyaQWrkxdb8=
Date: Sun, 27 Apr 2025 17:11:33 -0700
To: mm-commits@vger.kernel.org,hank20010209@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-macro-init_pasid.patch added to mm-unstable branch
Message-Id: <20250428001134.07274C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove unused macro INIT_PASID
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unused-macro-init_pasid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-macro-init_pasid.patch

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
From: Cheng-Han Wu <hank20010209@gmail.com>
Subject: mm: remove unused macro INIT_PASID
Date: Sun, 27 Apr 2025 22:50:04 +0800

The macro INIT_PASID was originally used by mm_init_pasid.  However, since
commit a6cbd44093ef ("kernel/fork: Initialize mm's PASID"), mm_init_pasid
has been removed.  Therefore, INIT_PASID is no longer needed and is
removed.

Link: https://lkml.kernel.org/r/20250427145004.13049-1-hank20010209@gmail.com
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm_types.h~mm-remove-unused-macro-init_pasid
+++ a/include/linux/mm_types.h
@@ -28,7 +28,6 @@
 #endif
 #define AT_VECTOR_SIZE (2*(AT_VECTOR_SIZE_ARCH + AT_VECTOR_SIZE_BASE + 1))
 
-#define INIT_PASID	0
 
 struct address_space;
 struct mem_cgroup;
_

Patches currently in -mm which might be from hank20010209@gmail.com are

mm-remove-unused-macro-init_pasid.patch

