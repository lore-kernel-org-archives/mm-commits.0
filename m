Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB8D7462
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 23:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745192196; cv=none; b=VDSlRhEh2/l+CVqwOtlTw0blHP/1rHDB8nj4anQb6Dl/nW8cVmEm2ENMByDVTPGlM8MWBgKaAYciW31t6+i5wCg3krtIJc1GuPoha17Tqqpq87644bYuZMXHbtsxcDDJNcBpzRLtd76pxGIPauWl5+zkaFHAWRWzAGFfl32bORg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745192196; c=relaxed/simple;
	bh=s8eelJaaYVTNbAz6hHmvhLYfcu4/iTw/bzUF+/krQjw=;
	h=Date:To:From:Subject:Message-Id; b=FVyB+r9QFtFRJPTYDoqH2TK0yQ1jiPf1pCCEoj4WaXEhVG8eE67lxtHpQ/EBzDDw2J3NEopfxm9xjVQGv9PwHxnKhPwmT6Ci3UIkKjTE/R7GZKLOY20cjbS/fd+UiRRCpEuWbQCrgWjbf3UgI53SwpheiQBrfj90w61/VC+nJ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WYYz+IYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WYYz+IYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AE9C4CEE2;
	Sun, 20 Apr 2025 23:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745192195;
	bh=s8eelJaaYVTNbAz6hHmvhLYfcu4/iTw/bzUF+/krQjw=;
	h=Date:To:From:Subject:From;
	b=WYYz+IYbQNFSPwHYsd1ENYf/zCIhP/PIkhPkFnOvhPncK2icxyk7249iXfqY/biFr
	 Ia7Q9p2VPO54SNtehvnUbk25zs1DLN4K4yWfrBYAPd2OatZ77MG7L9kUzZ+uWeT6qM
	 Vq8irecpqep3sXUKdNurc+KOWACj+tRF11ImJYgU=
Date: Sun, 20 Apr 2025 16:36:34 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-fix-spelling-mistake-crahskernel-crashkernel.patch added to mm-nonmm-unstable branch
Message-Id: <20250420233635.98AE9C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: fix spelling mistake "crahskernel" -> "crashkernel"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-fix-spelling-mistake-crahskernel-crashkernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-fix-spelling-mistake-crahskernel-crashkernel.patch

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

crash-fix-spelling-mistake-crahskernel-crashkernel.patch

