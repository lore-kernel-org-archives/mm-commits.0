Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F1B7DA7B
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248754; cv=none; b=OYqn0P3m9KANeCuety2ebFxPkqwncSlQqvPL3SOuP+K7Ywsz4KEeR5MaUihDX4X9jzgdPcDrkhHlUlo0mG/eviNvn0U1sKQiiWDzs+bw6/QxaSLuzh2eoFYqTqRV/itwONwrfpH5s/Ah6XhRlqW58xBe1m/+56hmn4H6Dx4s1W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248754; c=relaxed/simple;
	bh=JNXjk5IXjmg81IZrBPFKgdqsEz/43zWjmtMUqi2kp2Y=;
	h=Date:To:From:Subject:Message-Id; b=jgyMETYNLm3yyb4Xt7UwLY+ntCOeOgLRsqwObJUX3Hrsx9B3Zw6h0dK4KWbrYcQq8fj6qExQmQhjYINKoxJ4x7gEgeMt8Y1pH5eydUZ/TWxQOjyLcAQyi5BTuOQDIcTVrPaksJnZWenVpJda5I605+/socEPMPMkZO4+btScPA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z/+Ceic5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z/+Ceic5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5C1C4CEC2;
	Mon,  2 Sep 2024 03:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248753;
	bh=JNXjk5IXjmg81IZrBPFKgdqsEz/43zWjmtMUqi2kp2Y=;
	h=Date:To:From:Subject:From;
	b=Z/+Ceic5OApbNpG+ZHsD/ovVpZwu4/Ju/kFQc8K8mdTjQC14phBysA5+TJt/KDuE9
	 pQieYXUp8Y0Z0wTdIz5cBaLlCp5J/STUsoW2STTbqpMM7egQMP5cmSAT9rieYodTiR
	 qLQRMB/v33HKlad9NswUz03zJp0dwWYzvw+06+9o=
Date: Sun, 01 Sep 2024 20:45:53 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,nogikh@google.com,linux@rasmusvillemoes.dk,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-dont-instrument-lib-find_bitc.patch removed from -mm tree
Message-Id: <20240902034553.CA5C1C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: don't instrument lib/find_bit.c
has been removed from the -mm tree.  Its filename was
     kcov-dont-instrument-lib-find_bitc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@gmail.com>
Subject: kcov: don't instrument lib/find_bit.c
Date: Tue, 23 Jul 2024 00:37:26 +0200

This file produces large amounts of flaky coverage not useful for the
KCOV's intended use case (guiding the fuzzing process).

Link: https://lkml.kernel.org/r/20240722223726.194658-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Makefile~kcov-dont-instrument-lib-find_bitc
+++ a/lib/Makefile
@@ -14,6 +14,7 @@ KCOV_INSTRUMENT_list_debug.o := n
 KCOV_INSTRUMENT_debugobjects.o := n
 KCOV_INSTRUMENT_dynamic_debug.o := n
 KCOV_INSTRUMENT_fault-inject.o := n
+KCOV_INSTRUMENT_find_bit.o := n
 
 # string.o implements standard library functions like memset/memcpy etc.
 # Use -ffreestanding to ensure that the compiler does not try to "optimize"
_

Patches currently in -mm which might be from andreyknvl@gmail.com are

kasan-simplify-and-clarify-makefile.patch
kasan-simplify-and-clarify-makefile-v2.patch

