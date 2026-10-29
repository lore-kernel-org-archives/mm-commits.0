Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254765;
	b=gKAEYJNweW29EFsGEzCukQNx5YSNa7KUZeR3oNebdvz6aa/uXQUa+GkhcLcIx5PKwLX1
	 Bb7NHoZGC9PHwF2oxiACnrn4gAENvi6e83apO0u0tdleksAdv+gDjg/nEpOtn+ptrs37h
	 W1dToX5YT67s46nrlLUSiVsPlAxJoLeG6NVmaxuJv+KRbG4d3yzVNRLK4PVCxetuu6qC1
	 j7OGBwIsJDYEQVuhL52+6eVZ766E6jAPdhAF8BxFK6w0NzXoSBHqN8KePKXksZwvD+bZq
	 y4W+hXWP/P/fZ9KbMvGLTl+GoWiZGd+2B5z85zIfco6KhBmk+jEIk8uOePGoU1Mlp6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254765;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PtwGjg0iVho9apmc0xSKrGloO1B/7UUygKrvrBx8r3E=;
	b=rOxr2Wuch4Nv7W5B0eEbIq/G4h1Lyalnt/bM+u5H68jIZuEOt7fR7Kb0vtwZX5lG0B5M
	 nYJ1pgEkYuBfxwHOyMjx2xFfelKMFGHlQmN6DCgL4xxVb+FP5lk2suZ+kQUzrITZOYX4T
	 RrrnbY1SClV61AoR6q84MT1fJLw9HTIoLyWP1o7A+wwA6IZnI7nbPEd7R5cLCh7eyJp5p
	 czqztCebP9nee2GK1Er9k6Cuzpm3jWsYk4KitBycaP/ai1lb1NgTTwe9KvbB76AOPplfv
	 eul+CtT2m1ElQRoMi+BPMi4szURqFRSrpzFP+uvJLGgYGAX9KDGCm/Qwd5GiNdBkWPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zmh1rd29;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD9E606A327
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Zmh1rd29
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657061F01825;
	Thu, 29 Oct 2026 06:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254765;
	bh=PtwGjg0iVho9apmc0xSKrGloO1B/7UUygKrvrBx8r3E=;
	h=Date:To:From:Subject;
	b=Zmh1rd29Rv8487CpKxhcrD4w3fopKOxnEuaxzoxtM1qQFC+/LMVYGyDb3diS24OrJ
	 bR9yr5xwuyqRjVZ19oMwCj10aKE1xCOfK7g/q8uhOa6vW+iysbCrbz1n6Nw/vPkPT1
	 FNO8vLCzV1SK+Nyca2VlFHM3L1imrwzVAV37bH7g=
Date: Wed, 28 Oct 2026 23:19:24 -0700
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
Subject: + drm-gem-switch-to-__nonnull_args-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20261029061925.657061F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: drm/gem: awitch to __nonnull_args() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-gem-switch-to-__nonnull_args-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-gem-switch-to-__nonnull_args-macro.patch

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
Subject: drm/gem: awitch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:46 +0000

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the macro __nonnull_args() to wrap raw compiler
attribute.

Replace __attribute__((nonnull)) with __nonnull_args() to standardize
nonnull attribute usage across the tree and keep the attribute's quirks
in one place rather than open-coded at every call site.

Link: https://lore.kernel.org/5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
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
---

 include/drm/drm_gem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/drm/drm_gem.h~drm-gem-switch-to-__nonnull_args-macro
+++ a/include/drm/drm_gem.h
@@ -566,7 +566,7 @@ static inline void drm_gem_object_get(st
 	kref_get(&obj->refcount);
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static inline void
 __drm_gem_object_put(struct drm_gem_object *obj)
 {
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

