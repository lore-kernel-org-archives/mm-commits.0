Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254755;
	b=zIId2XNWJGKoHhME/uVxMT2/XDXCcCJrky4SRG+OAllXAMSpuSGldeuP4NAH0PQRe2Nd
	 XzBkKRn2NXyAzdiWr1gjhF5Czse1Tt198w2Rg1x33fhkP4gAn7NfqQM6ODL2uKECNNf3S
	 ZAzpwOZ8I8Wd1mBqgytHC2VggD/hwMjXdYQuyyCb9hTIRFC8OFeIzs/hEviZTDGeuNN01
	 yQDOiTK7p9XlsHbuQC1JD4GaAaMWepe+hmmoXgUNNVLBvEVSDg4prCBQUGjshCKpZQKOY
	 yAN6KCjHX0qgLRudu8EU6RPbtS72CoLOCLRriW1ZjJYTXLCQutvrKRW4ki0CZn364qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254755;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mle/wzSABEp2eykZUXDopMAb/bI26B0W46Gah3FGYV0=;
	b=huSsgWyimi5Ryx0C5L3fTEOZ0g2g0xPH4AaHbHjvbWa6TP+Jdy0P9d9vTmobGrzAIoWk
	 A0NkmKm1iXQwYAx2x3vWSt67ZYfrVTLeSfr7IiQQSPwEX2Sr3Y8JvqgbjfobpdLVHiNww
	 RorVmKG/TFiYN+Z1+ZhdXLMlHvdFdpmPE9GlirRsShV7ThMwi+NuhLu3Udzqttbx+wVIl
	 jmsTSOek28JjbWQFCeAsCVpBYoQrh4vz91HT1KWCX1KJes7CILTZ8TrDbWKG5FyOCAbgt
	 0oIK9ucIbhhQYXasQnvfDTH8wTMGDrEtkSRMlDnqQnx3xAH1ISlV05KRYgFpk0LC0dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ig5U3Ai5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1361F606A31E
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ig5U3Ai5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AF11F01825;
	Thu, 29 Oct 2026 06:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254754;
	bh=mle/wzSABEp2eykZUXDopMAb/bI26B0W46Gah3FGYV0=;
	h=Date:To:From:Subject;
	b=Ig5U3Ai5svkA1/fMZK3Jm5u27xYFtadw+iWMRg5C+RHCFjXd7YjNJT/a+ofvH8YC4
	 zP5HJP+Hc8HzTzttWZckXUVq2Mxh2+RZom5sYjw8fGDeK941qtV1cMlgumOykwjDUo
	 m6Dpr95LHdyySXZXvA+QhYwi1/UuSs6G/44cJNjE=
Date: Wed, 28 Oct 2026 23:19:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,
	tursulin@ursulin.net,skhan@linuxfoundation.org,simona@ffwll.ch,
	ryan_chen@aspeedtech.com,rodrigo.vivi@intel.com,rdunlap@infradead.org,
	pavel@kernel.org,ojeda@kernel.org,mripard@kernel.org,
	maarten.lankhorst@linux.intel.com,lee@kernel.org,kees@kernel.org,
	joonas.lahtinen@linux.intel.com,joe@perches.com,joel@jms.id.au,
	jani.nikula@linux.intel.com,jani.nikula@intel.com,corbet@lwn.net,
	christian.koenig@amd.com,billy_tsai@aspeedtech.com,apw@canonical.com,
	andy.shevchenko@gmail.com,andy@kernel.org,andrew@codeconstruct.com.au,
	andi.shyti@linux.intel.com,andi.shyti@kernel.org,alexander.deucher@amd.com,
	airlied@gmail.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + string-switch-to-__nonnull_args-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20261029061914.87AF11F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: string: switch to __nonnull_args() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     string-switch-to-__nonnull_args-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/string-switch-to-__nonnull_args-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: string: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:41 +0000

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the macro __nonnull_args() to wrap raw compiler
attribute.

Replace __attribute__((nonnull)) with __nonnull_args() to
standardize nonnull attribute usage across the tree and keep the
attribute's quirks in one place rather than open-coded at every call
site.

Link: https://lore.kernel.org/f0d7b2f0dce916f4cde3dd466a5b51a4b88fbdd8.1793027261.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Lee Jones <lee@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Ryan Chen <ryan_chen@aspeedtech.com>
Cc: Billy Tsai <billy_tsai@aspeedtech.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Andi Shyti <andi.shyti@kernel.org>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
---

 include/linux/string.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/string.h~string-switch-to-__nonnull_args-macro
+++ a/include/linux/string.h
@@ -587,7 +587,7 @@ static inline bool strstarts(const char
  * Returns:
  * True if @str ends with @suffix. False in all other cases.
  */
-static inline bool __attribute__((nonnull(1, 2)))
+static inline bool __nonnull_args(1, 2)
 strends(const char *str, const char *suffix)
 {
 	unsigned int str_len = strlen(str), suffix_len = strlen(suffix);
_

Patches currently in -mm which might be from d@ilvokhin.com are

docs-xforms_lists-support-__nonnull_args.patch
string-switch-to-__nonnull_args-macro.patch
lib-list_sort-switch-to-__nonnull_args-macro.patch
xarray-switch-to-__nonnull_args-macro.patch
drm-i915-switch-to-__nonnull_args-macro.patch
drm-amdgpu-switch-to-__nonnull_args-macro.patch
drm-gem-switch-to-__nonnull_args-macro.patch
leds-pwm-switch-to-__nonnull_args-macro.patch
soc-aspeed-lpc-snoop-switch-to-__nonnull_args-macro.patch
checkpatch-suggest-nonnull-attribute-conversion.patch

