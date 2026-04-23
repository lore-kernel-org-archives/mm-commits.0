Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA1D345CAF;
	Thu, 23 Apr 2026 14:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776955501; cv=none; b=uEYi8TXKoyR90QpY72s6jZD37KtZCNAUv8sNFWa753EV6zkbh5X2hQGpauUmwnBNCchN1XvMxR6iOwab831nOIjUPEgfU2gXeve9fG3+EMFSndCy9lnXssa8OuM5OAc0G/x0Aj/agLCF5e4cC+PC9jv5fQRz8rjH9OnbVHQLKlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776955501; c=relaxed/simple;
	bh=OIFmw0Zt+E1TIBRjqQYJijDgQbMQMtOjHaQh+iQXWA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cz2CK5HaktVFqPISvaqwVQRjeslJmyzXfe0AiJ8EGwuhv6zp99ye563IsP4T0ek4BP4Uk9/Q1BRFVmMzS1hlFEC2lTatlxhQc9cWnmwxCqxQHXRAxj/JOdc06DpvEFtjiLKLuEnbTmEh5zAsEx/fax98sT6GszXYZj5S2cHX/Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhQJuqW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhQJuqW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F25C2BCF4;
	Thu, 23 Apr 2026 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776955501;
	bh=OIFmw0Zt+E1TIBRjqQYJijDgQbMQMtOjHaQh+iQXWA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BhQJuqW3RPBMKmIK40BAs8p18yPepeiwVpghW6NZfj6j3z5iD9wIPgJl9lHgXRqHL
	 NVNbRpZZa6gA/4+j57REAHinGjFGuU+zw9Eq8How8p0kl3W0jk7/NoGqzAHFB3j8Zi
	 3mY/f3CAJ5MwAWJnL03Dkh02kv1hJqY+E46kf9Ek=
Date: Thu, 23 Apr 2026 10:44:59 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
Message-ID: <20260423-tasteful-stingray-from-sirius-7b94bb@lemur>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
 <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
 <20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
 <20260422-aquatic-chital-of-wealth-8b7fa3@meerkat>
 <20260423051246.5de8968ca017eeb8f053fbff@linux-foundation.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423051246.5de8968ca017eeb8f053fbff@linux-foundation.org>

On Thu, Apr 23, 2026 at 05:12:46AM -0700, Andrew Morton wrote:
> But what is the preferred, official URL?   Any preferences?

Its in
https://docs.kernel.org/process/submitting-patches.html#describe-your-changes:

    When linking to mailing list archives, preferably use the lore.kernel.org
    message archiver service. To create the link URL, use the contents of the
    Message-ID header of the message without the surrounding angle brackets. For
    example:

    Link: https://lore.kernel.org/30th.anniversary.repost@klaava.Helsinki.FI
    Please check the link to make sure that it is actually working and points to the relevant message.

However if the link is purely to indicate commit provenance ("this commit came
from the patch posted here"), use the dedicated patch.msgid.link domain, e.g.:

    Link: https://patch.msgid.link/{MSGID}

-K
