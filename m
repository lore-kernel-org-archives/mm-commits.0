Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7831CD10
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644471; cv=none; b=vCkk6mDg1e45lhrvaoz/C1uNDhiykXdAGXBLnM/UaqD5WYZXEOV3ezX1F7ySBbKue+0MDIqbT0k6erEWB23suHKxpQ5ljONptcnGrsj2mqhCTrPGjQ3XKhZfor8nRBxsWjJ1e6PWNI0AIRNFMP3/85shEJ/pbfeWHM1nOoPEHbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644471; c=relaxed/simple;
	bh=fnYVTYjJ8R9gHeRh+FKKTR6iCbU2pK135mYmBc5HbV8=;
	h=Date:To:From:Subject:Message-Id; b=qLaX4i14klMSZIBqfx0mHPow0GJGeNqk4E5xgARsUcq16t+MB/Gcrqi5rZxba3EreBiue5tve0IEp+bUXby0huNIRZBxWRZTGVhCbSksEVnxHnFVBz0ATHnHQZXoKPgimVrewD4shk4bjD2B5N9Sy5YDMDGZjV4eB8WU+s/DPLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZDAwHkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZDAwHkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE31AC433C7;
	Thu, 22 Feb 2024 23:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644470;
	bh=fnYVTYjJ8R9gHeRh+FKKTR6iCbU2pK135mYmBc5HbV8=;
	h=Date:To:From:Subject:From;
	b=eZDAwHkcFHvsv/h+tvWIT9/IKCCwxBtBnurShOkQ1HPggF5bie3A/zwkVFGlkBE9Y
	 t6iX2zIxDOW/1Ux+d4rdWZTO4rs3s8Av/Lr2R6QhhBZr1Usu7iXFQbO0fxl5CAxqym
	 3HUOtbouph9soar3KVoDzLtHUMJqsO6P8p+o2BYg=
Date: Thu, 22 Feb 2024 15:27:50 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tj@kernel.org,shuah@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,lizefan.x@bytedance.com,hannes@cmpxchg.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch removed from -mm tree
Message-Id: <20240222232750.BE31AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: zswap: add zswap selftest file to zswap maintainer entry
has been removed from the -mm tree.  Its filename was
     selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -24412,6 +24412,7 @@ F:	include/linux/zpool.h
 F:	include/linux/zswap.h
 F:	mm/zpool.c
 F:	mm/zswap.c
+F:	tools/testing/selftests/cgroup/test_zswap.c
 
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch

