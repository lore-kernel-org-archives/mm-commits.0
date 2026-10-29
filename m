Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254753;
	b=idjLRy/WeTFoFvVMrsvl5PYeZlK0/51iRmuLH5r2bv2pnDOLUUOnasxDVXW/tZeYpkzj
	 6zeyMYyYtew5Wnr9p6I6k3tBp87wcLc4dg4d8dVTyGeootvj1KzlHuMCCbeoCozN6hJL1
	 FmzPHWZEOvgcC6nvWIyvNvHp7amaxCrdVRIezzG5Z73vdyw4LV9nRGgS4w/aALlimm8V7
	 tLU2QuJOrjfgQRm2nUh+IOga18saEBey4DUQt2NmJ7T2Z3WDO3UmUSjC1iyXN7q+tmHfC
	 LR2xaCGskb77kJZcX1oVlPnNuO9LIRdzr3vzQhISV6AQx2eH7KBF5Qk2J5g3Yp3f1bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254753;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=I6W/buR4sfdXM4rmK9rU/ss7zO0xLBcY23L78rJa86s=;
	b=4jcVABzXUc6QyZ1oBj36QxmvSXU0m0efo3544KT5AoxINhBSCgFA0/tr7a3EOsrbQavC
	 Eikl44KKjWMSNCHad/idANqVHDa/NOkZuwxDgcz2un7PY+aPfwk8M9ee9ap94XLCBCWYp
	 /SjSE/wiQD41c2+hOZ8wcbYzgG6s6gs6r6zST09XpzcmiAN1z6hsqS8RF/MttLcpWi0Za
	 IEuNPCVZ7fDe5y9jLI7DHd3+ll+G+/mTzZzYPGCCDQZ5La3IunJJu7yTU1MwOzDQwByOY
	 o4Wf4moDzDRKM8/mgO2nJzyPjN8PABfWFpORTpOztLI6gSqE5Ux1S6+StpNUey8Cafg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HQPPqoqN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15377606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HQPPqoqN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B747B1F01825;
	Thu, 29 Oct 2026 06:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254752;
	bh=I6W/buR4sfdXM4rmK9rU/ss7zO0xLBcY23L78rJa86s=;
	h=Date:To:From:Subject;
	b=HQPPqoqNnVj3DzC7oV7mKBQ9Tq/n/3IW8z+PrfeCc3zvuHj5XWX472Z9Gf3Q8CKzP
	 si+E2nG9s0hopditVmyy6SneSThvh7NNeO2HrIIjW2OohGQdimrONMzJ1ZCnQUwaRI
	 YbCZ/Fu82pjP/7oJV+O9ykuJMENkwmjMYUOMrgRc=
Date: Wed, 28 Oct 2026 23:19:12 -0700
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
Subject: + docs-xforms_lists-support-__nonnull_args.patch added to mm-nonmm-unstable branch
Message-Id: <20261029061912.B747B1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: docs: xforms_lists: support __nonnull_args()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docs-xforms_lists-support-__nonnull_args.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-xforms_lists-support-__nonnull_args.patch

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
Subject: docs: xforms_lists: support __nonnull_args()
Date: Wed, 28 Oct 2026 08:19:40 +0000

Patch series "treewide: switch to __nonnull_args() macro", v1.

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the __nonnull_args() macro to wrap the raw compiler
attribute, keeping the attribute's quirks in one place rather than
open-coded at every call site.

This series replaces the remaining open-coded __attribute__((nonnull))
users with __nonnull_args() to standardize nonnull attribute usage
across the tree.

Each patch can be applied separately by the respective maintainers. The
only dependency is kernel-doc: the string and lib/list_sort patches need
patch 1 ("docs: xforms_lists: support __nonnull_args()") in the same
release, otherwise strends() and list_sort() drop out of the generated
documentation.

Latest Sparse release could not properly parse __nonnull_args() without
arguments. Fix was proposed [1] and merged, but until updated version of
Sparse will reach wide masses it might trip on __nonnull_args() without
arguments.

There are few more instances of __attribute__((nonnull)) usages left in
the tools subdirectory, they are perf related copied files and can
(should?) be updated separately after this patchset lands.

Build-tested allmodconfig with GCC 11.5.0 and clang 22.1.8.


This patch (of 10):

Avoid kernel-doc warnings by supporting __nonnull_args()
as a function transform.

This is a preparatory change for the treewide migration from
__attribute__((nonnull)) to __nonnull_args() macro.

Link: https://lore.kernel.org/cover.1793027261.git.d@ilvokhin.com
Link: https://lore.kernel.org/fd33c32bb1f1cf80721887b6e9bfa49749e03d20.1793027261.git.d@ilvokhin.com
Link: https://lore.kernel.org/all/20261019175633.415493-19-bvanassche@acm.org/ [1]
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Andi Shyti <andi.shyti@kernel.org>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
---

 tools/lib/python/kdoc/xforms_lists.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/lib/python/kdoc/xforms_lists.py~docs-xforms_lists-support-__nonnull_args
+++ a/tools/lib/python/kdoc/xforms_lists.py
@@ -108,6 +108,7 @@ class CTransforms:
         (CMatch("__attribute__"), ""),
         (CMatch("STATIC_IFN_KUNIT"), ""),
         (CMatch("INLINE_IFN_KUNIT"), ""),
+        (CMatch("__nonnull_args"), ""),
 
         #
         # HACK: this is similar to process_export() hack. It is meant to
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

