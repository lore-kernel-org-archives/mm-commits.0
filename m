Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A2034405F
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762974232; cv=none; b=JpqRiUAIOwxhqm0OUjevZYyuS5QrkMysan8q3U9m8cMv1sF3et2fUNvJZWjmyUyYHHoIm7Nfk42wP/RVLO/9aIsciIWnW+C6n/9aCMiXJUxBmrDYtT6VTHvOxSplBlGeB2abKbcMt4I2Zr642BJvcvBTUrFa8tPe/MxYA/U5d3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762974232; c=relaxed/simple;
	bh=NI/BuCslGv5NwEIZGKH7a+9iRPSL+NLzN9qky7/j5WU=;
	h=Date:To:From:Subject:Message-Id; b=MPInlqq77mQsRf+BCeZamkOCKxHamhu7AXDqJAKgJTpCyQsZUVy/zeB4o2Ei0ebE2xvCUWf6a17mLzxRmmN8Mteq+AzMdUBgs1Zb0kpqOaR+z3vlKxJjVEZvaDG48jfmuodB+mGYIUhrXxoEEC0PY+HdMS0JEi4CxO/C0YFPqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oWWLBQYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oWWLBQYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EA0C19425;
	Wed, 12 Nov 2025 19:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762974232;
	bh=NI/BuCslGv5NwEIZGKH7a+9iRPSL+NLzN9qky7/j5WU=;
	h=Date:To:From:Subject:From;
	b=oWWLBQYsLrZ0VaEKxuR7tLMiutV4uoqqbdIspJTEObO4Oq+mLWW+fcMvLIGFmVu9X
	 5y0ubaz0ZTQ3RtGhwuRDq9st3y37eNX+VxKwD9j7Nv9z7RxqVpmWmWxbJRV+BFGJ0r
	 eHpfXkURz9FprFoP69l/S7pzXdM8fVLlHxXlhqsc=
Date: Wed, 12 Nov 2025 11:03:48 -0800
To: mm-commits@vger.kernel.org,sumit.semwal@linaro.org,gustavo@padovan.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-myself-from-sync-framework.patch added to mm-nonmm-unstable branch
Message-Id: <20251112190351.D5EA0C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove Gustavo from sync framework
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-remove-myself-from-sync-framework.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-myself-from-sync-framework.patch

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
From: Gustavo Padovan <gustavo@padovan.org>
Subject: MAINTAINERS: remove Gustavo from sync framework
Date: Wed, 12 Nov 2025 10:43:30 -0300

I haven't been involved in the work anymore for some time.  It is only
fair that I remove myself from it and let other continue to take care of
it.

Link: https://lkml.kernel.org/r/20251112134330.64130-1-gustavo.padovan@collabora.com
Signed-off-by: Gustavo Padovan <gustavo@padovan.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-myself-from-sync-framework
+++ a/MAINTAINERS
@@ -24846,7 +24846,6 @@ F:	drivers/regulator/sy8106a-regulator.c
 
 SYNC FILE FRAMEWORK
 M:	Sumit Semwal <sumit.semwal@linaro.org>
-R:	Gustavo Padovan <gustavo@padovan.org>
 L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 S:	Maintained
_

Patches currently in -mm which might be from gustavo@padovan.org are

maintainers-remove-myself-from-sync-framework.patch

