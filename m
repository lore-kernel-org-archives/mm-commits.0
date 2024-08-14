Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED13A1BF315
	for <mm-commits@vger.kernel.org>; Wed, 14 Aug 2024 20:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723667246; cv=none; b=M/bRZS22S1CtwpDPDf2ZXY5VTs9q9EyJ2LXUB6jwVeagR0l7bSeKzjghZ7C9ntSB5jcBCeW8n1YTph4QvtPFdQ6m9fvH92RmHJ8zbFg71qKkP+WcOsTdWJ4fSM/n+gofWitvoeMvmwcct0YlyFUnfb1Uz7y8J3OJPgB5xdCNCOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723667246; c=relaxed/simple;
	bh=cqjbVCajIfTfZ+v4/JuARLfSuSEqoZBLqjYSfaAPuac=;
	h=Date:To:From:Subject:Message-Id; b=FJIx45iRAdVk48KGddCpKNYeBuC48eE4Xay3P8UJUxqroy+QlG0yM9rXpWaL17fl+Vyqiug0yK2uJccPlqdaGC3esmBhCGscDI1ETjw7jDTHqEgD7HmlpjyL6QhQef3SQMXggq3o0T6/uAyq15oPhc0UIHrSNwIYyWCbq4hO/wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i6Lt47UN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i6Lt47UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE36C116B1;
	Wed, 14 Aug 2024 20:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723667245;
	bh=cqjbVCajIfTfZ+v4/JuARLfSuSEqoZBLqjYSfaAPuac=;
	h=Date:To:From:Subject:From;
	b=i6Lt47UNQdLf7GQo4YeLOug8O62yI5MdKMGJiokTBoyYbtTZ0XB1IyA2I5KNrMBnT
	 izK9zeJZxdGPR26ejJQ+WVyNMrcI5ifZDeICZjd58F5hphL+s5tGQfrVaYE42roLdT
	 ZKTP6icecSfeWLcR4KtM/VdueLjDTzMQIxqLzxJ4=
Date: Wed, 14 Aug 2024 13:27:24 -0700
To: mm-commits@vger.kernel.org,ojeda@kernel.org,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-simplify-and-clarify-makefile-v2.patch added to mm-unstable branch
Message-Id: <20240814202725.5BE36C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kasan-simplify-and-clarify-makefile-v2
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-simplify-and-clarify-makefile-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-simplify-and-clarify-makefile-v2.patch

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
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kasan-simplify-and-clarify-makefile-v2
Date: Wed, 14 Aug 2024 18:10:52 +0200

comments fixes per Miguel

Link: https://lkml.kernel.org/r/20240814161052.10374-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/scripts/Makefile.kasan~kasan-simplify-and-clarify-makefile-v2
+++ a/scripts/Makefile.kasan
@@ -34,13 +34,15 @@ endif
 # First, enable -fsanitize=kernel-address together with providing the shadow
 # mapping offset, as for GCC, -fasan-shadow-offset fails without -fsanitize
 # (GCC accepts the shadow mapping offset via -fasan-shadow-offset instead of
-# a normal --param). Instead of ifdef-checking the compiler, rely on cc-option.
+# a --param like the other KASAN parameters).
+# Instead of ifdef-checking the compiler, rely on cc-option.
 CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
 		-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
 		$(call cc-option, -fsanitize=kernel-address \
 		-mllvm -asan-mapping-offset=$(KASAN_SHADOW_OFFSET)))
 
-# Now, add other parameters enabled in a similar way with GCC and Clang.
+# Now, add other parameters enabled similarly in both GCC and Clang.
+# As some of them are not supported by older compilers, use cc-param.
 CFLAGS_KASAN += $(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
 		$(call cc-param,asan-stack=$(stack_enable)) \
 		$(call cc-param,asan-instrument-allocas=1) \
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-simplify-and-clarify-makefile.patch
kasan-simplify-and-clarify-makefile-v2.patch
kcov-dont-instrument-lib-find_bitc.patch

