Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C0023CB
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 00:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757117180; cv=none; b=JT464wEp9R+oJdkD1RmSmfYXNUs9Y7vp3N11xfK+BdDQ4hYQjN2gDGHqBe7Bc9Xl31xU7+jXzpWBUAxLxPd3FJGlVPTHbgDsnu5UgH2FhhsJzGWF7xnlPqdNZ1oXWv/vf6HTioJGRByzGbdg8be97E68lmK0ArRs4PJypR9d9c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757117180; c=relaxed/simple;
	bh=nTkBWycrXLND1DXoqiRH/PaOTomF58cDTLIrt0BXg7c=;
	h=Date:To:From:Subject:Message-Id; b=SOYb69SwU7pJqy55Q/ssYzArKRmZjnQWlUYYCxlXlkJZDsm0s3GP2lNouxKnMYFpQpBJehuts7d86Rt83WTb/Si6ZA05w7X4D0dnTkxDq7e70QcFmvbng7559CvTR0wMOVz7Mg/ka/nNvElis86Zvmmq2Mh6i0sg3FNGte/RgDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FmytrMze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FmytrMze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35EEC4CEF1;
	Sat,  6 Sep 2025 00:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757117178;
	bh=nTkBWycrXLND1DXoqiRH/PaOTomF58cDTLIrt0BXg7c=;
	h=Date:To:From:Subject:From;
	b=FmytrMzeDD3Ks6m1toKbXoy6qbQgxTVd7Gbz/DGrXMmhRUBqFs+JT5EA7Pu/1Y27w
	 yB8SGr/cmMCCDB/C7pe6MrkAsdQ64P38h/o92HM692+RrokYHhGNuBDpiPftRftKs7
	 +OQ+03HqKgxkb8F4k0eXFJy8pa3iTIV+Bo75CMIY=
Date: Fri, 05 Sep 2025 17:06:17 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,bhe@redhat.com,vdumitrescu@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-fix-race-on-alloc-failed-warning-limit-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250906000618.A35EEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu-fix-race-on-alloc-failed-warning-limit-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     percpu-fix-race-on-alloc-failed-warning-limit-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-fix-race-on-alloc-failed-warning-limit-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Subject: percpu-fix-race-on-alloc-failed-warning-limit-v2
Date: Fri, 5 Sep 2025 15:42:14 -0700

prevent warn_limit from going negative, per Christoph Lameter

Link: https://lkml.kernel.org/r/ee87cc59-2717-4dbb-8052-1d2692c5aaaa@nvidia.com
Fixes: f7d77dfc91f7 ("mm/percpu.c: print error message too if atomic alloc failed")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/percpu.c~percpu-fix-race-on-alloc-failed-warning-limit-v2
+++ a/mm/percpu.c
@@ -1904,8 +1904,8 @@ fail_unlock:
 fail:
 	trace_percpu_alloc_percpu_fail(reserved, is_atomic, size, align);
 
-	if (do_warn && atomic_read(&warn_limit) > 0) {
-		int remaining = atomic_dec_return(&warn_limit);
+	if (do_warn) {
+		int remaining = atomic_dec_if_positive(&warn_limit);
 
 		if (remaining >= 0) {
 			pr_warn("allocation failed, size=%zu align=%zu atomic=%d, %s\n",
_

Patches currently in -mm which might be from vdumitrescu@nvidia.com are

percpu-fix-race-on-alloc-failed-warning-limit.patch
percpu-fix-race-on-alloc-failed-warning-limit-v2.patch

