Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AB121D3CA
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767111806; cv=none; b=HcXHZFc8AmZnSOMObyRjT71JAZm5E+64ZqxXu379PPvkV6gupNn2B0T/19xQitvl6gPOmWUaXepV2TTx5wvNr+9U/v/t0K6kDxS8o9oIgL/SF6Sbmkwy/S/aWZbNnR/nzVhraMgcjOPpA04spGYpnpGCX6LvGd5SmRTSd8zZXVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767111806; c=relaxed/simple;
	bh=ONX0cv2+JhjLnUTN8O51VyT6leq5KUEjhVizgfgO2bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTqNTO2xdovbN3K01yVNiPTym9ZM2sZUSJEWiqEx8Sf2Zvhgz9YE8J4D6vWuRzK/gLE+CTfa4yC0fdgLOu83b1X92qu0x8I9kZPNyEBZctjRug95Odgc3OEfVKosaW+NfQBFc3Rvd1O+s4tF06yJDqSMKwt+X192H+CS/PELNbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6aITRhx; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6aITRhx"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-596ba05aaecso10935399e87.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 08:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767111803; x=1767716603; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=22GfgSLVW9nrtFLqbTUllG4aBZa4x2Yq5YgXpf88rYo=;
        b=j6aITRhx63gcqxBWNrRRdqIwOHgzcxgPW7a+bcooxk75mRRM3ZDe8k8BXCuN17YHoC
         BTpBLgblhXIizymlOEfAlj5l3zrVTWM0Mn+7MIeigDZqXrSfi3jYZV/NFHQglfYRgWv5
         96TaHZNl4zkKi30ix7p1LFIQ/pv8UL5juZdHrDbWYJQp8CrrogXMUPxyrlT9kPjnQwyc
         oZR0M54B1vfrlXF0/yilkOgUUzEgFlL4dVyxFNX0VJ5g5B39TW0R0TtjK4RcBlGsF3M3
         YSoxaTogk5rqXgOQaJ0aLUmzwePHzPexTSBO8bill2czPAkNoxqX2DpuklNNc75yStyJ
         U3gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767111803; x=1767716603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=22GfgSLVW9nrtFLqbTUllG4aBZa4x2Yq5YgXpf88rYo=;
        b=UHW0olpqZEHmDJKCpkQTvGeSWzgDRRot0xtUUxh0c3gpcSyX5XJ4KmOHyYKyACIfYJ
         I2QqHqR2BRWfGNFVpUFtXsPW+Hf7fLzetuvRwycERcYc9oB2Nqssi7mu86a8Iidun9bg
         3eJiK2dmUBVmW9CJYWXoQsbMDit3j5rkvVCfzAPq30ZDFIFW27xrSq+8Fq0hG/5nezYK
         JGh/JB+jJEGY0v/VptfG8njA9de8+zgE8z2AmKVk6GeSpuI7pFAh5ygGH4II7zTo955N
         wz5RrBiEaa7e3vL73JLcNV8Yuanov+7wxU1L8VAlj7wAuo5+m8qq320sSL6yJFXXIzH0
         XcLQ==
X-Gm-Message-State: AOJu0Yz5ZZo7YiYXbhBsKyQHFsEHNqMMVy/ZTRybdxzFAlOgofTA+IK/
	Vr1vZeG0JjOgJUDIsUT2Z8Y0GKyOXUvhpvRJclwPuOSm28mvh5U/rXc=
X-Gm-Gg: AY/fxX53sSl+4Nqg2SB+f8Or8Y0WYNn9ByXJR3UGGChZ3avnmHD6pPH6agXkYOt1pJR
	v1jtJjLVOoFCAQyaUBUGlVKpvdXVaSxiiHVtFblfPRlxIZjuA+CdIuwVdjRqVHGK7xjVQcfaot7
	OQkIjyf6m+Qo8fWA3hz3rHKMpfqHLGRN+Rmr6Q0u0uo/pwFKSkAkr9qJydDKvtGDlAtGysA4yJx
	DrYpO9l8RDlGRhq6e2pEiuT4YaLz8bsqs6A4aeHLJBV0bsrvHjivfRLL3pqAX19jDz085JMtWYf
	+B3niguirUgLl4RvMiOkv9pShKAN5RvRMSKCFL/maxnvUtZ7SxheCwTWTOImKpkgkjZkp5z0KqB
	JhwcBLPsXgN5Jsxhsh+dX+/JciU/xjhAtLO2tQmGUJI1t/VvioJwYA2XjLTnM2DkzVBUgy7FooG
	p+
X-Google-Smtp-Source: AGHT+IEa2IZqd/x12v5cDLghgxV47gZik6ifYEe5Q7rvahoFptChCXGY3tpRDDqjYooWDFj+7hBBLw==
X-Received: by 2002:a05:6512:2241:b0:59a:1087:f0e8 with SMTP id 2adb3069b0e04-59a17d22532mr12433931e87.21.1767111802399;
        Tue, 30 Dec 2025 08:23:22 -0800 (PST)
Received: from p183 ([178.172.147.163])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a185dd1e9sm10160621e87.23.2025.12.30.08.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 08:23:21 -0800 (PST)
Date: Tue, 30 Dec 2025 19:23:50 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, oleg@redhat.com, mingo@kernel.org,
	gregkh@linuxfoundation.org, david@kernel.org, brauner@kernel.org,
	atomlin@atomlin.com
Subject: Re: + fs-proc-expose-mm_cpumask-in-proc-status.patch added to mm-new
 branch
Message-ID: <2a537a45-d75d-41e9-96a7-aefd14420ef2@p183>
References: <20251228192403.10773C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251228192403.10773C4CEFB@smtp.kernel.org>

On Sun, Dec 28, 2025 at 11:24:02AM -0800, Andrew Morton wrote:
> Subject: fs/proc: expose mm_cpumask in /proc/[pid]/status

> --- a/Documentation/filesystems/proc.rst~fs-proc-expose-mm_cpumask-in-proc-status
> +++ a/Documentation/filesystems/proc.rst
> @@ -291,6 +291,9 @@ It's slow but very precise.
>   Cpus_allowed                mask of CPUs on which this process may run
>   Cpus_allowed_list           Same as previous, but in "list format"
> + Cpus_active_mm              mask of CPUs on which this process has an active
> +                             memory context
> + Cpus_active_mm_list         Same as previous, but in "list format"
>   Mems_allowed                mask of memory nodes allowed to this process
>   Mems_allowed_list           Same as previous, but in "list format"

> +static void task_cpus_active_mm(struct seq_file *m, struct mm_struct *mm)
> +{
> +	seq_printf(m, "Cpus_active_mm:\t%*pb\n",
> +		   cpumask_pr_args(mm_cpumask(mm)));
> +	seq_printf(m, "Cpus_active_mm_list:\t%*pbl\n",
> +		   cpumask_pr_args(mm_cpumask(mm)));
> +}

So this is 3rd pair of values which represent the same thing
but can become desync during read().

I also wonder if anyone checked %pbl code to survive printing unstable masks.

	/proc/alexey
