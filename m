Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9A81640B
	for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 23:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721604004; cv=none; b=PBQDlBTWTFibXJBA5CO6fDrviem/M80czTpeSWcfBHBldrenhkO27/AcVnhu/MWo263Ob2LDNapTDuIcLRyhN3gzIHfu4QQeliGDykCakfoykCusjAjEnHeLOKSnVz9dVKtwutVbFThjB1AadNlrk/h/tAUiEhowCZLERHIh5R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721604004; c=relaxed/simple;
	bh=6XfL6zmiG48Bc5+7L2Nvgt2xjns4Mg6TDYVp2oOpnxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eTgG8YHfxb86Oz1ou/Dm3GTRUuRwVrBbNU/X5RFHvtDTscotvzGLH/n1x/6VI6hFtWXDc2iGB04fhSRVfRKYxX6p8XYQC3JpM1vdsfRqBQslAHrEc1Kd3H4iFYjzLwyzKhTDYoF5shxV53RTTGVgsESMzfEhYE4UpIzuKD3H/sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y9hUGw8t; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y9hUGw8t"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a77c080b521so372479866b.3
        for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 16:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721604000; x=1722208800; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=32YuisS0nN9yXPU8HG6FFhSsLCxcgTmmQjMW95eNEt4=;
        b=Y9hUGw8tgaUF+IIZKmd7mnSYYDP6v5WMcwgFFrcCcelpoGsP+27YFdgDTgSt3tgWtA
         RVIh4xzEaLSp3oF3MAy45EvL8JpnNCVMJNRjkPqtiEYxfyMt9dZdOBDdYiTP+VQ/A8CB
         t7qMOzUUK6J6WSSQabmy6vc1UOrcyWrQrA0jc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721604000; x=1722208800;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=32YuisS0nN9yXPU8HG6FFhSsLCxcgTmmQjMW95eNEt4=;
        b=G1jnbvR189xI3O2hlvXzGguICJPrIEsy0XnONX8ScZcoqpBmnNGE9qcZJfNHZ4bJNO
         oqIxmHTp50+usRWbb/c6tWSagentnZHcDb0Mpb6zvPoixE8ieb9WgVP3X7LjfmTppUr7
         ajiopQYnDVrby+eLMoRjDuW9nATeJPmaKXk1K6BnzqWp+M0jmlZTJcN5AQqAtCQ2K61p
         f/uu6DH1+eyJZ/qwKPC0vFIEA3XTJqeEt71XCREJDbZUy8BK8B5zqaaH5O3UBAOlpiwk
         GGxjnwh7xTxlwP6uYYNMFcckBgphJKF/OwHKdNYrvT99ATbrx1LiWecj8PvMu2Z1VuW7
         KS4w==
X-Forwarded-Encrypted: i=1; AJvYcCXKhcxF2a6i1hLKIco5dNHOIL17ErtTKdQ5x4Nnde84whYLMOtB1HBIB7MRMaZ8zFvW8EjyTcwuNFOFH1dxNEnaYXq0cfrjt3th9Q==
X-Gm-Message-State: AOJu0YxCzOUbS2FHHglQReCvVCyuRrPu8mbth2mhGCrPnokbHeqV+Xwv
	WN0l8oBwyXs4MS59G7GxZQCOGdvOWYzRjjdHPBTH4/JBhyINc6XFzHT2m4kHEdomzgUq/G6oODE
	rVD0=
X-Google-Smtp-Source: AGHT+IGJwby5pprGUAVDseA+7QxKIKa7tFACVorjDieSjE184XXAYxxdwIKLtKaB2xIUvubE8Eb5BQ==
X-Received: by 2002:a17:907:3e1c:b0:a77:eddf:a49c with SMTP id a640c23a62f3a-a7a4c1233c5mr357969566b.41.1721604000219;
        Sun, 21 Jul 2024 16:20:00 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a3c922b27sm343647066b.164.2024.07.21.16.19.59
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jul 2024 16:19:59 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5a1fcb611d9so2764746a12.1
        for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 16:19:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVssRbxyw3nKUR3oj+eyeQSM981guCM3ukboe7wW/ONq9sOYrAQ8VM1OWpnSbGw1yG3xLuAy9UkToWU//Al79vcUC40+DC3eFrz5g==
X-Received: by 2002:a50:cc8a:0:b0:5a4:6dec:cd3c with SMTP id
 4fb4d7f45d1cf-5a479d6470amr2804096a12.37.1721603999287; Sun, 21 Jul 2024
 16:19:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
In-Reply-To: <20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Jul 2024 16:19:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjpx6uTAvjNnD5eipGjNYcwTgG9G6Dct=eLTfyzaaTy_g@mail.gmail.com>
Message-ID: <CAHk-=wjpx6uTAvjNnD5eipGjNYcwTgG9G6Dct=eLTfyzaaTy_g@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.11-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 21 Jul 2024 at 14:54, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - 875fa64577da ("mm/hugetlb_vmemmap: fix race with speculative PFN
>   walkers") is known to cause a performance regression
>   (https://lore.kernel.org/all/3acefad9-96e5-4681-8014-827d6be71c7a@linux.ibm.com/T/#mfa809800a7862fb5bdf834c6f71a3a5113eb83ff).
>   Yu has a fix which I'll send along later via the hotfixes branch.

That commit "875fa64577da" does not exist. I think you are talking
about commit bd225530a4c7, which is in 6.10 and came in from your last
hotfixes pull.

I'm assuming 875fa64577da was some commit ID it had before getting
rebased or something?

I'm also a bit confused about why you mention this, since neither the
cause _nor_ the fix are in this pull request and you have the wrong
commit ID.

               Linus
