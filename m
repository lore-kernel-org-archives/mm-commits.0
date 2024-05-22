Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DC37D3E8
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 23:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716420233; cv=none; b=fQvuldHZN+zS93cn6JwxIYk+EYPYrK0rdL7Vc8ZzuqQ2OWYKwPFQ9wP6CZSNkVWJjtOJtSwOREIZNWCHP+caRwhKSEdSL73CplzOCX5JGKf06ayfWGWzZGSZiPGHPvOXBUaR4/gOOONYmEvP8psl1VZWk4mVUWL1QAA6m8JsmQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716420233; c=relaxed/simple;
	bh=aKyX7grHrSPMdLZ87jeVYgo7ARp+FBf3GmZtfhNZ1qo=;
	h=Date:To:From:Subject:Message-Id; b=SjU3qaf7MindjUaDgbg0iO+VXSEmHD+oya/bw/JUy6j3jvd7jzP7DaKdSOvLZtA1AnDUrJMIuNVDYhx1826WjftOmo5l6GIQUfsgHkRYU5j50GkAcfnYwbpjxo4NrJ33jW/Emp+9U6t5agLihnNHZD08HcxpUgH3cbTWm3sFB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zP0UnFxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zP0UnFxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED8FC2BBFC;
	Wed, 22 May 2024 23:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716420232;
	bh=aKyX7grHrSPMdLZ87jeVYgo7ARp+FBf3GmZtfhNZ1qo=;
	h=Date:To:From:Subject:From;
	b=zP0UnFxBlmq1YBaM38BLU32e3237jFxB+gL7R1UcOeZu8cvDJOajQDSehm3JOJ89f
	 iigPjY+a4iARBIPTVa/X2013pkWw7MhJCktmvmaAJDSrzI/lgvd6z+Fq9djEh2qQg0
	 Ig13ZGETRikOMtMIFZZVL8W8E7DswLoRQoDZ4M+Q=
Date: Wed, 22 May 2024 16:23:51 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,keescook@chromium.org,jorgelo@chromium.org,jeffxu@google.com,hughd@google.com,dverkamp@chromium.org,dmitry.torokhov@gmail.com,pobrn@protonmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch added to mm-unstable branch
Message-Id: <20240522232352.6ED8FC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`
has been added to the -mm mm-unstable branch.  Its filename is
     memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch

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
From: Barnabás Pőcze <pobrn@protonmail.com>
Subject: memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`
Date: Mon, 13 May 2024 19:15:47 +0000

`MFD_NOEXEC_SEAL` should remove the executable bits and set `F_SEAL_EXEC`
to prevent further modifications to the executable bits as per the comment
in the uapi header file:

  not executable and sealed to prevent changing to executable

However, currently, it also unsets `F_SEAL_SEAL`, essentially acting as a
superset of `MFD_ALLOW_SEALING`.  Nothing implies that it should be so,
and indeed up until the second version of the of the patchset[0] that
introduced `MFD_EXEC` and `MFD_NOEXEC_SEAL`, `F_SEAL_SEAL` was not
removed, however it was changed in the third revision of the patchset[1]
without a clear explanation.

This behaviour is suprising for application developers, there is no
documentation that would reveal that `MFD_NOEXEC_SEAL` has the additional
effect of `MFD_ALLOW_SEALING`.

So do not remove `F_SEAL_SEAL` when `MFD_NOEXEC_SEAL` is requested.  This
is technically an ABI break, but it seems very unlikely that an
application would depend on this behaviour (unless by accident).

[0]: https://lore.kernel.org/lkml/20220805222126.142525-3-jeffxu@google.com/
[1]: https://lore.kernel.org/lkml/20221202013404.163143-3-jeffxu@google.com/

Link: https://lkml.kernel.org/r/20240513191544.94754-1-pobrn@protonmail.com
Fixes: 105ff5339f498a ("mm/memfd: add MFD_NOEXEC_SEAL and MFD_EXEC")
Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Reviewed-by: Jeff Xu <jeffxu@google.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c                                 |    9 ++++-----
 tools/testing/selftests/memfd/memfd_test.c |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/memfd.c~memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing
+++ a/mm/memfd.c
@@ -391,12 +391,11 @@ SYSCALL_DEFINE2(memfd_create,
 
 		inode->i_mode &= ~0111;
 		file_seals = memfd_file_seals_ptr(file);
-		if (file_seals) {
-			*file_seals &= ~F_SEAL_SEAL;
+		if (file_seals)
 			*file_seals |= F_SEAL_EXEC;
-		}
-	} else if (flags & MFD_ALLOW_SEALING) {
-		/* MFD_EXEC and MFD_ALLOW_SEALING are set */
+	}
+
+	if (flags & MFD_ALLOW_SEALING) {
 		file_seals = memfd_file_seals_ptr(file);
 		if (file_seals)
 			*file_seals &= ~F_SEAL_SEAL;
--- a/tools/testing/selftests/memfd/memfd_test.c~memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -1151,7 +1151,7 @@ static void test_noexec_seal(void)
 			    mfd_def_size,
 			    MFD_CLOEXEC | MFD_NOEXEC_SEAL);
 	mfd_assert_mode(fd, 0666);
-	mfd_assert_has_seals(fd, F_SEAL_EXEC);
+	mfd_assert_has_seals(fd, F_SEAL_SEAL | F_SEAL_EXEC);
 	mfd_fail_chmod(fd, 0777);
 	close(fd);
 }
_

Patches currently in -mm which might be from pobrn@protonmail.com are

memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch

