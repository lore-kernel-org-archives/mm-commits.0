Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6982578F2B
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 09:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765877872; cv=none; b=Lk+8+lEwE5VtGJAnpuWtQmf5uYlVz6OojSRWgKIGYKoy69NQ34Xvryf4kiBLQFVzrzy+ErtUiKf4Th9MP7A0QkRjFRQiasfHvGKpsfOLoYTpfp6jrEv7kW8Ruyd/FmR2OFfEOMy9REy2VGJzOuHcJ4dbNI0U/MtHzAoROfXzPvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765877872; c=relaxed/simple;
	bh=WwNu28TlCkY54GDaPfe8ySDtgB3YmEnoj6BSCqpYUG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APZHuwtqropdJtQ3/2Mhqn4uFsEnlvC0qNGcwuyt9NUHvx2H/oqU0phiP9j2i/z8XC7pn4VdMZkdYRyWhf23vIl9RqZMX6VV+wcpDbiwDZrJETXVwOaokh5BcpjyGTVi/Ib/M7ezXgPCcqOyPnmgt1g49FM0OedmusiBohunUy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bZ6pg6I8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bZ6pg6I8"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b3b0d76fcso2597955f8f.3
        for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 01:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765877869; x=1766482669; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vu2rvdbmwgug/Mh9hu+8LzIVU8l0191q0z68Mc3S5/4=;
        b=bZ6pg6I8lkSTRvD1I7yl7f4klGEaRGFbfbah7QFPDapl601pD6+1qDNfiH7wiq1pd1
         d0ekGoAhLtKPQonpC5tX/679bLn0NZAUIanwUb1okmQnRNh25liJA+SDaa54G8G+Kl5a
         U4BAw+vpeuJtJc/TJ2NCs+mui/cISy25faBVIWUChwZnnEllgGVEQA7IRLfC6AoFMYrV
         nzoFAqzmzWpdYNTp26aq226InzdLCdefF5aChB+ibO1039vpZPURJASegleSy0JYAfXc
         pFpHhCAXg5Os6phoZGexQm895S077gELGHXDnNCqYLgdSQKDBDOaqB50lls9zlN6RrT+
         ytNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765877869; x=1766482669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vu2rvdbmwgug/Mh9hu+8LzIVU8l0191q0z68Mc3S5/4=;
        b=bNCbMGNk6mmTRFjDFAYfh4XOx5nUxKTcBcBG2oEBdTqWQfAezUwXpT5KcnrhXWx5zQ
         7sciQFFXmQoyE2ao2M1J3+9uX+wjlaqyq0FZc49JG0R4Kd+/ov6ePxl6V8+noQKim+Fh
         Nm9+K+RUl+whwJQr1B6T+ihnb6aRE6mtemcA5f5S15Ud0CEdy6mrlcitOyA4eMui+qiU
         SLjB/Fm/DpgfncmgkPWKTuMxBghsgPQLM8Yz2vJu4kk9r/NwpcWnwGceZLHDZfpKGtSY
         krzY9K9w4D5LhpUhuNsDjoca8WwoUqdudzdPNGu9kpaobF7vbivo+iC8r8ZptnbcfmtW
         /AfQ==
X-Gm-Message-State: AOJu0YzSEoaVoqckYixnUMe3fSwow6CE2fcozfJqRkUFKALYIKS39aS3
	bYFImKWtqlmbO3vK6c1wHSMtPk1tiFEIJga/MB8h60XeaXFAloWFMiyhUumwcJoS5co=
X-Gm-Gg: AY/fxX6XKkaU1OIq3ILxvRpVxXTqJm3/BPR19hOnomK33YGQ7cCQ+WkUktL2bZSSsbF
	nQfd00nS8/qMxiOenZxje9EX3JUH87ZPuuBgmPd/xmjCK80K1OaNUF1sLk69+afMkMIn9SEr0Gn
	3ogDSYBWfcyBItZgUK55in5jdtMk9bu+rHEKrrHvQskBIGXoAwdDGsChbbnFdBLdY+y/MI5tgEk
	pJk+1VoSdTCbheSgQafqzFjf6IbbOQHlZnTiVFW/nywoikUqLBVC/YXYaHtTZnC87wSMgCF2qhH
	4uBOxsTacy9a37WoIQSmbiIqQuplyOm/AhE4IMyNEnlyqAiO4j4csCxKxWK6PPaWoY8TuccaZ+u
	fJS2qdldwbe+A1k27KMQMwP8lHCoU1VPVqN+/DHMHQc1hfSRBQnfIRJyIYeFOeq0JyggFtAdmfU
	DFzBGSGRa3xaL28F0R5aiJRAfov7SFosc=
X-Google-Smtp-Source: AGHT+IFmqmstn/cY6rrYcJfOVUKbydoXM/GHXAI1cHMZYruTyFspCP1RkwzKUR1rzdQkh/9MQL5IjQ==
X-Received: by 2002:a05:6000:1863:b0:431:32f:3141 with SMTP id ffacd0b85a97d-431032f3210mr4099063f8f.11.1765877868763;
        Tue, 16 Dec 2025 01:37:48 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430fa52a709sm14027497f8f.11.2025.12.16.01.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 01:37:48 -0800 (PST)
Date: Tue, 16 Dec 2025 10:37:46 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, chenridong@huawei.com
Subject: Re: + memcg-remove-mem_cgroup_size.patch added to mm-new branch
Message-ID: <z6vmwycji3afvfvnhkgwec5zjzq6cyjxx3xz7yngkguk4t4ubf@3tpkcay6mqe4>
References: <20251216042702.5BAE0C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6kcauywi2cxrf4yc"
Content-Disposition: inline
In-Reply-To: <20251216042702.5BAE0C19422@smtp.kernel.org>


--6kcauywi2cxrf4yc
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: + memcg-remove-mem_cgroup_size.patch added to mm-new branch
MIME-Version: 1.0

(crop Cc list)

Hi.

On Mon, Dec 15, 2025 at 08:27:01PM -0800, Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> ------------------------------------------------------
> From: Chen Ridong <chenridong@huawei.com>
> Subject: memcg: remove mem_cgroup_size()
> Date: Thu, 11 Dec 2025 01:30:19 +0000
>=20
> The mem_cgroup_size helper is used only in apply_proportional_protection
> to read the current memory usage.  Its semantics are unclear and
> inconsistent with other sites, which directly call page_counter_read for
> the same purpose.
>=20
> Remove this helper and get its usage via mem_cgroup_protection for
> clarity.  Additionally, rename the local variable 'cgroup_size' to 'usage'
> to better reflect its meaning.
>=20
> No functional changes intended.
>=20
> Link: https://lkml.kernel.org/r/20251211013019.2080004-3-chenridong@huawe=
icloud.com
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Acked-by: Michal Koutn=FD <mkoutny@suse.com>

Actually, I acked only the first patch of the series, I had some remarks
to the 2nd but here it's marked with the ack too.

Thanks,
Michal

--6kcauywi2cxrf4yc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaUEoYxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Agd9wEA/HIH3WGMnzJk6D51//Ti
luspTst7zuEz5reyM1DEh3cBAMcH0nv38MwrhJDJbgkRVgVVhplMAnfDqGkV28nW
jEUK
=XLHN
-----END PGP SIGNATURE-----

--6kcauywi2cxrf4yc--
