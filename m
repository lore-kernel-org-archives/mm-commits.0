Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C1A1E51F9
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 09:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742290913; cv=none; b=WJ6LR4f5J6R8X5npphuUFV5VHuPmv0fnhKRICQ4IDGTxVTw0DrHy5bSBiEUVERFJiCxFDMG+bE4EYCvSyxn4r1kJSd/4H1ZoWInwf/siXFuEL4Er0VkWfD5HACvkP4nNoaI690I9uMSGHJv/OV7u8eGCfU0o0XQ9BSCwwujYmcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742290913; c=relaxed/simple;
	bh=p0XRAdS9yCx2Q9HkybnnlWLfsdYrCM8Dn1WPYrASQXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaDxDv058VNWxvFJEfG2oMnu+2JIdvUjDZWXYQ3/TBtBrFXdE9KpbqiC2G9ELWJMNs6f2iwj0v3tspiv6bu/vXYWtFSyI/zG7+SL7FGsQii1OihtPMruISy2qxHlkWF7FMEuhqpww7Q91k9qeqyHr90+lxk8BMPAls0Tb+59iZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ue2rmPUS; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ue2rmPUS"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-391211ea598so2972532f8f.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 02:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742290909; x=1742895709; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KTVRKqMMd8VhgvpCtzoRhK+sxMk7gEjCcG3yeNbZgkU=;
        b=Ue2rmPUS362z6JkcVblmXM6kcfb2DsInKJHBqwieWVDCbJk5bgViNeVWCP+nEki++Y
         7ZhU2HxTg+xJXE4U9a9kG3+xq/IvAbBkRqOUGF6Nr+KWKSAC26kl01kiBffV5NeP00Uy
         M+fkWmrBTeX7YIwOCDt9/55Jk/lCjSCs4Wen9y0O/XSsaCYgF5BfDEep2y3LFd/2S4gg
         y6jrfY2bDw62dgjv1nBjTjDy6TA4wnDv1lRQ3l+q4yx0Ckgqxg3p/L64/RCICR90Jxxo
         NgzxKRDkjeAHuy4+NVFYolISuW0lkIjpi7fJzdft5fpDw85iUsNhVGUA+A47pRKCdSFX
         dRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742290909; x=1742895709;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTVRKqMMd8VhgvpCtzoRhK+sxMk7gEjCcG3yeNbZgkU=;
        b=EW5Qn1ORzEGePeOsVkFYNKvweacZTP3Gx1F7g0Jkq+lT/0yaJnW6WPERB8hz3/cQqg
         mYHMaAKD363jLnNIebbI2mQdPNOpu39fEwU7yBgWZN8vzJyF+OllzolQBOiqXgT27Go0
         4z/7Owia+gR9FT0JP6lVNFwPvFfMg4K5HIP2XrDKEICR+SDs1Wi9YwQwDMyx5W7TVBbZ
         /cj/m+2p0tJ7YEsGW0CYKSFaKbx6nSfbWGyLBRTlvzPs2CqQpk69xrr0yzAY4lAk6wkV
         YRRX3KKqR/jjm7roC5wypYVrzdlz3uaQZ4wAOUh0fLP4CtX46OWofJMqDwZGmb1+178r
         BA0A==
X-Gm-Message-State: AOJu0YxF3ZyaXnE6xJiMdJRpPwzvPkYN0o7xI4Y9nJ3bSYOSrDb45jbh
	Txa4L80tQ1BQPady7aMr5l9j9R8i3Tshq3NmXXxH6uMXwQpG62Une2LhIMZVUnI=
X-Gm-Gg: ASbGncv8TpBTE3TBvZ5tP6njq4VJNNPhHps+IlnL57oELsh9xz/cd4GiU019jDqQ6d1
	fi5ADnBOGWmyJ8WwlGLKhLofKJrrBNWEPVvnxxeaWxTFcAriULto0vG0k2cApFlwSpTiXr8z9/d
	6gLVdda+FsNNs0lPLw8pLanSCJUJpEKesJk04F5JbJVtE7hXeeWJQmXMoRW4TtugLAmhghiXziQ
	rEsUqx6ZhXlv1ONaHuZ/Or7PBnFAkdesTnW0nWnZQqReMM9pt+j13q1zaWjFPoniKFVh6asqUxg
	4wtQKwm96cFaA7JO0XWkrKqYnGbVE7kHrMlFCHzkNzO7Y6s=
X-Google-Smtp-Source: AGHT+IHxO0PAS6wwexf8xwSDcecy3kA2GdN8+nEl05KVIP0yutRGU4DhBswfBKKR5L0WFLrSKqsfAA==
X-Received: by 2002:a5d:5986:0:b0:399:6dc0:f15b with SMTP id ffacd0b85a97d-3996dc0f33dmr1561968f8f.48.1742290908780;
        Tue, 18 Mar 2025 02:41:48 -0700 (PDT)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-397f2837e61sm12235135f8f.97.2025.03.18.02.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 02:41:48 -0700 (PDT)
Date: Tue, 18 Mar 2025 10:41:46 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tjmercier@google.com, tj@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org, 
	balbirs@nvidia.com, shakeel.butt@linux.dev
Subject: Re: [to-be-updated]
 memcg-add-hierarchical-effective-limits-for-v2.patch removed from -mm tree
Message-ID: <czrhndmrlwpadvj4lskvxqwrcnep3u2bvb3qp32ddt37tfafsy@meieuq2fd53l>
References: <20250318033636.C1DEAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pvwdqa2mlj6g35mc"
Content-Disposition: inline
In-Reply-To: <20250318033636.C1DEAC4CEE3@smtp.kernel.org>


--pvwdqa2mlj6g35mc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [to-be-updated]
 memcg-add-hierarchical-effective-limits-for-v2.patch removed from -mm tree
MIME-Version: 1.0

On Mon, Mar 17, 2025 at 08:36:36PM -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> Memcg-v1 exposes hierarchical_[memory|memsw]_limit counters in its
> memory.stat file which applications can use to get their effective limit
> which is the minimum of limits of itself and all of its ancestors.  This
> is pretty useful in environments where cgroup namespace is used and the
> application does not have access to the full view of the cgroup hierarchy.
> Let's expose effective limits for memcg v2 as well.

I understand the specific use case behind memory.max.effective (app's
nested allocator can size its area based on that). That one can be a
good starter.

cgroup v2 has decoupled swap accounting though (in contrast to memsw),
so I'm wondering what is memory.[z]swap.max.effective useful for the
application? Is it expected that it'd adapt its behavior based on those
values?

> Link: https://lkml.kernel.org/r/20250205222029.2979048-1-shakeel.butt@linux.dev

+Link: https://lore.kernel.org/all/20240606152232.20253-1-mkoutny@suse.com/

Michal

--pvwdqa2mlj6g35mc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCZ9k/2AAKCRAt3Wney77B
SaaGAP9ngmKdsFQghkpr42Esbe2NnB2mEVAUCFuwKOffvkX4WwEAhNpHeEodGVag
ETde3N+q7MvhuIIrdbLSJEqcv91iwAk=
=E/HW
-----END PGP SIGNATURE-----

--pvwdqa2mlj6g35mc--
