Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9524F13C8F3
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 19:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742241021; cv=none; b=XDY5JO8PpdG+ZN7IgnQTo1tjEiidpMjJsoUeYuEcz6Cm+w97mXV2/NST8j5paSBRZNQWH44uF7Cfw/13P2ZyhdGFYLlJQLh4qaNaUFgmENOG6iELihm4u6fLb20Tc3r+AjYJgfyMf2vJxw2UpaswqNteh0EblHvftm7OsNtjP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742241021; c=relaxed/simple;
	bh=ekpurIL5nyh6mZs+6721pOWcAisyFoTV4/3sQ+0xLeg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFY2FXLzMPrmadorJpb5smYDk8ysYkQbgV7i7H6L/dFXNod+wb0aA87OxZ4AeYS7tNeq9beJtUWvze5mt3jUyxBiJTDNeX7lHXOFEy2WOGgnZunYns3ziMigNuPkQyJ5bMa9WLcGkFtTlPEJUVe6daGUWw+C6Ivrx7ftp/RbcHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WJjCBTny; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJjCBTny"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ff611f2ed1so667197a91.0
        for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 12:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742241020; x=1742845820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ekpurIL5nyh6mZs+6721pOWcAisyFoTV4/3sQ+0xLeg=;
        b=WJjCBTnyeetGVAvRNxi3zGXZ1HOSDx4iU+EmWquV9/2E4rPyVzrcbWAjmKF1vQy1dE
         XIybT4x+AkqQjTNLIsnCgSdtKYza6V6zlJqyPV65F+TMSm9HrLZ9xGdq9ksn+o1gbAv1
         YyTbMOe27fV7KkZzGOrrq/6ExrUS5mZLcUyowe+DjePqq7LBQyapXby+LnV6xOvq0Mx6
         1IkaB88b7xNTG1XMa1ArmHzQf8LP3FtbuMc8nET2VXJhosPYEVK2dOOSBR1yOSb3zusm
         w8+711BOfxHKvRyJBFeum3vaPRnePb6v7n0T5RQaloOuPxt2rAMFvJsJnSC5Aoj0XQ+N
         IHBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742241020; x=1742845820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ekpurIL5nyh6mZs+6721pOWcAisyFoTV4/3sQ+0xLeg=;
        b=CFykXJ1DgkqAFpZXtBVGI2GhjkEUofgVrGiKaOVeKi3m3V61MN5T5m8czl9w+Zho7x
         x6NojqjQSbbs/1CapvUUeIXKSW6WLlP1+sd6r157S1kfesIOcHFjSWJw8VZpIwlaVwQm
         FBNywcVrvTTsmDWRKIWxOaC7op/ckeW3gdQivE1cfJ7+aPFVpGegHnYJiZtzBOO34g1z
         ImISj5CgkTAL4bLQtffIZuIKFZP6Zo862Gh2g0W5rpzXoZAnteH/nvLfeEgvuNWtKuFm
         JcHUlpElfUQgJNcpnTTrcylccOQ5Rp71ZjbEN0sZtVo+Rh0TvG2Dx0BJLbmAFIkfQ6Gw
         cA1A==
X-Forwarded-Encrypted: i=1; AJvYcCU4yu+/3+mGGUng0rIFxAZq+Uw7sp/YvgTPT9GNsQiVdlSRzbQd+vYnEfl6R7qUsZ9EmqHCIooHeCME@vger.kernel.org
X-Gm-Message-State: AOJu0YwVFOXAYNcH7YWUIOQSUEi+sJmmeYP5WYpe8UrVvgQSleUvt5A8
	aSKJ+khLtf7i5JAL3lUbHHo1IUqrAhZ3jco7EtqvOT7gkkYoVAmf+vaNT9s1AoOFtbe7Lh+IMf8
	yEuPHfJWxqjiWqTe9D/VVbLeIO2M=
X-Gm-Gg: ASbGncvX31Vdna3miOpD2BYmw+KCEeYk5FX9k0nSD71ku+4QfdBBgSKPdFtku2e0ZI0
	6q+SPCKOqYM8lqBLyVG5l4PE7grFvQOVtGSpd4N1X5Ni/Gv1k1cz/cf9LwfmPKYiJ6V1Y+BW0eX
	bfw/GFp4WqLjLEuabz3vBMm5nkTQ==
X-Google-Smtp-Source: AGHT+IH7bE6yesHdKuyFq9hW1mDBYmrEzb1rURGcWN6uFc1gQ2FtjvEAGhBcKOd0e7S3Wrf0Bqaf2gh5bjZcFnDm6zc=
X-Received: by 2002:a17:90b:3850:b0:2ff:6941:9b6a with SMTP id
 98e67ed59e1d1-30151d40343mr6406239a91.3.1742241019825; Mon, 17 Mar 2025
 12:50:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250317053150.5115AC4CEEC@smtp.kernel.org> <f150abf3659e151b29a2529b266d519465b7345d.camel@perches.com>
In-Reply-To: <f150abf3659e151b29a2529b266d519465b7345d.camel@perches.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 17 Mar 2025 20:50:07 +0100
X-Gm-Features: AQ5f1JqWr_MqtYf6CqssLedhIOOoX62gzT5LM9F5dH6fUTpiPGh6z-osOI47ed8
Message-ID: <CANiq72nntazBBa-MKvZcGx8udCidjurp1GVpakyDsx1caYcJ6A@mail.gmail.com>
Subject: Re: [merged mm-nonmm-stable] checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch
 removed from -mm tree
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	tmgross@umich.edu, ojeda@kernel.org, lukas.bulwahn@gmail.com, 
	gary@garyguo.net, dwaipayanray1@gmail.com, charmitro@posteo.net, 
	boqun.feng@gmail.com, bjorn3_gh@protonmail.com, benno.lossin@proton.me, 
	apw@canonical.com, aliceryhl@google.com, alex.gaynor@gmail.com, 
	a.hindborg@kernel.org, kurti@invicto.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2025 at 6:52=E2=80=AFAM Joe Perches <joe@perches.com> wrote=
:
>
> Not sure it's a 'real' need/issue as any new KERN_<LEVEL> that's
> not KERN_CONT will already add a new line.

But it is still intended that one uses an explicit newline, no? I am
not sure I follow your other comment, so I may be missing something
though.

Regarding complexity, agreed, it is fairly involved -- I think the
continuation case could be ignored, since it is rare and it is just a
warning anyway.

Cheers,
Miguel
