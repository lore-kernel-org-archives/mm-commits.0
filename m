Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DED0211A3E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990504; cv=none; b=G4aAZwEvJ6w2iMfQFaFBamE7woLl8GWLqJIr7s2u0FdSv7wz1IplxKmiFE7TUMydZ5PPjG4mAZ1G8VJ6lNBFeRsct/ZW1j7g11mI3NliNzdQ54uGnR4wg0xpTUWl+FW2WN2z/bBEerZVNyJORDa4jFjXuQ1X0YxJj/MkwRZ/yDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990504; c=relaxed/simple;
	bh=BLH6mkA2ucHVoZEoXGjVgU95Eh8xRGLUU3DKC4JNHnY=;
	h=Date:To:From:Subject:Message-Id; b=j5jX/W0rXRl+2TTlJfApV01h9ljpuhlVDTcUTRZhsMj776t1fvaDq0Onm3lmgE1M1QemJmaytaTCptafY/VtahDtXPPc/D8iknbz3xzQ53FfdVFAX0Z56xGMpTDNuR3o0JTaN4s55oy/8tL/4BfFcNLWzCZcFMpyB8cw3KDgP24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=esCfR9dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="esCfR9dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7429FC4CEE3;
	Mon,  7 Apr 2025 01:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990503;
	bh=BLH6mkA2ucHVoZEoXGjVgU95Eh8xRGLUU3DKC4JNHnY=;
	h=Date:To:From:Subject:From;
	b=esCfR9dn+DGnb7e4MxoZGj7cVKk39YpRjNPhevSiC8F02eloQbNVAHakTlz5yUkJz
	 duCfuM4qrIhj2nKLfeDx30044URp4rRwnNVcxKvoazAa5zZUOf6s6QThWoW3IjwAgm
	 GbgjKp0LtUv2LC5oW8DZEqPZBu9/0rZusEBcDVfo=
Date: Sun, 06 Apr 2025 18:48:22 -0700
To: mm-commits@vger.kernel.org,xiaopei01@kylinos.cn,vbabka@suse.cz,sfr@canb.auug.org.au,rmoar@google.com,masahiroy@kernel.org,linux@roeck-us.net,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-slub-add-module-description.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014823.7429FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: slub: add module description
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-slub-add-module-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-slub-add-module-description.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: kunit: slub: add module description
Date: Mon, 24 Mar 2025 18:32:35 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in lib/tests/slub_kunit.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-10-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Pei Xiao <xiaopei01@kylinos.cn>
Cc: Rae Moar <rmoar@google.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/slub_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/tests/slub_kunit.c~kunit-slub-add-module-description
+++ a/lib/tests/slub_kunit.c
@@ -325,4 +325,5 @@ static struct kunit_suite test_suite = {
 };
 kunit_test_suite(test_suite);
 
+MODULE_DESCRIPTION("Kunit tests for slub allocator");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are

exportfs-add-module-description.patch
asn1-add-module-description.patch
samples-livepatch-add-module-descriptions.patch
fpga-tests-add-module-descriptions.patch
xenbus-add-module-description.patch
zlib-add-module-description.patch
ucs2_string-add-module-description.patch
mm-kasan-add-module-decription.patch
kunit-slub-add-module-description.patch

