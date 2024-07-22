Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E6823BB
	for <mm-commits@vger.kernel.org>; Mon, 22 Jul 2024 00:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721607321; cv=none; b=JJV/t8ZkoZf7++dY4rP4B48FZ3e9vK79R6tyPHztqtvaz0IAfqw7vbD4HSRYBBeROUf9rY7JpUQubvfEiWeiFLMe9AaeBBSTHVTIB0GGycWcizQDZZtVIr6wJCeowYtig3Yqh8ZeUr4Bmu9/LSHxXmNTRnrePuMO3t+JmbTSCTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721607321; c=relaxed/simple;
	bh=4Lbvqiw93G2zHnDDYZ8Omb+j3DFInAVl4LQ2gZSThOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nkqdk1op4zqZqeYPgu/IA6wJDrroGGrIyiwxEtwSArzn2BsIp8waA+HfiQZLJHx/RD9Tc3lubtUz9+OcTOw9bYhmCxOxhJ4gLzgjn2Vwq2u27UDMLHEBoXCkKE+DDNFK06NmAN7+ZSxQMpUJ0gMa9u1i1dYeQl8oFNFF99cGjdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JJ/sTkSn; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JJ/sTkSn"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5a2ffc346ceso2353631a12.1
        for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 17:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721607317; x=1722212117; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fk+ZewaFQX4J1b598U+n7tTY7Ck12eH0e7NaScJUzQE=;
        b=JJ/sTkSnj4dWqLFQWOqk+S24G6i3Z6RGXAQc6AFTUwgfBjsZ74NkM9O0Ze7xG4TlI7
         B45ifVecEO+TnTb8QmTUX1vCRZRnODYTxCs2ghXT+mVVOr0hhy+3PeBNUamr19YV8EPe
         eYG9mtMgJoCXUGCd4xR5LkT2IGs90U4jaA/gs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721607317; x=1722212117;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fk+ZewaFQX4J1b598U+n7tTY7Ck12eH0e7NaScJUzQE=;
        b=E3f7GzEOtp12XSvHF5dqo/xxXf+M0cyDsD/Q6M/NaGSJ3SB/2EONKYkbxe3vcWw3L3
         aaTAGZJsbdltX8qpUFAEsmOELuP/MO176HYN6MfY9dh9eRGML3BXP4uq3yUPTcIPHVLg
         N0l3o5yDHHqdHcMtGFTRVSBmjLS3W1HzatKfhZfaZ9s/tyAbweqnzGx5/5hOznoR8d6T
         Z/65dEi9z9yvQvS4KVuCAmofVa8jDKIjA5GpPlemQ/hkrH/iGPJZZELCtSpcOGn66pxC
         lY9mJTQkUlYxNNJ9G0yQXJ8gfXq6hxelYUCylGIbV6SGcZCE8VBUuf63UE4pbrP+FLxg
         xBeg==
X-Forwarded-Encrypted: i=1; AJvYcCWE8tSLSGczCcRiJ+CPT/mys2xEYy67tBc1rNtNMbh8oRF4/Vg8aUg38MQ/yGdi8ivXQ9pGOPJSZyFWBVenvKSUO7T6oY1MEG6/aw==
X-Gm-Message-State: AOJu0Yzz4j8RkbAR3KQInFTx9UbIlf04KSgA1EU360aH4yqvWUVgDo23
	ij2W1EM2dk4gw/0G10/y+GU5appVvIeFoEWEmrSCFrvtOI0NgPx7iC8+IDkZfFI627BhEH6Qjcr
	dYuk=
X-Google-Smtp-Source: AGHT+IEX9+e3kxTQxjvoI5hYvAPL4bcfP+xQsvXKiNyRl0GhyAbNUppSy4rdYCu7FTV2FSlVPrz+cA==
X-Received: by 2002:a50:9fc5:0:b0:59e:f6e7:5521 with SMTP id 4fb4d7f45d1cf-5a47ab0dcd4mr2970947a12.19.1721607317147;
        Sun, 21 Jul 2024 17:15:17 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a7b9592144sm898480a12.75.2024.07.21.17.15.16
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jul 2024 17:15:16 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5a2ffc346ceso2353620a12.1
        for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 17:15:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXTIfVeyW5+wLaK3R946eMjY+g2jQQarXYuEyswhNi7Qj7E8I9ODZ/MoQzGDIXBRJ2VbU+9JCpUaZc5opBWWtzwiWOJmiPgR7O8Kg==
X-Received: by 2002:a05:6402:5204:b0:58d:81ac:ea90 with SMTP id
 4fb4d7f45d1cf-5a47c2763damr2803143a12.38.1721607316164; Sun, 21 Jul 2024
 17:15:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
In-Reply-To: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Jul 2024 17:14:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjPuiT+qqWXYb04AssPqo8FYMpjE43OQR4y91wtqxoHdg@mail.gmail.com>
Message-ID: <CAHk-=wjPuiT+qqWXYb04AssPqo8FYMpjE43OQR4y91wtqxoHdg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.11-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 21 Jul 2024 at 14:54, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - Is anyone reading this stuff?  If so, email me!

I do actually try to read the explanations..

However, I also do build testing, which seems to have been missing. Notably:

> Ho-Ren (Jack) Chuang (1):
>      memory tier: consolidate the initialization of memory tiers

causes

  WARNING: modpost: vmlinux: section mismatch in reference:
hmat_set_default_dram_perf+0xc (section: .text) -> default_dram_nodes
(section: .init.data)
  WARNING: modpost: vmlinux: section mismatch in reference:
hmat_set_default_dram_perf+0x6c (section: .text) -> default_dram_nodes
(section: .init.data)

and sure enough, default_dram_nodes() is an init section, and is
accessed from hmat_set_default_dram_perf().

I think the fix is to just mark hmat_set_default_dram_perf() as an
init function too. Testing that now.

                Linus
