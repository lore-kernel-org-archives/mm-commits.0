Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0667E41C71
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742191764; cv=none; b=BHhaYXP9bCqo9ONnqIwxZkpf+ix58/O5tGPTLaPWNFHKKLauZ4DrgUGUUAZ8+5NTUpWQpmsfaain8M8F1dI9kPzCiqN3ZnhvorGIu22eYi93mytw5jAa6iZa+1if61uXVGn+CyC50O5vja4MzM09GhPTMhQ9FshNkyk8w/t10YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742191764; c=relaxed/simple;
	bh=GqpCuT/7g1SthsM5m7I0NhM/rRp9+VFVHTufN7FYDeU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=DQ8z/U3+OcK60Iz9RviV+0r5vi/hGpvIADl8qTTJdNDJjGUcwUbRBm9J2Dz80w91mxj12a9vri1XJq8MaBvGfRLfcCY+yNRGbzRBbB0QVAx/Moeli6SMNJIxIcRakEb8Oc5ln7/L8cXea4rW/nZzzJkADVSZkikpnV/biXr93sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OWgvfRH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OWgvfRH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF569C4CEEC;
	Mon, 17 Mar 2025 06:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742191763;
	bh=GqpCuT/7g1SthsM5m7I0NhM/rRp9+VFVHTufN7FYDeU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OWgvfRH1lDUAhGJxyXYhhRgbCOAvN7ZbYo925sru2GSMlE+66X6eunAURtScjV/K9
	 m71qx9WgRWmFcpwLTl7brLQ0YQOR5FpeW7aLx+fN5k6ABLc6pw5o0Rn/oPgRarFQiP
	 fc7N5DeXkMVHS523fxeeJ5uYuJHmQ73xFcCmqoNA=
Date: Sun, 16 Mar 2025 23:09:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: mm-commits@vger.kernel.org, tmgross@umich.edu, ojeda@kernel.org,
 lukas.bulwahn@gmail.com, gary@garyguo.net, dwaipayanray1@gmail.com,
 charmitro@posteo.net, boqun.feng@gmail.com, bjorn3_gh@protonmail.com,
 benno.lossin@proton.me, apw@canonical.com, aliceryhl@google.com,
 alex.gaynor@gmail.com, a.hindborg@kernel.org, kurti@invicto.ai
Subject: Re: [merged mm-nonmm-stable]
 checkpatch-add-warning-for-pr_-and-dev_-macros-without-a-trailing-newline.patch
 removed from -mm tree
Message-Id: <20250316230922.9d2e6c8c36fb1934ca854ced@linux-foundation.org>
In-Reply-To: <f150abf3659e151b29a2529b266d519465b7345d.camel@perches.com>
References: <20250317053150.5115AC4CEEC@smtp.kernel.org>
	<f150abf3659e151b29a2529b266d519465b7345d.camel@perches.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 16 Mar 2025 22:51:53 -0700 Joe Perches <joe@perches.com> wrote:

> > One false warning that will be generated due to this change is in case we
> > have a patch that modifies a `pr_* call without a newline` which has a
> > pr_cont with a newline following it.  In this case there will be a warning
> > but because the patch does not include the following pr_cont it will warn
> > there is nothing creating a newline.  I have modified the warning to be
> > softer due to this known problem.
> 
> I think this patch is a merely a conversion of one defect for another
> and it's quite compilcated code too.

Well darn, it would have been nice to receive this review during the
review!

Should I drop the patch?

