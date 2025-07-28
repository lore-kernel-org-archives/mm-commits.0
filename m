Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D096F22A817;
	Mon, 28 Jul 2025 20:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753735822; cv=none; b=gPdJN4nJTJOeDgNCoHo8QuRaLZ62FnJSaZ9qBWL/WHMDplllVuzJfmAyOaBQ78Xha3Uf+YoeQaQzVRnvHuJajoWCR9i6STT0gdtaTg/QloUcXFVwePnD+7kEAQrQeurG1Z37xmf7//TLHQAVDrPO6qRPE5mtJECUGZ+MhPsEuds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753735822; c=relaxed/simple;
	bh=CLJt5ntYMJAdQqB6UlaIzQFx6fzecooQr9En9jZM6ns=;
	h=Date:To:From:Subject:Message-Id; b=tQluSsVrQfeli1V3sEDsgv/UmTZYhOcRyUTF13oV+qa2X1SYUwa4nlJmNRODipC9Ojm/TNTD2umzihYw01Xb8LSLo5pAwTME1q6L+jl+8Jxeu7mwkZHF5uKbIgnfxA12JQuzaylFdLLBzItUbg1iFQokbGammhDn/aPxyOJAFFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SwH5kxsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SwH5kxsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BE3C4CEE7;
	Mon, 28 Jul 2025 20:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753735820;
	bh=CLJt5ntYMJAdQqB6UlaIzQFx6fzecooQr9En9jZM6ns=;
	h=Date:To:From:Subject:From;
	b=SwH5kxsQpLfYVEKC5ogH2iWLi6wHv5pKA9z8rliYcNkTXnjmMgTYlUzNFnh7uyHcY
	 ySwkxjKtbZV87QeypT4hUn0ISl3/bswwLH691o9npbS+mNLzB/xCe5+/cgq90Jz/6o
	 L0CyGh462Yslx+32Vl17MWNZCvbsIM4n8EbUOyoM=
Date: Mon, 28 Jul 2025 13:50:19 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,stable@vger.kernel.org,ryabinin.a.a@gmail.com,niharchaithanya@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-test-fix-protection-against-compiler-elision.patch added to mm-hotfixes-unstable branch
Message-Id: <20250728205020.56BE3C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan/test: fix protection against compiler elision
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-test-fix-protection-against-compiler-elision.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-test-fix-protection-against-compiler-elision.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jann Horn <jannh@google.com>
Subject: kasan/test: fix protection against compiler elision
Date: Mon, 28 Jul 2025 22:11:54 +0200

The kunit test is using assignments to
"static volatile void *kasan_ptr_result" to prevent elision of memory
loads, but that's not working:
In this variable definition, the "volatile" applies to the "void", not to
the pointer.
To make "volatile" apply to the pointer as intended, it must follow
after the "*".

This makes the kasan_memchr test pass again on my system.  The
kasan_strings test is still failing because all the definitions of
load_unaligned_zeropad() are lacking explicit instrumentation hooks and
ASAN does not instrument asm() memory operands.

Link: https://lkml.kernel.org/r/20250728-kasan-kunit-fix-volatile-v1-1-e7157c9af82d@google.com
Fixes: 5f1c8108e7ad ("mm:kasan: fix sparse warnings: Should it be static?")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Nihar Chaithanya <niharchaithanya@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/kasan_test_c.c~kasan-test-fix-protection-against-compiler-elision
+++ a/mm/kasan/kasan_test_c.c
@@ -47,7 +47,7 @@ static struct {
  * Some tests use these global variables to store return values from function
  * calls that could otherwise be eliminated by the compiler as dead code.
  */
-static volatile void *kasan_ptr_result;
+static void *volatile kasan_ptr_result;
 static volatile int kasan_int_result;
 
 /* Probe for console output: obtains test_status lines of interest. */
_

Patches currently in -mm which might be from jannh@google.com are

kasan-test-fix-protection-against-compiler-elision.patch
kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch
mm-rmap-add-anon_vma-lifetime-debug-check.patch

