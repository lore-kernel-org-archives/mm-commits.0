Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BAB78F2B
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 23:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752361383; cv=none; b=Nl2/NILZMIlxVQWzvXAGi0uV1lLPP+HbktPzvongl4gl8XpZYdapEjhk+SQeEQVY7nSN6V/krRV+UdWiTHanKYJd8GTi8dgYbrklHoaVi4U2V3R8apnzXlhyzksw6T8AAyfWxE8rxnPQocnLh/QdhLuznMg/+zj8I1SBKpbpcAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752361383; c=relaxed/simple;
	bh=GQT1Lf77aH9hBArFl55iPb+ZROTat+8kD+dEnV/NooU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hOn7rUl9PutWwmowuB/O+ycGPnQUhRsOxWGnj+8tepZbqdJD9gyEwxQztOm4yfJuJfJ+/KRV8DXUO0Sb8Z52o+E9q77DymZWBxpAmC7sDw6X9lhWrtLprFisxWiq6RkXXGdY/4vZWRI7xjN0N97rQtn9cSMb+L0uhadpMjLVKyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F7+YHppa; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F7+YHppa"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-553d2eb03a0so4758154e87.1
        for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 16:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752361380; x=1752966180; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2tJg9o3HmwmUUIibn+scE823kIYJowc/rOtSy+LTnvE=;
        b=F7+YHppaxaW+8EkBVcUr6ZFOBevjhdMrDd22h4jFkOSbaARaUU1kpmZVkumR1SLzOR
         IDe1BWbbA+3WMh1ImoOA3cBcj6kTuVM53TSUbWGF1dkqPImX9Djo8iXMgw3DcMYLPfRr
         hYVZ5YfVLbmtA/ZpCp+DqV1CbpyAcTg/XH29i+oCS4ri8ld3IfL5KEQIrGYAws8/WKdB
         g+LCMd9tYVF7eEEhIl1vyBDX38pfgYNMNWCxSAcf6S5xTmAEl6SUAak279DVhwtpRXw0
         Mc1eVHG4EgXmGGlcOXIHw5kjdYv840YElw2H82EEebeYJmjXXaawLMTCdWcFok3YuORp
         Zb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752361380; x=1752966180;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tJg9o3HmwmUUIibn+scE823kIYJowc/rOtSy+LTnvE=;
        b=RLWXEMmykNnNjZfL2omlgbIIp9GeWGaNiguFyxQ/CQvuUqMiMTOBCd6khL8iFqbNaN
         BaaJZybbfFSkx1LbSUQ7wQpAqjh1u4kp02MRbNE0u0g076o9nKyPHXrH3Pu9DLnKS35H
         WvPki1z/5RH/G3/1D8ZtCD87osDmd5aA5rrVtRfQrrCVkTQc9WXbY1XcfPOiF8oC3aXj
         JlLKIGghW78qmnQJjBjzx7lU5D5Gc3rtodOWDhpKWuK4qEi8Hj+U6QHNPGhzONSC0ZkJ
         cQeRWPTlZcbttbNQwnCJuQ9A3fIVQTeLXyOSK7jL1OZ0NfzOdlgIaJtTrchULvQXpLxA
         3tHA==
X-Gm-Message-State: AOJu0YwllYIihwCsb5BkrKG4mDXLSWCTMJk0w1dAdX5ApehO4NStdTIU
	m8AT/sDLEF+66QKzy5q7O/oa/dEZkB3azt0VZ62p8zoRJOMwNX090Zr5
X-Gm-Gg: ASbGnctcuOJakyFJ5IMOMB8uj6bJzoWTLIoGN53SWzP85uMNIfllbCax9R4pKwRirmx
	R5PyKTqDiEXKUv37/7PMzqbMbPiAiAnJNa+cUbayJAfGNpEHJA6Xgqj5mXPz3ssv8SVR1FiQOTj
	Hfcf00TjqaVlEDzv09mBZ0T1cgXfV6YdehLVrHNYOnLJBOwozal9U2jXdOBqOyZ+NLHxCbAzXr4
	W+2DrDKnKDV2W4habAr+tkoTTmNadbradHV4GUmjIoT2Db629ZG7NovIhYLAHG+XuDOUDaCaZcN
	5kVxgtZV50FOktzCkJtp8l98ROzoxNY47pNYBOB05adoqNv1zJIMT8Zio5L754QfIURHeFzijs/
	jyXZfBVIxgTDxWjnANi6/L+fS9tgcPYTCHH0PRA==
X-Google-Smtp-Source: AGHT+IHjmwV8vbC9uDNKCOg3cvtTvbpILoes0DxxaUShuwclO6o171E19yD052SW0Op/awF7qGAtEA==
X-Received: by 2002:a05:6512:39d1:b0:550:e50a:bf49 with SMTP id 2adb3069b0e04-5590071e4d3mr4560512e87.19.1752361379335;
        Sat, 12 Jul 2025 16:02:59 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-32fa294bf63sm11315901fa.47.2025.07.12.16.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jul 2025 16:02:58 -0700 (PDT)
Date: Sun, 13 Jul 2025 01:02:58 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yukuai3@huawei.com, song@kernel.org, 
	herbert@gondor.apana.org.au
Subject: Re: [merged mm-nonmm-stable]
 lib-raid6-replace-custom-zero-page-with-zero_page.patch removed from -mm
 tree
Message-ID: <jwecjj2fkmmnan3t33r7rxxa7h6l6lgi4yf7qqq4kmboynd7rx@qtijxjnvj4sq>
References: <20250710055932.49250C4CEE3@smtp.kernel.org>
 <sr7kg67kaeuisbxitmvb3rfcvf2b6l2pelnrmgt2s4qsykw6eq@nxid2ju5tcho>
 <20250712154920.aa19ba0aaa09f46225b30db1@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250712154920.aa19ba0aaa09f46225b30db1@linux-foundation.org>

On 2025-07-12 15:49:20 -0700, Andrew Morton wrote:
> On Fri, 11 Jul 2025 13:49:27 +0200 Klara Modin <klarasmodin@gmail.com> wrote:
> 
> > > From: Herbert Xu <herbert@gondor.apana.org.au>
> > > Subject: lib/raid6: replace custom zero page with ZERO_PAGE
> > > Date: Mon, 17 Mar 2025 17:02:28 +0800
> > > 
> > > Use the system-wide zero page instead of a custom zero page.
> > > 
> > 
> > > [herbert@gondor.apana.org.au: update lib/raid6/recov_rvv.c, per Klara]
> > >   Link: https://lkml.kernel.org/r/aFkUnXWtxcgOTVkw@gondor.apana.org.au
> > 
> > Something seems to have went wrong here, the version in mm-nonmm-stable
> > does not seem to have this folded in and the diff below doesn't either.
> 
> Yes, thanks, somehow I managed to not fold that change in.  How does
> this look?
> 
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Subject: lib/raid6: update recov_rvv.c zero page usage
> Date: Mon, 23 Jun 2025 16:47:25 +0800
> 
> Update lib/raid6/recov_rvv.c, for 1857fcc84744 ("lib/raid6: replace custom
> zero page with ZERO_PAGE"), per Klara.
> 
> Link: https://lkml.kernel.org/r/aFkUnXWtxcgOTVkw@gondor.apana.org.au
> Fixes: 1857fcc84744 ("lib/raid6: replace custom zero page with ZERO_PAGE")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Klara Modin <klarasmodin@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  lib/raid6/recov_rvv.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/lib/raid6/recov_rvv.c~lib-raid6-replace-custom-zero-page-with-zero_page-v3
> +++ a/lib/raid6/recov_rvv.c
> @@ -165,10 +165,10 @@ static void raid6_2data_recov_rvv(int di
>  	 * delta p and delta q
>  	 */
>  	dp = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks - 2] = dp;
>  	dq = (u8 *)ptrs[failb];
> -	ptrs[failb] = (void *)raid6_empty_zero_page;
> +	ptrs[failb] = raid6_get_zero_page();
>  	ptrs[disks - 1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> @@ -203,7 +203,7 @@ static void raid6_datap_recov_rvv(int di
>  	 * Use the dead data page as temporary storage for delta q
>  	 */
>  	dq = (u8 *)ptrs[faila];
> -	ptrs[faila] = (void *)raid6_empty_zero_page;
> +	ptrs[faila] = raid6_get_zero_page();
>  	ptrs[disks - 1] = dq;
>  
>  	raid6_call.gen_syndrome(disks, bytes, ptrs);
> _
> 

This looks correct, thanks!
