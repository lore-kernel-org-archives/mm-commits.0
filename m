Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776D42868AD
	for <mm-commits@vger.kernel.org>; Fri,  5 Dec 2025 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764971800; cv=none; b=ntBz0+KXaqd6tA1LTcnQD+/6G2VxAmDL844dnx10WkEASlLdF+EK/WAWR0qNjDSaGo6DRkJLSnURYqbP7DYOc23+7gmNIeC3GBN95E0UZRyiNnWvZNpRcry2wFCqkly7Ik/u+9mD5jhr5Kc0PsIaTk0bcgoc8SynpPIube9+oiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764971800; c=relaxed/simple;
	bh=ZnRSSvl4jTP4pg+AUzW5rSp4U1Jh+XAfoSkCSKpCit4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EjUb11h3Kl1VPv0A/6LbvVN0ZIrj05E7iUNTfz+7s7OG+hNiuiIG0422qV68vWKCcmVUOUz45I3lsaq9AhTpCTCFoQLOhgnEQfPsShMrU0du3RnHz1HHfHtlVD6XnO4J7XgHEzTQAmz3tAL87spXYrueTxy7DJDelKh42gTQKWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hem47Ezl; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hem47Ezl"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso4559921a12.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Dec 2025 13:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764971796; x=1765576596; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YS34/ZTuIKBhwuafrChCxKoiQzvczG3OxfmcHipP46o=;
        b=hem47EzlH9RVH1ICfz7gg3Hzt8F3XYd3SN8nTQ3Dpb6boZjPP3Xo1bR6pao2R1GcNv
         z+DHEsREJlZFhVfGUPd16AtqJse0VvhR/nop0XxG6qnFBrBVIVQonJ3yOFa3IzfKODLk
         LWEIT7mTC7C8K/KCEUSvlhTCo0l+O7kgqCbW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764971796; x=1765576596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YS34/ZTuIKBhwuafrChCxKoiQzvczG3OxfmcHipP46o=;
        b=EUmNeuYYACeQdwvJoyZ2VN9aIg1k355Y2TCHSEfbvEJbZSxJ6kzQe2ZdSYpS7QhPuf
         lglC5EyKgkf+hVSRWF24h51bk8Z3hgJN5hrqOcXnbWx2zCxV3CPDY7/B/SLw0jMwyw/8
         sSm3/hJOlhOvUDWEZgAUZ7ndeiPHN2JicXra4swIpbqwBl5w7iNQ5daDCfJG1Tu6ZWyl
         UI0iYZbDQ9daqaIlcc+AAMR3AF8eKfwWZ4+e5AtpJ7Q0DmMJS2LX9gX1EBTebzTfNxYJ
         hR24V2KZG2dKyc7MYHs6GVksZrRm9ho2U3OQVa4X0Iog4EAv2cmIBjFHthAYlxfxDvgj
         79cg==
X-Forwarded-Encrypted: i=1; AJvYcCU+PnFsBELGSFQmwzoT9BLri04xjtOeM6QTCix5JMmD/p2EZr4N2IC70KESYVmhAbs3lUHHu3b91uvG@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+NMxv5CYrHyzq08j2W1G1NUHmAnOwKMlCUDvDDqqe8vrV5T2F
	aejnCiTOAQusV+n5kuiYF9OIFbuYPgsjYN54i3iELzukYYgVMWsGp6boPXV4DrnNKmMBubKOh4r
	qZjAP/HwWuw==
X-Gm-Gg: ASbGncuCMOFgIQ+fufYC/kSKvzFm5lIPWuzd8rnbV3QDFfxh4BmH6+iGBEDjjEDwJSe
	9/MPoTaFcDmM7tgtXkzaGy1TPenWjCLIs+GRzQtSE0LzkXtJbXhK+MJKpdZ8rSGp+JDsLhAiIl6
	RRR7ImMW0n19Upb/4tU95M7LM/XloJH68tJntrfdOE3NshfVcwGmDl+o+RA9rR7+WT/HKsQaLhI
	9OMgk5M2FftiPs7UWvDpuFEzY3Pjg7XpEQ85r5m35jw7fyA8MsvNRSGpDGP2DOS2NgSqb0P44AN
	Zoe6P6LrEd6Q4lkEby41A8yujl3cGCRVaqMWjQwoVGBUyJL4PZo8+D80u62JE1r9SP5NvyXmwDL
	eW2JEI2WTUd2qOXUhTqctdbKrCM9L+IYhaeIT0/Glxj4fyrPF0Sgns+JSN4sPlBQoCYQPWujv0h
	oYKRYZIYPzP1ezM1RwmDpdKwcvkFUr5kl8jeS5dF7OSB+94ioIewGL6x2JHck4
X-Google-Smtp-Source: AGHT+IFwm16YWMhwwyxf+hBo4NbFYmSxYUWmLenzr19pO/nVaZU7aQahqpGqgW2Kp8CKtdh+b5jYTQ==
X-Received: by 2002:a17:907:9611:b0:b76:4c8f:2cd8 with SMTP id a640c23a62f3a-b7a2477ae0cmr47872166b.55.1764971796376;
        Fri, 05 Dec 2025 13:56:36 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b412dd8csm4718055a12.33.2025.12.05.13.56.34
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 13:56:35 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so3926341a12.2
        for <mm-commits@vger.kernel.org>; Fri, 05 Dec 2025 13:56:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUVcUrjKYaFRFzxAkRzUi18Hu4/SHlGtFxReRGfLMRPmMrBPTQaAd4XoU4u7QkJZcenVb5aQLTGy9NI@vger.kernel.org
X-Received: by 2002:a05:6402:50ca:b0:640:a9fb:3464 with SMTP id
 4fb4d7f45d1cf-6491a3e15e8mr281045a12.7.1764971793872; Fri, 05 Dec 2025
 13:56:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
In-Reply-To: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Dec 2025 13:56:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj1aw7p-JkWdcJOkQQ279qgppG7_1kxFQAqaak7fEQAjw@mail.gmail.com>
X-Gm-Features: AQt7F2raveagspIXcILTjqryWuFYBWky6HLhbYqsd4miy0ZkeQl0CmPr-EtPev0
Message-ID: <CAHk-=wj1aw7p-JkWdcJOkQQ279qgppG7_1kxFQAqaak7fEQAjw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
To: Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Dec 2025 at 21:29, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Ankit Agrawal:
>       vfio/nvgrace-gpu: register device memory for poison handling

So I had to look at this one because there was a conflict ("int ret"
had been removed by another commit), and after looking at it I ended
up deciding to revert this patch entirely.

I may be wrong, but that patch looks *COMPETELY* broken.

It did

  nvgrace_gpu_mmap() ->
    nvgrace_gpu_vfio_pci_register_pfn_range() ->
      register_pfn_address_space()

using &nvdev->resmem/usemem, and honestly, that looks mis-designed
from beginning to end.

If somebody maps the same BAR of that device twice, the second call to
nvgrace_gpu_vfio_pci_register_pfn_range() will randomly overwrite a
node (that "region->pfn_address_space.node") that has already been
registered and inserted into the pfn_space_itree interval tree.

You can't *do* things like this!

Maybe I'm  misreading this, and somebody should correct me, but it
really looks like completely broken code to me. It basically seems to
assume that those two bar regions are mapped exactly once, and I don't
see why that would ever be true except by pure accident because you
only have one user.

That may be a common case, but that doesn't make any of this correct.

Again - maybe I'm missing something. If so, that commit can be re-done
with explanations of why it's all correct.

           Linus
