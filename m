Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3559913A276
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 20:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725480207; cv=none; b=JXvrzqISOTq2KdiBhTdC5W0jpwAuh0GuMZKHYE7NdRwpWttGhbQInypPT3nK/NpLVhJUAPpWYklFtYiP8TLAs6JusMZpqby1E4nNVW7gkizFzw3rGGehYYo8+fao7yB2eVd/UVBjzw8635dWHMXFGrH+lQ7lHE/w9MJ7xskM0Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725480207; c=relaxed/simple;
	bh=o8kPf531yu7uUdhdqYpdOs8G/XO4n/aBDxXB5WtwyVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tLoAQC7q0k1f9W3mohIloeYdBSCiTUSt25XvnEvFgnYqG2xivR4sJBqw254k+d3c7R3Nxe3QOrpPRSLZYpW8rfT35pV4u1GhgH8hTrw6n4vNfv8vtWEVSv4LiVgf3K43Y/yeG1oa1iA4NuzL9wGacwBzP2IgosPVRsFi7P5h0Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1gVjWeo; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1gVjWeo"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7d4fd79f8ceso2036a12.0
        for <mm-commits@vger.kernel.org>; Wed, 04 Sep 2024 13:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725480205; x=1726085005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2le6N8+yHUjLL3is4NzN0v5//OV6jZco75vt35t/b0=;
        b=V1gVjWeo3vSWYKLik6WbcET3M8FQufE4XLPqBP6QFFrU3/KEnNnPnvEZ3MibepLkYb
         6OHyLLcg+eSacTdeFg0i0DbBlv5kXrElc0j9igWcRg/rwLDw7175IioZ4F7Xyd4zeVxw
         sx4PUSgn/OFaun3UCH22Wmgot72QIxglp5lXnWq2c3rLUb5mahiYJGB19KwWMkNk+w2s
         depEMQgD5CMCJrmOij+HC7xb6lIEeXyyiqczAP4plWr9KnEoaFDZmx1fhh8wsDJWYGQe
         HD8g3yZbFY+EVeC5354cKPXYCkSV3XYW34pT306V1r8RgYw8nRBZC8jXB14yUofZQ3ou
         sFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725480205; x=1726085005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2le6N8+yHUjLL3is4NzN0v5//OV6jZco75vt35t/b0=;
        b=jo8q4nnAKyYfhAIAp/4ZuhjvJCVJyTcEKJhLvgw0ZG+90dwZRLvxhAYKdZEsA4stB+
         iC06UZQa8bYFA3wkA/qKijnfsb0s6EMW1Hyj4zIMmAvx3aAU8bO9wOgEd0mEovQFjL2c
         RnK6pkFaNyFIbOUFCxoeD+NJskJgye5gEzmpNIk/jVda4RW5PK9DppI16Nivq2LH3pb8
         TowPX0BsqJ9dcccui7fKfLcqzHaiw89ZkYx10uciJ0kiP/elvkCa3ervipQT+D0QiW6Z
         gDMvqbkmE2j8UZqSprAKzPhpmD9Dl99L5v5A4hNH6nNwMXOqjCMuw4PTnmuX1ZGWOpjh
         oxhA==
X-Gm-Message-State: AOJu0Yw/nUlmTiff+ZJW1tU0yYym2kxCsxaFcJLOBWJ9uSVVHLS2QgsO
	mRpkbOBb5jOXlHJn8YXm2dTr3hGRz+NCaCQZA9rxSDvQ2+V34bm/v8HYgblD8gU8+P29zmYhPpB
	C8c0y6xGZeJ46GEEC6zs9T68MnMo=
X-Google-Smtp-Source: AGHT+IEcmVgzsTW6+P/Wy/5zGGFsT3A5himWQmIFDXpYjZ+K1O7m07MaAxxKvyywlR4FGJ6j3NHjm1LidxFNo2ouQTY=
X-Received: by 2002:a17:903:1103:b0:202:18d7:7ffb with SMTP id
 d9443c01a7336-20528847f02mr109391825ad.11.1725480205298; Wed, 04 Sep 2024
 13:03:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904041800.486C6C4CEC2@smtp.kernel.org> <CANiq72k=mzebBFfAW2iJ-cWYTVYBDoR5XzYWZ+Crn-tq2YfnLQ@mail.gmail.com>
 <20240904121847.45c0977db4c0c97b6b06120d@linux-foundation.org>
In-Reply-To: <20240904121847.45c0977db4c0c97b6b06120d@linux-foundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 4 Sep 2024 22:03:12 +0200
Message-ID: <CANiq72mr+4HeuPFVp7cK8-EA9k4NOPDxfdHcoKj0+_Yu9k68QQ@mail.gmail.com>
Subject: Re: [merged mm-stable] kasan-simplify-and-clarify-makefile.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com, ojeda@kernel.org, 
	mmaurer@google.com, glider@google.com, elver@google.com, dvyukov@google.com, 
	andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 9:18=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> That's what I thought but after more than two weeks it still wasn't in
> linux-next so I assumed it had been forgotten, or that plans changed.

Yeah, sorry, I wanted to pick it up together with the Rust KASAN one,
and ideally that would go after the RUSTC_VERSION one that I am
applying now.

> OK thanks.  I expect Stephen will notify us when there's a duplicate
> patch.  As long as the two patches are identical code changes, git will
> sort it out when we merge with Linus.  Otherwise I'll drop the mm.git
> copy.

Sounds good. Thanks!

Cheers,
Miguel
