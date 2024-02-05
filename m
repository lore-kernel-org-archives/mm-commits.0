Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115BE482E6
	for <mm-commits@vger.kernel.org>; Mon,  5 Feb 2024 23:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174284; cv=none; b=q4FPpgeXN/mw7E9cccKYw3MeVhtdTUV3d8H0eR7WaRZD4r8LuLUOtsro09JKDeWAAxb5MQbFbRiv8gVDTuKNxdsslXh/FtNXR5I0oUioCYOHNYq5peA6Z6TKuPHxgcw6Y1mU+3pUEcWJ7nGeHzW4T0LCnV6eMunMP0r7ZvZnsR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174284; c=relaxed/simple;
	bh=EMnr92KYB1u4ExE9LpINi5aJBufLkHn+CD7H+ZK/NBs=;
	h=Date:To:From:Subject:Message-Id; b=V53DEpSDgjLkkiKxw85SrtgwJHrQPESbs9yoPHQM3hbmMbD2XF5b1J/wknqCgySpleK4Bf+DpbWvc25ukBTpy99/V9vkrxVKiRDCxBuO1iFRfY8m4/ewxtrMHV/bMnZ0UCVmQNRPxV0FvFa1zWaTiZc3CTwB4E10MhuVfCXyhSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eztCi35R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eztCi35R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653F1C433C7;
	Mon,  5 Feb 2024 23:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707174283;
	bh=EMnr92KYB1u4ExE9LpINi5aJBufLkHn+CD7H+ZK/NBs=;
	h=Date:To:From:Subject:From;
	b=eztCi35RJm03v8Mv4rkM3F0UB+hNqI+HZ3DjW2mEMXIa8RdR0c5yYRjJzy4oQdV1i
	 gHCBMrPCIhASA0XxT9fXYHOfbkrphvhAwnwiBJ3DHBdrsvzb/DCwzIj74m2DSkKXV+
	 K9LnC4bMOvN1e8tWN1Bru6Dy/9F4IVwUgc7A/X3o=
Date: Mon, 05 Feb 2024 15:04:42 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch added to mm-unstable branch
Message-Id: <20240205230443.653F1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: zswap: add zswap selftest file to zswap maintainer entry
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch

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
From: Nhat Pham <nphamcs@gmail.com>
Subject: selftests: zswap: add zswap selftest file to zswap maintainer entry
Date: Mon, 5 Feb 2024 14:56:06 -0800

Patch series "fix and extend zswap kselftests", v3.

Fix a broken zswap kselftest due to cgroup zswap writeback counter
renaming, and add 2 zswap kselftests, one to cover the (z)swapin case, and
another to check that no zswapping happens when the cgroup limit is 0.

Also, add the zswap kselftest file to zswap maintainer entry so that
get_maintainers script can find zswap maintainers.


This patch (of 3):

Make it easier for contributors to find the zswap maintainers when they
update the zswap tests.

Link: https://lkml.kernel.org/r/20240205225608.3083251-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20240205225608.3083251-2-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry
+++ a/MAINTAINERS
@@ -24399,6 +24399,7 @@ F:	include/linux/zpool.h
 F:	include/linux/zswap.h
 F:	mm/zpool.c
 F:	mm/zswap.c
+F:	tools/testing/selftests/cgroup/test_zswap.c
 
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
_

Patches currently in -mm which might be from nphamcs@gmail.com are

selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch

