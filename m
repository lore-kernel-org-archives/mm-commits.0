Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE2F1E52D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 18:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742237902; cv=none; b=g3sIJEl4k/jxvAiL3Tn1JfOBsSupNMe/XbHnVOxa5ahwfmSpSQYtfWO6/qZhg1JRdf8gYIRJS4wVjtxw/ZS9MPyh9wwOycBmdQxD3KRnoqxdsWzF3+4+hBI8NvOGNqFRCLtstk3CEC4JTC2kugDu5m5tbPCGO7jvZKhbtI6ryDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742237902; c=relaxed/simple;
	bh=1zDMJ5sXSTzlQtnDsbbLxGVS1Ls/ly5O5RU3JUrNiQQ=;
	h=Date:To:From:Subject:Message-Id; b=HGoJStrXilLZvtMNslkHUf0r+A3QMmhcXpQthWsKhRleXoNvVGZt8IxX1aQkE17w8TOCAwATyY2YLIP3Ai3GsWzO5TgvvwVuqiXuRT5J5ZRPvqX7V8BIMOojW90o8596M43hNP9mO0NwGz+Mn5jGEymz/jb3c+IxUnm9teL5Bb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bxRC9KQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bxRC9KQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6521C4CEE3;
	Mon, 17 Mar 2025 18:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742237901;
	bh=1zDMJ5sXSTzlQtnDsbbLxGVS1Ls/ly5O5RU3JUrNiQQ=;
	h=Date:To:From:Subject:From;
	b=bxRC9KQAbf2piqmvsaXKw9mMEr+Jt/SsACD3juaTgMParrFGzhHbailJ8dbndgzva
	 A3NVmCgXFIlQjr5uJLTPpixMI7Vlgfo9vSXwABWisl5bqral4r7FC7ukYDgrkx4roC
	 tuPnIJsv4sW3C0ITyAfUncEl6id9HRxZm248pov0=
Date: Mon, 17 Mar 2025 11:58:20 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-replace-open-coded-variant-of-define_res.patch added to mm-nonmm-unstable branch
Message-Id: <20250317185821.B6521C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: replace open coded variant of DEFINE_RES()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-replace-open-coded-variant-of-define_res.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-replace-open-coded-variant-of-define_res.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: resource: replace open coded variant of DEFINE_RES()
Date: Mon, 17 Mar 2025 20:11:13 +0200

Replace open coded variant of DEFINE_RES(). No functional changes intended.

Link: https://lkml.kernel.org/r/20250317181412.1560630-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/resource.c~resource-replace-open-coded-variant-of-define_res
+++ a/kernel/resource.c
@@ -561,8 +561,7 @@ static int __region_intersects(struct re
 	struct resource res, o;
 	bool covered;
 
-	res.start = start;
-	res.end = start + size - 1;
+	res = DEFINE_RES(start, size, 0);
 
 	for (p = parent->child; p ; p = p->sibling) {
 		if (!resource_intersection(p, &res, &o))
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

resource-split-define_res_named_desc-out-of-define_res_named.patch
resource-replace-open-coded-variant-of-define_res_named_desc.patch
resource-replace-open-coded-variants-of-define_res__named.patch
resource-replace-open-coded-variant-of-define_res.patch

