Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793254772;
	b=hnyn2PxMCVOdew/0fJo4HRMTc+IOQkfZwbbDaUzKvXP19NMACWw8IapiKSX6SgGk3/n2
	 NJImbbtAImxwzOoPIrOMIi4P2ZDndM8c/gT76g/bqWIj7sO7d8EzGs1xwg8rpjeIvmVNZ
	 n4WMlUKQNRKCYYfpteE7u9YCoeU5Y1N97dabv2wzhzlm2gs50RS9IyEMkf7G082/WwDSt
	 h0/6jXVrrqTB/CXmU7rrBqp2QTZp7nnl23z5tyy9SNcStJh51zC7fo8N7OvYYvx231rv2
	 vw++0z0OiXOMshD2IOjedJYZQzQNKw7JmiAGbe/YghvXZp3YtBFJLeFdlTwn8eQoQTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793254772;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CiAOqjkNwnawZvvNfk+FCytuCLI51HIJzPCOQtOxq7s=;
	b=DrpUzrS5cpW6rvSTYbc0q/Boi12wP5cAWZjw/wTyQqYi1UBfCj7FyLuHz4K8grJpyp0S
	 +iHWvCQKCC+5ZWmo/3KxZ8GZpuHx7Xq52iKTwV4Ti4cYjgVQ/yFc5kbt7n5OwmOxPit0V
	 +DRHaLURypS0Itd22nmPMcHsNXd2C5MyZZ/lPhbxfmfw2oKN2gWXZOhRxYVCwY0sFmJxg
	 86CbyHAJMpPBPVjg4tAE4STGDpkeG8pSeHPCCUYfh5DOJgCaSsexYSMcgSbtMEASMLh1O
	 pm01AAlCf176WYYo4qq/mkjGnQG1IU2iOHMOMSb5KCbKVdKOyLWnnpD7IHw/Kvu01eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="O/RNLqbS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E87606A32A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 06:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O/RNLqbS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7211F01825;
	Thu, 29 Oct 2026 06:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793254771;
	bh=CiAOqjkNwnawZvvNfk+FCytuCLI51HIJzPCOQtOxq7s=;
	h=Date:To:From:Subject;
	b=O/RNLqbSY8C1TPhiniUS+p6MP9TBbj79jjDdGg4wO6lzsMWDTVu7zHyp/EOAAOmHA
	 PA8SErvEpf9yMOPtg9m/Fp0CiFHyB5di0SIqFQZWDN5hPwWbQC7d08lAEDII3CEga8
	 EfQiDoFWX79KnEKViOjucYlRLeXdA8I0ecwSXwsk=
Date: Wed, 28 Oct 2026 23:19:30 -0700
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
Subject: + checkpatch-suggest-nonnull-attribute-conversion.patch added to mm-nonmm-unstable branch
Message-Id: <20261029061931.1C7211F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: checkpatch: suggest nonnull attribute conversion
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-suggest-nonnull-attribute-conversion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-suggest-nonnull-attribute-conversion.patch

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
Subject: checkpatch: suggest nonnull attribute conversion
Date: Wed, 28 Oct 2026 08:19:49 +0000

The kernel provides the __nonnull_args() macro as the preferred form for
marking pointer arguments as non-NULL. Add a check suggesting the macro
over the raw __attribute__((nonnull)) spelling, consistent with the
existing attribute conversion suggestions.

Examples:

  WARNING: Prefer __nonnull_args(1, 2) over __attribute__((nonnull(1, 2)))
  #11: FILE: drivers/soc/aspeed/aspeed-lpc-snoop.c:230:
  +__attribute__((nonnull(1, 2)))

  WARNING: Prefer __nonnull_args() over __attribute__((nonnull))
  #11: FILE: drivers/soc/aspeed/aspeed-lpc-snoop.c:283:
  +__attribute__((nonnull))

Link: https://lore.kernel.org/bc2cd702455e58feb777cdb230e3ba4f7e1db60f.1793027261.git.d@ilvokhin.com
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

 scripts/checkpatch.pl |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-suggest-nonnull-attribute-conversion
+++ a/scripts/checkpatch.pl
@@ -6884,6 +6884,7 @@ sub process {
 				"no_caller_saved_registers"	=> "__no_caller_saved_registers",
 				"noclone"			=> "__noclone",
 				"noinline"			=> "noinline",
+				"nonnull"			=> "__nonnull_args",
 				"nonstring"			=> "__nonstring",
 				"noreturn"			=> "__noreturn",
 				"packed"			=> "__packed",
@@ -6904,6 +6905,8 @@ sub process {
 					if ($curr_attr eq "format" && $params) {
 						$params =~ /^\s*\(\s*(\w+)\s*,\s*(.*)/;
 						$new = "__$1\($2";
+					} elsif ($curr_attr eq "nonnull" && $params eq "") {
+						$new = "$new()";
 					} else {
 						$new = "$new$params";
 					}
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

