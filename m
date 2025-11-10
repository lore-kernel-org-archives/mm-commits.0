Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880821A2C25
	for <mm-commits@vger.kernel.org>; Mon, 10 Nov 2025 05:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752044; cv=none; b=nFNRxKfaBR9bSH/TRebeWsMhG1/2zmDR+QPZdf8Pca2gEjYRjIWTg/PzPwfZ9y4LnW+sLP4KFBCrMZdSfCueZIBqOVAeFHk8I80YmpEgGM8oPMTaQiR0xy+XcWtm/Upn9Ru9qtl4PpFLCP22EYyFq/EfvWBMEueU2J4jsbTnkWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752044; c=relaxed/simple;
	bh=7Ux849wS9rsTU26DNQMwy9eE+7pZ4nsrcQu9slFZJpY=;
	h=Date:To:From:Subject:Message-Id; b=Sc7tT58eIe4EgiQwjUpzlMfcGqyiCdY2Za2Xy05X8nvZG+UznFqgnrIjqCSrrWBGC1PqcLihBuqLjFm2PDhKQ9Ex+DumzTB9zXOswjXnL+SeEGUa+VPHT2aBe7lY2Wk/07l+As+basMldWUl6t0V0D5iKoB2B8xXWNGl09ap83U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w1BXMZOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w1BXMZOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4F2C4CEFB;
	Mon, 10 Nov 2025 05:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752044;
	bh=7Ux849wS9rsTU26DNQMwy9eE+7pZ4nsrcQu9slFZJpY=;
	h=Date:To:From:Subject:From;
	b=w1BXMZOEkQm4Ig1BlEIRcQN7AQgdkEWol08txPBqZ225vNvkpZqXUwrCgdkTouoQB
	 X4+9ov5nAhfWm6cqM8or3BJA4Mn2htlyWIsc5h9LtRqS418Rwh/yO3E5qvS90UPXcn
	 AJaZkCr3661yvwZMxXGswqJUlNQh6SNEzgdXQy4g=
Date: Sun, 09 Nov 2025 21:20:43 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,roman.gushchin@linux.dev,nphamcs@gmail.com,minchan@kernel.org,mhocko@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,bhe@redhat.com,baohua@kernel.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-chris-and-kairui-as-the-swap-maintainer.patch removed from -mm tree
Message-Id: <20251110052043.EE4F2C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Chris and Kairui as the swap maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-chris-and-kairui-as-the-swap-maintainer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chris Li <chrisl@kernel.org>
Subject: MAINTAINERS: add Chris and Kairui as the swap maintainer
Date: Sun, 02 Nov 2025 07:11:07 -0800

We have been collaborating on a systematic effort to clean up and improve
the Linux swap system, and might as well take responsibility for it.

Link: https://lkml.kernel.org/r/20251102-swap-m-v1-1-582f275d5bce@kernel.org
Signed-off-by: Chris Li <chrisl@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-chris-and-kairui-as-the-swap-maintainer
+++ a/MAINTAINERS
@@ -16498,12 +16498,12 @@ F:	mm/secretmem.c
 
 MEMORY MANAGEMENT - SWAP
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Chris Li <chrisl@kernel.org>
+M:	Kairui Song <kasong@tencent.com>
 R:	Kemeng Shi <shikemeng@huaweicloud.com>
-R:	Kairui Song <kasong@tencent.com>
 R:	Nhat Pham <nphamcs@gmail.com>
 R:	Baoquan He <bhe@redhat.com>
 R:	Barry Song <baohua@kernel.org>
-R:	Chris Li <chrisl@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
_

Patches currently in -mm which might be from chrisl@kernel.org are


