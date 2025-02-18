Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A342862B7
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739920116; cv=none; b=GTfEPEkcIS010qO6LQzW2lE91sHnq2/EH+Tpc6gPqlBGN8wuOf1V+/3AKAk070MyeY2uLeA+txFIu1AUV9rJegWN+mIUPT5O2BeDZlGP4NHx8YvoO7lHUMmjYCphDqWS1u+HTbP3des1hdwkGsCGuXi1oqz11LrBCS+Jgsx4Qs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739920116; c=relaxed/simple;
	bh=4VKhjBYcnZZilfJffXOO2hipg3pEnaOImhyS2GUuES0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eEtvR+PTU7uqJ1UtFc3BMsfrq1P/b1/GJEIcM7xnIj5tTBKlz3P+2IlAsG0/mAn5RJPiqTRBszNRXYFkxWfCxbcKuqhCHSMrOUGLBK0QVZsdzH+7WPYcTLmYgm9fvxF2Oy6DPfndp2ppi0XB0wQ4hBSPCr7EyMaZOIt0rrCQazs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZUi2Aw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZUi2Aw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE807C4CEE2;
	Tue, 18 Feb 2025 23:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739920116;
	bh=4VKhjBYcnZZilfJffXOO2hipg3pEnaOImhyS2GUuES0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CZUi2Aw5geF55FwbR/e5nwtf4Dw9yj7I97J5sDXQJrs53O7b37xaRS/NGiMbP20U/
	 Y5HLbWDGHKoABgUMeX+FM1VJG9+k4hSxFiQGzQfLtUx4wYY4/TylUgwsEPkOn4Wod6
	 8yAuR+n+R7HrLUVekaFkGIYXsP47LCldOVlMLowBLtMoyYYLuuJzkNvmfQBj2d83Cn
	 32bUnP0Jwt1sOlb3z/LuXDGXiqGhslFptVesAJqLsFCPLINpBW7Fms8vMeG7Dgkuzt
	 fU9g/CyuLNKslkERe4siXcRODSs0sT0FPv69R8A1/Kuj1EbKCHnR0a5E7WeyRcFeUk
	 YTCJe3jZQEFZw==
Date: Tue, 18 Feb 2025 23:08:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	tzungbi@kernel.org, teknoraver@meta.com, serge@hallyn.com,
	rui.zhang@intel.com, robh@kernel.org, rafael@kernel.org,
	mazziesaccount@gmail.com, lukasz.luba@arm.com, lgirdwood@gmail.com,
	kernel@pengutronix.de, groeck@chromium.org, festevam@denx.de,
	daniel.lezcano@linaro.org, corbet@lwn.net, bleung@chromium.org
Subject: Re: +
 regulator-allow-user-configuration-of-hardware-protection-action.patch added
 to mm-nonmm-unstable branch
Message-ID: <Z7US8VerxR8nd8Ip@finisterre.sirena.org.uk>
References: <20250218025407.51C9FC4CED1@smtp.kernel.org>
 <Z7ShszudrCbadXuL@finisterre.sirena.org.uk>
 <7cf75d81-7113-4b62-9db2-76bc9f77cde1@pengutronix.de>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AqHdRY5/6RasmE7g"
Content-Disposition: inline
In-Reply-To: <7cf75d81-7113-4b62-9db2-76bc9f77cde1@pengutronix.de>
X-Cookie: Editing is a rewording activity.


--AqHdRY5/6RasmE7g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2025 at 04:15:43PM +0100, Ahmad Fatoum wrote:
> On 18.02.25 16:05, Mark Brown wrote:
> > On Mon, Feb 17, 2025 at 06:54:06PM -0800, Andrew Morton wrote:

> >> The patch titled
> >>      Subject: regulator: allow user configuration of hardware protection action
> >> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >>      regulator-allow-user-configuration-of-hardware-protection-action.patch

> > This patch was posted less than 24 hours ago, after I last looked at my
> > mail yesterday.  There's not been *any* chance for review here, I'm
> > still triaging my inbox today.

> Did you receive v2 of my patch series[1] that was sent last month?

> The only difference in this particular patch between v2 and v3 are
> two Reviewed-by tags that were posted in the meantime.

> I haven't sent out many patches crossing subsystems before, so please
> let me know how to better handle this in future.

> [1]: https://lore.kernel.org/all/20250113-hw_protection-reboot-v2-8-161d3fc734f0@pengutronix.de/

That seems to have some noticable subthreads on it, such as Matti's one
(if people don't cut any context from their mails it's hard to spot all
the new content, even if that's tags...), and people were suggesting
revisions there.  It was also posted *just* before the merge window, far
too late to go in so I'd be expecting a new version after the merge
window.

The problem here isn't you posting the patches, the problem is them
getting applied with absolutely no time for review.  Between v3 having
been on the list for less than 24 hours and v2 coming out at the end of
the previous release cycle there should've been *some* checking that
subsystems are OK.

--AqHdRY5/6RasmE7g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAme1EvAACgkQJNaLcl1U
h9AsiQf9FzqNJ1kPUC47sksETj68N5YOE7H/IUNHOOVUP/7oZxS7tJUBUvjUY9R7
jyp5qmuyuzZiTuAxMQfYdhV4L1ZioeOAQYvZ1n4E0J8gqn6nO6BFVvy0tmOdOieR
nx0YvnmW3o93KdiW1cTq/UG6oAyorexX1db+/f4ezpvN+km+9b8h3pv1pdpM2ohz
b1LWENifl+5XXKH7E0I0bQ/KyvgB+DfQuUiNixZAAMQ6h8E2x5v6AOrDfM+6P8no
Ylh04mPEbY1BUAHw8K8movDCcYJjvZtgs/k96DyfsQhkeIeSlzZRa/ia5pjZKfug
jNKJjKvN0U11reW9U5KImqi/GIl7eQ==
=v+7v
-----END PGP SIGNATURE-----

--AqHdRY5/6RasmE7g--
