Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7659254654;
	Sat, 20 Dec 2025 22:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766271542; cv=none; b=GzIZAHfj6e/9Qkb1pBkk5YVNB2xZnNvGRFL+iHEs4fPcWSeVE/Mj4Td0w9c5sFfuTkgNkh7IzKwq5GYS2aUbRPEqH3RZugWtR8X/P/365bfq3ZdCR2P13q7tyUupaQA9aaXO7GLfrsZtY/cCFE6KBkDgRMPO5H2UBKYql5IRjLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766271542; c=relaxed/simple;
	bh=q4oNtkC3wknNN4pJt8OW+tay8jgj9vpsuwNrLHwi1ms=;
	h=Date:To:From:Subject:Message-Id; b=WBLtM2H8lJkyK6+Js3H55Bar946UhObDzA7lUF4XGAL9rUiz3GFJqJ7ck9CuTPKU/YS8VBFdg4WIkLzdGRnDsXQyWgPwdtktDFLLAVDX5Wt625aOZKss4tmOyk/61VsC6BBR0n69QScGh7cuwczpFC3msDPqqMPrfFaPhTRD2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BoAnmKZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BoAnmKZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCBCC4CEF5;
	Sat, 20 Dec 2025 22:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766271542;
	bh=q4oNtkC3wknNN4pJt8OW+tay8jgj9vpsuwNrLHwi1ms=;
	h=Date:To:From:Subject:From;
	b=BoAnmKZZhF5lRfPl25rJHBxzmZgZVIO+dqIoMrlI0ick/y9irBjPVVbFBAHsk9Aeg
	 3nmY8FA9U/JvpbOA/Gy0HtRI8wOppvBPzqY37enRcAhde2ErlT8wV3GSDqX2mHR1bO
	 iCyiHq6mnIP8HiQdq4yPvNOEi4xu5JmpJWlzCKIw=
Date: Sat, 20 Dec 2025 14:59:01 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,elver@google.com,andreyknvl@gmail.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-fix-memory-leak-in-page_owner_stack_fops-release.patch added to mm-hotfixes-unstable branch
Message-Id: <20251220225901.EBCBCC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: fix memory leak in page_owner_stack_fops->release()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_owner-fix-memory-leak-in-page_owner_stack_fops-release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-fix-memory-leak-in-page_owner_stack_fops-release.patch

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
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: mm/page_owner: fix memory leak in page_owner_stack_fops->release()
Date: Fri, 19 Dec 2025 07:42:32 +0000

The page_owner_stack_fops->open() callback invokes seq_open_private(),
therefore its corresponding ->release() callback must call
seq_release_private().  Otherwise it will cause a memory leak of struct
stack_print_ctx.

Link: https://lkml.kernel.org/r/20251219074232.136482-1-ranxiaokai627@163.com
Fixes: 765973a098037 ("mm,page_owner: display all stacks and their count")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marco Elver <elver@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-fix-memory-leak-in-page_owner_stack_fops-release
+++ a/mm/page_owner.c
@@ -952,7 +952,7 @@ static const struct file_operations page
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 
 static int page_owner_threshold_get(void *data, u64 *val)
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

mm-page_owner-fix-memory-leak-in-page_owner_stack_fops-release.patch

