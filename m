Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1094A31
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 05:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716098217; cv=none; b=cTpvmRTx9gcx9kJgdAykLv/JkRHtjtYeq8oi0IDoY9s0GP2DZiO6ftoTWq/REsgIkuL0AoVMpVOO0mzdc8iNBeXBySCKPrMpMbpPOp92QnFLT/IN4/BdWwep5b4IOHyyvPeiF0KKeGn9zwwcFBKcZsG9cjpmYilp/scA5BQtePA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716098217; c=relaxed/simple;
	bh=LA1C4Dl8O2SY6LRhazKHgKgwtkDO0BDsB975rJsjfpo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=L/Bbny+0/2TCfexQAYrwRS8Zf0qnhwV8TXnYI4qoXZ5ZmB1QEyZasmrbXLSFEtSrbH/niF36o4Opf2u5ipJSb4V2PxA5b7SjGk0njp00W66QO9qet0eY8kqJVVH212qUwwFdri1xW0XZ8A9gmYD+TSo0FezFH2s539vOY3lnAx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UcgIJGZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UcgIJGZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6F2C32781;
	Sun, 19 May 2024 05:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716098216;
	bh=LA1C4Dl8O2SY6LRhazKHgKgwtkDO0BDsB975rJsjfpo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UcgIJGZUjy8sZI7UfmhhmLPC8eZb5MZ3PSFwiE3jXiG+wajcgJ4VVKLw4KPkSj+km
	 g2ME6RNtwlR137yrdDKztwGD4UQuTTwirubE1GvFPFeXiY+xRJ5m/pCEkPy5TzjZSN
	 b/mFrb0Dy/qYJ5/e+v34+eop6useVJ6IaDJ2JV+8=
Date: Sat, 18 May 2024 22:56:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
 kent.overstreet@linux.dev, keescook@chromium.org, surenb@google.com
Subject: Re: + lib-add-version-into-proc-allocinfo-output.patch added to
 mm-unstable branch
Message-Id: <20240518225655.728977c51f94812804cb85c2@linux-foundation.org>
In-Reply-To: <5c047df0-266e-420f-9bcc-fdec16c9b16b@suse.cz>
References: <20240514202009.2FA52C2BD10@smtp.kernel.org>
	<5c047df0-266e-420f-9bcc-fdec16c9b16b@suse.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 18 May 2024 23:03:52 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 5/14/24 10:20 PM, Andrew Morton wrote:
> > The patch titled
> >      Subject: lib: add version into /proc/allocinfo output
> > has been added to the -mm mm-unstable branch.  Its filename is
> 
> Hi, I don't know how mm-unstable/mm-hotfixes-unstable is handled during and
> right after the merge window, so maybe it's already the plan, but wanted to
> note that for this patch to set the userspace ABI with versioning right
> away, it should go in before 5.10 is released, and maybe even in the merge
> window itself so the version line is already there at 5.10-rc1.

I assume you mean 6.10.

Yes, I'll either build a little mm-stable for -rc1 or I'll add it to
hotfixes for 6.10-rcX.
