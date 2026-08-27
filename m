Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C330D1ABEDE;
	Thu, 27 Aug 2026 02:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796176; cv=none; b=ppu4INu7VXdk4Ir5jNZ54caNerJrkpmKxgIhqFQ8xOOAMI5RTw7RAD6vxVDnWWmPBaCwfT42kcXr1niMwvKOk/wBWZVQlVbUUC9iUdOXIrnPFyQ5iNn4vd3pdgW7G8ctTiLrRPJCBhnwGst5RnCMEmdwpd3NlEPx81NFGZEbc8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796176; c=relaxed/simple;
	bh=2Y3wHWGSJgk4/PsN6xJagMe6gGZvMijyJyQYtpUh9u8=;
	h=Date:To:From:Subject:Message-Id; b=YgeZorelSWmjlpGKDeQJgB3NFcZnR0pOFq3vc+57PlWGmn5kUH/LItQJt0xflYb/08Rghthcyx5CfZi3BsuBR76QyTG4KCZcpN4p9QAWHkuIyl1RRVcvjXRZITFZvKz2DDKvopnj/BynnpBGEV6/j+RU+QMBeORyIMvxKJ6tjg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NdsYVhU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NdsYVhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3ED1F000E9;
	Thu, 27 Aug 2026 02:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787796174;
	bh=m3jj90jfuXHNsTd4F9jG4VMGJ3o+E1cT8bTUYQKrA+A=;
	h=Date:To:From:Subject;
	b=1NdsYVhU/j4JGif2yUfVEequccLbSplF8aKPOQEUxo1eXBQlK/CKtjb4iLvYr71od
	 GqMu3bl/CZmM7qXM8nbhZfQakRKRo8ENo1PGYeDhTokLQEI04+jLJQwoX/mqOzZcgO
	 vErYUqw6yHTQ7fR+ogTt6F/TEGJJdLRqcWReaJsU=
Date: Wed, 26 Aug 2026 19:02:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,dmoulding@me.com,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-fix-early-boot-crash-with-bare-hostname-parameter.patch added to mm-nonmm-unstable branch
Message-Id: <20260827020254.2D3ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: Fix early boot crash with bare hostname parameter
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-fix-early-boot-crash-with-bare-hostname-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-fix-early-boot-crash-with-bare-hostname-parameter.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Thorsten Blum <blum@kernel.org>
Subject: init: Fix early boot crash with bare hostname parameter
Date: Wed, 26 Aug 2026 12:09:03 +0200

When a bare hostname parameter is specified on the kernel command line
without the '=' separator, early parameter parsing passes NULL to
early_hostname(), which dereferences it in strscpy() and can crash the
system during early boot.

Reject NULL values in early_hostname() and return -EINVAL instead.

Link: https://lore.kernel.org/20260826100904.296151-2-blum@kernel.org
Fixes: 5a704629f2c1 ("init: add "hostname" kernel parameter")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Cc: Dan Moulding <dmoulding@me.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/version.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/init/version.c~init-fix-early-boot-crash-with-bare-hostname-parameter
+++ a/init/version.c
@@ -23,6 +23,9 @@ static int __init early_hostname(char *a
 	size_t maxlen  = bufsize - 1;
 	ssize_t arglen;
 
+	if (!arg)
+		return -EINVAL;
+
 	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
 	if (arglen < 0) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
_

Patches currently in -mm which might be from blum@kernel.org are

maintainers-mailmap-update-entries-for-thorsten-blum.patch
init-fix-early-boot-crash-with-bare-hostname-parameter.patch

