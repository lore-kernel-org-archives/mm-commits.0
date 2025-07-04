Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6833B33991
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 00:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751589926; cv=none; b=HuAVh3tABjSipw2iAcHvzLfAU9XSsdrPNxNx7q7W/1P2y0bQYV6ts5Z+RUOEbBLBCb1aavRlxE0PJZH1rU/v99QPuWcICtzSGIEYYFvrRcjsT5HUuwcMPdZbumrGkT21Das6MaQJ3C7CdTuAoMTVzwHDb/7qbioSyOSWxPQt44c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751589926; c=relaxed/simple;
	bh=HV7sDmAu9JaIp6Lkxczq8r9u/MQqo/7XSod4D36SI3U=;
	h=Date:To:From:Subject:Message-Id; b=O8IFUsbqqasAWhCX/MhIFcuV3d9fLICbE9eXgfLl379VpeIVOVJBJpxfuvWWMevB7M31gLJxWCJ2/mDakusNiPYs/GxyNOOdKBKWYn6q1nL3LJcioQIxF5qkHaGta2u33CTzKDzXdY3wn08Ej+w/mkv8QYQeTbYhW2JdRZCiGR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rb/+O5ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rb/+O5ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E449FC4CEE3;
	Fri,  4 Jul 2025 00:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751589926;
	bh=HV7sDmAu9JaIp6Lkxczq8r9u/MQqo/7XSod4D36SI3U=;
	h=Date:To:From:Subject:From;
	b=Rb/+O5mlNflnJYOnpPjQLmKOM6o4eEbB+jf8t6bTExWgpWgWRW9AmH9x5V8ezdQTb
	 VkNO2mXJM6vMlpf6MuY6JG47k9YKoxgzJ1Z0SpTyCBqS+sKi3MlagsIlYy+c4K/gAx
	 bQ0jhk8ZDa3epCd3+nqkAfTdO+j3dWygERkN95C0=
Date: Thu, 03 Jul 2025 17:45:25 -0700
To: mm-commits@vger.kernel.org,liuqiye2025@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-spelling-issue-in-swaph.patch added to mm-unstable branch
Message-Id: <20250704004525.E449FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix spelling issue in swap.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-spelling-issue-in-swaph.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-spelling-issue-in-swaph.patch

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
From: Xuanye Liu <liuqiye2025@163.com>
Subject: mm: fix spelling issue in swap.h
Date: Wed, 2 Jul 2025 15:12:35 +0800

recliam -> reclaim

Link: https://lkml.kernel.org/r/20250702071235.212794-1-liuqiye2025@163.com
Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-fix-spelling-issue-in-swaph
+++ a/include/linux/swap.h
@@ -415,7 +415,7 @@ extern unsigned long try_to_free_pages(s
 #define MIN_SWAPPINESS 0
 #define MAX_SWAPPINESS 200
 
-/* Just recliam from anon folios in proactive memory reclaim */
+/* Just reclaim from anon folios in proactive memory reclaim */
 #define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
 
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
_

Patches currently in -mm which might be from liuqiye2025@163.com are

mm-fix-spelling-issue-in-swaph.patch

