Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A5617548
	for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 23:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721606375; cv=none; b=jQR1tdUTpDt7up1UV0MniquKYk0tsZ7E8y14vaS+Fg0gupiCq94Kmj3+R8xOx65UGPv4gw1m6c5em1WZ7kCWQDC+fKVvLaRoU7s6cUpoKpJZSLafHqwB/DLD0xH/chxl+yTJNYvyEutNeHwAce2mR4M3tyoIsWR7OlMIAwFgbDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721606375; c=relaxed/simple;
	bh=WOFMqWv6BalJziiXdfCEQkE0MOIy+Bx28w3rMsa4/7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TYSlgWqXi62SVtZWIV0ypcHOR8EP0pm4hE2nxggZLrv9xEpnsCGqq33ROx9bOFb1HMPFT0U/+c1XAq57pV382vYdxtsblGxYegOJyzokxVETAA+fuZQ9JQ5/cNNKuMFaSt3eqAce/p8UV8RKBOkG22LjgbJRX4l6nAJ27MxkqCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xy90NCGa; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xy90NCGa"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ef283c58f4so11114351fa.1
        for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 16:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721606371; x=1722211171; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+fOZVeriWhpqkH9YM43LruoiJ/1LHSMucjdwmnlpWHo=;
        b=Xy90NCGakbm8cjVWbpE695gGD7NhUmw0c2I4uIApSRR7Ci5CmwDXMGdSrw7rH2FZxg
         L1gWFyGOOwaUtu/sOw69fn/QPyspLkohro9XwpX1axT4C3Gtexj98BKBSpJOGwMoueb5
         m3tEuHgumPaObk444XwFN+rlvN7UH+68mHLe4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721606371; x=1722211171;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+fOZVeriWhpqkH9YM43LruoiJ/1LHSMucjdwmnlpWHo=;
        b=AXu1mQjXm0lhx0+xRqXCgsNcLLcGzsd26hxTCq0Bxocf/U36DSOLzsKoZAmPIJkdMa
         PFnTkOV8PgU54LqqbgG32sB1Da+MzOaZ4xcpfCgM+5SyXxsCoqRVX56WUckS2KVyt2di
         KDOan3nJ/2Uias+Zy87rJltH7ey+c/CONVfxSRveqaSL3J0oGr6fPoJvGxdHDZGCLhIj
         O/JRZXyodGPbVlCUKn+10tSsLrxrJXH5i7lhuK/apE5V4KVjM27g+rt1aMHLtpgE4b0Z
         +7xHukL178206+xU/tmNOPlSv3dVhRWJWrEbB4n2Ui2SHoTMtEZxg7lMSPulscoTnt9b
         FiIw==
X-Forwarded-Encrypted: i=1; AJvYcCV0F3ET0iA6DBpjvHnDAEHMQsAp/MlvIBRSwoamhA8VehJZH2nFH2505VrX1PXwifqyU/6q3xYXsX2FAamdbrtFrqruz9Y6FAMWuA==
X-Gm-Message-State: AOJu0Yz2yRwHGUcbsufy7HeYTdOq9Z8Qq2hb5WhIwB0Earb1qQkwhXYz
	6bjHTMcfJiJEO9JO2aIEffrPq8OOYGYoiuK1q+COK0gr5PhFblpiItG3Zw5gv37qRvrXDHkA2qI
	mDl0=
X-Google-Smtp-Source: AGHT+IHxVjBoJsOgYBJ3IU3O0gS7dYi7Fzk3YxqDTtSLr/LU6grv/iRsrGrR4K+hLS8aA5QjJ0qDPg==
X-Received: by 2002:a2e:97cc:0:b0:2ef:26f2:d3e6 with SMTP id 38308e7fff4ca-2ef26f2d9b1mr21004971fa.34.1721606371455;
        Sun, 21 Jul 2024 16:59:31 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ef0fcfefccsm10614231fa.110.2024.07.21.16.59.30
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jul 2024 16:59:30 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ef2cce8c08so7482251fa.0
        for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 16:59:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVu8AtVk1cbATAV4PV6m/9N1yP/aW924oXlSO6IPpo0ElBzCsZIXkY88ygMmM9tcxwJotpCvYH5xjHFrzSsEZKBbR3iITDTbEeZ9A==
X-Received: by 2002:a2e:9214:0:b0:2ef:2c20:e061 with SMTP id
 38308e7fff4ca-2ef2c20e213mr16484871fa.22.1721606370402; Sun, 21 Jul 2024
 16:59:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
 <CAHk-=wjpx6uTAvjNnD5eipGjNYcwTgG9G6Dct=eLTfyzaaTy_g@mail.gmail.com> <20240721165225.0c96cdf1a51bcd7630b0afdc@linux-foundation.org>
In-Reply-To: <20240721165225.0c96cdf1a51bcd7630b0afdc@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Jul 2024 16:59:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=whOue1FHXP7gvC7Heq0AKFYC32FrUytSao6oBuChRCURg@mail.gmail.com>
Message-ID: <CAHk-=whOue1FHXP7gvC7Heq0AKFYC32FrUytSao6oBuChRCURg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.11-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 21 Jul 2024 at 16:52, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Yes, right, sorry.  "mm/hugetlb_vmemmap: fix race with speculative PFN
> walkers" was promoted into mm-hotfixes after I make this note.

Ah. And that explains why the commit ID is different too. Ok, thanks,

             Linus
