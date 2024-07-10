Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8041263A5
	for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 23:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720655634; cv=none; b=PHihzrhmGY58J+pgxqIclhcHcvs6eB2n3OnU07cxWbzUZnddz3EO6i/D3Oc35yhapJgVZC42jJ/WOlxJyqSPxAliOsyXZ4pRVyMJ120/Pg8GsGRG8EMcMDpUnp5jHfwaRaxUODois2GE0DW8+dEVcV87IL/jYTcyi0hQAkuWJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720655634; c=relaxed/simple;
	bh=vJtjwO4U6t3tO8Cp8tvLaddrscD8QjQmAS5r5wvcpdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgLFPo9xOwWm1mrs0EPWrqRAC6yN5peu7wItvfVWAq4ENpa8z4uBWKKtqpoSRQ4b5SDXbGumwfAhMVEadJZDmFcRfTAdZXVY+vgPPjHSHZD6FQBMG0Co91aBfa35IesHKl3JSh+7Z9Y+7rZSUF5rQhAG3QGNgPO5ckT7SxLLXLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OFzGkoE+; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OFzGkoE+"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-58b966b41fbso306123a12.1
        for <mm-commits@vger.kernel.org>; Wed, 10 Jul 2024 16:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720655631; x=1721260431; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oeGdHKF3Xsu0KDyVZFu1ujHgXPmkf5xsld3icu48WuE=;
        b=OFzGkoE+g/tlXSDh9dpyVE3EVCnmYXByEk/Jfmok/BCMm3OgxfbchKX7RctWsWMUeD
         HrmLOKgRW2RbmDCP7OTu1M07baDybgv8XC/gftS9/Eq0I0CUBFP/fO1QPX9SEGYeB3Nv
         8BTGgiWfwXIQh41Al8TsVFDKpGXU1wgVbgz7z1fSgkTqMgukkvk40QfWVLP0y0a5cPvf
         /NiBAjbsPU6eGK8YptknTbvaJKFZu3QnbyW7ux4ynAL2MergBE6dsbalJT+nmXdJ6p26
         z5djCnNQdC0/uzEo/y5wdI447X+ea8960HfQjz+AfPZpglgee6YmJe2WASNMRuIrJ2+h
         XUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720655631; x=1721260431;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oeGdHKF3Xsu0KDyVZFu1ujHgXPmkf5xsld3icu48WuE=;
        b=Yzoso0Zn08VuSG878MNpfZYROHl73NC2XVWLrcZ5bvcEKypvc+8WONcSNG7eTM9ZP7
         xB7kMpL9feaYZAwSzMuisVpmGN/7SvBTd2cy5cjRcP05C+X0JII9wC1pHM40rQIWApun
         ZDhg66IGTLLCGuk4jelajAvSDMt6jz6UuCJECiaCgPpPr8vn6TNP/KKE5QBZnqx9UIVa
         Jbuqy80uHfrVafcWH3Z9gViN2dOE8MFx7cMb4JCQH9gpPVfTY4o2LERHpbJnd3AH6fqO
         +NamoK+TSDX9yddIwjYCrgwTEwyO2E/tpQY+IEoGBrL8vX9kiuZbriZlwZCExMnpyMTR
         EUiw==
X-Gm-Message-State: AOJu0YxGl5V4BxwOzpEtE8pZ8uUfZTmzlFJqmgXPXtTYIGYOxt6twhml
	tFZAn5vD1Dx9UF8qwinagKSBWQJtrWND+J5n2oSZi8oxeJsXE38KcO+TCZha
X-Google-Smtp-Source: AGHT+IEIjdZz+9kiB9KuSlExeBvcsf+1f/oNrHrIg4HoGbX1aeFzGlde19qPX1E5rLIhZ4i0BhCKrw==
X-Received: by 2002:a17:906:ae17:b0:a72:6631:fe60 with SMTP id a640c23a62f3a-a780b87ee15mr437544066b.51.1720655630503;
        Wed, 10 Jul 2024 16:53:50 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a871f24sm201095966b.205.2024.07.10.16.53.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jul 2024 16:53:49 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:53:49 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
	masahiroy@kernel.org, sfr@canb.auug.org.au
Subject: Re: +
 init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch
 added to mm-nonmm-unstable branch
Message-ID: <20240710235349.f4g35ewdgfhpo77f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20240710185931.88F9DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710185931.88F9DC32781@smtp.kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)

On Wed, Jul 10, 2024 at 11:59:30AM -0700, Andrew Morton wrote:
>
>The patch titled
>     Subject: init-modpost-conditionally-check-section-mismatch-to-__meminit-fix
>has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>     init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch
>
>This patch will shortly appear at
>     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-modpost-conditionally-check-section-mismatch-to-__meminit-fix.patch
>
>This patch will later appear in the mm-nonmm-unstable branch at
>    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>Before you just go and hit "reply", please:
>   a) Consider who else should be cc'ed
>   b) Prefer to cc a suitable mailing list as well
>   c) Ideally: find the original patch on the mailing list and do a
>      reply-to-all to that, adding suitable additional cc's
>
>*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
>The -mm tree is included into linux-next via the mm-everything
>branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>and is updated there every 2-3 working days
>
>------------------------------------------------------
>From: Stephen Rothwell <sfr@canb.auug.org.au>
>Subject: init-modpost-conditionally-check-section-mismatch-to-__meminit-fix
>Date: Wed, 10 Jul 2024 09:28:02 +1000
>
>remove MEM_KEEP from arch/powerpc/kernel/vmlinux.lds.S
>
>Link: https://lkml.kernel.org/r/20240710093213.2aefb25f@canb.auug.org.au
>Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>Cc: Masahiro Yamada <masahiroy@kernel.org>
>Cc: Wei Yang <richard.weiyang@gmail.com>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me
