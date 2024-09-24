Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD23101DE
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 23:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727219878; cv=none; b=X7g3FJaaAx9alEkCgdK1IwzK+N75XAkrv+yWIJFu2Stqmx/+9n9WdRPDf99FlVfLx1z026o/fxxK7MadkZsxuIMMI0tQN9t9XSF5Ne6W4PhmTtkldFk9tqBxfTIzaoiOimnMLb4DF37fplcQa+n6RzWzUYex4VMzMFe5vLVIOCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727219878; c=relaxed/simple;
	bh=+5/Q2Dv4dJb79M0cz3v2GSa4Sn2WWNdLEk3LygI/EXI=;
	h=Date:To:From:Subject:Message-Id; b=CxMTFWSDHHCzj5wLBOJiuLwY65MuagO63VBtEzcJvTo+ssChqzoP0Kvh7kgKWnJDGfN47GDdjwgPmlP34G1u/pIl+5KlUAqNxJ+zB8wvGww71Li+AHknU/kzzo8y6AnNs6IOhHapdL1qNx1HlXwbTBA7MP6oM/BHfAJOwGQT0hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P2ZFfvuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P2ZFfvuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EA5C4CEC4;
	Tue, 24 Sep 2024 23:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727219878;
	bh=+5/Q2Dv4dJb79M0cz3v2GSa4Sn2WWNdLEk3LygI/EXI=;
	h=Date:To:From:Subject:From;
	b=P2ZFfvuSF/m1zuPQhCGeHEtOaiybV5hAy+k7Y1n7YLBe/Q223RDPDRsOGkm1uulGg
	 xkllrGEsmIAf3AGmAfEe+4CxvqBgB9zxTVwTKYJwYaqlHaFFbfA8aNyALOYE+HAOQP
	 GY1CcZf/1uoyPFrgWE8rQywu79LhfLhJredCeo0Y=
Date: Tue, 24 Sep 2024 16:17:57 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,ruanjinjie@huawei.com,leocstone@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-fix-sparse-warning-for-zero-initializer.patch added to mm-unstable branch
Message-Id: <20240924231757.E7EA5C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: fix sparse warning for zero initializer
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-fix-sparse-warning-for-zero-initializer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-fix-sparse-warning-for-zero-initializer.patch

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
From: Leo Stone <leocstone@gmail.com>
Subject: mm/damon: fix sparse warning for zero initializer
Date: Sun, 22 Sep 2024 19:25:18 -0700

sparse warns about zero initializing an array with {0,}, change it to
the equivalent {0}.

Fixes the sparse warning:
mm/damon/tests/vaddr-kunit.h:69:47: warning: missing braces around initializer

Link: https://lkml.kernel.org/r/xriwklcwjpwcz7eiavo6f7envdar4jychhsk6sfkj5klaznb6b@j6vrvr2sxjht
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: Leo Stone <leocstone@gmail.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-fix-sparse-warning-for-zero-initializer
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -66,7 +66,7 @@ failed:
 static void damon_test_three_regions_in_vmas(struct kunit *test)
 {
 	static struct mm_struct mm;
-	struct damon_addr_range regions[3] = {0,};
+	struct damon_addr_range regions[3] = {0};
 	/* 10-20-25, 200-210-220, 300-305, 307-330 */
 	struct vm_area_struct vmas[] = {
 		(struct vm_area_struct) {.vm_start = 10, .vm_end = 20},
_

Patches currently in -mm which might be from leocstone@gmail.com are

mm-damon-fix-sparse-warning-for-zero-initializer.patch

