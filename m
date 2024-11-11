Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025D51AF0CC;
	Mon, 11 Nov 2024 21:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731359423; cv=none; b=ezApK3Vzbc31D2m3Rul0oHWVOhMitBjNF7zghUeJOhRVDwRWmaSCSmeFsvonORVL5e8ZSTxNSjEmvFaH7Fw4aH+IPdpqQo8lJNPPkgg9u86MUZn3weRfDDxZ0vZxA8B+dKitQOSF4BLyjFkdXvMSQtlSXL/H10tDFIxXO3ZoLkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731359423; c=relaxed/simple;
	bh=90VxAInis5El2v4v5xmUDd5134bKF6gnsc/5PlzQ3Mk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=dkkH0OCBj6heEf1SBvq6hk/aRXIohojxmEI7uif9N4QIhniQ61xXKrjkdeIr44n109D/VSe+I2KlzMv5+s/jpTYYDtVN8Ij+og3mBGV9wE/Wu3IISjEsAoQ33j35Zw0NOg25PatiIKxs1XRsoEU/JOtZGOnUkUVWIOvll5Q1qzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MBUFXgm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MBUFXgm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3210BC4CECF;
	Mon, 11 Nov 2024 21:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731359422;
	bh=90VxAInis5El2v4v5xmUDd5134bKF6gnsc/5PlzQ3Mk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MBUFXgm1UQLkPEpMnMr95xPRbamckBGYizEenukeAncGdNkvvv2fG+DJGH+qriln5
	 jKCW0c7pUVjiKvO/om32WLpDGMyj9wv3fuVJarblNIfRs0+4QyCs3POU8j/e0M4HjX
	 ExODZ2c3rhMl1I8Z/qx602qvD/9eNoECfIcfZ3tw=
Date: Mon, 11 Nov 2024 13:10:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Brian Geffon <bgeffon@google.com>
Cc: "# v4 . 10+" <stable@vger.kernel.org>, mm-commits@vger.kernel.org,
 minchan@kernel.org, kawasin@google.com, senozhatsky@chromium.org
Subject: Re: [merged mm-stable]
 zram-clear-idle-flag-after-recompression.patch removed from -mm tree
Message-Id: <20241111131021.1d48269ed8420cd3e90e2a6c@linux-foundation.org>
In-Reply-To: <CADyq12wbX6Jn0aPgm4EpMtFcE1d=K7qAWan=g9L7RtQ674Escw@mail.gmail.com>
References: <20241111082832.CB6B3C4CED0@smtp.kernel.org>
	<CADyq12zz+Di3FDANsZo1F79EvSSvUZt6fdRMDqG0tqbWoHq+rg@mail.gmail.com>
	<CADyq12wbX6Jn0aPgm4EpMtFcE1d=K7qAWan=g9L7RtQ674Escw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 11 Nov 2024 08:43:07 -0500 Brian Geffon <bgeffon@google.com> wrote:

> > > Link: https://lkml.kernel.org/r/20241028153629.1479791-1-senozhatsky@chromium.org
> > > Link: https://lkml.kernel.org/r/20241028153629.1479791-2-senozhatsky@chromium.org
> > > Fixes: 84b33bf78889 ("zram: introduce recompress sysfs knob")
> > > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > > Reported-by: Shin Kawamura <kawasin@google.com>
> > > Acked-by: Brian Geffon <bgeffon@google.com>
> > > Cc: Minchan Kim <minchan@kernel.org>
> Cc: stable@vger.kernel.org

OK, thanks, I edited/rebased.
