Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A00AA23
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 00:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709081535; cv=none; b=tcSVCSxzqeB4f4GLoMU7Vzim77GKA3Ps+jsEzqhkIiQivliKENilN9KXmMU9GlJ2D4ALxJ5FreHm3hG/JccSEBijFthbYVse4v5btFKEJUhHHz/Dz9ATif+OaFb1tofksPjwRyRxYVL+Ly9hByHkZ4490W69UQ17SdDifa4IxJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709081535; c=relaxed/simple;
	bh=/4+xU2nl2Qim7JMaWpZ5/E+UvRv0P+YRKK4Rvx4upno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sXdwixKlnlfQXEDe3OEtD8HgTV2HQsMV+tNocOkzSIHWDx7M5Djb1r6hZrWIW4COCxRaHAbG1hFfVlaofQBO8GGICOThtTIbjuQioAshBw16xwOlmMnH/ezx3KfJnD+ojNDwVNIQ/6xILrS9mjvPnqnIGU5KWsoZym7CPh3cSwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KAx74stG; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KAx74stG"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a26ed1e05c7so783968966b.2
        for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 16:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1709081531; x=1709686331; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H/XDCG1AIPihXz816FH77DikjrbKv0OtTNG33iOLSO4=;
        b=KAx74stGkQPTsABFbcSuIeZWuWQMOlxvKFswlentJs3zjM1ezqnm4jlM/IqKlGaRSR
         73o0ak14hZ/gAkXKaN7UQaqSy/32aD4m7PS4K62bFM+HOl6p/2qsTzxasL2b4xs5YaZ+
         ueKMR7hhtfOkF9WK3xLikfPCcG3NQ0hKMPqpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709081531; x=1709686331;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H/XDCG1AIPihXz816FH77DikjrbKv0OtTNG33iOLSO4=;
        b=Z5wamwBStwgjI0un38U01lrnbh+1WW/kGGA2FJMdJNZXWsbuWgS0AjflYo041OrtUz
         FTmtU8OVFecECoOfs/hGCPEjJCprM6qqcci3dy7KkEL3YCF7/JopiuErB1wOWxpSaoca
         /vxifPnTdQmzL59tAkwnALYP/XvZbUkJbxT+I3v27KI+xrwoapA2ZYvao3r4K022wYun
         5aRrZtv6De8UJl4I0SVncaLahEylNJztSb2bJg++xgBZRRc/kTaDdWr5SpACdMkkAEYP
         QgEBYt/Y2TUXuCK+zA/gw3dZ4nsXxW750P5B8MwuMsBXfW81I12WixskTwcKcF5V5dm5
         fNrw==
X-Forwarded-Encrypted: i=1; AJvYcCWKML5lMJUeNY2UN7vS9aMtdKwzggtK2O4EYakf2HvQ0kXC/UWFHvD/8UhXNJZ4RbdBLgTjcwYz4rC+XjopUbZDLIL8k2ipHcbyxQ==
X-Gm-Message-State: AOJu0YxWo1nyxUEgMKko8miGMtgU5EynDfoNGl4531QGD6Q1RmDoMGGy
	1U+XB2Bwa13dNyXjVkaLSrKxsbs6zl3pr3vLQ7CWUAEMnK/Oxw5hMQON1/77+VWPEEXrAowW114
	0QwW91w==
X-Google-Smtp-Source: AGHT+IEaZnddjOCppGACIeUH5y+zLbxIS44cpQTqoEhMulmpQuHCubKwgOh06y7bHU7b/mWJZ59AEw==
X-Received: by 2002:a17:906:603:b0:a3e:fc79:c92b with SMTP id s3-20020a170906060300b00a3efc79c92bmr7032065ejb.31.1709081531642;
        Tue, 27 Feb 2024 16:52:11 -0800 (PST)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id n3-20020a170906118300b00a412d3d506esm1307618eja.17.2024.02.27.16.52.10
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 16:52:10 -0800 (PST)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3f829cde6dso586894566b.0
        for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 16:52:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVp5+mRbEUcbhbOQHEuxSkFLPdwKVMeXNdtcZskB/B8OcAQ7NO6yv/LvU+mFdQPRcjLjPtOudrXaxWmgpURfZoaDwss6/CT708hYQ==
X-Received: by 2002:a17:906:36db:b0:a3e:95b8:4c7a with SMTP id
 b27-20020a17090636db00b00a3e95b84c7amr7569487ejc.23.1709081530526; Tue, 27
 Feb 2024 16:52:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227145619.40b2f9b33dc2723df27f68c0@linux-foundation.org>
In-Reply-To: <20240227145619.40b2f9b33dc2723df27f68c0@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Feb 2024 16:51:54 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjk98Rt6PYgwrEp627ociAzWrRpNXOg7TRJcDO_nx1==A@mail.gmail.com>
Message-ID: <CAHk-=wjk98Rt6PYgwrEp627ociAzWrRpNXOg7TRJcDO_nx1==A@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.8-rc7
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 27 Feb 2024 at 14:56, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> 6 hotfixes.  3 are cc:stable and the remainder address post-6.7 issues
> or aren't considered appropriate for backporting.

Hmm. I notice that you add "Link:" pointers to lore, but you do so
even for emails that have been sent to you without any lists, so that
they don't actually exist on lore..

IOW, that link-generating automation of yours looks a bit overly aggressive.

                Linus
