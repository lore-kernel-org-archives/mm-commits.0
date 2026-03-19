Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F161A9FA4
	for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 08:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773909579; cv=none; b=TW4VOA2gP3E7o/CzG7tAOoi8Av7VtFRnKc74rH5P6yK1unhv0JFqAg2Gnv1lY5Xvl21viQYfsc/UgQCg1J1UOkx7JDsh2piJlHbC/tOvSQq+sj7RSQFshl2PJxuJG+ckAKnIzOaSOffqJ95o9zleKFHC+ICBaRDEEpT03l5jG0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773909579; c=relaxed/simple;
	bh=tBIdknSGrjtD6rAYV22rPpTp1SM1tpZPUCj7i+Db8Tg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ci/pN3vcVSaGuZNBns/RV7gIcTkS08ykurd9TO+WTLGVV4cfE+xbzV7rnEjd1tGsrqmNTgIcoy+JUWiFQ7NrGZ25iLGTt33R/uRuMNYG/QmNNKpAE1uU7Y8F5Brfi4stLScrNDT0rhRfN4bDpS1ia35TtK8kwwtPmJGS19wCrpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fs2wFi4m; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fs2wFi4m"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485355493aeso4790205e9.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Mar 2026 01:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773909576; x=1774514376; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vw/6kwAy2eSoRjg9UV0ll7INGdWJyYzd1P4t3vfb/Rw=;
        b=fs2wFi4mSL1+s0sRg1fzzkxM1cog/w/9idjHzoeuHtdlpBUOY0g78iBXQJsuvPFfaY
         g22ttzUkGRENgGJPCdRuA0h3EH7pMgkTcXkK10c+Uqh4QAUgte/5P1pAvGd/n1PM9/XI
         Ti5zWO5G/tIzP974Biywkj2hugjlcZbF22y8lcOn/HX6FfyBmOSSaekENHAqgPAzHK0b
         fmZH6xF3VFw3h6hfxwtWfTyIY9mPAsRnOAklPQ/QtaDgFMmVRH+gE+/o/s77SEGSRDK3
         w2iRHfv661v7kJZutKjUQPA0B+mKJxsWWlLDZ12T0LqDhqY78ysBzCNd77AP4yCERGBI
         TDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773909576; x=1774514376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vw/6kwAy2eSoRjg9UV0ll7INGdWJyYzd1P4t3vfb/Rw=;
        b=d9Nkf1DpmFLNdPtjFTF50HiTQ1o1pfrPxAimyHK16tOR5++2WXPJT6qGMJ1lOmEsGz
         nXV46ieQVT+trm0/gez296xVKd7/8ojf68E/KdbLFBKkxXMPOJLOCd9TlNOkiIWyqd3a
         GhJKiXVQ6q5Ma5JgoCR8/bsLSvLjMUi061Eyizn46ZHT79qdXNExVpS/NmpU1VKA5IDx
         Z34qZxaxSz3jVc24hWk+91rgHJ1tnWKW7hJhbZDmrmD/TdLNLDLf4s08a5YcWe3RLQQP
         UfZ757FB0LwVFODugBuirWBNAd1wpCCBWAaW1UA9kuPfkl9QgWlycua0PSC7lVyUR2hR
         Wdvw==
X-Gm-Message-State: AOJu0Yw7AYxAPODmT8lzqqP8HQH0+uqcBkoRIWXtO8E7TEgTa5nanVyZ
	oUwZeDR6084MRqt9FH7tWtE4r7eYkclBc1XmONxcLoMbryVNWz8Ap/xqeJaD2KleRfood/dC92V
	lqiIF6HjcC/VCm8S1Uw==
X-Received: from wmim24.prod.google.com ([2002:a7b:cb98:0:b0:486:7a8:4f4e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d0b:b0:485:363b:fafe with SMTP id 5b1f17b1804b1-486f441bc8dmr106876315e9.1.1773909576019;
 Thu, 19 Mar 2026 01:39:36 -0700 (PDT)
Date: Thu, 19 Mar 2026 08:39:34 +0000
In-Reply-To: <20260318182015.BC9C3C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260318182015.BC9C3C19421@smtp.kernel.org>
Message-ID: <abu2Rh-yMHL7QNH0@google.com>
Subject: Re: + mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch
 added to mm-unstable branch
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, puranjay@kernel.org, ljs@kernel.org, 
	david@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, Mar 18, 2026 at 11:20:15AM -0700, Andrew Morton wrote:
> --- a/drivers/android/binder/page_range.rs~mm-rename-zap_page_range_single-to-zap_vma_range-fix
> +++ a/drivers/android/binder/page_range.rs
> @@ -762,7 +762,7 @@ unsafe extern "C" fn rust_shrink_free_pa
>      if let Some(unchecked_vma) = mmap_read.vma_lookup(vma_addr) {
>          if let Some(vma) = check_vma(unchecked_vma, range_ptr) {
>              let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
> -        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
> +            vma.zap_vma_range(user_page_addr, PAGE_SIZE);
>          }
>      }

LGTM!
