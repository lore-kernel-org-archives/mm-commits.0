Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88A130BF70
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788966518; cv=pass; b=T85w68R3BNokxsNuRgKdPAdivrTb2AcdmSPo5CYdzEe9Yu3Y8PT5qMA2x2sfOT7Lk9VFRCka+KNGhdyRAP/eCSa6z7kFo7I1h3qwNPkDW/So6Pa6D1Kt4NkQZT0tcL2muOGHB08NosGdWUkZGAbhPj6kNYJqx1dCqIuyz41dM2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788966518; c=relaxed/simple;
	bh=jSQnyiVi8XwGjn3yuq+Uup3Eh9fiHdl+7fQ23fVLuhc=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Content-Type; b=KGRcuFCXC6aIjRWHE7igpy9hfMLe5FdU1RWYF8cacdh1pgENHgCj7pOKKQKwNXu5jgAb9qxmiv5CzFTjHAb7+HYuG5r2Zl8HkaD7L9U9jOWK46FpHi0vvWpDixp5wF4fCLAex/rrRPWTqXbCcvlE3rbiFFe7I9w4DrTDTWoNIBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ah6YIvwQ; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ah6YIvwQ"
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab201f9so447385d50.0
        for <mm-commits@vger.kernel.org>; Wed, 09 Sep 2026 08:08:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788966516; cv=none;
        d=google.com; s=arc-20260327;
        b=W099pgq6N13gUsMq0NWaNNiY45sZEnC0ujjUA+Ph0AQkHj5wPBha4krQQi7wAqWm0a
         Sga/xiJDtAYrINhiEPPWJkmSliP45BU+Ov4IpAm1OkDWkkJtjraJXqmyFEg3P+zsrsAV
         UifdjsmJ0NIHF+EykrXb7eWsLJ0RtXKmK/C9UemhPAue1vhFgIEYPbbx3/ZOpU2OpCkk
         lcw7Q+26D9FAeAOoe79eNyj6Bqg5qG1j2FcsVmvrIyR7+IbqTFv/xdGF0jJtFHlIuJyy
         1Ku4O+4CFctgbqBuWgD2TkkDUrLAl6Uw6PH6UMg0tGrUC9yngw2Un8g7y6PqqG7/7uN7
         Dzmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:mime-version:references:in-reply-to:from
         :dkim-signature;
        bh=94I0hUMtDNmKUxYIy7OV/M7nkeWTAvjSeGub385Un2U=;
        fh=L77onqX5wK4nHINe7NyDS0mE/xrK0uGJZzxNswJQctg=;
        b=LjDcEFlxHxLcavi3tw6RyQAR6DINML/2yNhplJVkcg+D86SfLly8FakB1c0Jdgj9K5
         G+lvoHoMHFjaePXt8i3giY8xGtZo/3i59a7A6IOqN20A0WpKS4YeWEyWiZscM8gcarRe
         vY1llqbridiCxJVRf4lvLAly4eS/wqXVJVil/d/oZ1TnK90FbCQU8dKNzrefmlCVzhxP
         7/g7zplNKB9aoXG/VbrO+sikjioYhfNalD+a+a9q33aLSpCiihNiBhY7dpQqADwEmOTf
         TZPr88lOr2sWXoJzEIqivZ4PDvh9Cpn4oYIvXGP5sCyNfU7oPPJKdxTFWVKuHiGFy3k5
         N2MQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788966516; x=1789571316; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=94I0hUMtDNmKUxYIy7OV/M7nkeWTAvjSeGub385Un2U=;
        b=ah6YIvwQ6ICIjEiirBZOikxCaZh30LHQLNcvlQelDneqXo7aNvmUFcNzwIoiKtLsIy
         IvfqJXiy1GO/MK01g4OTHpDMSavLAyGxh6tQ/ZtWEPUTKEv0SXBcWueJgPvvFjCVcSQK
         fmZNH8TmVfvDa5SAl5SoR9htRb3jVBFCAJfyMs83drWCII78cs+92W79xdAzykMgI36N
         0XZivnufD8G4XV7UukYAIpRGpxECnJ6Oy4O7lQWHjrCPrQskL/QNQJzbVpSi7pl+55Wx
         4/m8UbBsjv+40a451CLmFafBTQZ/V5+gDQFQmIfp0BxMVSCVjrQeG78DZezrDKuwY4xm
         aOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788966516; x=1789571316;
        h=content-type:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=94I0hUMtDNmKUxYIy7OV/M7nkeWTAvjSeGub385Un2U=;
        b=dgUAEQNEXW57+O7Y6lONvMzNUCDD+mMQeTu6dS2gtOygD442egDa6cp2tIQYHVjVaj
         6LIxMlDQ2w1K0n6Gq/KAhLIBXe7b816mdKn9XeLWKmspMhZkPI0zE8mP+vROmYMFqrmH
         9X96fCweGf268V/otebzCDJJ8wX5QIKc83iFv+X7bDLQB52KZQp8ebAG7lkNe00R2zZm
         ScgwnzTyiHR9wXazCcygtbInfNqef1B9kJAgXcr7a6x4LwlVHgJTwrAkIm1Kgp42ithP
         iQ5waiDS0ZW/lPl4FEqSmYak/kkHTVvnj8jMxaxRwW+HHDotS4RsmnCpsn3fVjLkDBbL
         grzw==
X-Forwarded-Encrypted: i=1; AKwUvBwv+HVm8YkOboZEs4GX8Zx65zY0bxbnreslGtp8bIDKgnwwLZfFf6vM/ZCnmFwQIsXWtRCZtf8+kmuu@vger.kernel.org
X-Gm-Message-State: AFuF++nOnbawdaGy1H8/FP+mD4yIPq29oFoYpJ6tDt4NZMGp8+ipGsq1
	LoMy2e7PvbQUE9IKtHh3//eywx9PLhdoMQwS2ovid8bLl/R20VDEc5nBD1vW5hS1kg2wVkVsls4
	QK6kwoH4x3RslQsZ9IN4G+2d2Tz7bICQf16GH9Tt8
X-Gm-Gg: AYBFou0lpy7cstquqLixPEogcE5Hku2D3Wc85uLTkorGe6lwAV89lJNPjNzN/dXS6ZK
	eu22CqBIVvDX8qJ3oQy9wYdShEmhxZ2CqxVviLnJ8GUt0M1gteIdJB7OEVAmdMUvbvYNAU2Sg1S
	41oziWWGzJptELTjXNGB19iOzYQX+YKMo07Tq3PkYnq6GpFclvY/9FkiD73EYPyjHcMJHfX0rTQ
	eqsRApV77Xvz2OVp//1Mnv38rS5NeuzEFX8+D6qWmDgeGV8NVvxkEx8tPIixXpQEvPS3kzxhaCT
	EzXY42HUcXddBnMDH9ZOOUj/f/cSyO09dntNEfhfaYpYkRPXczev21FHLrge2r+dwxm6NxcIL2y
	DlxunM0OEJfo=
X-Received: by 2002:a53:e1c3:0:b0:66f:c1bc:8804 with SMTP id
 956f58d0204a3-671100aa4a0mr751213d50.93.1788966514801; Wed, 09 Sep 2026
 08:08:34 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 08:08:34 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 08:08:33 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260909062849.0CFC71F00A3A@smtp.kernel.org>
References: <20260909062849.0CFC71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 08:08:33 -0700
X-Gm-Features: AcwNN1VklKVcWcBWIqQ43VBTM1Y5rXVullNb148O--CoqtZ9WxNcwbmy31x-4Mw
Message-ID: <CAEvNRgFToiH0H0CfYTUoct3JgWksHOJY7ramUX_PK2k_NQajZA@mail.gmail.com>
Subject: Re: [merged mm-hotfixes-stable] mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	willy@infradead.org, vbabka@kernel.org, seanjc@google.com, hughd@google.com, 
	fuad.tabba@linux.dev, david@kernel.org, binbin.wu@linux.intel.com
Content-Type: text/plain; charset="UTF-8"

Andrew Morton <akpm@linux-foundation.org> writes:

>
> [...snip...]
>
> This patch was dropped because it was merged into the mm-hotfixes-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
>
> [...snip...]
>
> --- a/mm/folio.c~mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio
> +++ a/mm/folio.c
> @@ -33,6 +33,7 @@
>  #include <linux/page_idle.h>
>  #include <linux/local_lock.h>
>  #include <linux/buffer_head.h>
> +#include <linux/kvm_types.h>
>
>  #include "internal.h"
>  #include "page_alloc.h"
> @@ -926,6 +927,7 @@ void lru_cache_drain_for_folio(const str
>  			*drained = LRU_CACHE_DRAINED_ALL;
>  	}
>  }
> +EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
>
>
> [...snip...]
>

Thanks all!

Would like to check on branch management for mm-hotfixes-stable: Does
this patch being on mm-hotfixes-stable now (7.3-rc2) mean that this will
make it to 7.3-rc3?
