Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756B738F91
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957147; cv=none; b=LLEb9j2R18BZ8g4hXKjxH06Ix0er5rwdIrr7Zvb87x/bh3bU4YJpnpJYLMk7H4wzqfy3h7x1zdvwOllemjyxb2E5XWDFR21pKpH4YchK+DsRiPy+rWEm3O8bsdnIV1n2t50JuaUKW92CmDgOfyl9uiOOC7Y0++i6qjiUwLOM5CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957147; c=relaxed/simple;
	bh=wssnyR7w1Bz0p+tXtD1eEWUeEZBDfG7Uw5KHgv1+BDY=;
	h=Date:To:From:Subject:Message-Id; b=la7YF8iAIL3bX3RwBvR3xgs2jPEBFUa2ufNO9jHhqNRe04A9GiJPfd1Mftp2APSIeUmL6U20G7VFuUnXk0KEPNtW07CWvWJwauo/1HBcv2XDM4PLifiJKtrqbq2VwguOgk+eV+JuqWF6aHw++LR53sRkDxdUyXMHEyjiSaLTlO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krWBKRTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krWBKRTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED658C116B1;
	Mon,  6 May 2024 00:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957147;
	bh=wssnyR7w1Bz0p+tXtD1eEWUeEZBDfG7Uw5KHgv1+BDY=;
	h=Date:To:From:Subject:From;
	b=krWBKRTBR0wD1J5azbrGPSgxdrRj6Y4yz/6A4BxJ/xquKprxg5rXQUbk6mMTDiksU
	 OBak2+IRUKKgpwSkjUb6FlxlQmbUNL0wvZgCcaFdeVN5ZDQ2hdU8+EXqDuHOkL8EyN
	 LltAb4nVwddmSKgVrtmaY7GkxlhTKy3Elnm0hCwI=
Date: Sun, 05 May 2024 17:59:06 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jeffxu@google.com,gthelen@google.com,cyphar@cyphar.com,sauravshah.31@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-fix-spelling-mistakes.patch removed from -mm tree
Message-Id: <20240506005906.ED658C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd: fix spelling mistakes
has been removed from the -mm tree.  Its filename was
     selftests-memfd-fix-spelling-mistakes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Saurav Shah <sauravshah.31@gmail.com>
Subject: selftests/memfd: fix spelling mistakes
Date: Thu, 2 May 2024 04:43:17 +0530

Fix spelling mistakes in the comments.

Link: https://lkml.kernel.org/r/20240501231317.24648-1-sauravshah.31@gmail.com
Signed-off-by: Saurav Shah <sauravshah.31@gmail.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/fuse_test.c  |    2 +-
 tools/testing/selftests/memfd/memfd_test.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/memfd/fuse_test.c~selftests-memfd-fix-spelling-mistakes
+++ a/tools/testing/selftests/memfd/fuse_test.c
@@ -306,7 +306,7 @@ int main(int argc, char **argv)
 	 * then the kernel did a page-replacement or canceled the read() (or
 	 * whatever magic it did..). In that case, the memfd object is still
 	 * all zero.
-	 * In case the memfd-object was *not* sealed, the read() was successfull
+	 * In case the memfd-object was *not* sealed, the read() was successful
 	 * and the memfd object must *not* be all zero.
 	 * Note that in real scenarios, there might be a mixture of both, but
 	 * in this test-cases, we have explicit 200ms delays which should be
--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-fix-spelling-mistakes
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -1528,7 +1528,7 @@ static void test_share_open(char *banner
 
 /*
  * Test sharing via fork()
- * Test whether seal-modifications work as expected with forked childs.
+ * Test whether seal-modifications work as expected with forked children.
  */
 static void test_share_fork(char *banner, char *b_suffix)
 {
_

Patches currently in -mm which might be from sauravshah.31@gmail.com are


