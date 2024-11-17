Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D99E1C36
	for <mm-commits@vger.kernel.org>; Sun, 17 Nov 2024 00:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731803068; cv=none; b=mcInxHrSkYoBxuAALqwylD/srO/1+V90xlvDyJdueZskvvMTMOKxTiyYxo67UCGrT2ToSEDLGam/PAJT8WWEFgnOOF5fMjOJuuED+Co38DuwATXm08g4qG3MfXo0eNvYyxYbLnAGt78eicSp3c6s+ggdqf7172tpswgiwqFYQpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731803068; c=relaxed/simple;
	bh=ocQ0r7pmqpzv4lz5D1G/M4lBGf0YM0OQHNOLD6yFJo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fGGEQkPD3x8sBGq6sp6w7LqZ8pu/tkxkCkkLnfPD/yB+pdIu98U0wfBS3QMASzhN/XKxiE1zHjcmKlBqRGo+z8oTtLyqrjQIhhdig/wc5czA72+DSa/AUlpA7sgYIcCtqZqwiYEKqJ9GREOIx0LB87neQh3c7EBs1rn3Oy4mFpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BraRK5ye; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BraRK5ye"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9a4031f69fso479685866b.0
        for <mm-commits@vger.kernel.org>; Sat, 16 Nov 2024 16:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731803065; x=1732407865; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LX0zVUghvJRcc4ljKP7D+f24RyfwSYfXIKzndmlZIkk=;
        b=BraRK5yeTcvN96+eOvf7p/2PcLRvIf1+NNtLiZi15s5vfG7SF7apeDK8PVcF1rHeoh
         ctHGt9JeqfZ1J3h6+Cc4WYne+xhsfCbETmiTOFEnngbCZeRc/1MLoWAnASrU+qS+zGhi
         hRhUTepfDcoHHgz0zNMbD7ISqG5zvh6A/qxGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731803065; x=1732407865;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LX0zVUghvJRcc4ljKP7D+f24RyfwSYfXIKzndmlZIkk=;
        b=j9CjF7il8oGQGHracMHe3Ev16HjtuQG0kq/G80AMnQZT+IPLfmeVBpCt95UCPAbEbo
         cFd2s/ZJ65K0wpdbOfvAMO8MmcevkDlbP+vxS2cfzHkLdRDPzlcpTJ3zaPBsoEnQbrKx
         LHmzqzzfLdzN9RVRnS1wXB5V6jdw1HPmwNkbasHcG8PjCjf35xxCr42hK5iDkylcnYLH
         NR0eQA5wPtaHwu9idFsBR+obmjcb7fD/y3gHAQ+Rzs78P6FhGmEEKmB8meZr08sP0vC9
         aomOUVS6PG5VpxczZk5h8ZucB3ZtTiWJ+aRBxOJezaP428Fq2/0hyH/Y0dij9naqNhqW
         Q3vA==
X-Forwarded-Encrypted: i=1; AJvYcCWKvZg4W5A8GasUmOGZwqJ667Bb17R+2fZXPEBKCDKRHKhvsuUJfXcErJNGrw5DLGfeFyIQJC1NSKdY@vger.kernel.org
X-Gm-Message-State: AOJu0YxS/sjAJkRaW4OWKXSbfkU8LAEeawzuPAW+Ih61e622wonzVdvm
	uGom4SFRg3ErtsA+ojeJ43hqEkbvi8mD9uor/kIx9dlPY1bNRrAI8FbAW/LotOw1S/5Sd7WWQFw
	w/Ob1sQ==
X-Google-Smtp-Source: AGHT+IFHuNBkRBeSLcF2nQqGPn0gfW55ZOkp4gWLN2zNV8J4mPGJSE9pr122EqYO4Gm22sz8+aG76w==
X-Received: by 2002:a17:906:fe01:b0:a9e:b2da:b4a3 with SMTP id a640c23a62f3a-aa48352b5d9mr711268166b.42.1731803064663;
        Sat, 16 Nov 2024 16:24:24 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e08624fsm364852066b.183.2024.11.16.16.24.22
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 16:24:23 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a10e1so5338460a12.2
        for <mm-commits@vger.kernel.org>; Sat, 16 Nov 2024 16:24:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXXCBJhxAQwf+8/2R97kxFA6haDZ5SZqSN7y5Vccy/aHm4U+udpg01R1NgGHFHg1AyigdRyJ/wf2jOV@vger.kernel.org
X-Received: by 2002:a17:907:3f03:b0:a9a:a891:b43e with SMTP id
 a640c23a62f3a-aa483555ef6mr716497666b.50.1731803062330; Sat, 16 Nov 2024
 16:24:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241116153556.767f1aeed6ac628a09efe346@linux-foundation.org> <CAHk-=wji0ErHJjX-ZE4fdQ02nxcqQa5pwV==1sHC3p91wxUXAA@mail.gmail.com>
In-Reply-To: <CAHk-=wji0ErHJjX-ZE4fdQ02nxcqQa5pwV==1sHC3p91wxUXAA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Nov 2024 16:24:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj1T_JvBcn_gqFdnuENA-Y9EL=2WNhN5o2xY3p3h4TPMw@mail.gmail.com>
Message-ID: <CAHk-=wj1T_JvBcn_gqFdnuENA-Y9EL=2WNhN5o2xY3p3h4TPMw@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.12
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 16 Nov 2024 at 16:17, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I can see the original at [..]

That should have been

    https://lkml.kernel.org/20241112171655.1662670-1-motiejus@jakstys.lt

of course. The link was the wrong one.

            Linus
