Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793263605;
	b=MrOzdUG3a+/AD4X3e0ItaLYYI1OqXOMAaYXif66SCzWqCg6eSefHMQJw8vbFf8a+PYNc
	 0xJ3UdNd/qxo7mWo+Yunpq0wJAMPFEXdIFfEPeK/nxZPYqumMJdXKk65t3DFwdy8wq7ar
	 wZ+bcnuNjBQK6aKg2ufr7vNvfZXv0gH+fMqWTJEsZMIYVilbUylMuWZoyRTXXCrufGziD
	 EYm4lIDPhjJhd55P/vf8vMjD+q2UCufUJ9Lj2Vaa3fGUJqHiKUfbgrtRlz3bekF21t2+n
	 Mz1Ikg+p97xko+ANPlD8cZEnUhCa2vTdZ5TFso/WBay29i2hOvPIUg/eKDhYb2r24hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793263605;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Subject:
	 In-Reply-To:Organization:References:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=1Jf0yv5gY6zciA5ERMr7oTgCYbPScTrexTT89FJkLWk=;
	b=UeeWL4CfkfmMUkHTE3IdAQXYktYtBil1C5e88to+Xn2xu/ZO0XDs303gwkznghAI1T3i
	 M1pdNLKCVUqioR1+ye9nqrUEYg3VkBQyWT2qJf/np9dDcg5hQcGSHzJRylIGnZ0TdS3Lx
	 nzBwddFqdTSe/xA+RFS9V4rJUaLr3LRXfwmAvxEJ+cEYsGtJh/xsE/W0C0zytzAiCpf6i
	 RNSqKOHZmdx0lh8VFW3ZiUPFHqMFdowK+3jK61nMGFaGmD1PefNdJu45dF2v5VkcTcz2j
	 iNnJfvl3bUzlbq0455yuf09kfWOyEjgYfywqxIqGp256rtx2VePzHqkmTfTkVIddXPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=oH0daKqq;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AEA606A31C
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 08:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50AEA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=oH0daKqq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793263603; x=1824799603;
  h=from:to:subject:in-reply-to:references:date:message-id:
   mime-version:content-transfer-encoding;
  bh=/vri5aRqwO3RITynwe+NIw//M/sWFSAAXNuI7gjcOmY=;
  b=oH0daKqqSQLXoP8cHmSyApiBW6PJAMgE4pK9wsgsAqgYmRESBSdv+uzZ
   ZIVSHNObufXjFeir/PnJ2nQs5npJgdx3OBShVQndAg5z13Rlv/r9O/ZQU
   ZxaI4wVcmBIAXSBAs9luktfxk/xJbNF1QXLlDeS63ojq4Fen0WVE46ykd
   n0KmzY/cVlB8Tr9TZ3DVMzWK7Je9nuBAzOkTjydhA+FB74gpdVLclyH3b
   DMzBX8ouh3eAosEjjUvX+wiZP1CM31fuZTQm+PP5aA0jDEo4lY8UZQnIk
   xaQYI09LkFgHhTx4Dzd/W+mzsfxPJBGPy/o5Jqsfs/VEf63wRwWDmA25/
   A==;
X-CSE-ConnectionGUID: MYBQwFXpQaakdyd7eLikbA==
X-CSE-MsgGUID: khGHtcPdR964VNw0KIQieQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="2032776"
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="2032776"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 01:46:43 -0700
X-CSE-ConnectionGUID: KEqjYPzHTna66ouAhxBOGw==
X-CSE-MsgGUID: fQJ+g4i3TrS+JXuKLC5gzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="4970114"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.74])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 01:46:35 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 willy@infradead.org, tzimmermann@suse.de, tursulin@ursulin.net,
 skhan@linuxfoundation.org, simona@ffwll.ch, ryan_chen@aspeedtech.com,
 rodrigo.vivi@intel.com, rdunlap@infradead.org, pavel@kernel.org,
 ojeda@kernel.org, mripard@kernel.org, maarten.lankhorst@linux.intel.com,
 lee@kernel.org, kees@kernel.org, joonas.lahtinen@linux.intel.com,
 joe@perches.com, joel@jms.id.au, corbet@lwn.net, christian.koenig@amd.com,
 billy_tsai@aspeedtech.com, apw@canonical.com, andy.shevchenko@gmail.com,
 andy@kernel.org, andrew@codeconstruct.com.au, andi.shyti@linux.intel.com,
 andi.shyti@kernel.org, alexander.deucher@amd.com, airlied@gmail.com,
 d@ilvokhin.com, akpm@linux-foundation.org
Subject: Re: + drm-i915-switch-to-__nonnull_args-macro.patch added to
 mm-nonmm-unstable branch
In-Reply-To: <20261029061921.242CC1F01828@smtp.kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20261029061921.242CC1F01828@smtp.kernel.org>
Date: Thu, 29 Oct 2026 10:46:33 +0200
Message-ID: <0b535b95bdc0f90478dec2394fe8c5e1db9e8d31@intel.com>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Oct 2026, Andrew Morton <akpm@linux-foundation.org> wrote:
> The patch titled
>      Subject: drm/i915: switch to __nonnull_args() macro
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      drm-i915-switch-to-__nonnull_args-macro.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/drm-i915-switch-to-__nonnull_args-macro.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

I already applied this to drm-intel-next as per Dmitry's cover letter.

BR,
Jani.


>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
>
> ------------------------------------------------------
> From: Dmitry Ilvokhin <d@ilvokhin.com>
> Subject: drm/i915: switch to __nonnull_args() macro
> Date: Wed, 28 Oct 2026 08:19:44 +0000
>
> Commit 22302af28d3f ("cleanup: Annotate guard constructors with
> nonnull") added the macro __nonnull_args() to wrap raw compiler
> attribute.
>
> Replace __attribute__((nonnull)) with __nonnull_args() to standardize
> nonnull attribute usage across the tree and keep the attribute's quirks
> in one place rather than open-coded at every call site.
>
> Link: https://lore.kernel.org/33ec8080594f9f4ef1d50e36497339c9a6897393.17=
93027261.git.d@ilvokhin.com
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Suggested-by: Miguel Ojeda <ojeda@kernel.org>
> Reviewed-by: Andy Shevchenko <andy@kernel.org>
> Acked-by: Jani Nikula <jani.nikula@intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Tvrtko Ursulin <tursulin@ursulin.net>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Pavel Machek <pavel@kernel.org>
> Cc: Joel Stanley <joel@jms.id.au>
> Cc: Andrew Jeffery <andrew@codeconstruct.com.au>
> Cc: Ryan Chen <ryan_chen@aspeedtech.com>
> Cc: Billy Tsai <billy_tsai@aspeedtech.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Andi Shyti <andi.shyti@kernel.org>
> ---
>
>  drivers/gpu/drm/i915/gem/i915_gem_object.h |    4 ++--
>  drivers/gpu/drm/i915/i915_request.h        |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> --- a/drivers/gpu/drm/i915/gem/i915_gem_object.h~drm-i915-switch-to-__non=
null_args-macro
> +++ a/drivers/gpu/drm/i915/gem/i915_gem_object.h
> @@ -127,7 +127,7 @@ __deprecated
>  struct drm_gem_object *
>  drm_gem_object_lookup(struct drm_file *file, u32 handle);
>=20=20
> -__attribute__((nonnull))
> +__nonnull_args()
>  static inline struct drm_i915_gem_object *
>  i915_gem_object_get(struct drm_i915_gem_object *obj)
>  {
> @@ -135,7 +135,7 @@ i915_gem_object_get(struct drm_i915_gem_
>  	return obj;
>  }
>=20=20
> -__attribute__((nonnull))
> +__nonnull_args()
>  static inline void
>  i915_gem_object_put(struct drm_i915_gem_object *obj)
>  {
> --- a/drivers/gpu/drm/i915/i915_request.h~drm-i915-switch-to-__nonnull_ar=
gs-macro
> +++ a/drivers/gpu/drm/i915/i915_request.h
> @@ -437,12 +437,12 @@ void i915_request_cancel(struct i915_req
>  long i915_request_wait_timeout(struct i915_request *rq,
>  			       unsigned int flags,
>  			       long timeout)
> -	__attribute__((nonnull(1)));
> +	__nonnull_args(1);
>=20=20
>  long i915_request_wait(struct i915_request *rq,
>  		       unsigned int flags,
>  		       long timeout)
> -	__attribute__((nonnull(1)));
> +	__nonnull_args(1);
>  #define I915_WAIT_INTERRUPTIBLE	BIT(0)
>  #define I915_WAIT_PRIORITY	BIT(1) /* small priority bump for the request=
 */
>  #define I915_WAIT_ALL		BIT(2) /* used by i915_gem_object_wait() */
> _
>
> Patches currently in -mm which might be from d@ilvokhin.com are
>
> docs-xforms_lists-support-__nonnull_args.patch
> string-switch-to-__nonnull_args-macro.patch
> lib-list_sort-switch-to-__nonnull_args-macro.patch
> xarray-switch-to-__nonnull_args-macro.patch
> drm-i915-switch-to-__nonnull_args-macro.patch
> drm-amdgpu-switch-to-__nonnull_args-macro.patch
> drm-gem-switch-to-__nonnull_args-macro.patch
> leds-pwm-switch-to-__nonnull_args-macro.patch
> soc-aspeed-lpc-snoop-switch-to-__nonnull_args-macro.patch
> checkpatch-suggest-nonnull-attribute-conversion.patch
>

--=20
Jani Nikula, Intel
