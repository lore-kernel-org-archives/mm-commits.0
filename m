Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38471C32EB
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150138; cv=none; b=W1tsZ/S5zbruD9TKZOWNhk/UaAXc9as2wNULQSEXHzSjhnETaQlYGlGv70Qe7mk6aj/FCm9/AMsPUtvp/d7hrtlF+lBDq/0xE8kgpXsE4qqgbwDngBHBj9TdxQ394ni3ZlNq4pr+c3Io7iN/h4GHhs+iVTO97J9TfheasC1kiFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150138; c=relaxed/simple;
	bh=w2cfJ28FOPyV7Kz0SpStHnCgXdI/aOoXsDDOVIAvfXQ=;
	h=Date:To:From:Subject:Message-Id; b=O9hPEzX/xTSkFT9johK+GY6e5MX62NQslvMgxtnt8JH4v4WBcmiL43kkXR7jag6LZmBKBlxwi1lyMrTVaFK9x+qNJp+0SQzz0T/he3oFNuEPrF5tmeTkkXxRPz7aREy9IfRRZAzZvRKUzcu0g2soyF1Pg7NAe712hcZ7SBLNtlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uYCQE7F8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uYCQE7F8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C54BC4CEC3;
	Thu, 17 Oct 2024 07:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150138;
	bh=w2cfJ28FOPyV7Kz0SpStHnCgXdI/aOoXsDDOVIAvfXQ=;
	h=Date:To:From:Subject:From;
	b=uYCQE7F88FM7uJ3NZzwy/FsT0mIyfqM+DhKGR3HQv1cxNOGhU/7RPGNwpTM/6WqWJ
	 /QtPsaPkfP9l0PQqbYjhlKgbHCBDhZJupXlqs/nuIG7iaoQu/cES3DQmGIkVao7BK0
	 ZRxxSVSGuuSSVm9BaISMb1kSy2PpjVMB/MSZa2cI=
Date: Thu, 17 Oct 2024 00:28:57 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-kasan-kcov-add-bugzilla-links.patch removed from -mm tree
Message-Id: <20241017072858.3C54BC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: kasan, kcov: add bugzilla links
has been removed from the -mm tree.  Its filename was
     maintainers-kasan-kcov-add-bugzilla-links.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: MAINTAINERS: kasan, kcov: add bugzilla links
Date: Sun, 13 Oct 2024 00:55:24 +0200

Add links to the Bugzilla component that's used to track KASAN and KCOV
issues.

Link: https://lkml.kernel.org/r/20241012225524.117871-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-kasan-kcov-add-bugzilla-links
+++ a/MAINTAINERS
@@ -12242,6 +12242,7 @@ R:	Dmitry Vyukov <dvyukov@google.com>
 R:	Vincenzo Frascino <vincenzo.frascino@arm.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
+B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
 F:	Documentation/dev-tools/kasan.rst
 F:	arch/*/include/asm/*kasan.h
 F:	arch/*/mm/kasan_init*
@@ -12265,6 +12266,7 @@ R:	Dmitry Vyukov <dvyukov@google.com>
 R:	Andrey Konovalov <andreyknvl@gmail.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
+B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
 F:	Documentation/dev-tools/kcov.rst
 F:	include/linux/kcov.h
 F:	include/uapi/linux/kcov.h
_

Patches currently in -mm which might be from andreyknvl@gmail.com are


