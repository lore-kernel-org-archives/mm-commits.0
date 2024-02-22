Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB38150997
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708617490; cv=none; b=kcR6LrRSf2ptZgPe4sbMIfb4AgUTIWpmrYN7pv/di/NtS+ZbVbHiHpIe5kwLuogi7KXjxlpZI1aOh0Rmfkus0PA45Z7nS1Nwx98GDAfxJtfvRtG5vINsN+wUg0PQExkfNWuo+H+dC7GeO+H6sTU1j7W8g6wO2uoK9Klu3UNYuE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708617490; c=relaxed/simple;
	bh=n1RME01tK0uMVxBQDuD4fmWDtINL+DEyahFSdlItK3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPZmhcjzeTikvm3V0r8f2tw5S4etK+C0QXYkkg/tYDbTrJxRlOGm1ZezEcan6JdW9Vtkab3kYVYoFwAbKdjLu6+Cvg0jFV7Nsoh0nTVcKuTrDXeY/v1dvXG2UI9Swt0VL8M97mZE3B23wSDYK7eOfbNkpXYdjf/4u4Y/yUDWO5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FTRsTcTJ; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FTRsTcTJ"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-299dba8fd24so2422149a91.2
        for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 07:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708617486; x=1709222286; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vf2DP5fCCzFH92D6Z2Jm42tki05syrJhiW6PgDZT238=;
        b=FTRsTcTJ8y/q6/4ubc/njYDZlCji8jWn2J/9BsiHIRTiWmmxzkENUVp2qszSavxJYE
         cNFwLscY7fSKw6B8KqJct03lHnNfhVGM4O2ISbhL0f015yOlOtO5aSZvMtvZiRXuH1AS
         mBd7DsbZuXkEwf2rYOXC4Ti2njZAja3byn+cY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708617486; x=1709222286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vf2DP5fCCzFH92D6Z2Jm42tki05syrJhiW6PgDZT238=;
        b=t0hUwp7lwy6N66fyXe/yJGcrH4RAbhqEXeuK57iSfncB23U23w/40bkRpVvEIif+Yt
         mHJxNJyjmGngkVeleRY50ZBkFd3nBTKdY6vHFJdD/X8iIr4n9vp9Fis/OFhawrlhx1Ne
         JuUIqnl8ecuzRaJISse4Lr8nY//T4Rcd4iukQEPza3OJ7bzr3vYWvG6YazZIj8wEjOuF
         QfIoh+8oGZT+aVwIEV9bbYUMJ5KTJ/+JgMXnSuRFScvFZ1WQDrsVdPfrVfyhMHYaJ0eK
         gm38WcqlE9lE6jzGQRL+fEB7rcyxlFkE3GJ4e3cu+gYTbr9uwj7z6PsolNzPRXfN4vYh
         CNWg==
X-Gm-Message-State: AOJu0Yy2MSvEWGSZ5YE4eJ9YIdUIdWqOvF9IR0hhN7EuuuEdUOcKMb9C
	JUx0TxQV3NEBh6S4aKfbK4ARpfkjfRW2f9vCkLdaUTAlOMLNVB+xhPuVvZVHWg==
X-Google-Smtp-Source: AGHT+IHypsXAUHg+74oqzJdMrHdY4H22xZbMyKDCUCvOttZNBfb0qb6s+MS1Fe0Kg+2DHUcZlOw5Lw==
X-Received: by 2002:a17:90a:1506:b0:299:2db9:1ad4 with SMTP id l6-20020a17090a150600b002992db91ad4mr14575715pja.40.1708617486507;
        Thu, 22 Feb 2024 07:58:06 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z10-20020a17090ad78a00b0029a3c198f4fsm2185880pju.50.2024.02.22.07.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 07:58:06 -0800 (PST)
Date: Thu, 22 Feb 2024 07:58:05 -0800
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
	przemyslaw.kitszel@intel.com, peterz@infradead.org,
	ojeda@kernel.org, nicolas@fjasle.eu, ndesaulniers@google.com,
	nathan@kernel.org, masahiroy@kernel.org, justinstitt@google.com,
	haoluo@google.com, elver@google.com, andreyknvl@gmail.com
Subject: Re: [merged mm-stable]
 ubsan-reintroduce-signed-overflow-sanitizer.patch removed from -mm tree
Message-ID: <202402220756.459A7FD@keescook>
References: <20240222000307.9CB05C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222000307.9CB05C433F1@smtp.kernel.org>

On Wed, Feb 21, 2024 at 04:03:07PM -0800, Andrew Morton wrote:
> 
> The quilt patch titled
>      Subject: ubsan: reintroduce signed overflow sanitizer
> has been removed from the -mm tree.  Its filename was
>      ubsan-reintroduce-signed-overflow-sanitizer.patch

Hi Andrew,

Please drop this -- it has several prerequisites, and I'm already
carrying it in the hardening tree (since that's where UBSAN is carried
now[1]).

Thanks!

-Kees

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=for-next/kspp&id=0ea74b4de34a12396fe3790590007aa50fcb5d45

> 
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> ------------------------------------------------------
> From: Kees Cook <keescook@chromium.org>
> Subject: ubsan: reintroduce signed overflow sanitizer
> Date: Mon, 5 Feb 2024 01:37:29 -0800
> 
> In order to mitigate unexpected signed wrap-around[1], bring back the
> signed integer overflow sanitizer.  It was removed in commit 6aaa31aeb9cf
> ("ubsan: remove overflow checks") because it was effectively a no-op when
> combined with -fno-strict-overflow (which correctly changes signed
> overflow from being "undefined" to being explicitly "wrap around").
> 
> Compilers are adjusting their sanitizers to trap wrap-around and to
> detecting common code patterns that should not be instrumented (e.g.  "var
> + offset < var").  Prepare for this and explicitly rename the option from
> "OVERFLOW" to "WRAP".
> 
> To annotate intentional wrap-around arithmetic, the add/sub/mul_wrap()
> helpers can be used for individual statements.  At the function level, the
> __signed_wrap attribute can be used to mark an entire function as
> expecting its signed arithmetic to wrap around.  For a single object file
> the Makefile can use "UBSAN_WRAP_SIGNED_target.o := n" to mark it as
> wrapping, and for an entire directory, "UBSAN_WRAP_SIGNED := n" can be
> used.
> 
> Additionally keep these disabled under CONFIG_COMPILE_TEST for now.
> 
> Link: https://github.com/KSPP/linux/issues/26 [1]
> Link: https://lkml.kernel.org/r/20240205093725.make.582-kees@kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Marco Elver <elver@google.com>
> Cc: Justin Stitt <justinstitt@google.com>
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Hao Luo <haoluo@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Nicolas Schier <nicolas@fjasle.eu>
> Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/compiler_types.h |    9 +++-
>  lib/Kconfig.ubsan              |   14 ++++++
>  lib/test_ubsan.c               |   37 ++++++++++++++++
>  lib/ubsan.c                    |   68 +++++++++++++++++++++++++++++++
>  lib/ubsan.h                    |    4 +
>  scripts/Makefile.lib           |    3 +
>  scripts/Makefile.ubsan         |    3 +
>  7 files changed, 137 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/compiler_types.h~ubsan-reintroduce-signed-overflow-sanitizer
> +++ a/include/linux/compiler_types.h
> @@ -282,11 +282,18 @@ struct ftrace_likely_data {
>  #define __no_sanitize_or_inline __always_inline
>  #endif
>  
> +/* Do not trap wrapping arithmetic within an annotated function. */
> +#ifdef CONFIG_UBSAN_SIGNED_WRAP
> +# define __signed_wrap __attribute__((no_sanitize("signed-integer-overflow")))
> +#else
> +# define __signed_wrap
> +#endif
> +
>  /* Section for code which can't be instrumented at all */
>  #define __noinstr_section(section)					\
>  	noinline notrace __attribute((__section__(section)))		\
>  	__no_kcsan __no_sanitize_address __no_profile __no_sanitize_coverage \
> -	__no_sanitize_memory
> +	__no_sanitize_memory __signed_wrap
>  
>  #define noinstr __noinstr_section(".noinstr.text")
>  
> --- a/lib/Kconfig.ubsan~ubsan-reintroduce-signed-overflow-sanitizer
> +++ a/lib/Kconfig.ubsan
> @@ -116,6 +116,20 @@ config UBSAN_UNREACHABLE
>  	  This option enables -fsanitize=unreachable which checks for control
>  	  flow reaching an expected-to-be-unreachable position.
>  
> +config UBSAN_SIGNED_WRAP
> +	bool "Perform checking for signed arithmetic wrap-around"
> +	default UBSAN
> +	depends on !COMPILE_TEST
> +	depends on $(cc-option,-fsanitize=signed-integer-overflow)
> +	help
> +	  This option enables -fsanitize=signed-integer-overflow which checks
> +	  for wrap-around of any arithmetic operations with signed integers.
> +	  This currently performs nearly no instrumentation due to the
> +	  kernel's use of -fno-strict-overflow which converts all would-be
> +	  arithmetic undefined behavior into wrap-around arithmetic. Future
> +	  sanitizer versions will allow for wrap-around checking (rather than
> +	  exclusively undefined behavior).
> +
>  config UBSAN_BOOL
>  	bool "Perform checking for non-boolean values used as boolean"
>  	default UBSAN
> --- a/lib/test_ubsan.c~ubsan-reintroduce-signed-overflow-sanitizer
> +++ a/lib/test_ubsan.c
> @@ -11,6 +11,39 @@ typedef void(*test_ubsan_fp)(void);
>  			#config, IS_ENABLED(config) ? "y" : "n");	\
>  	} while (0)
>  
> +static void test_ubsan_add_overflow(void)
> +{
> +	volatile int val = INT_MAX;
> +
> +	UBSAN_TEST(CONFIG_UBSAN_SIGNED_WRAP);
> +	val += 2;
> +}
> +
> +static void test_ubsan_sub_overflow(void)
> +{
> +	volatile int val = INT_MIN;
> +	volatile int val2 = 2;
> +
> +	UBSAN_TEST(CONFIG_UBSAN_SIGNED_WRAP);
> +	val -= val2;
> +}
> +
> +static void test_ubsan_mul_overflow(void)
> +{
> +	volatile int val = INT_MAX / 2;
> +
> +	UBSAN_TEST(CONFIG_UBSAN_SIGNED_WRAP);
> +	val *= 3;
> +}
> +
> +static void test_ubsan_negate_overflow(void)
> +{
> +	volatile int val = INT_MIN;
> +
> +	UBSAN_TEST(CONFIG_UBSAN_SIGNED_WRAP);
> +	val = -val;
> +}
> +
>  static void test_ubsan_divrem_overflow(void)
>  {
>  	volatile int val = 16;
> @@ -90,6 +123,10 @@ static void test_ubsan_misaligned_access
>  }
>  
>  static const test_ubsan_fp test_ubsan_array[] = {
> +	test_ubsan_add_overflow,
> +	test_ubsan_sub_overflow,
> +	test_ubsan_mul_overflow,
> +	test_ubsan_negate_overflow,
>  	test_ubsan_shift_out_of_bounds,
>  	test_ubsan_out_of_bounds,
>  	test_ubsan_load_invalid_value,
> --- a/lib/ubsan.c~ubsan-reintroduce-signed-overflow-sanitizer
> +++ a/lib/ubsan.c
> @@ -222,6 +222,74 @@ static void ubsan_epilogue(void)
>  	check_panic_on_warn("UBSAN");
>  }
>  
> +static void handle_overflow(struct overflow_data *data, void *lhs,
> +			void *rhs, char op)
> +{
> +
> +	struct type_descriptor *type = data->type;
> +	char lhs_val_str[VALUE_LENGTH];
> +	char rhs_val_str[VALUE_LENGTH];
> +
> +	if (suppress_report(&data->location))
> +		return;
> +
> +	ubsan_prologue(&data->location, type_is_signed(type) ?
> +			"signed-integer-overflow" :
> +			"unsigned-integer-overflow");
> +
> +	val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
> +	val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
> +	pr_err("%s %c %s cannot be represented in type %s\n",
> +		lhs_val_str,
> +		op,
> +		rhs_val_str,
> +		type->type_name);
> +
> +	ubsan_epilogue();
> +}
> +
> +void __ubsan_handle_add_overflow(void *data,
> +				void *lhs, void *rhs)
> +{
> +
> +	handle_overflow(data, lhs, rhs, '+');
> +}
> +EXPORT_SYMBOL(__ubsan_handle_add_overflow);
> +
> +void __ubsan_handle_sub_overflow(void *data,
> +				void *lhs, void *rhs)
> +{
> +	handle_overflow(data, lhs, rhs, '-');
> +}
> +EXPORT_SYMBOL(__ubsan_handle_sub_overflow);
> +
> +void __ubsan_handle_mul_overflow(void *data,
> +				void *lhs, void *rhs)
> +{
> +	handle_overflow(data, lhs, rhs, '*');
> +}
> +EXPORT_SYMBOL(__ubsan_handle_mul_overflow);
> +
> +void __ubsan_handle_negate_overflow(void *_data, void *old_val)
> +{
> +	struct overflow_data *data = _data;
> +	char old_val_str[VALUE_LENGTH];
> +
> +	if (suppress_report(&data->location))
> +		return;
> +
> +	ubsan_prologue(&data->location, "negation-overflow");
> +
> +	val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
> +
> +	pr_err("negation of %s cannot be represented in type %s:\n",
> +		old_val_str, data->type->type_name);
> +
> +	ubsan_epilogue();
> +}
> +EXPORT_SYMBOL(__ubsan_handle_negate_overflow);
> +
> +
>  void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
>  {
>  	struct overflow_data *data = _data;
> --- a/lib/ubsan.h~ubsan-reintroduce-signed-overflow-sanitizer
> +++ a/lib/ubsan.h
> @@ -124,6 +124,10 @@ typedef s64 s_max;
>  typedef u64 u_max;
>  #endif
>  
> +void __ubsan_handle_add_overflow(void *data, void *lhs, void *rhs);
> +void __ubsan_handle_sub_overflow(void *data, void *lhs, void *rhs);
> +void __ubsan_handle_mul_overflow(void *data, void *lhs, void *rhs);
> +void __ubsan_handle_negate_overflow(void *_data, void *old_val);
>  void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs);
>  void __ubsan_handle_type_mismatch(struct type_mismatch_data *data, void *ptr);
>  void __ubsan_handle_type_mismatch_v1(void *_data, void *ptr);
> --- a/scripts/Makefile.lib~ubsan-reintroduce-signed-overflow-sanitizer
> +++ a/scripts/Makefile.lib
> @@ -177,6 +177,9 @@ ifeq ($(CONFIG_UBSAN),y)
>  _c_flags += $(if $(patsubst n%,, \
>  		$(UBSAN_SANITIZE_$(basetarget).o)$(UBSAN_SANITIZE)$(CONFIG_UBSAN_SANITIZE_ALL)), \
>  		$(CFLAGS_UBSAN))
> +_c_flags += $(if $(patsubst n%,, \
> +		$(UBSAN_WRAP_SIGNED_$(basetarget).o)$(UBSAN_SANITIZE_$(basetarget).o)$(UBSAN_WRAP_SIGNED)$(UBSAN_SANITIZE)y), \
> +		$(CFLAGS_UBSAN_WRAP_SIGNED))
>  endif
>  
>  ifeq ($(CONFIG_KCOV),y)
> --- a/scripts/Makefile.ubsan~ubsan-reintroduce-signed-overflow-sanitizer
> +++ a/scripts/Makefile.ubsan
> @@ -13,3 +13,6 @@ ubsan-cflags-$(CONFIG_UBSAN_ENUM)		+= -f
>  ubsan-cflags-$(CONFIG_UBSAN_TRAP)		+= -fsanitize-undefined-trap-on-error
>  
>  export CFLAGS_UBSAN := $(ubsan-cflags-y)
> +
> +ubsan-wrap-signed-cflags-$(CONFIG_UBSAN_SIGNED_WRAP)     += -fsanitize=signed-integer-overflow
> +export CFLAGS_UBSAN_WRAP_SIGNED := $(ubsan-wrap-signed-cflags-y)
> _
> 
> Patches currently in -mm which might be from keescook@chromium.org are
> 
> 

-- 
Kees Cook
