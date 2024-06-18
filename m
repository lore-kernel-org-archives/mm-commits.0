Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6F553E24
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718743498; cv=none; b=D8po99EOZQKJ0fUV+CEDBRsQ/PkGp4xv5+6z8A9lsGKRsIK6jeDHzi3wjW7glmZqCtYVRrIs2h1dEi1SN83QA20sFNW/P/vXUu/RbfqmcM6i+e/Ne0cNL43nJsf7ksU7r8V//rDPIFRjReS4xHsYJdpYEoMeTYSN7PJ6g//nXfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718743498; c=relaxed/simple;
	bh=0ylAZ/D/acI+waEyzeO1iw+sjp9uNSxzeS3LX/S3Qa4=;
	h=Date:To:From:Subject:Message-Id; b=ZuPQ9sdjYXMQ2/O33j2ae3g/aAnq4pzbjGYHDjUWaw3GDqXYb+SbLRaDimZXIjOk72l3qm1qZ1XmwhIj4YuS/7ouxCDSGsxGnj51t2/1sZ9m9n9D6iQz0LzUe1sxJBtVtYqiTAIvsYQTq25oU5QKo99CPyvgMY1adCNj7yTHAMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n7ZH/TMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n7ZH/TMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827A8C3277B;
	Tue, 18 Jun 2024 20:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718743497;
	bh=0ylAZ/D/acI+waEyzeO1iw+sjp9uNSxzeS3LX/S3Qa4=;
	h=Date:To:From:Subject:From;
	b=n7ZH/TMxK6QRfYFAEKLO5RsjgKfaKJ7CKdAk2SZfehv2gR3JOlQv6DL9ecKJigGvP
	 4X7zajKuIad52EnIXD6AF9XKD4LguhUrbavStHXVPVw0DWN2RThsul75JtASpMRDiZ
	 wYhHzC2y6GbrpoFFMOwTg5T2C0QvMt1vceg23wk4=
Date: Tue, 18 Jun 2024 13:44:57 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix.patch added to mm-unstable branch
Message-Id: <20240618204457.827A8C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix.patch

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
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix
Date: Tue, 18 Jun 2024 13:17:45 -0700

include the new mseal_helpers.h in Makefile dependencies


Link: https://lkml.kernel.org/r/01685978-f6b1-4c24-8397-22cd3c24b91a@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/Makefile~selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix
+++ a/tools/testing/selftests/mm/Makefile
@@ -2,6 +2,7 @@
 # Makefile for mm selftests
 
 LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

selftests-mm-mseal-self_elf-fix-missing-__nr_mseal.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch
selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix.patch
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-remove-local-__nr_-definitions.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

