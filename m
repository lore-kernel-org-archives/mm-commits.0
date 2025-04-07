Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE14B1A238A
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990502; cv=none; b=kmDw0TyIFqLcLeLrIeflX/XRSc5KdaNjggv0YVpDfeeafTd9iWG54bHmurvA8kecyAOmxJPALyI/m6Gd+G7ISI5fIRQYnUa9pv/nYOvS/jwbYvPgD/qGy6QcQuJOj1PIzF+BR+kGFubN/j5sSetH1gyRngASvTJobh9nZGHIWes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990502; c=relaxed/simple;
	bh=ss2anqzb7bYGMd7A72klJLI4pQ2E/PP5Y790aoKI4kg=;
	h=Date:To:From:Subject:Message-Id; b=nTwRfo/GKxwwpHbYjdPGblSCze4CR1KOZaXqGLtz6VQ94qTgpo2+Nkq8p2bSlwGzpI4iydKbXM0KpKklYbW+ukU6mcg1RXdS97qFcwS6w0eUaM+pdYiEpAHU+DPhvV4HNj3dvEbGjVvfL4yidyrbdYq46sZj5wu3ljdxUlIjUUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1oYOBYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1oYOBYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E04C4CEE3;
	Mon,  7 Apr 2025 01:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990501;
	bh=ss2anqzb7bYGMd7A72klJLI4pQ2E/PP5Y790aoKI4kg=;
	h=Date:To:From:Subject:From;
	b=W1oYOBYn21nl+MJctGvGfh62QaFoB4/4BRkMEra2vtwIiDA4XNdPrnbu+y2men7Hz
	 9Bpjfv4oSWIOsg90FGNrUEs1e2harfslSgZKqIgYCPdte6QSaeQpyBfjtgquP+BeCn
	 9vH3OR6V6Sl4Fp+b9CNiLbQiM8f5tM6HGOzaSNfc=
Date: Sun, 06 Apr 2025 18:48:20 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,snovitoll@gmail.com,sfr@canb.auug.org.au,ryabinin.a.a@gmail.com,peterz@infradead.org,niharchaithanya@gmail.com,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,jannh@google.com,glider@google.com,elver@google.com,dvyukov@google.com,arnd@arndb.de,andreyknvl@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-add-module-decription-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014821.56E04C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-kasan-add-module-decription-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-kasan-add-module-decription-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-add-module-decription-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kasan-add-module-decription-fix
Date: Sun Apr  6 06:46:45 PM PDT 2025

update description text, per Andrey

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Macro Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nihar Chaithanya <niharchaithanya@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-add-module-decription-fix
+++ a/mm/kasan/kasan_test_c.c
@@ -2127,5 +2127,5 @@ static struct kunit_suite kasan_kunit_te
 
 kunit_test_suite(kasan_kunit_test_suite);
 
-MODULE_DESCRIPTION("kunit test case for kasan");
+MODULE_DESCRIPTION("KUnit tests for checking KASAN bug-detection capabilities");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radix-tree-add-missing-cleanuph-fix.patch
samples-livepatch-add-module-descriptions-fix.patch
mm-kasan-add-module-decription-fix.patch

