Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E545229A0
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 05:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732943785; cv=none; b=cfAGh0mTmp/GXttrvWO2XBJXY4h2VYCpx+D/Iky5nEyE58jNQiENMPiQlwYB9bs2n5seY+dFNaGtYA/WEwH13GcGUCFD0eiGNcWnukUGkP55yb4WudxSXcz0xR2TN3ls0mZojuqzV9gcJZU4f0Hd3iO1DZHLsNLIH3y28PnKo2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732943785; c=relaxed/simple;
	bh=+S6GABTJJwc+vbEVp7JW0YgFIwtd5KHl8DujTmQYj+Y=;
	h=Date:To:From:Subject:Message-Id; b=boXO8bFjhKCOrh3hopMyxkSd3c8uVUpmuRvyP0VIeHJVW2dxB9nkMJPVzob8NX9PSRE8HjxfK5MwoD427Dc326p9cVpYDFfcKmpR5NFL86Immz+Xg8qn0lkhNUG038v42FFXsac+LF5lkI3sPHoFIvfVKe/3ZTmwfLrBBzfzbC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SVvFa2/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SVvFa2/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547EBC4CECC;
	Sat, 30 Nov 2024 05:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732943784;
	bh=+S6GABTJJwc+vbEVp7JW0YgFIwtd5KHl8DujTmQYj+Y=;
	h=Date:To:From:Subject:From;
	b=SVvFa2/DQGjkAS9w93xONlFm9EDtJCGeajRjckL8fSh7J133Qs6kgje2kedHXWo1F
	 3nmUKnlV+HcRDNB81ASK4SlF/XF1ovP/LTETPXlQvHF9YMT3siEmRmgMU6LYoJ1rFw
	 tRmKBvJ1lNAb+D0GdmgpaFuYYJ4SpmCqJ+Xlg+oE=
Date: Fri, 29 Nov 2024 21:16:23 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,ryabinin.a.a@gmail.com,lkp@intel.com,dvyukov@google.com,andreyknvl@gmail.com,niharchaithanya@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-fix-sparse-warnings-should-it-be-static.patch added to mm-unstable branch
Message-Id: <20241130051624.547EBC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm:kasan: fix sparse warnings: Should it be static?
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kasan-fix-sparse-warnings-should-it-be-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-fix-sparse-warnings-should-it-be-static.patch

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
From: Nihar Chaithanya <niharchaithanya@gmail.com>
Subject: mm:kasan: fix sparse warnings: Should it be static?
Date: Fri, 11 Oct 2024 17:15:38 +0530

Yes, when making the global variables kasan_ptr_result and
kasan_int_result as static volatile, the warnings are removed and the
variable and assignments are retained, but when just static is used I
understand that it might be optimized.

Add a fix making the global varaibles - static volatile, removing the
warnings:
mm/kasan/kasan_test.c:36:6: warning: symbol 'kasan_ptr_result' was not declared. Should it be static?
mm/kasan/kasan_test.c:37:5: warning: symbol 'kasan_int_result' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20241011114537.35664-1-niharchaithanya@gmail.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312261010.o0lRiI9b-lkp@intel.com/
Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-fix-sparse-warnings-should-it-be-static
+++ a/mm/kasan/kasan_test_c.c
@@ -47,8 +47,8 @@ static struct {
  * Some tests use these global variables to store return values from function
  * calls that could otherwise be eliminated by the compiler as dead code.
  */
-void *kasan_ptr_result;
-int kasan_int_result;
+static volatile void *kasan_ptr_result;
+static volatile int kasan_int_result;
 
 /* Probe for console output: obtains test_status lines of interest. */
 static void probe_console(void *ignore, const char *buf, size_t len)
_

Patches currently in -mm which might be from niharchaithanya@gmail.com are

mm-kasan-fix-sparse-warnings-should-it-be-static.patch

