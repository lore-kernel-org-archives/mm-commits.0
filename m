Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AD0357706
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769106390; cv=none; b=Yrz68LTFxa2rmT/XPos7FyV0yYQ9jJsATUffmU6pvLyHWk1HKNNytWpe8OYXaGwbpUZNsd5WxgjlTFDJbs7W1/ssm0OGCOw9MfQfED8yH9W4jCei1HkF4/YWcKoys+5vQKVDxwSMg75Fnkv9hcWPEURxr1l5sDNcnKPzr2tO2Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769106390; c=relaxed/simple;
	bh=Tp0mr0fVfNh+JtjZE0oroRmcjUrKcJFoBuWNGb46s1I=;
	h=Date:To:From:Subject:Message-Id; b=ViaL6xpRqFwhhGEo4zip4poZC0vrYKr8mZyu97HtnvNS6+OYZQ6c5Sq4RyPjKCcscwKH9xjWQR5SWhWj7aF/fj5cgyxDu3LSyl1LT5mTigAqvw/wOFsY9RG53fmqHH/Gj8+Z5crovZUh1RdEWAlA7Rmai4BqdG8+JKdEnPeDgAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JSnnoHJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JSnnoHJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B58FC116D0;
	Thu, 22 Jan 2026 18:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769106387;
	bh=Tp0mr0fVfNh+JtjZE0oroRmcjUrKcJFoBuWNGb46s1I=;
	h=Date:To:From:Subject:From;
	b=JSnnoHJFBasY92dTYE8IZR+rBH3VVjViGEqIzZC1heMz+E5M+SEZjLE6oAhNKkLv/
	 KXJU7GiUF84/NpM0an1I061JmmHS69quMM1H7A994DApHuken9IXDzQwxarsj0ncmF
	 s2LMhO17AF/VwWHmm6JRnysM5hrGnKXHepem8bLA=
Date: Thu, 22 Jan 2026 10:26:26 -0800
To: mm-commits@vger.kernel.org,Usama.Anjum@arm.com,sj@kernel.org,shuah@kernel.org,ryan.roberts@arm.com,pabeni@redhat.com,lorenzo.stoakes@oracle.com,linyunsheng@huawei.com,lianux.mm@gmail.com,jhubbard@nvidia.com,jgg@nvidia.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch added to mm-unstable branch
Message-Id: <20260122182627.7B58FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: pass down full CC and CFLAGS to check_config.sh
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Thu, 22 Jan 2026 17:02:18 +0000

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

Link: https://lkml.kernel.org/r/20260122170224.4056513-4-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Usama Anjum <Usama.Anjum@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
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
@@ -230,7 +230,7 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	/bin/sh ./check_config.sh $(CC)
+	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests.patch
selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-check-that-force_read-succeeded.patch
selftests-mm-introduce-helper-to-read-every-page.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

