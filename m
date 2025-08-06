Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7710419F420
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754447564; cv=none; b=qfRqJV9kUSa9c1SaXvsdATawc2nbY0RJYj4exB/5c8FWgZcaKZ8+5GGim0bonMDGYnZJBhqHPqVuW/NheFO9bvV86KTf7heXXa72C6riZgMuzWyoT6L2hGAeyS89NL3cPpPKOhtyUcvDmCOdnNB1rRMcX/vnT3LQfjSz9GEZTFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754447564; c=relaxed/simple;
	bh=nRX1Qto8l8UuYYGcMqHpI/DTAH7g3aFbB1ZKssDlUKU=;
	h=Date:To:From:Subject:Message-Id; b=oiwb6dh/3T8hsz/7LczAkHrB1Wl5EoGZhi925ljeUmMHGQHq2ungz/DpxBGPSvnhkkjNOSQ1MVKf/r8CAh2C3o9WUnMPIKLS1zjuAtto2q9OWZTegK48HfLUXHUTsUQCdgh9yLMQ49bVpYKIo35wuU87YM3xPCT93+NUFYPO4PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLstdnBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLstdnBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCE3C4CEF0;
	Wed,  6 Aug 2025 02:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754447564;
	bh=nRX1Qto8l8UuYYGcMqHpI/DTAH7g3aFbB1ZKssDlUKU=;
	h=Date:To:From:Subject:From;
	b=HLstdnBcvQzRnXN0i0ctCszh3oVwczt7EU7pf0WzOFO6X1RqS6iH94hJos3NUSmcc
	 FjfRAcbY4ZkJWBi4l4QQWvGSvjPEVfggzPDU0Ew44yyW4mrI5tQBvPITMXMduwAPEu
	 Xjwp+N9/9jPaBi3/RgVBV09V5s5jluH8+b8UG7dU=
Date: Tue, 05 Aug 2025 19:32:43 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-make-kasan=onoff-take-effect-for-all-three-modes.patch added to mm-new branch
Message-Id: <20250806023243.ECCE3C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: make kasan=on|off take effect for all three modes
has been added to the -mm mm-new branch.  Its filename is
     mm-kasan-make-kasan=onoff-take-effect-for-all-three-modes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-make-kasan=onoff-take-effect-for-all-three-modes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/kasan: make kasan=on|off take effect for all three modes
Date: Tue, 5 Aug 2025 14:23:33 +0800

Now everything is ready, set kasan=off can disable kasan for all three
modes.

Link: https://lkml.kernel.org/r/20250805062333.121553-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan-enabled.h |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/include/linux/kasan-enabled.h~mm-kasan-make-kasan=onoff-take-effect-for-all-three-modes
+++ a/include/linux/kasan-enabled.h
@@ -8,30 +8,21 @@ extern bool kasan_arg_disabled;
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
-#ifdef CONFIG_KASAN_HW_TAGS
-
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
 }
 
+#ifdef CONFIG_KASAN_HW_TAGS
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return kasan_enabled();
 }
-
 #else /* CONFIG_KASAN_HW_TAGS */
-
-static inline bool kasan_enabled(void)
-{
-	return IS_ENABLED(CONFIG_KASAN);
-}
-
 static inline bool kasan_hw_tags_enabled(void)
 {
 	return false;
 }
-
 #endif /* CONFIG_KASAN_HW_TAGS */
 
 #endif /* LINUX_KASAN_ENABLED_H */
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled.patch
mm-kasan-move-kasan=-code-to-common-place.patch
mm-kasan-dont-initialize-kasan-if-its-disabled.patch
mm-kasan-make-kasan=onoff-take-effect-for-all-three-modes.patch

