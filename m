Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E6C26AFC
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389635; cv=none; b=XhYOr7BbJm1TqH+0GhdOjmiCoF/E+NkLgbqZxUMZMcON7Nk145vChGMcyf9FuMxYbZSgnYC16OQ+zZsz12gOnd62F7D2OujSqe5DDGaxP3S2YZqKD+vgLVhSV+B9QgmtRhiviinmbTlAcCc8jTfKUDNOWbRiKISkQqGzyD0JRZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389635; c=relaxed/simple;
	bh=bi5BhUoaYw2GiarkbupM3sklX3H8F+30JvA+JNuqqfc=;
	h=Date:To:From:Subject:Message-Id; b=BJ3oDUEhggyz3hev9SBHWBt1zSdco20ndq7glJAf+HIOoNka14wwP+l1y/XbqKqljXLU32qrgsAyy2xbMPLb6VrLW1GQiBRsIgnKAr1+OGjAysp+dWNlSCkq70bmkhY5AT5IEa4RxZVn4jrEdenl3pM01mkr29Qik/9DTfE7Kv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ymN1MGUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ymN1MGUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12694C2BD10;
	Fri, 14 Jun 2024 18:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718389635;
	bh=bi5BhUoaYw2GiarkbupM3sklX3H8F+30JvA+JNuqqfc=;
	h=Date:To:From:Subject:From;
	b=ymN1MGUbie9aj4eT8mfZd/pWDSXcTgfHFLvPNeqPHbb7F6ECKM4XSyoZZC6wiVa8R
	 T0o0H4LG3FgyH5aIl4kiKc4PxbsZnZ8TdMxZSNsevcU4KxNc+K1rl3MbIc2qfa4HjN
	 079xRnRDyrD3rHH5GA3gus5IwyNXVzJSoIBP9N6g=
Date: Fri, 14 Jun 2024 11:27:14 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,keescook@chromium.org,jorgelo@chromium.org,jeffxu@google.com,hughd@google.com,dverkamp@chromium.org,dmitry.torokhov@gmail.com,david@readahead.eu,pobrn@protonmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch removed from -mm tree
Message-Id: <20240614182715.12694C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`
has been removed from the -mm tree.  Its filename was
     memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch

This patch was dropped because it was nacked

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
Fixes: 105ff5339f49 ("mm/memfd: add MFD_NOEXEC_SEAL and MFD_EXEC")
Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Reviewed-by: Jeff Xu <jeffxu@google.com>
Reviewed-by: David Rheinsberg <david@readahead.eu>
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
@@ -356,12 +356,11 @@ SYSCALL_DEFINE2(memfd_create,
 
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


