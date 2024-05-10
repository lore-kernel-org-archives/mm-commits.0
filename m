Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9887680028
	for <mm-commits@vger.kernel.org>; Fri, 10 May 2024 21:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715374847; cv=none; b=IEMfKcHJAnpyii0BYfCXvzA35b7LEOn5z47Td2n5jebnR/huyv93cBxcIm+2qF2IqC4Xcqq+Cyl0pp3cLLXZw0ebucWYM15uBH89E5yKnQtkPqHPiip7koCSKJoPlDTacQ/0pbBNGTShtmhBw/L24rIaqAQQl/eJ7kk7MMdQZEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715374847; c=relaxed/simple;
	bh=+v2CyGWre7FViv2q+gWskzmC08UpI0br+uxEzFMUgiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WnXkukmLnkKkVz1YZ0T3afPxrIO3x7eosVxZRvAMN9fuswg5BMOd0t5Brb8jFeS9LP4wIJ4lYMjnwA83xy+gyRy2uXtEePHklGcG4V4z4OS5tvBsPvAF8lTk3ceSF31OJpg8sBGKXZttMCUg4BC6TNtORX1/BYm+kqzU+mae8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c9yA3GnN; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c9yA3GnN"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a59b49162aeso601746566b.3
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2024 14:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715374844; x=1715979644; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2DUX1DFhjN4Cse0eC9UIMDH8SiM6U9i/F0JxyDME3sQ=;
        b=c9yA3GnNdYquBNcglY0x7x2/A3ixBhvRPQU8Y6hxc6Oe8Qys7iO2/WEcshggttusuh
         ND4f6utC67soJoospycQAUv1mitxuZdlHGBtdaWGjT9DrEH1tL9TRYKfSnGQ3B2mrwJy
         PBcmphnjSgDmkeeTIH2bw79s6tOjYzUc9A0xE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715374844; x=1715979644;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DUX1DFhjN4Cse0eC9UIMDH8SiM6U9i/F0JxyDME3sQ=;
        b=Hzw9RCc/eEEa8UjuZ0YQ+n3eUL/GDySmZ6nZYEY1M4tU6q8mzzdVBkcH1ZPSGjDuvR
         JmENzT7gd+4al33SS08N+t9bZX6Iezq50JCLwo/ZKQfTOwlkHVNHtn1CWUvgTzBfaHjx
         QBpTrPyllIFS522aTd4tW+I+xBlbD28Ew6rBzarE8hI4t1Mfmvi5HiGQar2Khhz08gi3
         FXZk1WDuz7tzKIrbHNK+khEGKK30Z62wSxpiCD6lJNI9v9RN15BpmmHfzt51QmPg8GaP
         QxlknZ4eUIS0HJTlhzIVfQveRZTgW1YWYyp/CKj/dCGRCD+sxBF9YzvOXTlpGq0wgHqj
         AnZw==
X-Forwarded-Encrypted: i=1; AJvYcCXwqcWlulGPNBQGPaGENJhLPvjI+cVvG8uZB3lHXKuPpHS+qVovoZ7WY1sl7OxFSof/E+TBkxCF5xX99WtK+i85jUXmyJON/WX6yA==
X-Gm-Message-State: AOJu0Yz2xfpQnIq7qwS9tVOMBLC7IO5TxZwag1Ak29CEw/c/+RbT7J0N
	rq+kXU4VtSi3GPXwPQuQuiAkNBCeIXIIfaGc27PlJEtqivlC71JytvbYJOLSKFadsvVbFquFlZ5
	u33E=
X-Google-Smtp-Source: AGHT+IEnZssCaFn25OxWOwcohufXA8wRHXHxrM3P5KmjOS3hLxzBeTyv/Pzyy3A8DCEP3MvYFkAJgw==
X-Received: by 2002:a50:d650:0:b0:572:78df:c606 with SMTP id 4fb4d7f45d1cf-5734d67ef03mr2581940a12.26.1715374843606;
        Fri, 10 May 2024 14:00:43 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733c2c7e25sm2208913a12.61.2024.05.10.14.00.42
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 May 2024 14:00:42 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a59c0a6415fso708527266b.1
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2024 14:00:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVPiY+4xsblztk1wCADavvUmD6nwjTnoWCluWiPlHEgT7YpC16AigHHqGLa6jsdfsLEPEfKk5b8/VCQNyh92V7erU45151nPXWhBQ==
X-Received: by 2002:a17:906:9982:b0:a59:bacc:b086 with SMTP id
 a640c23a62f3a-a5a2d641841mr239515866b.50.1715374842012; Fri, 10 May 2024
 14:00:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240510131743.cf12a22295edd6ae4c175d5b@linux-foundation.org>
In-Reply-To: <20240510131743.cf12a22295edd6ae4c175d5b@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 May 2024 14:00:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeV5w3=K_r5+ypeB6_JWKiN7CuiReTn+6BMTyXvXZ2pw@mail.gmail.com>
Message-ID: <CAHk-=wjeV5w3=K_r5+ypeB6_JWKiN7CuiReTn+6BMTyXvXZ2pw@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.10
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 May 2024 at 13:17, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> 18 hotfixes, 7 of which are cc:stable.

I assume the subject line is wrong, and you meant 6.9.

              Linus
