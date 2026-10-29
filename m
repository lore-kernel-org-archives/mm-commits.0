Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254769;
	b=xsZSj++lgFkPdUsOhvEDspP+DyKocLZnKmsd/iCjiHP1UYiccUDFLRLkU6TgmA/N51fF
	 VL+8ZVrUt+WnwR9BXCQoPfqWK1jM2iHxXdmiuRqflQKzIuYZ5EPy+/WaG3reGvdzZ61TR
	 6XOaB0NITrMA5AxlOqn5jh//UqgDg5O2W7vfISmPJOJM3ZfxpWvsbYOVa0jcVtzlg8B4K
	 w461z5IK7PWsx93oElRrEW7CS5qlJPtJSgZUeTtFX/1gTkh9pzFSr53XhqxFK4U+5ROus
	 oZrRDF8HG1GQVwSL0P69CyFlIFDOsbLOuRlTkFevnxbv0em30p013VU21RK7lL+v4Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254769;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ipy3R0c1I7cJkMwcLc0Rc8usinkU5A/flTQyiAsC0ZM=;
	b=EgKZUE7FhsCc+SvDuItc6L/6MFWbldUi2TA1FwHsB5o5/W9ySRGM1NP/dRsEE/n2sGAy
	 Gj73P+I6/MqoXaxMdyg7uixF6S2pvt7s/JH21Eqz1CpHeS6gX5vFgrEQcdfXnCOcVnihD
	 dzwk07Q5K/iBKhv9eweZiVHBNaTkiKKirjbHi/T1lNo/hGjYA/d5tWdzG8iGDwsVySTlQ
	 tjcsoZuEjg6/XXWqkIr6/FMWKyG1g6hifsQNY/f2FKzrylRJNlb4kp4APUeOG8z/s0VCH
	 zdMh4vyLeSlBEKEfwnrBOLQiFUGoj16BaF/Lw0b21aoLOaXbkikN8mXDCpmJxWFFp8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="ndO/IaVv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6680C606A324
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ndO/IaVv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C08A1F01825;
	Thu, 29 Oct 2026 06:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254769;
	bh=ipy3R0c1I7cJkMwcLc0Rc8usinkU5A/flTQyiAsC0ZM=;
	h=Date:To:From:Subject;
	b=ndO/IaVvUnITS1AJqJks6fSg8UswbwHRsYRW4gqWi84PM25lp4tsQNVYSUX90IDkP
	 WIe2b6obmzf5R2GrYK290UoYro5xYO+IErhrl8y2i1AGbsjzHZZ91kE8ARqlw85oWL
	 XzNOAAyIZeHRCefdUR/IEO9qrT2YOIxhnM+TxiWY=
Date: Wed, 28 Oct 2026 23:19:28 -0700
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
Subject: + soc-aspeed-lpc-snoop-switch-to-__nonnull_args-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20261029061929.2C08A1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: soc: aspeed: lpc-snoop: switch to __nonnull_args() macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     soc-aspeed-lpc-snoop-switch-to-__nonnull_args-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/soc-aspeed-lpc-snoop-switch-to-__nonnull_args-macro.patch

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
Subject: soc: aspeed: lpc-snoop: switch to __nonnull_args() macro
Date: Wed, 28 Oct 2026 08:19:48 +0000

Commit 22302af28d3f ("cleanup: Annotate guard constructors with
nonnull") added the macro __nonnull_args() to wrap raw compiler
attribute.

Replace __attribute__((nonnull)) with __nonnull_args() to standardize
nonnull attribute usage across the tree and keep the attribute's quirks
in one place rather than open-coded at every call site.

Link: https://lore.kernel.org/6b82201d601c23bf8545f8d581fd6632c36cd208.1793027261.git.d@ilvokhin.com
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

 drivers/soc/aspeed/aspeed-lpc-snoop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c~soc-aspeed-lpc-snoop-switch-to-__nonnull_args-macro
+++ a/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -226,7 +226,7 @@ static int aspeed_lpc_snoop_config_irq(s
 	return 0;
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static int aspeed_lpc_enable_snoop(struct device *dev,
 				    struct aspeed_lpc_snoop *lpc_snoop,
 				    struct aspeed_lpc_snoop_channel *channel,
@@ -279,7 +279,7 @@ err_free_fifo:
 	return rc;
 }
 
-__attribute__((nonnull))
+__nonnull_args()
 static void aspeed_lpc_disable_snoop(struct aspeed_lpc_snoop *lpc_snoop,
 				     struct aspeed_lpc_snoop_channel *channel)
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

