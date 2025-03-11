Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC6726039A
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 16:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741712338; cv=none; b=eaUT+Al+mrWEbShtVLkhx3hmmHXoiNmsIVfGc7U0IPOdSDwT6mn0L7caqqh1DQZH9x/8QSfxaSgxBD6wuSSvbclGYjbH9dT5yruOYeEbQtK9Fu6vkSpoNFxyVhOnka2HD489Mbyxbcu6osXfkNttcRDNblp9fu1kNlUtHCWprOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741712338; c=relaxed/simple;
	bh=bqa4Zo5G3EvpwSCUBlVCZ/hQ7UKYLe4xSoHICsRADqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ye+jsQpBvGAGsUUShsQ1J/7C3r0dVFyJ37zCHCuQTC1iH71nZgw4c4hfgqWbc+t6l+B0wv+GsHRjIdYhFwEkmhK99YDYQw1xi5DQ+SY6hJPa8F5M8WbzXsjJ7CPZ/DaMLXgFEJ3GxLT//AlI7ftxJq/A4IRrNNbb5knQHKvDkOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c80JGyfj; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c80JGyfj"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c04df48a5bso511379985a.2
        for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 09:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741712335; x=1742317135; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iA4x+zsdoa1/Ttu5kIO7FqzRTujqnaAXXb7vBTWVWBw=;
        b=c80JGyfj5X+61ZpH4baWjodKLunRd4jl6Ki5DHfBdpfkqAX3zVGHofWpx+Lb905tQq
         8AHnsvQa3vFWfTV2yzcvuMJ4IbMA3woYh222xNjcXJrJgem+hI8mSj9/SObYlUMTEc+C
         fPC8ul4xqEIgJIJAAWCH7cjOdkskfwKTIg78btMIM5piH0VoxKphXDVirY4e+LRp1dZs
         zuEkRCIHKR2Fuv09IirbdL4Aj8Hkv5mIZpf9GopV2OQOS+/7C6DxN/jyqwky8FuDKti0
         kz7C+N4AdNe7yUwFOUbYJPEpGZdLkeIBN6a5aKusETd4uPfUqIMqz//4aIo6MQHin1zT
         eueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741712335; x=1742317135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iA4x+zsdoa1/Ttu5kIO7FqzRTujqnaAXXb7vBTWVWBw=;
        b=fFR49Zh12zEBJ7HQEJTCoao6Ll9yxepxxkVfC6IBX0TQj10bIHgiv9+OHJbHaotOX/
         YushDBT8hBkJO/pt3Y2vyqJG7wR/ScVkyWDcxGdZ5smOvEsyZ6RKGCRgK18SkYuZQgDM
         PPq+Q3r1IaaW9evR2f1DPInzqXCF2hYAZLlAtfKAhUqFBTP4stgYcC3v6xd9Ae72hDdJ
         paREQpDbrg/2T/poX2olj2UiwLBfLRsyxCaMqIgKbRyubv8GWjs/8zR2aeEF7uRqdOYx
         9FKrpOJYQjX91jXH/YM7tmtsaU8FJDC4MLOzS9RLE2irInEey5tuytXVNG/L6DW2JZ3Z
         XlGQ==
X-Gm-Message-State: AOJu0YxNFVBKiQluLqB2VoY4+3i1RSk2tsxHNStILsonQX7WEtAbEwxb
	QCRr9bqluNI4DziG8zGqtlQu2KKiQmU5ZAiJ+qNK1BNWjGnHqMNcp3XigUBfbr80Yx1COy+78Gg
	Z/dJrgC0tRF3ilTN4gH3GF7hfRl8bDaf413L/
X-Gm-Gg: ASbGncuXf0V65y0DwGWajsXF+VuM8T004qzqMGTbRAoVcNI+qZ5DqXojbWrzpOmKwb5
	xdX+MvUdOU7rK/3/T9hWMiV2ksl2MG/xOb9yLFxAK4pJlQidqBrxRQdGAWcevdJu12wgRlrJM3x
	UwcByRjQ1x3klD69Ta+65uYA+6yUtJfFId5O3QyWtm5x92oNuGuygQ6gk=
X-Google-Smtp-Source: AGHT+IGXTV6jt8zy0b/a5jQLG+eKvtaOTrGi6iFpSH7vWvwWk2XXzc4vkIrgDbePZzBUnokoYaBHhAtlF7Osr8wlR60=
X-Received: by 2002:a05:620a:838c:b0:7c0:a0ba:2029 with SMTP id
 af79cd13be357-7c4e6178ce4mr2882337785a.40.1741712335418; Tue, 11 Mar 2025
 09:58:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250306053724.9DF85C4CEE4@smtp.kernel.org>
In-Reply-To: <20250306053724.9DF85C4CEE4@smtp.kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Mar 2025 12:58:17 -0400
X-Gm-Features: AQ5f1Jo0wKRvS-Sw6eU2fJMQMU5J89-Jhq8EBJNyzSQhqhPzSEtZkom-oS0Ybcw
Message-ID: <CAG_fn=W0KFnHq0=M1FovTHPTnve=W2Hqvq1Hny4TQuU+rL2fiQ@mail.gmail.com>
Subject: Re: [merged mm-hotfixes-stable] dma-kmsan-export-kmsan_handle_dma-for-modules.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tglx@linutronix.de, stable@vger.kernel.org, 
	peterz@infradead.org, lkp@intel.com, elver@google.com, dvyukov@google.com, 
	bigeasy@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 6, 2025 at 12:37=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: dma: kmsan: export kmsan_handle_dma() for modules
> has been removed from the -mm tree.  Its filename was
>      dma-kmsan-export-kmsan_handle_dma-for-modules.patch
>
> This patch was dropped because it was merged into the mm-hotfixes-stable =
branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Subject: dma: kmsan: export kmsan_handle_dma() for modules
> Date: Tue, 18 Feb 2025 10:14:11 +0100
>
> kmsan_handle_dma() is used by virtio_ring() which can be built as a
> module.  kmsan_handle_dma() needs to be exported otherwise building the
> virtio_ring fails.
>
> Export kmsan_handle_dma for modules.
>
> Link: https://lkml.kernel.org/r/20250218091411.MMS3wBN9@linutronix.de
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202502150634.qjxwSeJR-lkp@i=
ntel.com/
> Fixes: 7ade4f10779c ("dma: kmsan: unpoison DMA mappings")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Dmitriy Vyukov <dvyukov@google.com>
> Cc: Macro Elver <elver@google.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Note: I think the Reviewed-by: I left on the patch is missing here,
but I don't mind (no need to respin)
