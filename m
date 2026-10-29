Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254764;
	b=Dp2fLodIMH0SiMGYbvXH7lhzQsE3MIYlCYFAbX6QUdjjyrdEBEKxu7pBR2xdcHhJaeFL
	 BY/5ANAuFhwP6gbPqZnkpX7CNy84U6bye1IYHOe52UEFodwMUwacQ1uZZVXIpLWSP5cw8
	 odZKCiaRBvc12Ad2+ZFc6FUeb8wPjl8f2kceSvE5+W6rrrTiEsXbZc13WuY4ZgsckG7qP
	 A1TvcCP1do8QdlPos22/Ekk00KweBn9WJC2scnLOl4W4SZf5nlwmN8bfVpIYU5S4uX/hT
	 8svUQQH3hJ/XEjJgz4uD3vp9onP5rJujqlOsWNzORyEqZh8bwCIELe2PJZjlpmi3LCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254764;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=3Fc9uv+iksRnKIJXoxoj0ujWd9bvWIL0zA4pZkIlb4s=;
	b=RFAJTURMl/Q0oNYPcchRzRWKeyldmWXQCszDjhMOpQ2D9PBvHKPGO4KvVy3SI/DebhAv
	 TovBVL/6Vaev4YhuJ1QJDqkk6SnIqXimXyWIz4lGN1XomjLPtrV1wuisQQbrwC2MKfw2B
	 xXPvGPLcRSfJpCA2XhvgomCaA+ywN/R7HLplNAhh13scDekBc0R8UcD9e6TFXsu9B4/g1
	 oCWsoTfe9h3wx/cNEgDOQx4ak4cbpiUwYgDnr6s7DOdCl8G2baLDhH6Za9H4ogjknkyz+
	 QFqA06g0ceKrgOuR8m/j/UPNWxq7gWI8LWyFtL2JsfTHQ2VZU1wcg2zaHIEbSRY+N3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O8o6Tsh6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A2F606A322
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O8o6Tsh6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA301F01825;
	Thu, 29 Oct 2026 06:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254763;
	bh=3Fc9uv+iksRnKIJXoxoj0ujWd9bvWIL0zA4pZkIlb4s=;
	h=Date:To:From:Subject;
	b=O8o6Tsh6u1jipoKrRfgr7Rvjz+aSVI4dZCBWQ2W/gNeSRswFSvL5Ps7OAP0gsMH/h
	 Pkko7ocS9I7xSTmzfwScJGBhBX9N0by68q//3pQ8O2L4V6B9Glj5BXvma1QNco1S+/
	 jqwP/JKlQqmRG0q6qU6zIibTn5jj9t7CcZcqSqtI=
Date: Wed, 28 Oct 2026 23:19:23 -0700
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
Subject: + drm-amdgpu-switch-to-__nonnull_args-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20261029061923.7CA301F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: drm/amdgpu: switch to __nonnull_args() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     drm-amdgpu-switch-to-__nonnull_args-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-amdgpu-switch-to-__nonnull_args-macro.patch

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
Subject: drm/amdgpu: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:45 +0000

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the macro __nonnull_args() to wrap raw compiler
attribute.

Replace __attribute__((nonnull)) with __nonnull_args() to standardize
nonnull attribute usage across the tree and keep the attribute's quirks
in one place rather than open-coded at every call site.

Link: https://lore.kernel.org/d57489b8bec240794a7a8aaac6e1e3e0d78ea331.1793027261.git.d@ilvokhin.com
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

 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~drm-amdgpu-switch-to-__nonnull_args-macro
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -307,7 +307,7 @@ static int amdgpu_ttm_map_buffer(struct
  * move and different for a BO to BO copy.
  *
  */
-__attribute__((nonnull))
+__nonnull_args()
 static int amdgpu_ttm_copy_mem_to_mem(struct amdgpu_device *adev,
 				      struct amdgpu_ttm_buffer_entity *entity,
 				      const struct amdgpu_copy_mem *src,
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

