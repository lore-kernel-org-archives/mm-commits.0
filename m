Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD79D2EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011368; cv=none; b=R+VwtYpfBZpBx50Df1x+jTWZksbYhEKV6/MO+dYbSkDmfzLzBI4Xbo7R1tZF6anRMpypNwrx05abQFa9JIgAD2k5aEsxFvpj0Y5gATBeoyiaJTNY3OMwGfXuKo58YOQvVosz7Csv6THz+K4U+h/40AIc64jwMm9c3KJJIP887D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011368; c=relaxed/simple;
	bh=xqpFEubyqoBqYhxiZZp/1iqve8VPdFFEHYCxMPFnBm8=;
	h=Date:To:From:Subject:Message-Id; b=FO8JhvUQoD9waHMpNUC69YYo/25Oj3g1eYvaPWanPZAniy7d6gBd30eD31ojk4V3OxRMgOwQ9ko+fa5oAy/OevlHkOwQ/tB8fvHU3HMc001GCZ7rLQBeHZWwINfT6Ut7v79Eq2n4FE9lTak8T8iv08JCFRlEi0q81xK5CfZHRzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lRK1M8i2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lRK1M8i2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36B1C4CEE4;
	Mon, 12 May 2025 00:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011368;
	bh=xqpFEubyqoBqYhxiZZp/1iqve8VPdFFEHYCxMPFnBm8=;
	h=Date:To:From:Subject:From;
	b=lRK1M8i2W5n3U14Pthm3TIQwp5zrEawgrCBlpB9iw8szJEdxuK8Lvsq3lS/Uh8mp5
	 HQ7m68s/MwkwA5X9c8WEOc1+mWCtCVmSgonQRiePerVQZnqIu/tCrvYkLPtuBA6ZFs
	 7cXIx9Itp3I6jGa0xkCXft+CPnJG0qtS2rcxOsxI=
Date: Sun, 11 May 2025 17:56:08 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-fix-spelling-mistake-crahskernel-crashkernel.patch removed from -mm tree
Message-Id: <20250512005608.B36B1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: fix spelling mistake "crahskernel" -> "crashkernel"
has been removed from the -mm tree.  Its filename was
     crash-fix-spelling-mistake-crahskernel-crashkernel.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: crash: fix spelling mistake "crahskernel" -> "crashkernel"
Date: Fri, 18 Apr 2025 13:03:31 +0100

There is a spelling mistake in a pr_warn message. Fix it.

Link: https://lkml.kernel.org/r/20250418120331.535086-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/crash_reserve.c~crash-fix-spelling-mistake-crahskernel-crashkernel
+++ a/kernel/crash_reserve.c
@@ -131,7 +131,7 @@ static int __init parse_crashkernel_mem(
 			cur++;
 			*crash_base = memparse(cur, &tmp);
 			if (cur == tmp) {
-				pr_warn("crahskernel: Memory value expected after '@'\n");
+				pr_warn("crashkernel: Memory value expected after '@'\n");
 				return -EINVAL;
 			}
 		}
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


