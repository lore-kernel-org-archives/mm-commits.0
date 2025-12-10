Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1591E16CD33
	for <mm-commits@vger.kernel.org>; Wed, 10 Dec 2025 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765388804; cv=none; b=fUhyWBBEPBvuLkpZ0cNAguuwWLN8jYwDen8nUgkUypOgLAXI8A/rXB3n/qNNo0DP1eIZ+1rkm/rEd1gAq9hC2pv3sQSmCrv6XEjmwJy5Id5DO//2KNwHT0bWIBuVN+FaOxjBnm0A2jECKA8h3Py3QPYYawAmxivnqaaBNVGAgEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765388804; c=relaxed/simple;
	bh=azDKAvO99X/fdVNEbI9QIQzaClWjZn1FlwFCH2wv7JE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pjqi/FPsfYuXUYlnUETT9BtFVV3/FIxJZINkdqfuRwb1aem8qJYgPeisjN3d09whGvYOHQ04i/Jg5iD83PhjSJpxe2OLgp1TWZjrzltIHulvDEm6f36IoK3oj2beMpvKKoHLA2l5VPwjaA4bZPl1p1cZddxgawWeC5t9tOIyw/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i24nFR2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i24nFR2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2705AC4CEF1;
	Wed, 10 Dec 2025 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765388803;
	bh=azDKAvO99X/fdVNEbI9QIQzaClWjZn1FlwFCH2wv7JE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i24nFR2dLQzhZZlFKnVloQv8WohsK1+e+iWBwXbgJL6qRrhoR+ahFhZUwOZSrA3ak
	 Hhf4sxEgAD+fKsSy36hJqYwuVXtawFsyRf0LG6/gxjFnCJYEorg4w4Ke+gm0kD9as9
	 6hdUhaGhe784ZTfRTAy7wJ10SBYQtcGSJeIRy2do=
Date: Wed, 10 Dec 2025 09:46:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, mm-commits@vger.kernel.org,
 surenb@google.com, rppt@kernel.org, oliver.sang@intel.com, mhocko@suse.com,
 liam.howlett@oracle.com, jhubbard@nvidia.com, david.laight.linux@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: + mm-avoid-use-of-bit-macro-for-initialising-vma-flags.patch
 added to mm-unstable branch
Message-Id: <20251210094642.113c6cc9006ffe4da771f6b0@linux-foundation.org>
In-Reply-To: <5a479ed5-3cce-42fc-a572-771244108dee@lucifer.local>
References: <20251205201510.3D83EC4CEF1@smtp.kernel.org>
	<95d18dbe-9055-43b8-bb4b-da40da670c10@suse.cz>
	<20251208174009.f982210c3a12ecd2459f59ce@linux-foundation.org>
	<20251209112943.6f5e405590671076f55bf4a3@linux-foundation.org>
	<5a479ed5-3cce-42fc-a572-771244108dee@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Dec 2025 09:36:19 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> >
> > So I'm holding it in want-and-see mode - we can add it later as a
> > hotfix.
> 
> I mean not sure it's really worth holding back given this is:
> 
> BIT(...) vs.
> 
> (1UL << ...)
> 
> Hardly something that is hugely harmful no?

Nope.  I'm just giving it some settling time.  Doing it as a hotfix in
a week or so is fine.

