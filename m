Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8623A134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418016; cv=none; b=csMFHcQGwhzGvuVxqS0HVSSamRxTEinEq/iR5rikibOcCWn9707e03TDjPfqJYUJf7wAA1rJTaYmJxAtcn27MfO0fvYXrc9KsD3QTj/LJmPEmg35/R++JfvNCTS0Vq3zpeoUPDHlSqzVIfT4rjSQa0ZYpseDDnWky0GzdOSDwSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418016; c=relaxed/simple;
	bh=11dEhJupsFOjSFyF3MGS7y6WwiUfe0qsMwQAQZj4T+k=;
	h=Date:To:From:Subject:Message-Id; b=Ir7ROKQMeJ9JPywJoAps/yaAzt1ACJZ01SAfvpJDR+RXZqEd/xcbCAuq88L3KEhAJX/2I7HRBH+Duf3kxY7dEYLDivsfDwcsaBy0PBkATOscXoQfCsPMgeBOGaRmn860SBf8U/LgOzkppgnvmPxMH0AUSBrwRJDjifsIVkErFD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1vMTMY+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1vMTMY+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA64C4CEE2;
	Sat, 12 Apr 2025 00:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418016;
	bh=11dEhJupsFOjSFyF3MGS7y6WwiUfe0qsMwQAQZj4T+k=;
	h=Date:To:From:Subject:From;
	b=1vMTMY+AYFQf67NMrplLD++3EpvcSyOlPetgejp6tFUp4tYApwP59qq6u2yTsvE4E
	 yaUXzxS6u9x6hsqnxXE3JBIOL8sb3XpI/tcW3/QYNFX0WqG0NeKsYi7Dj5ADcCGPoX
	 L/vJ+NQiEJguFgtL7LZt/fGSyN/tO35m34j4OCsU=
Date: Fri, 11 Apr 2025 17:33:35 -0700
To: mm-commits@vger.kernel.org,xiaopei01@kylinos.cn,vbabka@suse.cz,sfr@canb.auug.org.au,rmoar@google.com,masahiroy@kernel.org,linux@roeck-us.net,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kunit-slub-add-module-description.patch removed from -mm tree
Message-Id: <20250412003336.5AA64C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit: slub: add module description
has been removed from the -mm tree.  Its filename was
     kunit-slub-add-module-description.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kunit: slub: add module description
Date: Mon, 24 Mar 2025 18:32:35 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in lib/tests/slub_kunit.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-10-arnd@kernel.org
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
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


