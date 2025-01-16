Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E444A18E750
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 20:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737059592; cv=none; b=CK7kHRMIv+656feYzNmh8lD9it78Zp1D4L40WMRr8IvhVsaD70s9UszDEvhb6cvKbJTr0CIZs631C1TxBFA/6/GYRY3Y0eyPuHvhgddonbskkk/OKSa3FMJntYWNfvrV73jAxIAp2UmoYXiiLjoNeHozZ8ZKNoW0WlyfsO6bjvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737059592; c=relaxed/simple;
	bh=ewtO+s91/M4+/zlWmywzywSQD/JLy8vDVlWY18Q/vyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tj1ozCiS34VeSa91mHi2MoSkgkLKVUR8ZCZEW1NOu8ShF/GPe76n9pmy2Tn/I0oXnSUtI/gnarfKvgKYhZVEvytQqY/v3eUOpscYFZODwDX+V4d0C8ScigsIL0ZB09UwLyOIkqgzBOoqDp0bmRAWmjkXuRx8JVKqfICTWn1Nxhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PiNhkEtW; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PiNhkEtW"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso264495366b.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 12:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737059589; x=1737664389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N99XEuP+j/jXTkRTTqUfZwF7OP7GtmnNwUsdFB/RQho=;
        b=PiNhkEtW5frXeT4R8xppDf1ml1Ccuk0WQ+kdWp4dh/Js4Re4lEb4qUNeKMBEkGLM+a
         ndh+XkCOcxprV8Ezy7ZmbC1YdWvKOSNy8KKXbgCKq1P2cMwcyWGPuJhzetXO4/zdPcr7
         EVo4jJkWisbY+DFflrqaVHG8Wtmlf8Zuig6ywtu5/EJlPZxnynURc80UJLVSAQreOtcL
         LmZfzOeWv7NBpLPx+Q//g7KJcx8leY54lOFkHr/EfYvpKZQCZZpKng5+agA+gzMTGsZf
         cZg7h8UGJS43N0zDA4CYsZ8K57FOqnAvTSHsBSI+RhnJ1CBn6597ldDhruZfjC8XIH5a
         aTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737059589; x=1737664389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N99XEuP+j/jXTkRTTqUfZwF7OP7GtmnNwUsdFB/RQho=;
        b=hZzMo+Hjn6h9j2mxn1JRYuJNGeaxYU8YrwXGNk7hBUj8Dfk4WxfqqUbFS87nA+tXMs
         +Kml3zlfuzOZozjOdsF/wnL9/WtUK+bHBofsB/fSThWMfAsrJkXZQf22S6bcj1zDymp9
         KHF2Ccc1qtZ9En3seO18JCDUTY//3gEiHYL7Jy6fdcXFflQdjPMbyw0lmpt/7iQYw5a7
         6ZqpGBLCMlO1iEFYeh6/kIp9kE5cFSP0GETrQLW9iEsYDY7Lqqw7tkIN9Rt3jQC0H8Rq
         KdisYDBIOUyJkN/hqCa4gfHHrZiwpZuwZ+qpxPiztwNYxeRGHfuX8ttEEdgnY6amT7yP
         FLng==
X-Gm-Message-State: AOJu0YzsaNIyS+3CF8Q/E0fGIQ5pmOTS/ZH/Fb4B1pkS566BfBvHmUqf
	zKRtmBbQK/xJF7mhBe1VgUyOrjTlI29Kq8fTntEtHmYIcNEz8Ck+wolmAh1pjwhQWzcK5WpbA1U
	HWqalI/7Zw3eLkQP42bVtGPbRKv8Sjvie6qY=
X-Gm-Gg: ASbGncv9Gx/P2PCt2T8LCJLL1u6X75g3lUfmOn+WtYQGIi085TLyzHoHN5CORzpCoQY
	PrlYpDeMSMJ5Xb4SzKhwOWdtXcZrsjzAy3S8=
X-Google-Smtp-Source: AGHT+IF/h2LKrJ6HhrGYwPvG5qd6Kyonbd45HKH+3Z6e7EVWsl2KGCehtbfoyav6lHHbqswLvvpfjJCD3541iqGBrgs=
X-Received: by 2002:a17:906:cec6:b0:ab3:85eb:377b with SMTP id
 a640c23a62f3a-ab38b4c6c1emr16907366b.53.1737059589066; Thu, 16 Jan 2025
 12:33:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116054810.A1CAFC4CED6@smtp.kernel.org>
In-Reply-To: <20250116054810.A1CAFC4CED6@smtp.kernel.org>
From: Bill Wendling <morbo@google.com>
Date: Thu, 16 Jan 2025 12:32:52 -0800
X-Gm-Features: AbW1kvY3CupN_YxDw37fw-yihR3hjnVGhO5gjtJkjumwog_3LjnX0-lFkuzMuMo
Message-ID: <CAGG=3QXtnOPY24sGHoT4VHoBN-Q27z1y_qcYO3gm7TBbr41NBQ@mail.gmail.com>
Subject: Re: [merged mm-nonmm-stable] gcov-clang-use-correct-function-param-names.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, oberpar@linux.ibm.com, ndesaulniers@google.com, 
	nathan@kernel.org, justinstitt@google.com, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 9:48=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: gcov: clang: use correct function param names
> has been removed from the -mm tree.  Its filename was
>      gcov-clang-use-correct-function-param-names.patch
>
> This patch was dropped because it was merged into the mm-nonmm-stable bra=
nch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Randy Dunlap <rdunlap@infradead.org>
> Subject: gcov: clang: use correct function param names
> Date: Fri, 10 Jan 2025 22:29:44 -0800
>
> Fix the function parameter names to match the function so that
> the kernel-doc warnings disappear.
>
> clang.c:273: warning: Function parameter or struct member 'dst' not descr=
ibed in 'gcov_info_add'
> clang.c:273: warning: Function parameter or struct member 'src' not descr=
ibed in 'gcov_info_add'
> clang.c:273: warning: Excess function parameter 'dest' description in 'gc=
ov_info_add'
> clang.c:273: warning: Excess function parameter 'source' description in '=
gcov_info_add'
>
> Link: https://lkml.kernel.org/r/20250111062944.910638-1-rdunlap@infradead=
.org
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Bill Wendling <morbo@google.com>
> Cc: Justin Stitt <justinstitt@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/gcov/clang.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- a/kernel/gcov/clang.c~gcov-clang-use-correct-function-param-names
> +++ a/kernel/gcov/clang.c
> @@ -264,10 +264,10 @@ int gcov_info_is_compatible(struct gcov_
>
>  /**
>   * gcov_info_add - add up profiling data
> - * @dest: profiling data set to which data is added
> - * @source: profiling data set which is added
> + * @dst: profiling data set to which data is added
> + * @src: profiling data set which is added
>   *
> - * Adds profiling counts of @source to @dest.
> + * Adds profiling counts of @src to @dst.
>   */
>  void gcov_info_add(struct gcov_info *dst, struct gcov_info *src)
>  {

Reviewed-by: Bill Wendling <morbo@google.com>

> _
>
> Patches currently in -mm which might be from rdunlap@infradead.org are
>
>
