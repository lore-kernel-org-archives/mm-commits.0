Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EEE27E077
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 06:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757917044; cv=none; b=I30fi2353/fHRGCVNuKkLkuiwK+92lDMxw3Z6YILgvOCtzAvzQsU/LfgdcUIV1PLWyJJNU14cCTRyh+WFneo9hOomdHSwRxYJZidJ7mspu0yJWoLc6jsQpAmLR+QqouGG8iRppP5YfhdsYllL2lND1kjAH0A9OOvdQoaea5COEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757917044; c=relaxed/simple;
	bh=pe0COvgW9rLSFCzKb0aFZkyHx4ribSfm1h2guFBiKco=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jbNTso61vZ4QwKVKhYr3+phgyuxKbp9tAz78jzElzQXXUNRA90ZJcrNQC9PVls5P3wBQfV8tc8WhXF2t24KulZ/jkLDfVUGvV6MWObmRCJetsBBPLibm3/OprP49PyixiWsRQWf59xbgJtdLWd3XdfAwj+vSU2nZ501lGRTBJqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEpImLph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEpImLph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EB3C4CEFF
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 06:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757917044;
	bh=pe0COvgW9rLSFCzKb0aFZkyHx4ribSfm1h2guFBiKco=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nEpImLphpPXwUUXPn+MNKnDaIZ0PkYkzyS6dYTV97FCK5UK2xMjlCM7srTBHOFNdp
	 BNIdD4Hkc4NtN5nUZzlHnH8i0d9X+Z6wbJyiyMF/RYpIJ99nx4ODXPiliuMwKx1pg9
	 Ig5xCfkd4+9p5jdNK32lGFOcazWZWsU5i5DpJHkvv2wBSTgLZII4SIOAzargF8EPmV
	 bS8EiimzpOuBzgAIJUJQalY+rvR2niKpcMQek1jhVu9uGZpJW2WzAoA75YgtN8Ta69
	 uqOCktDcHkenWS96T5LsGqUY1HmZFoompcp/w1QsKeZwtT5mLx7cDBwjTFa3OmRQS2
	 hIqkTnGxRNwIA==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-570d0c280e4so3214677e87.0
        for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 23:17:23 -0700 (PDT)
X-Gm-Message-State: AOJu0YyfOmvuFZzhvOj/UqEoXQ1AeeOgr0Y+L4qpT+l34UNxis7OCKc1
	0EmOmO1tM/kzAwtADJ8SBcelMhfnhrrndCWP/p6HYG3DLURccVMOUAPpsdFaOBbASgVrZVEACF+
	qWV3SbiymxGXxJ67SSVdj/QK4b1mETJ0=
X-Google-Smtp-Source: AGHT+IEerrAPlZ10zYJyk/swbKSRR5OhXZGRryFRepIx2qpxh90JE/ihkb/CtoNmIN43NvhYvmugDC0ajoJs6She5/k=
X-Received: by 2002:a05:6512:3498:b0:55b:87d9:3bad with SMTP id
 2adb3069b0e04-5704f1ce56amr3067150e87.34.1757917042258; Sun, 14 Sep 2025
 23:17:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250914003610.84C8DC4CEEB@smtp.kernel.org>
In-Reply-To: <20250914003610.84C8DC4CEEB@smtp.kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 15 Sep 2025 08:17:10 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG7nhf3bL21H89fOcBNgB3iN3hYLhs1qr4jPp9LgKv8Bg@mail.gmail.com>
X-Gm-Features: Ac12FXxNmun1REL97i8HF3JmbOOTzIL5coBtlFcIz1tzWDpM6QbEjoRbDUdw3f8
Message-ID: <CAMj1kXG7nhf3bL21H89fOcBNgB3iN3hYLhs1qr4jPp9LgKv8Bg@mail.gmail.com>
Subject: Re: [merged mm-nonmm-stable] efi-support-booting-with-kexec-handover-kho.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, pratyush@kernel.org, 
	graf@amazon.com, changyuanl@google.com, bhe@redhat.com, epetron@amazon.de
Content-Type: text/plain; charset="UTF-8"

On Sun, 14 Sept 2025 at 02:36, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The quilt patch titled
>      Subject: efi: support booting with kexec handover (KHO)
> has been removed from the -mm tree.  Its filename was
>      efi-support-booting-with-kexec-handover-kho.patch
>
> This patch was dropped because it was merged into the mm-nonmm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Evangelos Petrongonas <epetron@amazon.de>
> Subject: efi: support booting with kexec handover (KHO)
> Date: Thu, 21 Aug 2025 17:59:00 +0000
>
> When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
> early during device tree scanning.  After kexec, the new kernel
> exclusively uses this region for memory allocations during boot up to the
> initialization of the page allocator
>
> However, when booting with EFI, EFI's reserve_regions() uses
> memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
> rebuilding them from EFI data.  This destroys KHO scratch regions and
> their flags, thus causing a kernel panic, as there are no scratch memory
> regions.
>
> Instead of wholesale removal, iterate through memory regions and only
> remove non-KHO ones.  This preserves KHO scratch regions, which are good
> known memory, while still allowing EFI to rebuild its memory map.
>
> Link: https://lkml.kernel.org/r/b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de
> Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Pratyush Yadav <pratyush@kernel.org>
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Changyuan Lyu <changyuanl@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

You forgot to apply my Reviewed-by - it's on the Link: thread.
