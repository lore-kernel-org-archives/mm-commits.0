Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74A9131E2D
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757350115; cv=none; b=iAr5ON3oxHFLF3pS1InPoXqR7hHWHAKq72esotDboPpW1B/cOoxZHO7RK7J/VLGh99Feb4CYIiakvWZGymU4+UqoH05Ca+3eNHcMkbIbDm558zQMDK8zkG4X9VKpXUb/Y/qTti0ZEbDbaMceeYH18O0q0hEq5UM1YXHWQX/JvDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757350115; c=relaxed/simple;
	bh=rPxjqeg8O1IwBQVAY5HV6eAb8vqfMw1shTBONXPz5nE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HMQ0Vmz0pFuKfdU/RAbMRpPkgmgUlA96+O2EA+tqXf3xAzNuLsx6IdZ2nf51N7XhBuq6FAEzOfoISBvZkJL4HLFOPsOfYjtgenNTRGKCSJuplcBYTwNEqReUjK6qFBMHbcsqO2AImCKcQxP4JTTM6tLbNm80GffyfBYSfFw3z5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=VKNDaSu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VKNDaSu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2A1C4CEF5
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 16:48:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VKNDaSu/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1757350112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rPxjqeg8O1IwBQVAY5HV6eAb8vqfMw1shTBONXPz5nE=;
	b=VKNDaSu/FyH7tpc2xV65sSSFS1/p3rUA1a4130/vEOAn5Cmi0tullrw5hBw/plFVpRX8sf
	+/8WWBpsqDs5Lq7qDqqy7w1vgtGAhE6jjDNVQSvFicj7/h9uWY3C7eADOZtC9+rpNkKIAD
	1mUo4SUHMuEJDWFNz7hawqoxalWHqbA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 08e36d89 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <mm-commits@vger.kernel.org>;
	Mon, 8 Sep 2025 16:48:32 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-319c2a87a5aso1677288fac.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Sep 2025 09:48:32 -0700 (PDT)
X-Gm-Message-State: AOJu0YwnnVUljMN2KR4Gtc7PS1rSWNm3xvizgjpf/aHDdHWTY8kVPbca
	rxRek2qeaTAMFBZLqzmWWRvgbruJF5SCzHzmvzx700q0wFVYccOgOURdj8VSnva0CqoQWlAawi5
	Ja40Er2YPV7azBlbOxfU6IS/SY+leDUQ=
X-Google-Smtp-Source: AGHT+IGkctwc6DnySJEeqGKrcO3kjQ1rW3ad9rD9OQ/+vWHsbwQOjTqxyvoXxDKTG9Wz7TR/hXMvruaauXE3qdekk4U=
X-Received: by 2002:a05:6808:15a0:b0:439:1c13:4585 with SMTP id
 5614622812f47-43b29a8995amr3901866b6e.20.1757350111372; Mon, 08 Sep 2025
 09:48:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901184218.044AFC4CEF0@smtp.kernel.org>
In-Reply-To: <20250901184218.044AFC4CEF0@smtp.kernel.org>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 8 Sep 2025 18:48:19 +0200
X-Gmail-Original-Message-ID: <CAHmME9o=OyFiRVYFnvT9f3MUbzfS8KYVtFe3u-guk8m2Ft-VAA@mail.gmail.com>
X-Gm-Features: AS18NWBRvnPwuzXB223p31SLJxo6kU3YyD2ls8wTL6ULwbCuscqRIyQWby6nQNc
Message-ID: <CAHmME9o=OyFiRVYFnvT9f3MUbzfS8KYVtFe3u-guk8m2Ft-VAA@mail.gmail.com>
Subject: Re: + wireguard-selftests-remove-config_sparsemem_vmemmap=y-from-qemu-kernel-config.patch
 added to mm-new branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, shuah@kernel.org, rppt@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"

I've taken this through the wireguard tree.
