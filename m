Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D4320ADF0
	for <mm-commits@vger.kernel.org>; Wed, 12 Feb 2025 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739374474; cv=none; b=XBLOTbQDWyw4/VXZJD1Fw+9qJLUoPVUYnehjgQMvQCErZAbU5TM+1yqAP+YvbQ1Jc+hIoizZMhH8BtNrhqTnpXJvTNu5gWeZ9u11KF7nMnReAjXrRpZSqNbTt8ghs2ddmHHPVMWqWSdi/kyIO4jH1Tpe9ydK8GpOz67D2OYbvB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739374474; c=relaxed/simple;
	bh=pO+1GWM550hwkl4hbwmPnUb31m1oTuUXW+cVSfspBqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=luZiKfPLiQkMO8iA+589EEF0XVOEPigz2bVBuTMHvpgmJi1/50vUZPqK/M+FN7qP6rqB03CVleJ9FJ8ug6YBXng0EI0pqy7jBbORWSSriJheVSmCebdR08kMkm8++RLkUR7LR4/e7XYi9BkjKUoFOjRJ6xddJh9g1V/uA8CniGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=XI8zJZzr; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=soumwAzG; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="XI8zJZzr";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="soumwAzG"
Date: Wed, 12 Feb 2025 16:34:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739374470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gHwynm+dEpJmdE4znZslAQlkLGMfxNpFCw/Lu88R4Wk=;
	b=XI8zJZzrKJMt6J/ulyrwscWOb6vh0HRffYMu3JxP0TpT8UJ7ht8e18jIGjuHziWib1dqmD
	HMx6IAqSjExdmY8b1t34K1RiAZAO8kfnvVatDuVRQiaVdJnayhfNRchVCLV4dZSetrGDte
	78fGUjawup9zVwELAsVMjeHywLgweNetB+cnT+yDzgFsGJs5mrjvNfdnnlp312PVPJ7cQi
	2JGR/SnhdysIv4lnyNWceAIron3IMjPDFUBwW/ZQpQahDFxLL8vXoA0d+jdPSzk0pDQG84
	4n+miS4Ypu4gQswhYqCdTS8qc4H6E3xfMbTGMn/2P6jTpvduPR/7PhwlOdCASQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739374470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gHwynm+dEpJmdE4znZslAQlkLGMfxNpFCw/Lu88R4Wk=;
	b=soumwAzGdsVfYTKGu23J/4EdPMxAgwtwmvH3oEFs1gSG5JenjrouVAsYMXpvuna6pdunRj
	xlV7ELU71J0vQtBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, yuehongwu@tencent.com, urezki@gmail.com,
	tglx@linutronix.de, rostedt@goodmis.org, qiang.zhang1211@gmail.com,
	paulmck@kernel.org, mengensun@tencent.com,
	mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
	joel@joelfernandes.org, jiangshanlai@gmail.com,
	boqun.feng@gmail.com
Subject: Re: + rcu-provide-a-static-initializer-for-hlist_nulls_head.patch
 added to mm-nonmm-unstable branch
Message-ID: <20250212153429.MfIMiecM@linutronix.de>
References: <20250207235121.04F1CC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250207235121.04F1CC4CED1@smtp.kernel.org>

Thank you picking up the series.

On 2025-02-07 15:51:20 [-0800], Andrew Morton wrote:
>=20
> The patch titled
>      Subject: rcu: provide a static initializer for hlist_nulls_head
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      rcu-provide-a-static-initializer-for-hlist_nulls_head.patch
=E2=80=A6
> Link: https://lkml.kernel.org/r/20250203150525.456525-1-bigeasy@linutroni=
x.de
> Link: https://lkml.kernel.org/r/20250203150525.456525-2-bigeasy@linutroni=
x.de
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Acked-by:Thomas Gleixner <tglx@linutronix.de>

This and the following three patches have a Cc: in front of the tag and
there could be a space after the tag before the name.
[I haven't seen tglx replying to this series but then there are other
channels=E2=80=A6]

Sebastian
