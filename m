Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099651DDC10;
	Fri,  1 Nov 2024 20:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492615; cv=none; b=JZcXBByzZw9DQTNFlwcz9/Ndtfwdlacuz3NmcjXs/wZLqtWmo/vmDCM1kV64W7xJhqBjFvMnv+QggieH27V1qYuycPjFh2M7uSW8qwh1fk0zDijORrveOKGyL9frDBZnDNfb9+uhaU2BoAlkoTkw6FeKq1SliuLXLaj3PXnVh/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492615; c=relaxed/simple;
	bh=YCmOQtIMKaMTPQHqiGfpeKVDWD3EDhkkyGBGWHBW2hI=;
	h=Date:To:From:Subject:Message-Id; b=J833EM/qo0rvqOrAR2rXCDMQ2ArRY3xixZP5Mji5iYctF7EhI5bUGqoJ9HQ515gnnsR9tZS7yCMnjas7NxkmAe8rr++/nPhDfveE2u166/ZxsdbHdYdqJb2t7IJCaejvZIYwUdldrgdN5VW94LfOR/QI/JhE5hAav3qyXykinpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y2gu7QxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y2gu7QxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A172DC4CECD;
	Fri,  1 Nov 2024 20:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730492614;
	bh=YCmOQtIMKaMTPQHqiGfpeKVDWD3EDhkkyGBGWHBW2hI=;
	h=Date:To:From:Subject:From;
	b=Y2gu7QxXLIyATD8rQelmruI6kH0UtQo/mnU7jmkKU1b+vM8lBIkYSJn651seeo287
	 nY1L6bgpZCTzYbLgQONMpkyHPTQub+2UzifmbSIMdmqMHjm/ca1Euqm8H42aUeahgt
	 A45brrf+q3M3EWE6EVXlon2sHzd1fmVY8n/smkwY=
Date: Fri, 01 Nov 2024 13:23:33 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,oleg@redhat.com,legion@kernel.org,kees@kernel.org,ebiederm@xmission.com,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucounts-fix-counter-leak-in-inc_rlimit_get_ucounts.patch added to mm-hotfixes-unstable branch
Message-Id: <20241101202334.A172DC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucounts: fix counter leak in inc_rlimit_get_ucounts()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ucounts-fix-counter-leak-in-inc_rlimit_get_ucounts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucounts-fix-counter-leak-in-inc_rlimit_get_ucounts.patch

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
From: Andrei Vagin <avagin@google.com>
Subject: ucounts: fix counter leak in inc_rlimit_get_ucounts()
Date: Fri, 1 Nov 2024 19:19:40 +0000

The inc_rlimit_get_ucounts() increments the specified rlimit counter and
then checks its limit.  If the value exceeds the limit, the function
returns an error without decrementing the counter.

Link: https://lkml.kernel.org/r/20241101191940.3211128-1-roman.gushchin@linux.dev
Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Andrei Vagin <avagin@google.com>
Co-developed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Tested-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ucount.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/ucount.c~ucounts-fix-counter-leak-in-inc_rlimit_get_ucounts
+++ a/kernel/ucount.c
@@ -318,7 +318,7 @@ long inc_rlimit_get_ucounts(struct ucoun
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
 		long new = atomic_long_add_return(1, &iter->rlimit[type]);
 		if (new < 0 || (!override_rlimit && (new > max)))
-			goto unwind;
+			goto dec_unwind;
 		if (iter == ucounts)
 			ret = new;
 		max = get_userns_rlimit_max(iter->ns, type);
@@ -335,7 +335,6 @@ long inc_rlimit_get_ucounts(struct ucoun
 dec_unwind:
 	dec = atomic_long_sub_return(1, &iter->rlimit[type]);
 	WARN_ON_ONCE(dec < 0);
-unwind:
 	do_dec_rlimit_put_ucounts(ucounts, iter, type);
 	return 0;
 }
_

Patches currently in -mm which might be from avagin@google.com are

ucounts-fix-counter-leak-in-inc_rlimit_get_ucounts.patch

