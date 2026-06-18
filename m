Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078A2329C48
	for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781798551; cv=none; b=Iw0Ixb4p12tIMa9OZji0WZeNMVYGTYdl+6RamHxKrSh6jvmZSE1E0vjQecDycOC0QzpW1DkXswfLEkg4ReeTylbFz5x12gCB9qrTw0m0XBJHehBy92CFfYTg6gfihlnEqaGbDzUE4PLfx5SSxN7bMsiuVNODfQhYmz4pT3V+uo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781798551; c=relaxed/simple;
	bh=0cpJK1Xe80/Mko5kWAXAL95ZqyTrLgjlgdLBk1ZOa0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thxKmQKTubyg4qJOffKjFXtSVSpDDWBCwZ9psXdRSAblMGhmsY7Pw88StcTcTcjY6+EVMy4jFayae1BJCyz8lNwp/ghY+bHc9jUCGuQ2IfOpbAC48TG6irs7D7v/yMkskSUoM/IQgbVgksuTpl6gRv6OU0SSQb7mJIPpDFBPIVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H0Q2AuB/; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H0Q2AuB/"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-68bd9fce347so1973826a12.2
        for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1781798548; x=1782403348; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XiFrlN9u2kIOzdDbdgTMoI7zFXGysr9y4Am1xX7xAWk=;
        b=H0Q2AuB/sz94ud1xxXIC1VttxFnzOlvmTIiZRlFINdYXSEskQ6CnazMj10iJYbh9Fb
         bgrdphVUclv9Xh69YakUWA3PplKZOLOlsN1Iadhtksghr0qT3kPFcVIHijiiOLFUE+nC
         1PP5w5Q5hUiNQBwRWGvN9I9nI5Z8qJSnTH650=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781798548; x=1782403348;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiFrlN9u2kIOzdDbdgTMoI7zFXGysr9y4Am1xX7xAWk=;
        b=L8dZT9xSMHvI8v2111nCM/fim2dx93CoeKwmu2R5EQhgq9jeiTRPkPTDPbLmM1OO1b
         EMhMHpGcNAYve2lFmPRLCyWeecjToq1ypYzcu99k0QH1pJ+mSVMD3pGO30VrqPPJn0Kb
         y5itsiR4mO5zr3YSI3safolnEpuMtebEyspjOZfREi+/vpk9EeBtiaNj5/zs3Qs7RO86
         Xg4a3c2+vds63OLSmcf/m4O43QGJ/RwSgz9zj5Gr6csBWd94HpnKFMfAaocCdrVRXkky
         JnBuQ7+6gIjhHmw4bh99Qs1wuEEf59mpwwabbgWek8HcNZf/DwmpXgoT42yp7bZk6Pty
         B3tA==
X-Forwarded-Encrypted: i=1; AFNElJ87aYCOxn4tGDAv+nQ6bTmoN2igcxxpNAQQYQdvknrD+fg9vbMlqV3LeBkDwnoehcY1HwpfL7cpadMq@vger.kernel.org
X-Gm-Message-State: AOJu0YwIAnhFT+r/RDS8UshAas13JB0ST4DGlPVp6u7GIOxX93E30k1q
	IfkWbzp7JAP58V1c+adW2F5EQZY73BnE/k+76YV55un5LoRhGZe51fIawlnU2tw6Aecr6WUOOJB
	d0O5c1gE=
X-Gm-Gg: AfdE7ckhP1NSmdByjV0cHKHq7P+Ymc6Kcv2tEGqkWcXFzriqw5eYmCUUOLHuDgWrWju
	xBMZr+Weq1UJq1S3Qi1iuXaNGE/Z8i91haNmStfvb1+k5hz7/HMz05iYeeKsy0lBLYhZ43SUx5L
	1tgOnccla6/vGcNWY/6AH6b7WmMW1CgOGPpqyQd1kNfp9nHBfYar0znpvF6g9PWG72x1IVc3ywR
	xRZgzoaipVVSVsg3VCt8uBSGxBV5sXZbkYw+IcHB8pIGddeRvw9lvj+6usQhhSygpGjLx/hSXwX
	QYVKQaUjlaMSwasP9uUwOSD9Z6jswXgOPFBoqBWGmXg8S4UBm0d4tBocNz8IA8u39bELnSwDqeM
	p0iw3zFO/DGwpx+estHSqkHPo1v0thNcKcOh7WG+AzenS2ajXVTS67kMf0jHhtrNbhLtsIc/GEE
	NXxn2Wtuco0vOkMuuf8eH4IejZlRsFukSnNumB839LbFrySppvVnXpr4wgSiefD4Yg7clIwSt6
X-Received: by 2002:a05:6402:11c6:b0:695:717b:2372 with SMTP id 4fb4d7f45d1cf-696e5104f81mr13164a12.7.1781798546092;
        Thu, 18 Jun 2026 09:02:26 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6937949bc4esm8236152a12.25.2026.06.18.09.02.24
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 09:02:24 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c03a466c96aso188329766b.3
        for <mm-commits@vger.kernel.org>; Thu, 18 Jun 2026 09:02:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8D20ucZncj7W/2eibVQisxMvPsXhDGoIPOii4PgWsm/n5cuJGSOZlA2Z1Yvu1p0v4M4zY1XGRhya7c@vger.kernel.org
X-Received: by 2002:a17:907:1804:b0:c05:21a7:6b0d with SMTP id
 a640c23a62f3a-c07c7bdfdfemr172026466b.47.1781798544383; Thu, 18 Jun 2026
 09:02:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org> <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
In-Reply-To: <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Jun 2026 09:02:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
X-Gm-Features: AVVi8CciHIaGTA_UXGcV5OZpxqlwvfzejICQbiD_QoQSAfSAS7HIF_HX-wWOw0E
Message-ID: <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
To: pr-tracker-bot@kernel.org, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 08:22, <pr-tracker-bot@kernel.org> wrote:
>
> The pull request you sent on Wed, 17 Jun 2026 15:31:44 -0700:
>
> > git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-17-15-16
>
> has been merged into torvalds/linux.git:
> https://git.kernel.org/torvalds/c/2f9f5887b42711595e768b9dc0582dccfdf60c3b

This is very wrong. That merge (2f9f5887b427) is merging Jens'
io_uring epoll cleanup. Not Andrew's MM tree, which I haven't gotten
to yet.

I wonder why pr-tracker-bot got this wrong.

[ Goes off and looks ]

Oh. Andrew's pull request is confused. It says

   The following changes since commit e771677...
     ...
   for you to fetch changes up to e771677....

and note how the "since" commit and "up to" commits are the same (and
is my iommufd merge). So then pr-tracker bot thinks it's merged when
the "since" commit was merged.

That doesn't explain why pr-tracker-bot thinks it got merged in what
was me merging Jens' tree, but whatever.

And I have no idea what Andrew did to generate that bogus pull request message.

              Linus
