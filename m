Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254759;
	b=yxPnxI1fi5/tanqIUCgmqxe7PdyIS01LuK0yFWISv/L4GiTWe5OJBxr/l4xA4wJ+jV5R
	 ldt5NqPbm36MBpVSI1lZi+DwM9d+I4ngo/dZ9g3Pm+CZvkzCVmhc1h5Exi+IqEZ2YO0Wg
	 pTrjuc8U4i4hFJl2ONFsdg1uSF0cTD5i2ZpDiVm4HDeLqO9easOZEypF5Lu/Z1h/ierXV
	 lz000TosQttgsfPnw/l8EdlO7tKXGbrLPPgp5eHvGVtE9spt/xwQnmmrLcREgtydBaYXz
	 zf4pBrvyxd34yK+OkHs0eWV1FvZe+rAN2LtnIH5y6F+/+Swu+uuZoQ4y4eyXyhuO2YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254759;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YId734gX2/eLSrpu9uXmD2gWnyXBxG6D86clhO4MPOo=;
	b=DqCXR3u70SWYmZa5i3ZYr3UgABTUmIsev8QeUSem5GDf7CB5gjYHc+gLS0cPw9mH72PL
	 X7fL6Z66QJN9jFa9C6X7QQnPz/6xTepB/cd+e7OsSo+XAbpkd/q1Ae/Xa4LI6JvcJFRyq
	 9nFn1ALBJs56GE+d5/e/+jhZwRTjiaAan6cz3tmCAMOqq4mgVMgmNfj7Go1tzTtyc4vO8
	 tJyyd4kKOXYFWs8nMvXdMzY3yB+XFIjpjqoVosgwJa/fDbf0kp7EI3JVh7o4ZUvvG0lRq
	 4MU6suI8RfdHpDqLX5ymE4F89y69JE7i2Ifj91bEqEwgZG/YrONBmj5FbRgKqHf2yvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pwtYJO1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FDF606A31D
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pwtYJO1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8701F01825;
	Thu, 29 Oct 2026 06:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254758;
	bh=YId734gX2/eLSrpu9uXmD2gWnyXBxG6D86clhO4MPOo=;
	h=Date:To:From:Subject;
	b=pwtYJO1gyEbmW6+QKST/lcUd4j0exnhOBSYq2FRbY5dk35EwiOX58LEEKiylWEOwz
	 Wo1kjry7pEahnIrJkqVBlf9xSnPFY78mdEqrhYeCtTwJGupwrci+H9TNzumbUIL1FK
	 LRLltP0osRmaKaJD1+DRotURUIRo5GdqaR6EZKWc=
Date: Wed, 28 Oct 2026 23:19:18 -0700
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
Subject: + xarray-switch-to-__nonnull_args-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20261029061918.BC8701F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: xarray: switch to __nonnull_args() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xarray-switch-to-__nonnull_args-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-switch-to-__nonnull_args-macro.patch

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
Subject: xarray: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:43 +0000

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the macro __nonnull_args() to wrap raw compiler
attribute.

Replace __attribute__((nonnull)) with __nonnull_args() to standardize
nonnull attribute usage across the tree and keep the attribute's quirks
in one place rather than open-coded at every call site.

tools/testing/shared/linux/xarray.h directly includes the kernel's
include/linux/xarray.h, which now uses __nonnull_args(). The macro is
not defined under tools/, breaking test builds.

Define __nonnull_args() in tools/include/linux/compiler.h.

Link: https://lore.kernel.org/e2660c4c9f5e6f97be2ef7bd3752d259bce77d81.1793027261.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
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
Cc: Andy Shevchenko <andy@kernel.org>
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

 include/linux/xarray.h         |    4 ++--
 tools/include/linux/compiler.h |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/xarray.h~xarray-switch-to-__nonnull_args-macro
+++ a/include/linux/xarray.h
@@ -361,9 +361,9 @@ bool xa_get_mark(struct xarray *, unsign
 void xa_set_mark(struct xarray *, unsigned long index, xa_mark_t);
 void xa_clear_mark(struct xarray *, unsigned long index, xa_mark_t);
 void *xa_find(struct xarray *xa, unsigned long *index,
-		unsigned long max, xa_mark_t) __attribute__((nonnull(2)));
+		unsigned long max, xa_mark_t) __nonnull_args(2);
 void *xa_find_after(struct xarray *xa, unsigned long *index,
-		unsigned long max, xa_mark_t) __attribute__((nonnull(2)));
+		unsigned long max, xa_mark_t) __nonnull_args(2);
 unsigned int xa_extract(struct xarray *, void **dst, unsigned long start,
 		unsigned long max, unsigned int n, xa_mark_t);
 void xa_destroy(struct xarray *);
--- a/tools/include/linux/compiler.h~xarray-switch-to-__nonnull_args-macro
+++ a/tools/include/linux/compiler.h
@@ -68,6 +68,10 @@
 #define __naked __attribute__((__naked__))
 #endif
 
+#ifndef __nonnull_args
+#define __nonnull_args(x...) __attribute__((__nonnull__(x)))
+#endif
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #ifndef __same_type
 # define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
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

