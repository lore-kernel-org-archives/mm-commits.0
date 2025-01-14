Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CF223C70B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837032; cv=none; b=FwmmrCXYBHUCPNK74bOHVLNwhOgwPl/hXYzB141sG71zXxHgV2/KdPMbz3p1Ij00ThWHCCA8jYKh9gZecLrcvuWhf9OH0xWGzdsx9tyHS9akuQG59YS4QQrOBC/v7D9O7/tF3+DByuJ2OrbdmkNEZR9UxSxqU7GZGLKxpSCcGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837032; c=relaxed/simple;
	bh=/slQ8DiiB/2AFnk1VQzOCRZ4bAv9cHDdbBBujS8B7jE=;
	h=Date:To:From:Subject:Message-Id; b=GDiiCiHxvVYg46SqkPwblBJEoe298wSo0F5uMzuMZByIljmYeVeDtW6gNHXPTr7ozZX+ud1KFQlBaPn6glMXj9g/4xKi7eKRqfCUCJkepVb3XSR6/kXo09dU192ZgEeLUDKZBNJwkt9ATBCXqhlnSFVZ94LFhwylGUNuo6BM/ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SIYJ668y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SIYJ668y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD994C4CEDD;
	Tue, 14 Jan 2025 06:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837032;
	bh=/slQ8DiiB/2AFnk1VQzOCRZ4bAv9cHDdbBBujS8B7jE=;
	h=Date:To:From:Subject:From;
	b=SIYJ668y3owtP9lCVnqFLDQ4KsjTvVYEbLzQF8//Yw1RZauuu++w/SdcsSzpBY/Sl
	 qJ7oDD2GWud7HzgVScBToD3gkveSJqg8pcum2trBXuRZrTGcWskN+ObsywLlQDD9eX
	 kprRfeQjsmtjihm99E3PYZ91yBRi0HagUXDA1X14=
Date: Mon, 13 Jan 2025 22:43:51 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,david@redhat.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-thp_settings-remove-const-from-return-type.patch removed from -mm tree
Message-Id: <20250114064351.DD994C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: thp_settings: remove const from return type
has been removed from the -mm tree.  Its filename was
     selftests-mm-thp_settings-remove-const-from-return-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-mm-remove-argc-and-argv-unused-parameters.patch
selftests-mm-fix-unused-parameter-warnings.patch
selftests-mm-fix-type-mismatch-warnings.patch
selftests-mm-kselftest_harness-fix-warnings.patch
selftests-mm-cow-remove-unused-variables-and-fix-type-mismatch-errors.patch
selftests-mm-hmm-tests-remove-always-false-expressions.patch
selftests-mm-guard-pages-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-madvise-fix-type-mismatch-issues.patch
selftests-mm-hugepage-vmemmap-fix-type-mismatch-warnings.patch
selftests-mm-hugetlb-read-hwpoison-fix-type-mismatch-warnings.patch
selftests-mm-khugepaged-fix-type-mismatch-warnings.patch
selftests-mm-protection_keys-fix-variables-types-mismatch-warnings.patch
selftests-mm-thuge-gen-fix-type-mismatch-warnings.patch
selftests-mm-uffd-fix-all-type-mismatch-warnings.patch
selftests-mm-makefile-add-the-compiler-flags.patch

