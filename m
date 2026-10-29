Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290494;
	b=A8/UVJkCE/RQHEbNorBQO74DXOte6iPivIkBfWHMgR4pjY9Qm+CpNrl9Bu5gbrkqSB78
	 0O1OoEEBiorU81B+tkp2jqVbRintS5Kv7GAFgru6f1NVflbOmVfQrHnTCa2gdfh/+3p09
	 Kcg01k+03rI2h+jaUAtUifumZsRSTZfO1G5+s7X0/5A3mj/jLfFD0kOjkmVvo5PYMqgJ2
	 Utg9gwxcj7vDKJ5ZDyXk51o0Eum3BSORg9+KY6PXBrX0wBtkEP3+6004ESkayiVLFi0dl
	 thzjEpKRBTS1qkKD03vz/AQsBD3Ns6eiSxIhZqeDIkTA8hmQS8sPZrMpVxsJ2Hlq82Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290494;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=KWWq7djpCfZIJTr2CIM/43OiPdYE21wRUdQlL+SNPb8=;
	b=LrWoK/z80AJzr7MfX3yJfTQM587bxiQ0jjmPTUYkeF4z6Dd3J5ZYgF5JeP9RJ0D0ZEQl
	 00DoOeI+uFZz8VYSVulS9OrBAa4DpQKKAr0OoVU6laoqyd5NuSSdWpQI08/GJ6mSS5A6o
	 y4v+T9aW1oCyS25OQrz18S222c7SdE0vKqX+zzuvIMbTAFFcTyR0sGuzdaExsFwUqIi5R
	 KFLbm+Js3Noc6lt/WGYIU1QGx3dPlkouJ/uiOt+URSV7ZIcTlapR96qJbo6H3vGVbGkkt
	 8hHwF/rcQkG5tsJ1H4kuMBfGeV+y7c7LrbYK2dOAjR+b1HL5lOYTRpQGftKEYmdjEgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0nFG9zA8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A1F606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 16:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0nFG9zA8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B3E1F01816;
	Thu, 29 Oct 2026 16:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793290494;
	bh=KWWq7djpCfZIJTr2CIM/43OiPdYE21wRUdQlL+SNPb8=;
	h=Date:To:From:Subject;
	b=0nFG9zA8Kx3dVmYGhndGE2J/eB0AF4W9OLjCLB2NPkhlclTwUPHFuLkG+0wDkcpa0
	 I/4QlWDc01TLzx1dfEzRF41+ogJV8ChedOTnCgSRyxCRENydUE8bIvu3PaQryyr4Qd
	 OyoomYa/MzNum7jjUztccsnqawm7m6UoSSFnnNUM=
Date: Thu, 29 Oct 2026 09:14:53 -0700
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
Subject: [merged] drm-i915-switch-to-__nonnull_args-macro.patch removed from -mm tree
Message-Id: <20261029161453.E8B3E1F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: drm/i915: switch to __nonnull_args() macro
has been removed from the -mm tree.  Its filename was
     drm-i915-switch-to-__nonnull_args-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
drm-amdgpu-switch-to-__nonnull_args-macro.patch
drm-gem-switch-to-__nonnull_args-macro.patch
leds-pwm-switch-to-__nonnull_args-macro.patch
soc-aspeed-lpc-snoop-switch-to-__nonnull_args-macro.patch
checkpatch-suggest-nonnull-attribute-conversion.patch

