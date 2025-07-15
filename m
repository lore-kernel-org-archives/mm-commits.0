Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9509726AD9;
	Tue, 15 Jul 2025 21:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752616173; cv=none; b=gyFtM1E3gzcBdsVtbb9mqJ9QpVHF/7GAd8+Rf74ULf1sNkHRGqvoF9KHDePT4UuN7tg5sYDpLOkNZNg1s+cTZAbf3ih7V6l5XailNAVVW6nFirfZfchVDnB6jfa7AIOaatnJZ5XvY8gFah1u0o1yNIdmaIHXv6Km+02Tf+ewvxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752616173; c=relaxed/simple;
	bh=Y6Kwqw2XBwaFF9GeOQDluWNxZchC3R6QjKcFLzYDC3g=;
	h=Date:To:From:Subject:Message-Id; b=rMDWfuEtRgXyL2or+UOoTYuRehuGay4Hw3087qEaOZW8Gf85AieYwV/pCV/ejLI6epyh36yGZNfrH9IO+xs8N/wUM/h2IVxRQp7pymErlmOTNJw0Es2Lz+xIradhZSyA9pssuA8xUCWUIhBRju8nXVsyrdNxJgtZIi3WI0S0/TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j/Ls23FQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j/Ls23FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CA4C4CEE3;
	Tue, 15 Jul 2025 21:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752616173;
	bh=Y6Kwqw2XBwaFF9GeOQDluWNxZchC3R6QjKcFLzYDC3g=;
	h=Date:To:From:Subject:From;
	b=j/Ls23FQlJT0KJ4+lDW5gCj5JF7I6EDOZT2OpxHEp41Uc7KEbCsHnWkZaSdSX2Qr3
	 wK5a2Uzkpo+DK6IFZtNy8Dx995sVVAelp6pEkONc2ZrCzNb5keBQU6flMAqmmNo+8k
	 vskHPQt8t8PwIF8eXo6z50qTgZBPcnq4aucpvtFU=
Date: Tue, 15 Jul 2025 14:49:32 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,stable@vger.kernel.org,shr@devkernel.io,david@redhat.com,chengming.zhou@linux.dev,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-wsometimes-uninitialized-from-clang-21-in-advisor_mode_show.patch added to mm-hotfixes-unstable branch
Message-Id: <20250715214933.25CA4C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-wsometimes-uninitialized-from-clang-21-in-advisor_mode_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-wsometimes-uninitialized-from-clang-21-in-advisor_mode_show.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()
Date: Tue, 15 Jul 2025 12:56:16 -0700

After a recent change in clang to expose uninitialized warnings from const
variables [1], there is a false positive warning from the if statement in
advisor_mode_show().

  mm/ksm.c:3687:11: error: variable 'output' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   3687 |         else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
        |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/ksm.c:3690:33: note: uninitialized use occurs here
   3690 |         return sysfs_emit(buf, "%s\n", output);
        |                                        ^~~~~~

Rewrite the if statement to implicitly make KSM_ADVISOR_NONE the else
branch so that it is obvious to the compiler that ksm_advisor can only be
KSM_ADVISOR_NONE or KSM_ADVISOR_SCAN_TIME due to the assignments in
advisor_mode_store().

Link: https://lkml.kernel.org/r/20250715-ksm-fix-clang-21-uninit-warning-v1-1-f443feb4bfc4@kernel.org
Fixes: 66790e9a735b ("mm/ksm: add sysfs knobs for advisor")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2100
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-wsometimes-uninitialized-from-clang-21-in-advisor_mode_show
+++ a/mm/ksm.c
@@ -3669,10 +3669,10 @@ static ssize_t advisor_mode_show(struct
 {
 	const char *output;
 
-	if (ksm_advisor == KSM_ADVISOR_NONE)
-		output = "[none] scan-time";
-	else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
+	if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
 		output = "none [scan-time]";
+	else
+		output = "[none] scan-time";
 
 	return sysfs_emit(buf, "%s\n", output);
 }
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-ksm-fix-wsometimes-uninitialized-from-clang-21-in-advisor_mode_show.patch
panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch

