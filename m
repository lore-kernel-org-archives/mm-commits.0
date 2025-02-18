Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627E01D5AAE
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739919392; cv=none; b=a1SAwcYW0SIIrtoY+XdQxYKx8RkS8SdZQTB8JF/ZjGIiLw42HCP8nIThpDxcLnmQCCWvmOD5HL5m6pCxdn2XxA/d32YCMVnWOzDaTht8PW7W8OJ6Uu4AjUJunQ2nDAVXkuEM1Uwl4KIMCt4GM31vHgqAeD96IWcOnwbUii1uZh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739919392; c=relaxed/simple;
	bh=JP1QqiOFAaWHvLs51IQ0TWwh1WsA8I2/ee44iAIwd9Q=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=VG9Qh8xYxfnbGcBbyONWUbXrOgmhsxTiROHNue5VZ/QqK8twzyGly7hChMOXhhmZ5qJoSKJzb0e9tN8b+2fgz46RRFtTiHWM1EVcjr+TbQp+7/D6IJupNjjE7R60dEyrdVcGo2Zl4ha1CMStqP8c/CQMi8krtnLUqEiTSWLaHTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jBnJ+Lty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jBnJ+Lty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B365C4CEE2;
	Tue, 18 Feb 2025 22:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739919392;
	bh=JP1QqiOFAaWHvLs51IQ0TWwh1WsA8I2/ee44iAIwd9Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jBnJ+Ltyh3kamybzjPZD+m+yjM3XZdHB58rdjnZThakC2TclQIJUcl5tjZDCYEaH3
	 ipss62q4Fe7V5bZwT/DaALtjq3FH+n2US2mU9wHDepYVgePhSwVMO6bWAqXYPk9rqn
	 4XWBIWqlm5XyJljZCuvMQgpqYPhfuUCGpssrn1aA=
Date: Tue, 18 Feb 2025 14:56:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: mm-commits@vger.kernel.org, tzungbi@kernel.org, teknoraver@meta.com,
 serge@hallyn.com, rui.zhang@intel.com, robh@kernel.org, rafael@kernel.org,
 mazziesaccount@gmail.com, lukasz.luba@arm.com, lgirdwood@gmail.com,
 kernel@pengutronix.de, groeck@chromium.org, festevam@denx.de,
 daniel.lezcano@linaro.org, corbet@lwn.net, bleung@chromium.org,
 a.fatoum@pengutronix.de
Subject: Re: +
 regulator-allow-user-configuration-of-hardware-protection-action.patch
 added to mm-nonmm-unstable branch
Message-Id: <20250218145630.cbfd6cc6adde97fe28471a4c@linux-foundation.org>
In-Reply-To: <Z7ShszudrCbadXuL@finisterre.sirena.org.uk>
References: <20250218025407.51C9FC4CED1@smtp.kernel.org>
	<Z7ShszudrCbadXuL@finisterre.sirena.org.uk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Feb 2025 15:05:23 +0000 Mark Brown <broonie@kernel.org> wrote:

> On Mon, Feb 17, 2025 at 06:54:06PM -0800, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: regulator: allow user configuration of hardware protection action
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      regulator-allow-user-configuration-of-hardware-protection-action.patch
> 
> This patch was posted less than 24 hours ago, after I last looked at my
> mail yesterday.  There's not been *any* chance for review here, I'm
> still triaging my inbox today.

That's OK - we're only at -rc3.  If over the next month there are
negative review comments then I won't be upstreaming this in its
present form.

mm.git's -unstable branches are very fluid.
