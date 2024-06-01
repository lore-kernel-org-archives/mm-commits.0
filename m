Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7F1EDC
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717202375; cv=none; b=QDsffmBD6hJhQ6L/Cj1eKMEwLIMjnIxj+NtrimPRfT17F9YkTuM7hs9pVdODIe/mhKtKw1v5EiclyIgMxKLSmwp/+xINvmEaWtd9Cp+WjluidAHrz4bQI+ugiXMUB4fTuZdLdg2H5curI+Igve5uHTNE2tPqwDlZmmjxEkNb48E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717202375; c=relaxed/simple;
	bh=QjQE6IiMq3Vl7vIrHNnFVnJC31Jw+AQ0iLfmaK9YtDc=;
	h=Date:To:From:Subject:Message-Id; b=lftVaP/zA/DcIAB7sikWSiEtZKT8JXsIhdbX8KxcypXwww/EqdgNOom6yM7a3WSSw9shpTcxfA9fG/4AsC81BU8/T+KSEHkOziBx3w1Ja/6VefFyCNUavhlcIo/0jnMxNww6detzZXk6pA7C2tdSnS3gKu+DXFh0JoEIrZCDn5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQ54gUjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQ54gUjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BFDC116B1;
	Sat,  1 Jun 2024 00:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717202375;
	bh=QjQE6IiMq3Vl7vIrHNnFVnJC31Jw+AQ0iLfmaK9YtDc=;
	h=Date:To:From:Subject:From;
	b=AQ54gUjdwNT7Lt8dAW6OICWR2xFN5A/hvagsUHcruDQmd7vIOwhF8/iwbgO4KTkuj
	 WuLTGXgVIL4cFLkCTE5BSldf/Ym1RDEdKSvisvD3quQnKKDH6n0l3WKXBTcPFWUDG/
	 7hd4jAm3MGLO448G4lXP2abV+N/fTtdwyPIcby94=
Date: Fri, 31 May 2024 17:39:34 -0700
To: mm-commits@vger.kernel.org,keescook@chromium.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-fortify-add-missing-module_description-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20240601003935.41BFDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit/fortify: add missing MODULE_DESCRIPTION() macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-fortify-add-missing-module_description-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-fortify-add-missing-module_description-macros.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: kunit/fortify: add missing MODULE_DESCRIPTION() macros
Date: Fri, 31 May 2024 15:45:22 -0700

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/memcpy_kunit.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/fortify_kunit.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Link: https://lkml.kernel.org/r/20240531-md-lib-fortify_source-v1-1-2c37f7fbaafc@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fortify_kunit.c |    1 +
 lib/memcpy_kunit.c  |    1 +
 2 files changed, 2 insertions(+)

--- a/lib/fortify_kunit.c~kunit-fortify-add-missing-module_description-macros
+++ a/lib/fortify_kunit.c
@@ -1099,4 +1099,5 @@ static struct kunit_suite fortify_test_s
 
 kunit_test_suite(fortify_test_suite);
 
+MODULE_DESCRIPTION("Runtime test cases for CONFIG_FORTIFY_SOURCE");
 MODULE_LICENSE("GPL");
--- a/lib/memcpy_kunit.c~kunit-fortify-add-missing-module_description-macros
+++ a/lib/memcpy_kunit.c
@@ -510,4 +510,5 @@ static struct kunit_suite memcpy_test_su
 
 kunit_test_suite(memcpy_test_suite);
 
+MODULE_DESCRIPTION("test cases for memcpy(), memmove(), and memset()");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

mm-hwpoison-add-module_description.patch
mm-dmapool-add-module_description.patch
mm-kfence-add-module_description.patch
mm-zsmalloc-add-module_description.patch
backtracetest-add-module_description.patch
dyndbg-add-missing-module_description-macro.patch
lib-ts-add-missing-module_description-macros.patch
kunit-fortify-add-missing-module_description-macros.patch

