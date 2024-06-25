Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA02021A0C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289823; cv=none; b=Lr/vWefOeyaa6WhNRB1FOoM5gJxbtYnU30As92S8IUh4P6HwwAt++k1dflrESSnfqw5HMqjSOiB192EOIjubOVTtFHzDaWfbz5XgrbFRtgP3O1XG1DqqvUvDlQo3lfXsYJvOimqCsdtOkPThmNLGEbD8D/vkU2GX8FqKOodtChM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289823; c=relaxed/simple;
	bh=CMD/RxnJvKJcbI71OSqJHq35bUd6HWQ/5/LYpn/QCrQ=;
	h=Date:To:From:Subject:Message-Id; b=BxzbiFDFTADMzYnN30SiyVV6MjF8PWGA8uSdldxkJihegpeDWaeD2czmk9uk3QrX5YA68Fg0GwfPTMKwp15bLuBXpqM6qd8mwDxPzXmpZfcuzBN0W8HQI6naXuGmvgzCvgU331BsPCBOBdooOnRZOViAXIog7NHnyrzdhqPUiIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gP2gMJUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gP2gMJUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFB6C32782;
	Tue, 25 Jun 2024 04:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289823;
	bh=CMD/RxnJvKJcbI71OSqJHq35bUd6HWQ/5/LYpn/QCrQ=;
	h=Date:To:From:Subject:From;
	b=gP2gMJUPlXHXcDrOC1MhW1btzXG1oG6UNCMblds8AvSUO4wo3aDoDUFt17cK/b+u8
	 XESuhqxeYYkz9DUKXGQquAeabs8Wj0mW4eXmkITLXEE9FeoqV67uMMCryUp4TW/lXC
	 Bwd+foLtnwF0MvAzEyHXqGoMJGfGsCWnH6BT03cQ=
Date: Mon, 24 Jun 2024 21:30:22 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,kees@kernel.org,jeffxu@chromium.org,david@redhat.com,dalias@libc.org,brauner@kernel.org,axelrasmussen@google.com,avagin@google.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix.patch removed from -mm tree
Message-Id: <20240625043023.5BFB6C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix
has been removed from the -mm tree.  Its filename was
     selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items-fix.patch

This patch was dropped because it was folded into selftests-mm-mseal-self_elf-factor-out-test-macros-and-other-duplicated-items.patch

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
selftests-mm-mseal-self_elf-rename-test_end_check-to-report_test_pass.patch
selftests-mm-fix-vm_utilc-build-failures-add-snapshot-of-fsh.patch
selftests-mm-kvm-mdwe-fixes-to-avoid-requiring-make-headers.patch
selftests-mm-remove-local-__nr_-definitions.patch
selftests-mqueue-fix-5-warnings-about-signed-unsigned-mismatches.patch

