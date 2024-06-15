Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBD7168C4
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473172; cv=none; b=Y/3oKsIt/mKIjvxBudtrMAp45RBPJuZqh1gC/0diMR229j2AVvC5V36bT4dMGEuBV6L8sgohfQlcRXfE2lxiG66SlwBh0D8dx12Cr9WvQvBK/Ce3iJaJCDZKjy/A5JTbrUQ7CS/k89ZN74EOClGW2BNXBAyNPrUk+u2++N+rrqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473172; c=relaxed/simple;
	bh=SRuvqEw2+DzGGGHiyNA97U5jiz/2noc0N6sng1YZTk0=;
	h=Date:To:From:Subject:Message-Id; b=cRiGp6xL/5W+3S+4nFCG0NPvdZXQC0IpmdLVlW9CfrvOS7Vc9X9xhH28c/NWGhm9Ta6qc26wnJuD4/gPpEV/FyI6FSH6EstH6wVwq4ZNHMMLF4KtVhCqRGLYx40W0y3t+WqWDOBjFPkJrn3XNRlJbf6Polc3jZ15DpCB2eJVMps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dIN3X3oW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dIN3X3oW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECADC116B1;
	Sat, 15 Jun 2024 17:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473171;
	bh=SRuvqEw2+DzGGGHiyNA97U5jiz/2noc0N6sng1YZTk0=;
	h=Date:To:From:Subject:From;
	b=dIN3X3oWVpzIJHmo5QeHX3sbpxXDZeEjP/bLiHxUobtHL/aPu5pWqcJJws7jGsehQ
	 JbrUouuXlq7mEODBxh3XXZCvhSJ/q+fjsNAHNzw4G/93nGso/RK1u37LLE4qoUTVEf
	 bOQhgJZ3sKxset8EHxJ3d7TNZCekSEFJYBXNFEbk=
Date: Sat, 15 Jun 2024 10:39:30 -0700
To: mm-commits@vger.kernel.org,dvyukov@google.com,andreyknvl@gmail.com,nogikh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kcov-dont-lose-track-of-remote-references-during-softirqs-v2.patch removed from -mm tree
Message-Id: <20240615173931.8ECADC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov-dont-lose-track-of-remote-references-during-softirqs-v2
has been removed from the -mm tree.  Its filename was
     kcov-dont-lose-track-of-remote-references-during-softirqs-v2.patch

This patch was dropped because it was folded into kcov-dont-lose-track-of-remote-references-during-softirqs.patch

------------------------------------------------------
From: Aleksandr Nogikh <nogikh@google.com>
Subject: kcov-dont-lose-track-of-remote-references-during-softirqs-v2
Date: Fri, 14 Jun 2024 19:12:21 +0200

replace WRITE_ONCE() with an ordinary assignment

Link: https://lkml.kernel.org/r/20240614171221.2837584-1-nogikh@google.com
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kcov.c~kcov-dont-lose-track-of-remote-references-during-softirqs-v2
+++ a/kernel/kcov.c
@@ -632,7 +632,7 @@ static int kcov_ioctl_locked(struct kcov
 			return -EINVAL;
 		kcov->mode = mode;
 		t->kcov = kcov;
-		WRITE_ONCE(t->kcov_mode, KCOV_MODE_REMOTE);
+	        t->kcov_mode = KCOV_MODE_REMOTE;
 		kcov->t = t;
 		kcov->remote = true;
 		kcov->remote_size = remote_arg->area_size;
_

Patches currently in -mm which might be from nogikh@google.com are

kcov-dont-lose-track-of-remote-references-during-softirqs.patch

