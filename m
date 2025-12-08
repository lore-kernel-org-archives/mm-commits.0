Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1343211706
	for <mm-commits@vger.kernel.org>; Mon,  8 Dec 2025 02:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765160522; cv=none; b=k2nbAgrP03pmqC8qCPFlrT5l899QJSYlA+U+13gYEsh8LlyTzP7HscSux6C2+/F6AVphWI4YNIMFL+/CR2Vrm+OTgLT0YEsWdLA9LxtFWrWQ924UqVWqbgI4WeyXik2tF3tTeu/2vIf7Rb1xpN93Mx9vdGFz/d91uznlFmDLRrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765160522; c=relaxed/simple;
	bh=7KoahCFrJTJx0rn/vNeg6cICXpKndXlRPxqRx3/jMsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VTEQdtksg4wnGkiZUVYLyPKvOwacnDoTUUJYavsUh77MNgE12PdMMkQEjAeXMOTQpR/mzL7NR8Su9vASL80Swd1lWVjmnB3yF2HKJdAM657OwMuvjE+YcKYYVWq2njdgJF1EO9RTDtD8eKIu0F/kKZJtAPJ7HR8/nfeNJ4ZgmBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d04pUiIh; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d04pUiIh"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b72bf7e703fso658757466b.2
        for <mm-commits@vger.kernel.org>; Sun, 07 Dec 2025 18:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1765160518; x=1765765318; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W7Ny34kX+7pV2gTBJmZNlkjdHSh/Hj+/uXXhNu/zf30=;
        b=d04pUiIh+Qz3tVwdm91MgMMhRJ1fJZphvtqx5OOAZDFbTWvfbqqsZLSVoj4jqOSNup
         J1ryCElwPJK0fP+EVuGvqpLzGnm5dDL2veCvQLk6QdIaWBeWPJNxp4HY1lzhqqZI3e20
         eHmRDSRxaf0sPBAjhI3cJuqKVz1ZbrLnnSPHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765160518; x=1765765318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7Ny34kX+7pV2gTBJmZNlkjdHSh/Hj+/uXXhNu/zf30=;
        b=uZbzTxSie5z0bI1cUUC9E8kPmQCVmeiiKr7sUOfMY3N8vEVgjNMb8zYi4RXsrLsGPm
         6jYGfM5tdX1xOkb1M0nfVxIk/v8QGbq+Aoo/4FFZ/eKEooMmkk0hJU4f/OM9oJ4IRJrA
         HyHo89nw4IxuTRLECI2su9Y86BDahA5+FhqgPyUkTcRDAyPM9luZiNb2kng5Am2mtJem
         8txZRWHQoYZ1MUIWpj4je4+q71cAvE8Xh1uVodu4SCi6DHNie/iphYHkbL5lyjfwzytA
         3jKP80VuFaiQo4dCSHkB3b6OTBb3sUSHmESiVcLBNAd/v88pjuvEfLB4349eECRoM0Lp
         QreQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeAci4yenGsoMhcwHV1mPAUd1deomtrDu3Sg1fLtG1vP6A455xyJk8ChRqkVGS7yT+mRErKXV3l2HB@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqlbtd3QiPRfx9ttvlgprnIKW0iNPzl0P2QjkI3v1CUe/e3Zxi
	YHV8gHfxAlrAxzT1nIqT1XbyToUf3avnEYOzUAtCA/x8NtV5tQ/xbHVOK2tzR/aFBOo2AHXIxyh
	4h5CWv48=
X-Gm-Gg: ASbGncvTz/ENTbi3pXj0fon9/kLz2pRj6LqwuEe9kbNXLxXjop4jE8hV3rs4ZOcJ3mm
	DcLhcxFCCmGwgls+cgT9YTRh6LQIH0MHBGG01qyoO4NVkluqM32wrfMeb4SgE37wSGaROGxMr+g
	/QLSMxvlOBf5Kj8mY4D3tQ3PtJVnhHZRqFAZ30AC9dLJ30WgOPURGqu4IiDH/RQgDW3RkUnPwKO
	9ovZ/7cxf4JeyoYsLHZiCYYAgQAV0y2Au2kkCrMZ2kGunEm9Ar5YTXxa3eMaj3gO/xUUqdqDHh0
	6IBjdFpI/W7LlOBFWNezPRm2kXhkUpLI3qRoAA+ilyhCLucG5uASwCLsYHLR0rZWb4hFA5sswJG
	VVnjv0kY34wah8hO4ONr9Eq9wiPtYitI5WJ+DCECWfmoCgGV1iCY4sOia/FMzWwFLA1SHbDv4FD
	dfuFmPea8Krq/HkP3d63I2iCsCUkJPKsm56UhaFkZskVEKqL2738RfRKCCZuI=
X-Google-Smtp-Source: AGHT+IFZNiBuvrWqZHW+fMVI110guNsSAxA+xVntZyYHhY3yTD593Kbr5BQtWZMwxhL49JqY83pIGg==
X-Received: by 2002:a17:907:7291:b0:b72:eaba:aac2 with SMTP id a640c23a62f3a-b7a24304344mr690732466b.26.1765160518012;
        Sun, 07 Dec 2025 18:21:58 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79fab22ae8sm913492066b.4.2025.12.07.18.21.56
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Dec 2025 18:21:56 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so7105658a12.3
        for <mm-commits@vger.kernel.org>; Sun, 07 Dec 2025 18:21:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWxt8dx3L9D4/KeeIu1Pv1TKtqb2TTQ8rn+UUevTCrGXh2d/wdwzv/1MkoNdcg+5ehdQFeOhX3/plxd@vger.kernel.org
X-Received: by 2002:a05:6402:90d:b0:640:a9b1:870b with SMTP id
 4fb4d7f45d1cf-6491a3fefffmr4880149a12.14.1765160516078; Sun, 07 Dec 2025
 18:21:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com> <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
In-Reply-To: <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Mon, 8 Dec 2025 11:21:39 +0900
X-Gmail-Original-Message-ID: <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
X-Gm-Features: AQt7F2pA7YIn5OZVITJ1bBw8kF53abcL2dtB4SE1NWrGI8hCS8MOKvzfGAZKktE
Message-ID: <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitry Antipov <dmantipov@yandex.ru>, 
	Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Dec 2025 at 10:11, Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>
> On 2025/12/7 07:40, Linus Torvalds wrote:
> >
> > See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
> > error") which simply makes the 'last' pointer point to the actual last
> > entry, rather than point to one _past_ the last entry.
>
> It looks fine to me.
> Sorry for the noise and thank you for pointing out my mistake.

Note that if my fix is correct, the mistake is most certainly not
yours and goes all the way back to 2009, and commit 0fe9b66c65f3
("ocfs2: Add preserve to reflink").

But I would really love to have somebody who knows that code go
through it, and see if my fix actually is the right thing to do.

               Linus
