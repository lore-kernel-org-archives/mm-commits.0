Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC551537CE;
	Thu, 24 Oct 2024 03:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739331; cv=none; b=nzDyZoipPZcIViXF/R+YGpkj+kEjjTgNWhgqALAqhpql/ec74D9YK3Umuzx54aweBiqxM28hLVayNwlFgOpL8X0vMciGYHsIyxwLFvodavm8onH+MQmQKYx3B3co1kwzbqG4wRFDAH1iUApmVseMqi4m07o4n7z/VB0Er8MIbqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739331; c=relaxed/simple;
	bh=SBtdUtnHf3EZbh4WUnYlb0VbbvvHOMMHOAyfPY0u/Co=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MANleL9jMkuLV5FZx0N/PidKyOvdQSJLJL3M+KQK5uNvrReWzj61LHktMUewv3M56lX7SM2Vv9cE+nOOyH9qV5B6nuojDwJJTmuYhl90LfEP2ufD6f56DRs36kGteWRPQuBaSa+4p5qG1+Smw/AO7N0PkQ4lb/U49Rv14Z4haz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=fcN7B5ES; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=GJ3aMVhS; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="fcN7B5ES";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="GJ3aMVhS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1729739328;
	bh=SBtdUtnHf3EZbh4WUnYlb0VbbvvHOMMHOAyfPY0u/Co=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=fcN7B5ESLyr3KcGw9084AlkjRMFxpk0lCeCXu3nRJsyHRBx4Azvcj5b4StMLkjMuR
	 h8YrljN/KNgNl+Kt15PnXneEQ9hikunS7g0RW1Q0THn4nocvwQOeywGt18RxIPhYUZ
	 qQWjlsC6DizHl0HsLakpZGJfPGiJFzC1FI6f1EOU=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 3FD1A1287915;
	Wed, 23 Oct 2024 23:08:48 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id CCIe8oASZAqX; Wed, 23 Oct 2024 23:08:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1729739327;
	bh=SBtdUtnHf3EZbh4WUnYlb0VbbvvHOMMHOAyfPY0u/Co=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=GJ3aMVhSk6/o8fXg6vsgl9OjnzHdXqOlcbie5kvbuyVWd0+7vvtRY/FP4lOC2hUev
	 zzVGVCzjT+O8WGLbRNsIpYhB27BjqdiXILIYWD6lFOsD/hXLkCpiUscU18RQJ2oTyJ
	 9Nn/MUC+v+tJdqlBb3d1pPuzRkpMJqGj8OYdxe/w=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 66A3912878D1;
	Wed, 23 Oct 2024 23:08:47 -0400 (EDT)
Message-ID: <601574d94d05e580548256d6c46e1d3d38c6f132.camel@HansenPartnership.com>
Subject: Re: +
 lib-string_helpers-fix-potential-snprintf-output-truncation.patch added to
 mm-hotfixes-unstable branch
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	stable@vger.kernel.org, kees@kernel.org, andy@kernel.org, 
	bartosz.golaszewski@linaro.org
Date: Wed, 23 Oct 2024 23:08:46 -0400
In-Reply-To: <20241024025252.BA359C4CEC6@smtp.kernel.org>
References: <20241024025252.BA359C4CEC6@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2024-10-23 at 19:52 -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: lib: string_helpers: fix potential snprintf() output
> truncation
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename
> is
>      lib-string_helpers-fix-potential-snprintf-output-
> truncation.patch
> 
> This patch will shortly appear at
>     
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-string_helpers-fix-potential-snprintf-output-truncation.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when
> testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Subject: lib: string_helpers: fix potential snprintf() output
> truncation
> Date: Mon, 21 Oct 2024 11:14:17 +0200
> 
> The output of ".%03u" with the unsigned int in range [0, 4294966295]
> may get truncated if the target buffer is not 12 bytes.

I think we all agree the explanation isn't accurate: remainder will be
between 0-999 (not range [0, 4294966295]) which means that the string
will only ever be 5 bytes (including leading zero).

This might be required to correct a compiler false warning, but if it
is applied, the patch description should say this.

James

