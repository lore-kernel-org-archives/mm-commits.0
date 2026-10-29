Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254761;
	b=XYhPDFiSxIezkDArPLw4EQIFFDs0sc9ism+nLMNxjgp+CJ+0pNYKhP+KkMwMUeg0avDQ
	 GOEX1MfKfmdaLC4FL6Ut5/mb5pxo5WTc1dkmOuyZHeMVAf2ZTuoY+Ikgs/zFtbI7WsG0a
	 15pkHex/eK4idCy0weC379AR2HAEPw25OxRgfrlGNhz6WZfJ6EVCWxabQGl3hholg9Tpg
	 qM60wYr0JYsVd8lZD7VN02fP7fF+8JjXOQeJ3r/yEJnu890kYxappgA+iyHPh0uAJ35TX
	 LS7OvI0tOYBio3/XRUh9Ca2shiu9YFQayzydA047wEITH5rKKQO47cbvUSvRxX/lzgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254761;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/TnDNWydWfRqOTP2Al4gAT0oaELEGTrZU8OeE7Wmaus=;
	b=JkTsj2O3/E0oz3+SoG2AChA7ivHjcaRFhqmkyUorUqrZPxhufPhfffgM7rdz83FBPhQW
	 7VMd0vMiLO8NURzTfiupjdzWuhCGg66CnmUDf9uxO9YBxnMeO8TmY/pt/VJzjZsBzhJlO
	 gdh6+9LxbrRZmDbNXwO73LPQn/YpNmPYl9euSDXCHcTv5okW+xoe890MtSpjUuLw5fPv/
	 nGJQU62rOnqyirp0rcCMOmUFNYaPkfbu2VNY8qvlJWidBI4NQdltOlL0fE+aimWakPiy0
	 lWAHjXJd6mqtQL9VNjRmNsGEwP6c74nlRb6M1yVBXDaMNo5i5SxOXO47zrpsEX2+2Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=G0ixjnhV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D54606A31F
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=G0ixjnhV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242CC1F01828;
	Thu, 29 Oct 2026 06:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254761;
	bh=/TnDNWydWfRqOTP2Al4gAT0oaELEGTrZU8OeE7Wmaus=;
	h=Date:To:From:Subject;
	b=G0ixjnhVoRdEJsvOGK88CXJ/5sU0nY0ftef3ZSTNLmjTVe0MmSoXMdruhsGCeS3a9
	 CWGVRYIC5H/68p6kPygYDrgP/y+DhNNroWLs7DbphZAZ61F2UGn2oizq8McXRp/tcA
	 Iq9m+MG3jY8/1TxiraXOnZDwzSveaK4c3+xvg9nU=
Date: Wed, 28 Oct 2026 23:19:20 -0700
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
Subject: + drm-i915-switch-to-__nonnull_args-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20261029061921.242CC1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: drm/i915: switch to __nonnull_args() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-i915-switch-to-__nonnull_args-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-i915-switch-to-__nonnull_args-macro.patch

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
Subject: drm/i915: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:44 +0000

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the macro __nonnull_args() to wrap raw compiler
attribute.

Replace __attribute__((nonnull)) with __nonnull_args() to standardize
nonnull attribute usage across the tree and keep the attribute's quirks
in one place rather than open-coded at every call site.

Link: https://lore.kernel.org/33ec8080594f9f4ef1d50e36497339c9a6897393.1793027261.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
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
Cc: Andi Shyti <andi.shyti@kernel.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_object.h |    4 ++--
 drivers/gpu/drm/i915/i915_request.h        |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h~drm-i915-switch-to-__nonnull_args-macro
+++ a/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -127,7 +127,7 @@ __deprecated
 struct drm_gem_object *
 drm_gem_object_lookup(struct drm_file *file, u32 handle);
 
-__attribute__((nonnull))
+__nonnull_args()
 static inline struct drm_i915_gem_object *
 i915_gem_object_get(struct drm_i915_gem_object *obj)
 {
@@ -135,7 +135,7 @@ i915_gem_object_get(struct drm_i915_gem_
 	return obj;
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static inline void
 i915_gem_object_put(struct drm_i915_gem_object *obj)
 {
--- a/drivers/gpu/drm/i915/i915_request.h~drm-i915-switch-to-__nonnull_args-macro
+++ a/drivers/gpu/drm/i915/i915_request.h
@@ -437,12 +437,12 @@ void i915_request_cancel(struct i915_req
 long i915_request_wait_timeout(struct i915_request *rq,
 			       unsigned int flags,
 			       long timeout)
-	__attribute__((nonnull(1)));
+	__nonnull_args(1);
 
 long i915_request_wait(struct i915_request *rq,
 		       unsigned int flags,
 		       long timeout)
-	__attribute__((nonnull(1)));
+	__nonnull_args(1);
 #define I915_WAIT_INTERRUPTIBLE	BIT(0)
 #define I915_WAIT_PRIORITY	BIT(1) /* small priority bump for the request */
 #define I915_WAIT_ALL		BIT(2) /* used by i915_gem_object_wait() */
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

