Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F859628
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068923; cv=none; b=G21+WCZh0EvnU1M7SFLDPZXBWtQR13OGyM86m3inoLf9O5u2+sDaeagSicoFqY2oF9xUA6oKDgU3AT9J0lsQA2R+RQPSIghhW4nKZ8mtKHRQQihCeiMU+9O1BL/T10CnxEDU+9aPes7FLeo0wxdeCwZZPjKY7L3MGkmvW1UXSiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068923; c=relaxed/simple;
	bh=vCdH4cz5pc4VAMWT6GG39/wSNZ0d+uR9/It76c1tYKA=;
	h=Date:To:From:Subject:Message-Id; b=mrMYMMbs/16sb3KMWkAe/zdFGlXoh8/BNLySQRibZLxAwnPswTmALHKRLcamdz+qPcbLf/m3qgzvkWsshVmLK4kw6vELxdB95/ZsozBNkworP69O5mRkBZe2sddM4SWFmNwo3vm/kDvFDrmZ6IL8XpqudCJtI6RTZ/i4N8zHRMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=REwVsIn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="REwVsIn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE8C433C7;
	Fri, 22 Mar 2024 00:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711068922;
	bh=vCdH4cz5pc4VAMWT6GG39/wSNZ0d+uR9/It76c1tYKA=;
	h=Date:To:From:Subject:From;
	b=REwVsIn9f9cb0HTo4Z0X7CITHbh361CuS0BeQ7CwYWeyuyFtqSpr6utkOKu7rTRHd
	 2xyNW3VjOPCxWA7zyCf8GbIUifEX7Lo/VeV0ccKGna42rHz6VQwaXl1rKShJUS2sgD
	 W0kY/cPoOEWm2coX5jU5QIsHqxKQfEWnlN5oNCdM=
Date: Thu, 21 Mar 2024 17:55:22 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-disable-kasan-instrumentation-in-kmemleak.patch added to mm-unstable branch
Message-Id: <20240322005522.A8EE8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: disable KASAN instrumentation in kmemleak
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-disable-kasan-instrumentation-in-kmemleak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-disable-kasan-instrumentation-in-kmemleak.patch

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
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: disable KASAN instrumentation in kmemleak
Date: Thu, 7 Mar 2024 14:05:48 -0500

Kmemleak ia a memory leak checker.  KASAN is also a memory checker but it
focuses more on finding out-of-bounds and use-after-free bugs.  Since
kmemleak is inherently slow especially on systems with large number of
CPUs, adding KASAN instrumentation will make it slower even more.  As
kmemleak is not for production use, the utility of enabling KASAN there is
questionable.

This patch disables KASAN instrumentation for configurations that enable
both of them to slightly reduce performance overhead.

Link: https://lkml.kernel.org/r/20240307190548.963626-3-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Makefile~mm-kmemleak-disable-kasan-instrumentation-in-kmemleak
+++ a/mm/Makefile
@@ -5,6 +5,7 @@
 
 KASAN_SANITIZE_slab_common.o := n
 KASAN_SANITIZE_slub.o := n
+KASAN_SANITIZE_kmemleak.o := n
 KCSAN_SANITIZE_kmemleak.o := n
 
 # These produce frequent data race reports: most of them are due to races on
_

Patches currently in -mm which might be from longman@redhat.com are

mm-kmemleak-compact-kmemleak_object-further.patch
mm-kmemleak-disable-kasan-instrumentation-in-kmemleak.patch

