Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C04146A6F;
	Sun, 26 Jan 2025 21:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737927343; cv=none; b=AdW/mkyIL4B5q31CHCLWcscq5zTA6MgjsklsFnoEEwIe88wuIWwGsTAHlawoS3kFRSJBoEK22pSusS5LD9/bAGcladZ1rRzpbIbLHnXnq0sN0GfbFsFnvRyI0XIzddKmrCeILQQD7kXk3BI9BZRCmLTXfSk1OLV+SuBfqbNjRow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737927343; c=relaxed/simple;
	bh=Brl44lxCl0/PDc1z0qnHaT7jx8EkP5HkYGslQCb1MwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ITGqOj49ZxGSU63S82jfD1C++pJ59QvlRmuPGKvRWhKJA4R8tjp0GYZjSzCvE9g8GcffLXsLmXyyns2fcfWxvjeZc0ZCuxGDLAoCkRhu008DKxU3iSFicYZZfqN6RMY2yd4MJS/EoPohC3DNJppjULwvbYz4p0A7lgycts7+MR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eY9GDuWI; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eY9GDuWI"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21634417587so7495605ad.3;
        Sun, 26 Jan 2025 13:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737927340; x=1738532140; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUZk5Htk/qxyUPEAclI/Dus69dtfm/23zECE3Jvucj0=;
        b=eY9GDuWI3FfUpQHbAfh6v/znKDsDQSvvn+AKNjygp4GdcfwFhaVht8LP47d07zSV0B
         J6WMrggznvCquMKP2VBrooO4l4xdGZjbbMQhyEckblUoFbZw5HZBI+eoY1eaZD9zKcVu
         ArspD3N1X1bOrv5Cq/fl/NNXZsxX2OuNOnP4oZZAzuv55GIiRujk6HX7YTEHgMVHYsC/
         pq0bCcMIq24vCTHSDksCO9BoK/xJtl32aZgPjBYu6ic/IAZ5E8m3yQJcszVSl3Hgnbjb
         PQNG1klNePV92zHfTuJ8TxQuPJqtea6uEBuG6o/GEFZb6/G0G08WQlaGh2GM9hEmdsL1
         a5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737927340; x=1738532140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tUZk5Htk/qxyUPEAclI/Dus69dtfm/23zECE3Jvucj0=;
        b=n2gMtB1fAvg2UGdMMy7yBVAccxpFab2yfRWpNhB370ToOAqM93Q8ZJaklItIL2bG4d
         qxnHbui8wPCQl4sSO/NnpnUXQHLKrImOwZzwNfrTXHIHU6NNXhxNYloO4zBF9WsnO0xa
         iZGG3yinlKgZ7BOTdu7o+mNVgrGYsi45Dnk+voFE2Nx2RdioyoICWuEsgy4DEwW+zSdh
         pS1ki3fY19tlM/dOaWpiKM25CVpCs0tmYS4cd/wp3oZLa9lxCp3YSGo+oAGxV7sZvg4j
         w7BuG2UikDZqOhs3GiWbBcD6sEIeqqwnO0D8bxtekwfXkObaLfSiBjZfCkJRlCWhl/1i
         VIBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAQjqZ65c8hHfm5E5HbsxORo561OEeKnKfwzjENj5IoVVzUNtdmTCUvHlNbcu17/Bp5sQQas9g4/uE+QQ=@vger.kernel.org, AJvYcCVkOtToZP42Zq1/jk/ZJtlB+nNSzH9C1HE4hhxcTiS/1rtVFAp4SjCCuLEgMHy4xrebqnhU/Zb82xb70g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzD3Tjz7Kfm5RHQB9u54G5RK50yVGSl3C/D90+R0GMYUEyFtOcl
	w7ey3h/g8YfWGLPWhHY/89gKIAbdkS9otpKh/qnvm9KHC3xvJEsbYMJS8zp2EJIQaN91r6SRt/x
	zwcRVUAT81ymcfIAIyKYqSl96KDU=
X-Gm-Gg: ASbGncvxKQQXcubd4b3BchN1kplyrv2pPk/eZyH+Pq5q5+5kzTlIfwkr97bm8JFofVQ
	Z8QOnTm6y61nfGUkgFMl30pP9xUIjg202UQR/ib0+/dEiFUOxDuk/yrG4SR+OHQ==
X-Google-Smtp-Source: AGHT+IFL77pQ4oszIgg+JqbHknADhHVB7OhR4Nd3j6UwB8e1F9/l3cb02FFRZsH6SETj2IaBCx0I11F6PjoXrYNX8oo=
X-Received: by 2002:a17:903:191:b0:215:6af0:11d5 with SMTP id
 d9443c01a7336-21c355399fcmr209652665ad.1.1737927340685; Sun, 26 Jan 2025
 13:35:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
 <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
 <CANiq72mC7Fr6pB-D_JT9A2gCc2Yr0TLf16eRyY4_UWqRrKNVZg@mail.gmail.com> <Z5am8bRw4lSJY8jF@casper.infradead.org>
In-Reply-To: <Z5am8bRw4lSJY8jF@casper.infradead.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 26 Jan 2025 22:35:27 +0100
X-Gm-Features: AWEUYZnWcDRfyESHzRHC0QhSMAwFP0xobxO9X26rEXlIO-PRQC4gxvO5EJ0RLAY
Message-ID: <CANiq72=w454CKVUZ=s3tfUnGgqVOY=PNsoR-+37kZHQXgW7jYA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Uros Bizjak <ubizjak@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2025 at 10:19=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> FYI, this was picked up:
>
> https://lore.kernel.org/all/CA+G9fYuP2bHnDvJwfMm6+8Y8UYk74qCw-2HsFyRzJDFi=
Q5dbpQ@mail.gmail.com/
>
> But, I guess due to the xmas break, nobody figured it out.  It even
> went to the Rust list via Dan Carpenter's response.

I missed that, sorry.

Cheers,
Miguel
