Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9D91AD26D
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 10:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725359164; cv=none; b=CzAfTrtI070VnEb38V7pPI3+4XidycFvsMqngoheMTWsQRR79xCDjC9J4Mzxe7m+UPLHE3chEYU+099UG9/8545TdOItAO1O9O1ARREqB2OgZqVX+1d3ymSLKTY6KkLs70XXZdY0R0MYTkHW3yRTBPY5WClqhOPqCyH1jA75SYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725359164; c=relaxed/simple;
	bh=uOrSVQbonqd2i3HCZPCOYcWsoQ3ZoCPEDaE/y1AAMhE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rh8mCSHj1522i3xGUCMW1lRVyj+Y8aIUYkZDzqIudI3ed3VHVTHNlNY4nMfwbmx1QH9LX5QBBs7hxskIaV6N79zr11VfNYR6OCAcoLBbz2eFoRsjFcptnb0CVX4nUMjOaPjCW1TeZUn3ata/qKPhVGlarlZ1oS9B6bNI8Hkrwxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=IQEJBQSK; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IQEJBQSK"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2f43de7ad5eso65485361fa.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Sep 2024 03:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725359161; x=1725963961; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOrSVQbonqd2i3HCZPCOYcWsoQ3ZoCPEDaE/y1AAMhE=;
        b=IQEJBQSKtM0wl0Cu6nRUFlFx+TZI268zcsKxNGIlH5AaihOjvYR5ZJ/Cl4T6di0E93
         PagR4Tad2XfHav3dI4ZiHzhOZmHRMDGJSvWmydpfVEOA2eLSEbVQbqvnJ1NZiF70pRz5
         DQpw1fLQmMz31vmXZIqRhUlbHyI1WWIDMjNpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725359161; x=1725963961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uOrSVQbonqd2i3HCZPCOYcWsoQ3ZoCPEDaE/y1AAMhE=;
        b=q33JCCCbaLBga4neM/fGoBMyUOlnTHDT5EsiuTPkyzRXGtQgCpI9/UmqbtCUoAQ6zG
         C/c/2ZZegVUopXhEsxvmkTyyENAVu6CVPzDakgexmtTAr5XO9th3X0BJ3XOE4hXLccPV
         xMNsHzte7q7Z/LaTGYlmz/eB8WBM2rhrEddhdgTJCxYfDf3QQcqMpciNdrxR3AOB9s5w
         evUJ5qTOmDp5C5w7Q/k2l9cwDzG1yH33Za8qXLq8LgtKIDkSAlihWVYXC+N20BaAhKpd
         ufMol682Kj1T0UHqNWBo295h0jxmCZo6SbYM7qjlrDOc2F2GllCBa4/ONESBivKbLcTx
         mX5A==
X-Gm-Message-State: AOJu0YzrCagcSdi97j9+XDVmWPHWlPkeSomBkenEsEgBlZbNNlQvBkuf
	TnnwCguZOfyAJowSajV5Q2IEI0cSYgDgpt1YTndWN2q9FkdEv7y6AX9xn+DFXAUMTDSXP+dfI9c
	2UMTmLAZPXYREblPyKorbJ6R7Jy/k/enrVw5Y+Zngvtk1lQ==
X-Google-Smtp-Source: AGHT+IEOSPCTsPWgSWq9oTTWe19dFeTmGpQjRQapS/2QXn6Mn+IyKIqZVmgvHgGJ++5ll9bDcl06JN0vdV0A2y20x80=
X-Received: by 2002:a2e:4602:0:b0:2ee:80b2:1e99 with SMTP id
 38308e7fff4ca-2f6265ea66cmr62878111fa.44.1725359160430; Tue, 03 Sep 2024
 03:26:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240902033004.5128EC4CEC2@smtp.kernel.org> <CAH9xa6eWt4nDE-1a4ZHsz9Z2e5muAYwEZ1+dJRSeKxzowhkYfA@mail.gmail.com>
 <20240902123526.37112a46daff0fd59061a955@linux-foundation.org>
In-Reply-To: <20240902123526.37112a46daff0fd59061a955@linux-foundation.org>
From: Takaya Saeki <takayas@chromium.org>
Date: Tue, 3 Sep 2024 19:25:48 +0900
Message-ID: <CAH9xa6cr1HExqRdAEyBSpLq0WW_2B=pdRK3Ck335BMG1Pz9G7g@mail.gmail.com>
Subject: Re: [merged mm-stable] filemap-add-trace-events-for-get_pages-map_pages-and-fault.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, uekawa@chromium.org, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 4:35=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Mon, 2 Sep 2024 18:44:45 +0900 Takaya Saeki <takayas@chromium.org> wro=
te:
>
> > Hello Andrew, there is a newer v4 version for this patch.
> > https://lore.kernel.org/lkml/20240816211029.903842-1-takayas@chromium.o=
rg/T/
> > Do you mind letting me know how to correct the patch being merged to
> > the latest version?
>
> Send a patch against the earlier code, be sure to include
>
> Fixes: b6273b55d885 ("filemap: add trace events for get_pages, map_pages,=
 and fault")
>

Thank you so much for the guidance. I've sent a patch to this thread.
