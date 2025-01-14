Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3D8168DA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 04:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736828074; cv=none; b=uhrtKmX/PnLv31ewRrav+aRt7vCcCCGhTLbpBcUIfmzBvE9OXqyIn77mDaLrZsEHRF/kVBqQVpELrZTTE5m+xpqyVREywwxQoSGq+oHEdhc0CFfm6C3hfokQ1Ik53jbT8P8ebQsHVTCSAfYdKvB+wSbdu8LYrNsgCF+zaigR8zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736828074; c=relaxed/simple;
	bh=TZfJa+lCy24X+2+/49XejuYHA9pvMkTLaOortp9qFL0=;
	h=Date:To:From:Subject:Message-Id; b=VKL6JBNzLZYS2AncM9WXDYsEHwA/Rd3jSUlJptKwhsfLK80ZeZgLxCVMpLCYCFTjUxFCgBHTDqYw/XrU8AI0GtHFl0GmxcFSyMIYAYRHk9nvyrYL0Oai6Ip3EGrvBMdmGZBnsaImVOErPZ/UxVQ/2nyo1CJ4n8i7z5oy4C4PUOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kOSOf9Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kOSOf9Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C2BC4CEDF;
	Tue, 14 Jan 2025 04:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736828074;
	bh=TZfJa+lCy24X+2+/49XejuYHA9pvMkTLaOortp9qFL0=;
	h=Date:To:From:Subject:From;
	b=kOSOf9Bgbhd3bKcGupH65Cg29NdI+GK0s91+oBgqNYZQhBPAxsKHputOcbGTNz1Xp
	 0hCBuh+J9ZRZZh7ASa3YpVTN64WtL+cSgDmJj9nCJYEQOB9of9RGsH6jlvd80CYcML
	 Uq0s9K/+5tEj2wUNfomJ6lwGdG785SrfhoKWCYrQ=
Date: Mon, 13 Jan 2025 20:14:33 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sauravshah.31@gmail.com,lorenzo.stoakes@oracle.com,jeffxu@google.com,isaacmanjarres@google.com,gthelen@google.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd-memfd_test-fix-possible-null-pointer-dereference.patch added to mm-unstable branch
Message-Id: <20250114041434.44C2BC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/memfd/memfd_test: fix possible NULL pointer dereference
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-memfd-memfd_test-fix-possible-null-pointer-dereference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd-memfd_test-fix-possible-null-pointer-dereference.patch

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
From: liuye <liuye@kylinos.cn>
Subject: selftests/memfd/memfd_test: fix possible NULL pointer dereference
Date: Tue, 14 Jan 2025 11:21:15 +0800

If `name' is NULL, a NULL pointer may be accessed in printf.

Link: https://lkml.kernel.org/r/20250114032115.58638-1-liuye@kylinos.cn
Signed-off-by: liuye <liuye@kylinos.cn>
Cc: Greg Thelen <gthelen@google.com>
Cc: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Saurav Shah <sauravshah.31@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-memfd_test-fix-possible-null-pointer-dereference
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -171,7 +171,7 @@ static void mfd_fail_new(const char *nam
 	r = sys_memfd_create(name, flags);
 	if (r >= 0) {
 		printf("memfd_create(\"%s\", %u) succeeded, but failure expected\n",
-		       name, flags);
+		       name ? name : "NULL", flags);
 		close(r);
 		abort();
 	}
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios.patch
selftests-memfd-memfd_test-fix-possible-null-pointer-dereference.patch

