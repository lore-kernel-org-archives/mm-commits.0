Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B7D4A04
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794677; cv=none; b=eInpPTOI73VkSTwhXijSO5H1IlFnE/RFhzSvipLKY9GuZnwO631VIcPnqlHAT+F+EtZIes5wR6pZTajhRDq/XsVH8oT13OAA4x5KYKZvktCWwhD7S55fmYh83cFoLQ22Qtt5gsxOGxeLyslU+9ncuU/E2zQgVwnWwTjWYqSPfng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794677; c=relaxed/simple;
	bh=963tfyExNw7rkhnlHwvCsoK16+TzQ8aRPzqrNNo14jo=;
	h=Date:To:From:Subject:Message-Id; b=lQdJMCv+vofJe6N3zS7fyXZvFXaXz77OktOyPhVDtzYQuc/OibqDCUWZjF+lmMhf/e+PoBWLXaaoJzhYJVal0QMhuI2Cnwe85tEcGwJXYSfZfpc7w4PKfshhVnYy4W9fMwYe+FCeXfKNuoviUyMPVWRlif6I9I4OyJ9knywB9YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cu5DWHzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cu5DWHzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F722C4CED1;
	Tue, 10 Dec 2024 01:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733794675;
	bh=963tfyExNw7rkhnlHwvCsoK16+TzQ8aRPzqrNNo14jo=;
	h=Date:To:From:Subject:From;
	b=Cu5DWHzXvVsjLTUcna0hoY3uCtNWpF5mjURT+x4tZeWMXSbszG60j3gofNCjCoMVm
	 ZaWuWjA4jm4/wiKYEEGx2CJt/h+W8ce8gy5i40lvttQqSOkXNHnZqaJHKTiCBDOdrX
	 BCqL9j7IxJ1ZR2FDSp4q1ezvqQcABRXRoaRoilDk=
Date: Mon, 09 Dec 2024 17:37:54 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,david@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-thp_settings-remove-const-from-return-type.patch added to mm-unstable branch
Message-Id: <20241210013755.6F722C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: thp_settings: remove const from return type
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-thp_settings-remove-const-from-return-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-thp_settings-remove-const-from-return-type.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: thp_settings: remove const from return type
Date: Mon, 9 Dec 2024 23:56:21 +0500

Patch series "selftest/mm: Remove warnings found by adding compiler flags".

Recently, I reviewed a patch on the mm/kselftest mailing list about a test
which had obvious type mismatch fix in it.  It was strange why that wasn't
caught during development and when patch was accepted.  This led me to
discover that those extra compiler options to catch these warnings aren't
being used.  When I added them, I found tens of warnings in just mm suite.

In this series, I'm fixing those warnings in a few files.  More fixes will
be sent later.


This patch (of 4):

Remove cost from the return type as it is ignored anyways and generates
the warning:

  warning: type qualifiers ignored on function return type [-Wignored-qualifiers]

Link: https://lkml.kernel.org/r/20241209185624.2245158-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20241209185624.2245158-2-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thp_settings.c |    4 ++--
 tools/testing/selftests/mm/thp_settings.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/thp_settings.c~selftests-mm-thp_settings-remove-const-from-return-type
+++ a/tools/testing/selftests/mm/thp_settings.c
@@ -87,7 +87,7 @@ int write_file(const char *path, const c
 	return (unsigned int) numwritten;
 }
 
-const unsigned long read_num(const char *path)
+unsigned long read_num(const char *path)
 {
 	char buf[21];
 
@@ -172,7 +172,7 @@ void thp_write_string(const char *name,
 	}
 }
 
-const unsigned long thp_read_num(const char *name)
+unsigned long thp_read_num(const char *name)
 {
 	char path[PATH_MAX];
 	int ret;
--- a/tools/testing/selftests/mm/thp_settings.h~selftests-mm-thp_settings-remove-const-from-return-type
+++ a/tools/testing/selftests/mm/thp_settings.h
@@ -64,12 +64,12 @@ struct thp_settings {
 
 int read_file(const char *path, char *buf, size_t buflen);
 int write_file(const char *path, const char *buf, size_t buflen);
-const unsigned long read_num(const char *path);
+unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
 
 int thp_read_string(const char *name, const char * const strings[]);
 void thp_write_string(const char *name, const char *val);
-const unsigned long thp_read_num(const char *name);
+unsigned long thp_read_num(const char *name);
 void thp_write_num(const char *name, unsigned long num);
 
 void thp_write_settings(struct thp_settings *settings);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-thp_settings-remove-const-from-return-type.patch
selftests-mm-pagemap_ioctl-fix-types-mismatches-shown-by-compiler-options.patch
selftests-mm-mseal_test-remove-unused-variables.patch
selftests-mm-mremap_test-remove-unused-variable-and-type-mismatches.patch

