Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BCE17A2E1
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 08:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747901975; cv=none; b=jKHUAGY9XIG98Z8UK5i1onK8mbmxIuOMvUuCpIZYyegVGtg7Kw6dsOmWzTkZlDzi337rQBSthwUc438SNmO01NB8JIZBDqgnzdr+FQYJHwIXoz6brN/UcuEd1ZNawbx10e7JIzc6jUQqbyxGKUGBL5q09EYt85VlmwbM/Oti9ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747901975; c=relaxed/simple;
	bh=zmBsU9n19JOjxWRpSX3l1GswvhaFRQp+Wn6T/2Bgacs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JqETAjcOwi8Z9MsuEkSu0p0OTRAldubX6fe6xJ8y1vw+zlsyBZV31c7xlXDpNN4CXGA2LP/jFOHBiq2Q6Ey/4yOB98xWE8ewSoddx0LMS+PvdpIJTltttl8oEYwi3IZ4GJUJ4DyyEP3WWU/T1iY2lwDtORFy+t49F8Y8faHwwCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JeRehbCX; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JeRehbCX"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a374f727dbso3018878f8f.0
        for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 01:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747901971; x=1748506771; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxnmma8vJ5yH1JnLeEFeOpgsB+4Vzj+px60wIcIlW8Q=;
        b=JeRehbCXuN1cCmcInW4ssd6uIprah11bOteQN8PRYIUkDU31+F3qz8O9BLSyw2aH/T
         BoiRvoUgCghad8dau6Gh3X5gm/cvnZDPQJKj33qpdEGhFs8G3jGVw4bQQd4I7d6nQ4Fx
         jlCmqh+VJHiXNt9NtTfi/07/uaR+uml5+StEstTb5Igeyt7E89IaT7wOSGMjHOdPzOSz
         NVQF13eLdKaG4O0jnyt6cb8XwkD1FngUP2O0dqX9JlYflGI82DVHjHdp+ebgdyLJf00I
         ct9tvbfl4XqzTnldfzJgqQ91+BZw4ZVzlkJvRmwsrSdi6QcAf0SSIsiIjyb/kCY+dbU/
         0b+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747901971; x=1748506771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxnmma8vJ5yH1JnLeEFeOpgsB+4Vzj+px60wIcIlW8Q=;
        b=XFSYNEtHkEMVszRSj72AA/HX5C/MRGXFXSaUkbt3MH9SaUSNj405ZlNTBgrmm6JYYh
         tYg9ee4TlgBDkSnusVt0Q2PP3bLFLviPJsFRBIBaIZ6u7RpyE/yy8dGr/J5PUi/deHQt
         a8KnYXEQ+XUw0R+aGwHbXsgvEhIm/kvWTYNgEK6O8ShS45pPyLt9LOUsqeoQLJASqWh6
         lo5jDk9ItB2AJdo6G+yqZATUjGt8ktOhpFWl+eOw30x0jJ0BkG2+j2N3uyyaq+FTqRTl
         G0fJkx1t8T27s4b78YkAH8PvOUXV1pLg/UpzfKnytW7C3vBEcYvfeXyoZbWhf+Srf4Vn
         OUQg==
X-Forwarded-Encrypted: i=1; AJvYcCW76X7mrd/bc4d+hoGGUqvRjs7W4zvV2vejZTzXZC4czYUbzOKlO/IP7hQ4iU7k4WXuavzTowvts4d0@vger.kernel.org
X-Gm-Message-State: AOJu0YzEZyhHlLrmHpQKEpH8lwekcKGAwxYqPDfYnfE/EK01ulqAME05
	GFbDfrYV+zUVwt+J1hgfEHAw57AXHUYU/APbr6LZ8n4LhnGijo/qORmUc22vBOvDEg1whxqh8kw
	jBakBA+E=
X-Gm-Gg: ASbGncvHWU8eo/dvzHCZQYCpb8CzW+hppiDYtkNj9FG70Rd1p6c//707qUGK/s5Pv0s
	/P0pJJhRXO9piGbuiNpX55dgl2SGn9oJAgI2tsG435FDcB1SmLL6Aoa+InGewQYIOzVEL3q1WN0
	pcilbl7vt3VCZCEQnK4pEZrEKGQ3VFaeIYTbgu6JBEqjzxeZk2PV9hsr9nk39grIngQvf0AFdEP
	5WHlYYsmd00zKs7W77g4Qn4HmZb3k4K191Uwq+MhVbZ6dCy99GTI5PLjE0qayRKLr2WZRc2+9Sz
	fbtbTULxUuTxAU4JjoctL5EvKSmj9TPiUuyuInzjgwO6gtVViWo8sUTeU+puwG2ekek=
X-Google-Smtp-Source: AGHT+IHVG3xJnIANIk4vOkl11AbwPae1nfe4mrSJz53fJkJzUhzKfslv2UlmB8wAYwBgzfjhrnQDgw==
X-Received: by 2002:a05:6000:4284:b0:3a1:fd60:887 with SMTP id ffacd0b85a97d-3a35ffd2bbbmr20917541f8f.45.1747901971582;
        Thu, 22 May 2025 01:19:31 -0700 (PDT)
Received: from blackbook2 (server.hotelpassage.eu. [88.146.207.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca5a841sm22576407f8f.34.2025.05.22.01.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 01:19:31 -0700 (PDT)
Date: Thu, 22 May 2025 10:19:29 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	yu.c.chen@intel.com, vineethr@linux.ibm.com, venkat88@linux.ibm.com, tj@kernel.org, 
	tim.c.chen@intel.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, mingo@redhat.com, mhocko@kernel.org, mgorman@suse.de, 
	kprateek.nayak@amd.com, hannes@cmpxchg.org, corbet@lwn.net, Ayush.jain3@amd.com, 
	aubrey.li@intel.com, libo.chen@oracle.com
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
Message-ID: <yf637jkmcdunhgs6qjbnprygpkifnphdcqofp546dd6ti6s6i4@b2geqedevt42>
References: <20250521165653.4CFACC4CEE4@smtp.kernel.org>
 <20250521191114.GE24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zlmrcwvmpxzkhcxj"
Content-Disposition: inline
In-Reply-To: <20250521191114.GE24938@noisy.programming.kicks-ass.net>


--zlmrcwvmpxzkhcxj
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [merged mm-stable]
 sched-numa-fix-task-swap-by-skipping-kernel-threads.patch removed from -mm
 tree
MIME-Version: 1.0

On Wed, May 21, 2025 at 09:11:14PM +0200, Peter Zijlstra <peterz@infradead.=
org> wrote:
> > @@ -2273,7 +2273,8 @@ static bool task_numa_compare(struct tas
> > =20
> >  	rcu_read_lock();
> >  	cur =3D rcu_dereference(dst_rq->curr);
> > -	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur)))
> > +	if (cur && ((cur->flags & PF_EXITING) || is_idle_task(cur) ||
> > +		    !cur->mm))
>=20
> !->mm is not the right way to determine a kernel thread, PF_KTHREAD is.
> Notably, there are kernel threads that have ->mm.

How does this compose with the NUMA balancing? Should kernel threads
with ->mm be considered here? (I don't know thus asking.)

Thanks,
Michal

--zlmrcwvmpxzkhcxj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCaC7d/gAKCRAt3Wney77B
SYTaAQDX/F+RmDzCEmqu6Q2qMisLiGUpE0CoVW1Rp3AdqtNmSgD/ShlCqo5NoqKe
ZHB8nivd2kxpLQ/PJK+avb0wbDyalgQ=
=zIL5
-----END PGP SIGNATURE-----

--zlmrcwvmpxzkhcxj--
