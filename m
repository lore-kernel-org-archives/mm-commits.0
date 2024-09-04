Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B511CCEE3
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 09:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725443962; cv=none; b=oiK4Uux3146mi9BEMO5magxumZ8naTep+ci9+FClJ0lRP39TzK+xWR37rUdTy18za+xQ0g5TcxwYTKx5IpojRszxl8GnJZJWoACjt0+JuKHMZKchHjc64kNhiIGpyiiu7NPlCXZellY8IN4WiBmIKimpMWMi3p848KQz1BDa5uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725443962; c=relaxed/simple;
	bh=l00P4U04a/qfEK+1kbEu9oW6uMf3ehpKzsIBLWTCdoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KIkxGDImuWoE9GJpUUHdL0I6p8JjACda0CSGk4eN6cvB7r0vYI7zeoV+fpKLQkDFtBovXAEHyOeJOj8tUWFXcgD4wneerJU/hnheSaKI6c+ooF3RKTbtuD+y0n05oVEoqv2CRCRm/F/yH7FWSuWY+4xM/F3RlgLGoBnkWjCF1KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SKiOtHQp; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SKiOtHQp"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7174a3baf92so318703b3a.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Sep 2024 02:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725443960; x=1726048760; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Uukx7lUVPuVqzEiSwY9mpZMO4ysB73zzns2z1j6Hjg=;
        b=SKiOtHQpl6UI7fYN1pzjdx9scmqn26k86SrDttWlq4yDy9nZhsJZT5kngqtU11qYJa
         nztV4bR9LnD0epRzIKH1Vj4ReKbZKGcW4oQzzse4WLY+xRxSOZokcAqMAjY4JvTJVC8F
         fwtJ1WFdq4QK0dUHqzt9eKonG4FdRWOU42rKhxONVnEasNNfVtvOwyZSdsfWCI+XJFVC
         5IDMGnXXakLS1Kw+p8kBqxL8HNNkgOxYoSo0v8mPUj5g+YKf3Zpm85tYD5dWiDK0OGAm
         wCZiiMzt4JWUErjdhPTRECr45s9oUM74ukh5LWDnynjRGdo7+SgQ5+EWQR0OMX3aDc0O
         4pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725443960; x=1726048760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Uukx7lUVPuVqzEiSwY9mpZMO4ysB73zzns2z1j6Hjg=;
        b=w+lUlVoGeRRastMFCLb8+rz3QkYAAmkQ5YxaHvki8UIWwVR6V7n0++kG0WyKg1Cw0Z
         zwBAWrrMPyTu4drcYxvfbpVkq/w6VyvWld1T9Q/nkE/bMNa1UXRjMh316IMUxOvJs/u/
         EzimHG7gjGxBDdJlARPd7g0CsP6jMLTwPdvTlHZN+FeJKd9k5rZFmebiYQf9AEBZmk57
         sTLxwdHuwF/yP5WytySWmEYX0Uvb49co4LSvGfHI2KLNhDXwDQxUp5jsYP7/xrHfYtWB
         ErBHPAmyFITXV0k3hRtjfIPC2SYVVE/hxTb6hUU0fgFLXTnwWrP//ufCmVaYZEckPtdl
         dhZg==
X-Gm-Message-State: AOJu0Yw6RIdWHRB92xPJu2DeQl0v5A0YKsOsmjVgw3moniOMCbIPrM3g
	kgFlXDV2c7Cr8PE71HKnuqE+ruzSt6dt9PrF2CteyUoAwPb8DByR0eovqWCtodyP9UMbk9BblzJ
	GsPQA6AlLnCtLBTagPqbMDBuAeyo=
X-Google-Smtp-Source: AGHT+IEFua6UNIfZQji2p32drBwSb/C3sFUEftMhcQpj6mws2riTESDOKf0gto/jghDIJV1eT3YePQ4/HUo2AipsZp8=
X-Received: by 2002:a05:6a00:1950:b0:714:1bcf:adbe with SMTP id
 d2e1a72fcca58-717304591e4mr9789330b3a.0.1725443960169; Wed, 04 Sep 2024
 02:59:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904041800.486C6C4CEC2@smtp.kernel.org>
In-Reply-To: <20240904041800.486C6C4CEC2@smtp.kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 4 Sep 2024 11:59:06 +0200
Message-ID: <CANiq72k=mzebBFfAW2iJ-cWYTVYBDoR5XzYWZ+Crn-tq2YfnLQ@mail.gmail.com>
Subject: Re: [merged mm-stable] kasan-simplify-and-clarify-makefile.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, ojeda@kernel.org, 
	mmaurer@google.com, glider@google.com, elver@google.com, dvyukov@google.com, 
	andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, Sep 4, 2024 at 6:18=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> The quilt patch titled
>      Subject: kasan: simplify and clarify Makefile
> has been removed from the -mm tree.  Its filename was
>      kasan-simplify-and-clarify-makefile.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

I think we were taking this one through the Rust tree so that we could
merge the Rust KASAN support through there (and handle the other
interdependencies we have this cycle), right?

I will apply those very soon (in case you moved it into mm-stable
because you didn't see it in linux-next).

Thanks!

Cheers,
Miguel
