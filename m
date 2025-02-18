Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB6A18A6DB
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739921764; cv=none; b=JqsA1Iyq9DCZVGBlLeiIiJXOcahztgOoPDmuZ/gfZtBRaGRohODF1CiwqN+KhH3wRXcVKaVQm9vCNT80JCt/8bQmzYAXzjxjWfhhq3YNlTUAs708nCSC5NRVAXxcfWdrlXWrWAdyX5nNHez3VQnFKJb1fTxWA5PW2hC+cVH6jxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739921764; c=relaxed/simple;
	bh=yZeG3Pwm42KRCNniP2oARmavfaqKN6jsIfxdXF9XMMw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=qaZROWiCGv2jtbHwb0ozoVpfKDJPBozMApKmkFEXCr1HiHTCp7ecFToiSmHdV3TiTJCVnS905SemKLVjCLG0hmS+gXn400SyPdn7WhascxJiQmrr+bh+XVJJjemJX10mHSf4hIQ7+61prcNzfsinaBGCb/oVaq17WozWq2DwQ4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oEahyMTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oEahyMTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E819C4CEE2;
	Tue, 18 Feb 2025 23:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739921764;
	bh=yZeG3Pwm42KRCNniP2oARmavfaqKN6jsIfxdXF9XMMw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oEahyMTqVyex2LBgcNkRqCoksGvujjogB07XDGpHbUcGSrbGCA4ssP6t+v9b0Gxqf
	 aQWnnAc54IPqrmVn13v3f3aa6TQEj0Kwu9SMjFnkfUCIUh+2xE8WSzCPZ0PkGibhcp
	 +WwOYnWAmtM34nszJGVyvOrZw4f8Tm4dME99lUlY=
Date: Tue, 18 Feb 2025 15:36:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, mm-commits@vger.kernel.org,
 tzungbi@kernel.org, teknoraver@meta.com, serge@hallyn.com,
 rui.zhang@intel.com, robh@kernel.org, rafael@kernel.org,
 mazziesaccount@gmail.com, lukasz.luba@arm.com, lgirdwood@gmail.com,
 kernel@pengutronix.de, groeck@chromium.org, festevam@denx.de,
 daniel.lezcano@linaro.org, corbet@lwn.net, bleung@chromium.org
Subject: Re: +
 regulator-allow-user-configuration-of-hardware-protection-action.patch
 added to mm-nonmm-unstable branch
Message-Id: <20250218153602.7f9ea93b73d43e599ee6a8cf@linux-foundation.org>
In-Reply-To: <Z7US8VerxR8nd8Ip@finisterre.sirena.org.uk>
References: <20250218025407.51C9FC4CED1@smtp.kernel.org>
	<Z7ShszudrCbadXuL@finisterre.sirena.org.uk>
	<7cf75d81-7113-4b62-9db2-76bc9f77cde1@pengutronix.de>
	<Z7US8VerxR8nd8Ip@finisterre.sirena.org.uk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Feb 2025 23:08:33 +0000 Mark Brown <broonie@kernel.org> wrote:

> The problem here isn't you posting the patches, the problem is them
> getting applied with absolutely no time for review.  Between v3 having
> been on the list for less than 24 hours and v2 coming out at the end of
> the previous release cycle there should've been *some* checking that
> subsystems are OK.

There's more than a month for review!  That's how mm.git's -unstable
branches work: things get added and after an extended period for
review, updates, testing and possibly rejection, they get moved into the
-stable branches.

If a regulator patch was added to the -stable branch straight off the
mailing list then that would be bad.  This doesn't happen.

