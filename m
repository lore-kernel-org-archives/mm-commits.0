Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E415F32ABEC
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806498; cv=none; b=XfcgjVmd+To3ncgKyLNoz/wxbV3KeTqXZg3VR3t6rO42OhzUim9+g+Brwu+CEVWjvYIG7IpPNZDV07+Dyc1KuIfPC/FcZTF/4axMmwA7N241uW/qKa1LxpOT9NGSKoIBzU0Aw6qLZT8fL0aW6oL4WbiMcZEJ1xuI0iSElIvVD0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806498; c=relaxed/simple;
	bh=Cv/K1C3/1JbREjdMLS+bGJru1Z/uLfQTmN2EKBfVAV8=;
	h=Date:To:From:Subject:Message-Id; b=WY6oNtrwuczEWox32oFC+RdCWiTgl1EM8zhdJyIPIFUEPHIeG9pXZwVMBPjMuhkIaEpMEeuSpYRX7VlxqQpF9OXgs/Jm3C1HkDrKb2JJmEp3RmGqSH8f8cPX0QO7v23bGubA2BIGf0rbLIflx7pGom3I1sSx7CL9xmG+WBmPI/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=olKd0s3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="olKd0s3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779E1C4CEF1;
	Wed,  7 Jan 2026 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806495;
	bh=Cv/K1C3/1JbREjdMLS+bGJru1Z/uLfQTmN2EKBfVAV8=;
	h=Date:To:From:Subject:From;
	b=olKd0s3LYFuML0MR3YQbFpL87Sm+7YgCbYf0yN07UPnVyyzoRVuSo53s1Kg2+G3WM
	 XbS5IMy7fZyRffo1Jm8UcWR0rIoLVJJV0Js7VylWNx0DzIviW9zSwrAmCWgWECJCiv
	 HuIfU3EHzCYAAiuoV5/TWMi6/od9/OQtSdqrbO8I=
Date: Wed, 07 Jan 2026 09:21:34 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Usama.Anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,pabeni@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,Liam.Howlett@oracle.com,jhubbard@nvidia.com,jgg@nvidia.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch added to mm-new branch
Message-Id: <20260107172135.779E1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: pass down full CC and CFLAGS to check_config.sh
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: pass down full CC and CFLAGS to check_config.sh
Date: Wed, 7 Jan 2026 16:48:37 +0000

check_config.sh checks that liburing is available by running the compiler
provided as its first argument.  This makes two assumptions:

1. CC consists of only one word
2. No extra flag is required

Unfortunately, there are many situations where these assumptions don't
hold.  For instance:

- When using Clang, CC consists of multiple words
- When cross-compiling, extra flags may be required to allow the
  compiler to find headers

Remove these assumptions by passing down CC and CFLAGS as-is from the
Makefile, so that the same command line is used as when actually building
the tests.

Link: https://lkml.kernel.org/r/20260107164842.3289559-4-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile        |    2 +-
 tools/testing/selftests/mm/check_config.sh |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/check_config.sh~selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh
+++ a/tools/testing/selftests/mm/check_config.sh
@@ -16,8 +16,7 @@ echo "#include <sys/types.h>"        > $
 echo "#include <liburing.h>"        >> $tmpfile_c
 echo "int func(void) { return 0; }" >> $tmpfile_c
 
-CC=${1:?"Usage: $0 <compiler> # example compiler: gcc"}
-$CC -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
--- a/tools/testing/selftests/mm/Makefile~selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh
+++ a/tools/testing/selftests/mm/Makefile
@@ -231,7 +231,7 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	/bin/sh ./check_config.sh $(CC)
+	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

x86-xen-simplify-flush_lazy_mmu.patch
powerpc-mm-implement-arch_flush_lazy_mmu_mode.patch
sparc-mm-implement-arch_flush_lazy_mmu_mode.patch
mm-clarify-lazy_mmu-sleeping-constraints.patch
mm-introduce-config_arch_has_lazy_mmu_mode.patch
mm-introduce-generic-lazy_mmu-helpers.patch
mm-bail-out-of-lazy_mmu_mode_-in-interrupt-context.patch
mm-enable-lazy_mmu-sections-to-nest.patch
arm64-mm-replace-tif_lazy_mmu-with-is_lazy_mmu_mode_active.patch
powerpc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
sparc-mm-replace-batch-active-with-is_lazy_mmu_mode_active.patch
x86-xen-use-lazy_mmu_state-when-context-switching.patch
mm-add-basic-tests-for-lazy_mmu.patch
mm-add-basic-tests-for-lazy_mmu-fix-fix-fix.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

