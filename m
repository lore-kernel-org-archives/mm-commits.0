Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7021A0B00
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730393337; cv=none; b=AM4hmhgZBUVdtScHM75mdXieKg+L511B7vkwilKk4Fiit04t/QffGc7/1EZrPyJ1fzUBupr0gbUIwcFFNSCdkW7GrVQXmx6wymbnhsVJfg02XYb7rGgzkkx7h4CHGxi/BRSCyQqaVQeDys+JOveoD1xLd+QmOBlJc2PuOzEbuF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730393337; c=relaxed/simple;
	bh=DyWph8UUJAkQclrw0BMcHAWESaNV8zNxbZmG/7+Hbk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UPOpnP5adZr+j3SP+9qR8uwnsXX+uNGzgaSCoeyRwDYXaDpQvsNvdyUdrTOWRQMWium5mia6bWyM5I3h7NrCffB0a0IpK2Yk5ALVc7kkCzJ0D43yj15iT6kX0bowlpywNTIHGDWAaAZxvPtca12o9x7I0vP1uYi/CTVA+jkGxas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PI/VjL3R; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PI/VjL3R"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e2974743675so1097878276.1
        for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 09:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730393334; x=1730998134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCGIRPOYY6VkyMbSOzu8Bu46cDZwcKzHLqJf7pVc9Bc=;
        b=PI/VjL3RWBuqHKME5Npp0/dRYasW0vQeUlJRWfFa74rH5L5aEyk7t3jAyXIkdjUnSQ
         I69vCcN4RNhf2PvrYrlR4TDYdxgbQx5AdqxdJExnq1afnuF3DvaeAF5GGec8vJLxJYJq
         C77cQpuW1j16/EfJM/PLOHA//0IP+27fgBZHfCUU2zNxq5Fl0nDFBPqUpvg3u4FyTxWV
         WC11MgqZb1jFWD4/p/zySgsHRt+3Xa054hskmhQ1l6Wlxg2Ji30ANle+3q9OmYub9fdH
         Z3VuEwG5kGkE+FrE84/7ZebHZF30GMqawkaeXKY/+pLpxO1LPCafZCjiVeZkP2090kCe
         nCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730393334; x=1730998134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CCGIRPOYY6VkyMbSOzu8Bu46cDZwcKzHLqJf7pVc9Bc=;
        b=xEYNYDpFRnGjJyyDSjdj+zl9lLoUtUS/ATOBluFFzGJR/jfl+1DeoOJ1rnUooCqlaY
         sOYe2ytt0DIZlPFCnN1R4uR83f7bcGZgDKKKsAjiRD5vgIxCKbnVQoVKh/hu06swXYn0
         r2ke6n5Sw3cfo5NEYgWwqW7NzYJIcf+NRjVCfE0/sbW42MKO5ieR9+No81ENqHQ2+hhi
         wFBcvMJh5nYEqAMdkmrFnvitbAApT/CA6VLgp/k0eTmGJgdpeqQGL5bSQYqwPYManwN7
         kopQs/16VwPD41Ca7AUaCGuH0CR6n9Q5WTLkURqYWdTtdfFfdJYNYmTvl3bt6yuMjpiv
         EHlQ==
X-Gm-Message-State: AOJu0YxEX9VAWvWsqwaXqotGPtKlDwVkwwaBXyMMtFs2E1Q/YIf5Lhl5
	FOSMXnPObA5GAdamy5cnQRDeeIeoQ/0tpcuewR/mYqQwujobLC2i5TQvaQM73tpwJC2mpnbd15X
	GebD944z3mQJtEjhdawyl0ADdhg+xH5ki4GSi
X-Google-Smtp-Source: AGHT+IFhxc21ZHz4vbc2RJxBu7ImVfd1dY7qdM5KSOEx184gZpnveCCVXiqO6RQl2JdhFA5FqtGx/OQa9HaAkqcLcjo=
X-Received: by 2002:a05:6902:b08:b0:e25:d900:a0f8 with SMTP id
 3f1490d57ef6-e30e5b57747mr2920629276.43.1730393334042; Thu, 31 Oct 2024
 09:48:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031031517.3AE43C4CECE@smtp.kernel.org>
In-Reply-To: <20241031031517.3AE43C4CECE@smtp.kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Thu, 31 Oct 2024 09:48:16 -0700
Message-ID: <CADrL8HXPjHDRAUmzLnSS0fqsw3Rt921EYm2KyEUqW-sPn15o5Q@mail.gmail.com>
Subject: Re: [merged mm-hotfixes-stable] mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, weixugc@google.com, stevensd@google.com, 
	stable@vger.kernel.org, seanjc@google.com, rientjes@google.com, 
	pbonzini@redhat.com, oliver.upton@linux.dev, dmatlack@google.com, 
	axelrasmussen@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 8:15=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The quilt patch titled
>      Subject: mm: multi-gen LRU: use {ptep,pmdp}_clear_young_notify()
> has been removed from the -mm tree.  Its filename was
>      mm-multi-gen-lru-use-pteppmdp_clear_young_notify.patch
>
> This patch was dropped because it was merged into the mm-hotfixes-stable =
branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Hi Andrew,

I posted a fixup for this patch here[1]. It fixes builds for some
configs but is otherwise a no-op. Could you apply it? (Do you need
anything from me before you can apply it?)

[1]: https://lore.kernel.org/linux-mm/20241025192106.957236-1-jthoughton@go=
ogle.com/
